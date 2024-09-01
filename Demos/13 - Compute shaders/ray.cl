__constant float EPSILON = 0.00003f;
__constant float PI = 3.14159265359f;
__constant int SAMPLES = 8;
__constant float INV_SAMPLES = 1.0f / SAMPLES;

typedef struct Ray {
    float3 origin;
    float3 dir;
} Ray;

typedef struct Sphere {
    float radius;
    float3 pos;
    float3 color;
    float3 emission;
} Sphere;

static inline float get_random(unsigned int *seed0, unsigned int *seed1) {
    *seed0 = 36969 * ((*seed0) & 65535) + ((*seed0) >> 16);
    *seed1 = 18000 * ((*seed1) & 65535) + ((*seed1) >> 16);

    unsigned int ires = ((*seed0) << 16) + (*seed1);
    union {
        float f;
        unsigned int ui;
    } res;

    res.ui = (ires & 0x007fffff) | 0x40000000;
    return (res.f - 2.0f) / 2.0f;
}

Ray createCamRay(const int x_coord, const int y_coord, const int width, const int height, float zoom) {
    float aspect_ratio = (float)width / (float)height;
    float fx = ((float)x_coord / width - 0.5f) * aspect_ratio * zoom;
    float fy = ((float)y_coord / height - 0.5f) * zoom;

    float3 pixel_pos = (float3)(fx, -fy, 0.0f);
    Ray ray;
    ray.origin = (float3)(0.0f, 0.1f, 2.0f);
    ray.dir = normalize(pixel_pos - ray.origin);

    return ray;
}

inline float intersect_sphere(const Sphere* sphere, const Ray* ray) {
    float3 rayToCenter = sphere->pos - ray->origin;
    float b = dot(rayToCenter, ray->dir);
    float c = dot(rayToCenter, rayToCenter) - sphere->radius * sphere->radius;
    float disc = b * b - c;

    if (disc < 0.0f) return 0.0f;
    disc = sqrt(disc);

    if ((b - disc) > EPSILON) return b - disc;
    if ((b + disc) > EPSILON) return b + disc;

    return 0.0f;
}

bool intersect_scene(const Sphere* spheres, const Ray* ray, float* t, int* sphere_id, const int sphere_count) {
    float inf = 1e20f;
    *t = inf;

    for (int i = 0; i < sphere_count; i++) {
        float hitdistance = intersect_sphere(&spheres[i], ray);
        if (hitdistance != 0.0f && hitdistance < *t) {
            *t = hitdistance;
            *sphere_id = i;
        }
    }
    return *t < inf;
}

float3 trace(const Sphere* spheres, const Ray* camray, const int sphere_count, unsigned int* seed0, unsigned int* seed1, float zoom) {
    Ray ray = *camray;
    float3 accum_color = (float3)(0.0f, 0.0f, 0.0f);
    float3 mask = (float3)(1.0f, 1.0f, 1.0f);

    for (int bounces = 0; bounces < 3; bounces++) {
        float t;
        int hitsphere_id = 0;

        if (!intersect_scene(spheres, &ray, &t, &hitsphere_id, sphere_count))
            return accum_color += mask * (float3)(0.15f, 0.15f, 0.25f);

        const Sphere* hitsphere = &spheres[hitsphere_id];

        float3 hitpoint = ray.origin + ray.dir * t;
        float3 normal = normalize(hitpoint - hitsphere->pos);
        float3 normal_facing = dot(normal, ray.dir) < 0.0f ? normal : -normal;

        float rand1 = 2.0f * PI * get_random(seed0, seed1);
        float rand2 = get_random(seed0, seed1);
        float rand2s = sqrt(rand2);

        float3 w = normal_facing;
        float3 u = normalize(cross((fabs(w.x) > 0.1f ? (float3)(0.0f, 1.0f, 0.0f) : (float3)(1.0f, 0.0f, 0.0f)), w));
        float3 v = cross(w, u);

        float3 newdir = normalize(u * cos(rand1) * rand2s + v * sin(rand1) * rand2s + w * sqrt(1.0f - rand2));

        ray.origin = hitpoint + normal_facing * EPSILON;
        ray.dir = newdir;

        accum_color += mask * hitsphere->emission;
        mask *= hitsphere->color;
        mask *= dot(newdir, normal_facing);
    }

    return accum_color;
}

__kernel void render_kernel(__global uchar4* output, const int width, const int height, float zoom, float r, float ox, float oy) {
    unsigned int work_item_id = get_global_id(0);
    unsigned int x_coord = work_item_id % width;
    unsigned int y_coord = work_item_id / width;

    unsigned int seed0 = x_coord;
    unsigned int seed1 = y_coord;

    Sphere cpu_spheres[10];
    int sphere_count = 10;

	// left wall
	cpu_spheres[0].radius	= 200.0f;
	cpu_spheres[0].pos = (float3)(-200.6f, 0.0f, 0.0f);
	cpu_spheres[0].color    = (float3)(0.75f, 0.25f, 0.25f);
	cpu_spheres[0].emission = (float3)(0.0f, 0.0f, 0.0f);

	// right wall
	cpu_spheres[1].radius	= 200.0f;
	cpu_spheres[1].pos = (float3)(200.6f, 0.0f, 0.0f);
	cpu_spheres[1].color    = (float3)(0.25f, 0.25f, 0.75f);
	cpu_spheres[1].emission = (float3)(0.0f, 0.0f, 0.0f);

	// floor
	cpu_spheres[2].radius	= 200.0f;
	cpu_spheres[2].pos = (float3)(0.0f, -200.4f, 0.0f);
	cpu_spheres[2].color	= (float3)(0.9f, 0.8f, 0.7f);
	cpu_spheres[2].emission = (float3)(0.0f, 0.0f, 0.0f);

	// ceiling
	cpu_spheres[3].radius	= 200.0f;
	cpu_spheres[3].pos = (float3)(0.0f, 200.4f, 0.0f);
	cpu_spheres[3].color	= (float3)(0.9f, 0.8f, 0.7f);
	cpu_spheres[3].emission = (float3)(0.0f, 0.0f, 0.0f);

	// back wall
	cpu_spheres[4].radius   = 200.0f;
	cpu_spheres[4].pos = (float3)(0.0f, 0.0f, -200.4f);
	cpu_spheres[4].color    = (float3)(0.9f, 0.8f, 0.7f);
	cpu_spheres[4].emission = (float3)(0.0f, 0.0f, 0.0f);

	// front wall 
	cpu_spheres[5].radius   = 200.0f;
	cpu_spheres[5].pos = (float3)(0.0f, 0.0f, 202.0f);
	cpu_spheres[5].color    = (float3)(0.9f, 0.8f, 0.7f);
	cpu_spheres[5].emission = (float3)(0.0f, 0.0f, 0.0f);

	// left sphere
	cpu_spheres[6].radius   = 0.16f;
	cpu_spheres[6].pos = (float3)(-0.25f, -0.24f, -0.1f);
	cpu_spheres[6].color    = (float3)(0.9f, 0.8f, 0.7f);
	cpu_spheres[6].emission = (float3)(0.0f, 0.0f, 0.0f);

	// right sphere
	cpu_spheres[7].radius   = 0.16f;
	cpu_spheres[7].pos = (float3)(0.25f, -0.24f, 0.1f);
	cpu_spheres[7].color    = (float3)(0.9f, 0.8f, 0.7f);
	cpu_spheres[7].emission = (float3)(0.0f, 0.0f, 0.0f);

	// lightsource
	cpu_spheres[8].radius   = 1.0f;
	cpu_spheres[8].pos = (float3)(0.0f, 1.36f, 0.0f);
	cpu_spheres[8].color    = (float3)(0.0f, 0.0f, 0.0f);
	cpu_spheres[8].emission = (float3)(6.0f, 5.0f, 3.0f);

 cpu_spheres[9].radius   = r;
	cpu_spheres[9].pos = (float3)(ox, oy, 0.1f);
	cpu_spheres[9].color    = (float3)(0.9f, 0.8f, 0.7f);
	cpu_spheres[9].emission = (float3)(1.0f, 2.0f, 2.0f);

    


    // Define all spheres similarly as before ...

    Ray camray = createCamRay(x_coord, y_coord, width, height, zoom);

    float3 finalcolor = (float3)(0.0f, 0.0f, 0.0f);
    
    for (int i = 0; i < SAMPLES; i++)
        finalcolor += trace(cpu_spheres, &camray, 10, &seed0, &seed1, zoom) * INV_SAMPLES;

    uchar4 rgba;

    rgba.x=(uchar)(finalcolor.x*255.0);
    rgba.y=(uchar)(finalcolor.y*255.0);
    rgba.z=(uchar)(finalcolor.z*255.0);
    rgba.w=255;

    output[work_item_id] = rgba;
}