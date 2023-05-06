{

  let g3d = {};
  g3d.name = "WebObjects/Graphics3D";
  interpretate.contextExpand(g3d);

  let three = false

  function computeGroupCenter(group) {
    var center = new three.Vector3();
    var children = group.children;
    var count = children.length;
    for (var i = 0; i < count; i++) {
      center.add(children[i].position);
    }
    center.divideScalar(count);
    return center;
  }

  g3d.Style = (args, env) => {
    var copy = Object.assign({}, env);

    args.forEach((el) => {
      interpretate(el, copy);
    });
  };
  /**
   * @description https://threejs.org/docs/#api/en/materials/LineDashedMaterial
   */
  g3d.Dashing = (args, env) => {
    console.log("Dashing not implemented");
  }

  g3d.Annotation = (args, env) => {
    args.forEach((el) => {
      interpretate(el, env);
    });
  };

  g3d.GraphicsGroup = (args, env) => {
    var group = new three.Group();
    var copy = Object.assign({}, env);

    copy.mesh = group;

    args.forEach((el) => {
      interpretate(el, copy);
    });

    env.mesh.add(group);
  };

  g3d.Metalness = (args, env) => {
    env.metalness = interpretate(args[0], env);
  }

  g3d.Emissive = (args, env) => {
    var copy = Object.assign({}, env);
    interpretate(args[0], copy);
    env.emissive = copy.color;
  }

  g3d.RGBColor = (args, env) => {
    if (args.length !== 3 && args.length !== 1) {
      console.log("RGB format not implemented", args);
      console.error("RGB values should be triple!");
      return;
    }
    if (args.length === 1) {
      args = interpretate(args[0], env); // return [r, g, b] , 0<=r, g, b<=1
    }
    const r = interpretate(args[0], env);
    const g = interpretate(args[1], env);
    const b = interpretate(args[2], env);

    env.color = new three.Color(r, g, b);
  };

  g3d.Roughness = (args, env) => {
    const o = interpretate(args[0], env);
    if (typeof o !== "number") console.error("Opacity must have number value!");
    console.log(o);
    env.roughness = o;  
  }

  g3d.Opacity = (args, env) => {
    var o = interpretate(args[0], env);
    if (typeof o !== "number") console.error("Opacity must have number value!");
    console.log(o);
    env.opacity = o;
  };

  g3d.ImageScaled = (args, env) => { };

  g3d.Thickness = (args, env) => { env.thickness = interpretate(args[0], env)};

  g3d.Arrowheads = (args, env) => {
    if (args.length == 1) {
      env.arrowRadius = interpretate(args[0], env);
    } else {
      env.arrowHeight = interpretate(args[1], env);
      env.arrowRadius = interpretate(args[0], env);
    }
  };

  g3d.TubeArrow = (args, env) => {
    console.log('Context test');
    console.log(this);

    let radius = 1;
    if (args.length > 1) radius = args[1];
    /**
     * @type {three.Vector3}}
     */
    const coordinates = interpretate(args[0], env);

    /**
     * @type {THREE.MeshPhysicalMaterial}}
     */  
    const material = new three.MeshPhysicalMaterial({
      color: env.color,
      transparent: false,
      roughness: env.roughness,
      opacity: env.opacity,
      metalness: env.metalness,
      emissive: env.emissive,
      reflectivity: env.reflectivity,
      clearcoat: env.clearcoat,
      ior: env.ior
    });

    //points 1, 2
    const p1 = new three.Vector3(...coordinates[0]);
    const p2 = new three.Vector3(...coordinates[1]);
    //direction
    const dp = p2.clone().addScaledVector(p1, -1);

    const geometry = new three.CylinderGeometry(radius, radius, dp.length(), 20, 1);

    //calculate the center (might be done better, i hope BoundingBox doest not envolve heavy computations)
    geometry.computeBoundingBox();
    let position = geometry.boundingBox;

    let center = position.max.addScaledVector(position.min, -1);

    //default geometry
    const cylinder = new three.Mesh(geometry, material);

    //cone
    const conegeometry = new three.ConeBufferGeometry(env.arrowRadius, env.arrowHeight, 32 );
    const cone = new three.Mesh(conegeometry, material);
    cone.position.y = dp.length()/2 + env.arrowHeight/2;

    let group = new three.Group();
    group.add(cylinder, cone);

    //the default axis of a Three.js cylinder is [010], then we rotate it to dp vector.
    //using https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
    const v = new three.Vector3(0, 1, 0).cross(dp.normalize());
    const theta = Math.asin(v.length() / dp.length());
    const sc = Math.sin(theta);
    const mcs = 1.0 - Math.cos(theta);

    //Did not find how to write it using vectors
    const matrix = new three.Matrix4().set(
      1 - mcs * (v.y * v.y + v.z * v.z), mcs * v.x * v.y - sc * v.z,/*   */ sc * v.y + mcs * v.x * v.z,/*   */ 0,//
      mcs * v.x * v.y + sc * v.z,/*   */ 1 - mcs * (v.x * v.x + v.z * v.z), -(sc * v.x) + mcs * v.y * v.z,/**/ 0,//
      -(sc * v.y) + mcs * v.x * v.z,/**/ sc * v.x + mcs * v.y * v.z,/*   */ 1 - mcs * (v.x * v.x + v.y * v.y), 0,//
      0,/*                            */0,/*                            */ 0,/**                           */ 1
    );

    //middle target point
    const middle = p1.divideScalar(2.0).addScaledVector(p2, 0.5);

    //shift to the center and rotate
    //group.position = center;
    group.applyMatrix4(matrix);

    //translate its center to the middle target point
    group.position.addScaledVector(middle, -1);

    env.mesh.add(group);

    geometry.dispose();
    conegeometry.dispose();
    material.dispose();
  };

  g3d.Arrow = (args, env) => {
    var arr = interpretate(args[0], env);
    if (arr.length === 1) arr = arr[0];
    if (arr.length !== 2) {
      console.error("Tube must have 2 vectors!");
      return;
    }

    const points = [
      new three.Vector4(...arr[0], 1),
      new three.Vector4(...arr[1], 1),
    ];

    points.forEach((p) => {
      p = p.applyMatrix4(env.matrix);
    });

    const origin = points[0].clone();
    const dir = points[1].add(points[0].negate());

    const arrowHelper = new three.ArrowHelper(
      dir.normalize(),
      origin,
      dir.length(),
      env.color,
    );
    env.mesh.add(arrowHelper);
    arrowHelper.line.material.linewidth = env.thickness;
  };

  g3d.Sphere = async (args, env) => {
    var radius = 1;
    if (args.length > 1) radius = await interpretate(args[1], env);

    const material = new three.MeshPhysicalMaterial({
      color: env.color,
      roughness: env.roughness,
      opacity: env.opacity,
      metalness: env.metalness,
      emissive: env.emissive,
      reflectivity: env.reflectivity,
      clearcoat: env.clearcoat,
      ior: env.ior
    });

    function addSphere(cr) {
      const origin = new three.Vector4(...cr, 1);
      const geometry = new three.SphereGeometry(radius, 20, 20);
      const sphere = new three.Mesh(geometry, material);

      sphere.position.set(origin.x, origin.y, origin.z);

      env.mesh.add(sphere);
      geometry.dispose();
      return sphere;
    }

    let list = await interpretate(args[0], env);

    if (list.length === 1) list = list[0];
    if (list.length === 1) list = list[0];

    if (list.length === 3) {
      env.local.object = addSphere(list);
    } else if (list.length > 3) {

      env.local.multiple = true;
      env.local.object = [];

      list.forEach((el) => {
        env.local.object.push(addSphere(el));
      });
    } else {
      console.log(list);
      console.error("List of coords. for sphere object is less 1");
      return;
    }

    material.dispose();
  };

  g3d.Sphere.update = async (args, env) => {
    console.log('Sphere: updating the data!');
    console.log(args);
    console.log(env);

    if (env.local.multiple) {
      const data = await interpretate(args[0], env);
      let i = 0;
      data.forEach((c)=>{
        env.local.object[i].position.set(...c);
        ++i;
      });

      return;
    }

    const c = await interpretate(args[0], env);
    env.local.object.position.set(...c);

  }

  g3d.Sphere.destroy = (args, env) => {
    console.log('Sphere: destroy');
    console.log(args);
    console.log(env);

  }

  g3d.Sphere.virtual = true

  g3d.Sky = (args, env) => {
    const sky = new Sky();
  	sky.scale.setScalar( 10000 );
  	env.mesh.add( sky );
    env.sky = sky;
    env.sun = new three.Vector3();

  	const skyUniforms = sky.material.uniforms;

  	skyUniforms[ 'turbidity' ].value = 10;
  	skyUniforms[ 'rayleigh' ].value = 2;
  	skyUniforms[ 'mieCoefficient' ].value = 0.005;
  	skyUniforms[ 'mieDirectionalG' ].value = 0.8;
  }

  g3d.Water = (args, env) => {
    const waterGeometry = new three.PlaneGeometry( 10000, 10000 );

  	const water = new Water(
  		waterGeometry,
  		{
  			textureWidth: 512,
  			textureHeight: 512,
  			waterNormals: new three.TextureLoader().load( 'textures/waternormals.jpg', function ( texture ) {

          texture.wrapS = texture.wrapT = three.RepeatWrapping;
  			} ),

        sunDirection: new three.Vector3(),
  			sunColor: 0xffffff,
  			waterColor: 0x001e0f,
  			distortionScale: 3.7,
  			fog: true
  		}
  		);

  		water.rotation.x = - Math.PI / 2;

  		env.mesh.add( water );
      env.water = water;
  }

  g3d.Cuboid = (args, env) => {
    //if (params.hasOwnProperty('geometry')) {
    //	var points = [new three.Vector4(...interpretate(func.args[0]), 1),
    //				new three.Vector4(...interpretate(func.args[1]), 1)];
    //}
    /**
     * @type {three.Vector4}
     */
    var diff;
    /**
     * @type {three.Vector4}
     */
    var origin;
    var p;

    if (args.length === 2) {
      var points = [
        new three.Vector4(...interpretate(args[0], env), 1),
        new three.Vector4(...interpretate(args[1], env), 1),
      ];

      origin = points[0]
        .clone()
        .add(points[1])
        .divideScalar(2);
      diff = points[0].clone().add(points[1].clone().negate());
    } else if (args.length === 1) {
      p = interpretate(args[0], env);
      origin = new three.Vector4(...p, 1);
      diff = new three.Vector4(1, 1, 1, 1);

      //shift it
      origin.add(diff.clone().divideScalar(2));
    } else {
      console.error("Expected 2 or 1 arguments");
      return;
    }

    const geometry = new three.BoxGeometry(diff.x, diff.y, diff.z);
    const material = new three.MeshPhysicalMaterial({
      color: env.color,
      transparent: true,
      opacity: env.opacity,
      roughness: env.roughness,
      depthWrite: true,
      metalness: env.metalness,
      emissive: env.emissive,
      reflectivity: env.reflectivity,
      clearcoat: env.clearcoat,
      ior: env.ior
    });

    //material.side = three.DoubleSide;

    const cube = new three.Mesh(geometry, material);

    //var tr = new three.Matrix4();
    //	tr.makeTranslation(origin.x,origin.y,origin.z);

    //cube.applyMatrix(params.matrix.clone().multiply(tr));

    cube.position.set(origin.x, origin.y, origin.z);

    env.mesh.add(cube);

    geometry.dispose();
    material.dispose();
  };

  g3d.Center = (args, env) => {
    return "Center";
  };

  g3d.Cylinder = (args, env) => {
    let radius = 1;
    if (args.length > 1) radius = args[1];
    /**
     * @type {three.Vector3}}
     */
    const coordinates = interpretate(args[0], env);

    const material = new three.MeshPhysicalMaterial({
      color: env.color,
      transparent: false,
      roughness: env.roughness,
      opacity: env.opacity,
      metalness: env.metalness,
      emissive: env.emissive,
      reflectivity: env.reflectivity,
      clearcoat: env.clearcoat,
      ior: env.ior
    });

    //points 1, 2
    const p1 = new three.Vector3(...coordinates[0]);
    const p2 = new three.Vector3(...coordinates[1]);
    //direction
    const dp = p2.clone().addScaledVector(p1, -1);

    const geometry = new three.CylinderGeometry(radius, radius, dp.length(), 20, 1);

    //calculate the center (might be done better, i hope BoundingBox doest not envolve heavy computations)
    geometry.computeBoundingBox();
    const position = geometry.boundingBox;

    const center = position.max.addScaledVector(position.min, -1);

    //default geometry
    const cylinder = new three.Mesh(geometry, material);

    //the default axis of a Three.js cylinder is [010], then we rotate it to dp vector.
    //using https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
    const v = new three.Vector3(0, 1, 0).cross(dp.normalize());
    const theta = Math.asin(v.length() / dp.length());
    const sc = Math.sin(theta);
    const mcs = 1.0 - Math.cos(theta);

    //Did not find how to write it using vectors
    const matrix = new three.Matrix4().set(
      1 - mcs * (v.y * v.y + v.z * v.z), mcs * v.x * v.y - sc * v.z,/*   */ sc * v.y + mcs * v.x * v.z,/*   */ 0,//
      mcs * v.x * v.y + sc * v.z,/*   */ 1 - mcs * (v.x * v.x + v.z * v.z), -(sc * v.x) + mcs * v.y * v.z,/**/ 0,//
      -(sc * v.y) + mcs * v.x * v.z,/**/ sc * v.x + mcs * v.y * v.z,/*   */ 1 - mcs * (v.x * v.x + v.y * v.y), 0,//
      0,/*                            */0,/*                            */ 0,/**                           */ 1
    );

    //middle target point
    const middle = p1.divideScalar(2.0).addScaledVector(p2, 0.5);

    //shift to the center and rotate
    cylinder.position = center;
    cylinder.applyMatrix4(matrix);

    //translate its center to the middle target point
    cylinder.position.addScaledVector(middle, -1);

    env.mesh.add(cylinder);

    geometry.dispose();
    material.dispose();
  };

  g3d.Tetrahedron = (args, env) => {
    /**
     * @type {number[]}
     */
    var points = interpretate(args[0], env);
    console.log("Points of tetrahedron:");
    console.log(points);
    var faces = [
      [points[0], points[1], points[2]],
      [points[0], points[1], points[3]],
      [points[1], points[2], points[3]],
      [points[0], points[3], points[2]],
    ];

    var fake = ["List"];

    var listVert = (cord) => ["List", cord[0], cord[1], cord[2]];

    faces.forEach((fs) => {
      fake.push([
        "Polygon",
        ["List", listVert(fs[0]), listVert(fs[1]), listVert(fs[2])],
      ]);
    });
    console.log(fake);
    interpretate(fake, env);
  };

  g3d.GeometricTransformation = (args, env) => {
    var group = new three.Group();
    //Если center, то наверное надо приметь matrix
    //к каждому объекту относительно родительской группы.
    var p = interpretate(args[1], env);
    var centering = false;
    var centrans = [];

    if (p.length === 1) {
      p = p[0];
    }
    if (p.length === 1) {
      p = p[0];
    } else if (p.length === 2) {
      console.log(p);
      if (p[1] === "Center") {
        centering = true;
      } else {
        console.log("NON CENTERING ISSUE!!!");
        console.log(p);
        centrans = p[1];
        console.log("???");
      }
      //return;
      p = p[0];
    }

    if (p.length === 3) {
      if (typeof p[0] === "number") {
        var dir = p;
        var matrix = new three.Matrix4().makeTranslation(...dir, 1);
      } else {
        //make it like Matrix4
        p.forEach((el) => {
          el.push(0);
        });
        p.push([0, 0, 0, 1]);

        var matrix = new three.Matrix4();
        console.log("Apply matrix to group::");
        matrix.set(...aflatten(p));
      }
    } else {
      console.log(p);
      console.error("Unexpected length matrix: :: " + p);
    }

    //Backup of params
    var copy = Object.assign({}, env);
    copy.mesh = group;
    interpretate(args[0], copy);

    console.log(matrix);

    if (centering || centrans.length > 0) {
      console.log("::CENTER::");
      var bbox = new three.Box3().setFromObject(group);
      console.log(bbox);
      var center = bbox.max.clone().add(bbox.min).divideScalar(2);
      if (centrans.length > 0) {
        console.log("CENTRANS");
        center = center.fromArray(centrans);
      }
      console.log(center);

      var translate = new three.Matrix4().makeTranslation(
        -center.x,
        -center.y,
        -center.z,
      );
      group.applyMatrix4(translate);
      group.applyMatrix4(matrix);
      translate = new three.Matrix4().makeTranslation(
        center.x,
        center.y,
        center.z
      );
      group.applyMatrix4(translate);
    } else {
      group.applyMatrix4(matrix);
    }

    env.mesh.add(group);
  };

  g3d.GraphicsComplex = (args, env) => {
    var copy = Object.assign({}, env);

    copy.geometry = new three.Geometry();

    interpretate(args[0], copy).forEach((el) => {
      if (typeof el[0] !== "number") console.error("not a triple of number" + el);
      copy.geometry.vertices.push(new three.Vector3(el[0], el[1], el[2]));
    });

    const group = new three.Group();

    interpretate(args[1], copy);

    env.mesh.add(group);
    copy.geometry.dispose();
  };

  g3d.Polygon = (args, env) => {
    if (env.hasOwnProperty("geometry")) {
      /**
       * @type {three.Geometry}
       */
      var geometry = env.geometry.clone();

      var createFace = (c) => {
        c = c.map((x) => x - 1);

        switch (c.length) {
          case 3:
            geometry.faces.push(new three.Face3(c[0], c[1], c[2]));
            break;

          case 4:
            geometry.faces.push(
              new three.Face3(c[0], c[1], c[2]),
              new three.Face3(c[0], c[2], c[3]),
            );
            break;

          case 5:
            geometry.faces.push(
              new three.Face3(c[0], c[1], c[4]),
              new three.Face3(c[1], c[2], c[3]),
              new three.Face3(c[1], c[3], c[4]),
            );
            break;
          /**
           * 0 1
           *5    2
           * 4  3
           */
          case 6:
            geometry.faces.push(
              new three.Face3(c[0], c[1], c[5]),
              new three.Face3(c[1], c[2], c[5]),
              new three.Face3(c[5], c[2], c[4]),
              new three.Face3(c[2], c[3], c[4])
            );
            break;
          default:
            console.log(c);
            console.log(c.length);
            console.error("Cant produce complex polygons! at", c);
        }
      };

      var a = interpretate(args[0], env);
      if (a.length === 1) {
        a = a[0];
      }

      if (typeof a[0] === "number") {
        console.log("Create single face");
        createFace(a);
      } else {
        console.log("Create multiple face");
        a.forEach(createFace);
      }
    } else {
      var geometry = new three.Geometry();
      var points = interpretate(args[0], env);

      points.forEach((el) => {
        if (typeof el[0] !== "number") {
          console.error("not a triple of number", el);
          return;
        }
        geometry.vertices.push(new three.Vector3(el[0], el[1], el[2]));
      });

      console.log("points");
      console.log(points);

      switch (points.length) {
        case 3:
          geometry.faces.push(new three.Face3(0, 1, 2));
          break;

        case 4:
          geometry.faces.push(
            new three.Face3(0, 1, 2),
            new three.Face3(0, 2, 3));
          break;
        /**
         *  0 1
         * 4   2
         *   3
         */
        case 5:
          geometry.faces.push(
            new three.Face3(0, 1, 4),
            new three.Face3(1, 2, 3),
            new three.Face3(1, 3, 4));
          break;
        /**
         * 0  1
         *5     2
         * 4   3
         */
        case 6:
          geometry.faces.push(
            new three.Face3(0, 1, 5),
            new three.Face3(1, 2, 5),
            new three.Face3(5, 2, 4),
            new three.Face3(2, 3, 4)
          );
          break;
        default:
          console.log(points);
          console.error("Cant build complex polygon ::");
      }
    }

    const material = new three.MeshPhysicalMaterial({
      color: env.color,
      transparent: env.opacity < 0.9,
      opacity: env.opacity,
      roughness: env.roughness,
      metalness: env.metalness,
      emissive: env.emissive,
      reflectivity: env.reflectivity,
      clearcoat: env.clearcoat,
      ior: env.ior
      //depthTest: false
      //depthWrite: false
    });
    console.log(env.opacity);
    material.side = three.DoubleSide;

    geometry.computeFaceNormals();
    geometry.computeVertexNormals(true);
    const poly = new three.Mesh(geometry, material);

    //poly.frustumCulled = false;
    env.mesh.add(poly);
    material.dispose();
  };

  g3d.Polyhedron = (args, env) => {
    if (args[1][1].length > 4) {
      //non-optimised variant to work with 4 vertex per face
      interpretate(["GraphicsComplex", args[0], ["Polygon", args[1]]], env);
    } else {
      //reguar one. gpu-fiendly
      /**
       * @type {number[]}
       */
      const indices = interpretate(args[1], env)
        .flat(4)
        .map((i) => i - 1);
      /**
       * @type {number[]}
       */
      const vertices = interpretate(args[0], env).flat(4);

      const geometry = new three.PolyhedronGeometry(vertices, indices);

      var material = new three.MeshPhysicalMaterial({
        color: env.color,
        transparent: true,
        opacity: env.opacity,
        depthWrite: true,
        roughness: env.roughness,
        metalness: env.metalness,
        emissive: env.emissive,
        reflectivity: env.reflectivity,
        clearcoat: env.clearcoat,
        ior: env.ior
      });

      const mesh = new three.Mesh(geometry, material);
      env.mesh.add(mesh);
      geometry.dispose();
      material.dispose();
    }
  };

  g3d.GrayLevel = (args, env) => { };

  g3d.EdgeForm = (args, env) => { };

  g3d.Specularity = (args, env) => { };

  g3d.Text = (args, env) => { };

  g3d.Directive = (args, env) => { };

  g3d.PlaneGeometry = () => { new three.PlaneGeometry;  };

  g3d.Line = (args, env) => {
    if (env.hasOwnProperty("geometry")) {
      const geometry = new three.Geometry();

      const points = interpretate(args[0], env);
      points.forEach((el) => {
        geometry.vertices.push((env.geometry.vertices[el - 1]).clone(),);
      });

      const material = new three.LineBasicMaterial({
        linewidth: env.thickness,
        color: env.edgecolor,
      });
      const line = new three.Line(geometry, material);

      line.material.setValues({
        polygonOffset: true,
        polygonOffsetFactor: 1,
        polygonOffsetUnits: 1
      })

      env.mesh.add(line);

      geometry.dispose();
      material.dispose();
    } else {
      let arr = interpretate(args[0], env);
      if (arr.length === 1) arr = arr[0];
      //if (arr.length !== 2) console.error( "Tube must have 2 vectors!");
      console.log("points: ", arr.length);

      const points = [];
      arr.forEach((p) => {
        points.push(new three.Vector4(...p, 1));
      });
      //new three.Vector4(...arr[0], 1)

      points.forEach((p) => {
        p = p.applyMatrix4(env.matrix);
      });

      const geometry = new three.Geometry().setFromPoints(points);
      const material = new three.LineBasicMaterial({
        color: env.edgecolor,
        linewidth: env.thickness,
      });

      env.mesh.add(new three.Line(geometry, material));
    }
  };

  let OrbitControls;
  let FirstPersonControls = false;

  let EffectComposer;
  let RenderPass; 
  let UnrealBloomPass;

  let GUI;


  g3d.Graphics3D = async (args, env) => {
    /* lazy loading */

    if (!three) {
      console.log('not there...')
      three         = (await import('three'));
      OrbitControls = (await import("three/examples/jsm/controls/OrbitControls")).OrbitControls;
      EffectComposer= (await import('three/examples/jsm/postprocessing/EffectComposer')).EffectComposer;
      RenderPass    = (await import('three/examples/jsm/postprocessing/RenderPass.js')).RenderPass;
      UnrealBloomPass=(await import('three/examples/jsm/postprocessing/UnrealBloomPass.js')).UnrealBloomPass;
      GUI           = (await import('dat.gui')).GUI;
    }

    /**
     * @type {Object}
     */   
    env.local.handlers = [];
    env.local.prolog   = [];

    /**
     * @type {Object}
     */  
    const options = core._getRules(args, env);
    console.log(options);

    /**
     * @type {HTMLElement}
     */
    var container = env.element;

    /**
     * @type {[Number, Number]}
     */
    let ImageSize = options.ImageSize || [core.DefaultWidth, core.DefaultWidth*0.618034];

    let background = options.Background || new three.Color(0xffffff);

    const lighting = options.Lighting || "Default";

    const aspectratio = options.AspectRatio || 0.618034;

    //if only the width is specified
    if (!(ImageSize instanceof Array)) ImageSize = [ImageSize, ImageSize*aspectratio];
    console.log('Image size');
    console.log(ImageSize);

    //path tracing engine
    if (options.RTX) {
      //FullScreenQuad = (await import('three/examples/jsm/postprocessing/Pass.js')).Pass.FullScreenQuad;
      //RTX = await import('three-gpu-pathtracer/build/index.module');
      //PathTracingSceneGenerator   = RTX.PathTracingSceneGenerator;
      //PathTracingRenderer         = RTX.PathTracingRenderer;
      //PhysicalPathTracingMaterial = RTX.PhysicalPathTracingMaterial;
    }

    if (options.Controls) {
      console.log('controld');
      console.log(options);
      if (options.Controls === 'FirstPersonControls') {
        FirstPersonControls = (await import("three/examples/jsm/controls/FirstPersonControls")).FirstPersonControls;
      }
    }

    /**
    * @type {three.Mesh<three.Geometry>}
    */

    let camera, scene, renderer, composer;
    let controls, water, sun, mesh;

    const params = {
      exposure: 1,
      bloomStrength: 0.1,
      bloomThreshold: 0.5,
      bloomRadius: 0.11
    };

    init();
    animate();



    function init() {

      scene = new three.Scene();
      camera = new three.PerspectiveCamera( 55, ImageSize[0]/ImageSize[1], 1, 20000 );
      camera.position.set( 3, 3, 10 );

      renderer = new three.WebGLRenderer();
      renderer.setPixelRatio( window.devicePixelRatio );
      renderer.setSize(ImageSize[0], ImageSize[1]);
      //renderer.toneMapping = three.ACESFilmicToneMapping;
      renderer.domElement.style = "margin:auto";
      container.appendChild( renderer.domElement );

      /* postprocess */
  		const renderScene = new RenderPass( scene, camera );

  		const bloomPass = new UnrealBloomPass( new three.Vector2( ImageSize[0], ImageSize[1] ), 1.5, 0.4, 0.85 );
  		bloomPass.threshold = params.bloomThreshold;
  		bloomPass.strength = params.bloomStrength;
  		bloomPass.radius = params.bloomRadius;

      composer = new EffectComposer( renderer );
  		composer.addPass( renderScene );
  		composer.addPass( bloomPass );

      composer.setSize(ImageSize[0], ImageSize[1]);

      function takeScheenshot() {
        //renderer.render( scene, camera );
        composer.render();
        renderer.domElement.toBlob(function(blob){
          var a = document.createElement('a');
          var url = URL.createObjectURL(blob);
          a.href = url;
          a.download = 'screenshot.png';
          a.click();
        }, 'image/png', 1.0);
      }

      const gui = new GUI({ autoPlace: false });
      const button = { Save:function(){ takeScheenshot() }};
      gui.add(button, 'Save');

      const bloomFolder = gui.addFolder('Bloom');

  		bloomFolder.add( params, 'exposure', 0.1, 2 ).onChange( function ( value ) {
  			renderer.toneMappingExposure = Math.pow( value, 4.0 );
  		} );

  		bloomFolder.add( params, 'bloomThreshold', 0.0, 1.0 ).onChange( function ( value ) {
  			bloomPass.threshold = Number( value );
  		} );

  		bloomFolder.add( params, 'bloomStrength', 0.0, 3.0 ).onChange( function ( value ) {
  			bloomPass.strength = Number( value );
  		} );

  		bloomFolder.add( params, 'bloomRadius', 0.0, 1.0 ).step( 0.01 ).onChange( function ( value ) {
  			bloomPass.radius = Number( value );
  		} );

      if (background instanceof three.Color) scene.background = background;


      const guiContainer = document.createElement('div');
      guiContainer.classList.add('graphics3d-controller');
      guiContainer.appendChild(gui.domElement);
      container.appendChild( guiContainer );    

      env.local.renderer = renderer;
      env.local.scene    = scene;
      env.local.camera = camera;

      scene.add(camera);

      if (lighting === "Default") g3d.DefaultLighting([], env);

      const group = new three.Group();

      const envcopy = {
        ...env,
        context: g3d,
        numerical: true,
        tostring: false,
        matrix: new three.Matrix4().set(
          1, 0, 0, 0,//
          0, 1, 0, 0,//
          0, 0, 1, 0,//
          0, 0, 0, 1),
        color: new three.Color(1, 1, 1),
        opacity: 1,
        thickness: 1,
        roughness: 0.5,
        edgecolor: new three.Color(0, 0, 0),
        mesh: group,
        metalness: 0,
        emissive: new three.Color(0, 0, 0),
        arrowHeight: 20,
        arrowRadius: 5,
        reflectivity: 0.5,
        clearcoat: 0,
        ior: 1.5
      }
    
      interpretate(args[0], envcopy);

      group.applyMatrix4(new three.Matrix4().set(
        1, 0, 0, 0,
        0, 0, 1, 0,
        0,-1, 0, 0,
        0, 0, 0, 1));

      scene.add(group);
      
      controls = new OrbitControls( camera, renderer.domElement );
      controls.target.set( 0, 1, 0 );
      controls.update();
      

    }


    function animate() {

      env.local.aid = requestAnimationFrame( animate );
      render();
    }

    function render() {
      //added loop-handlers, void
      env.local.handlers.forEach((f)=>{
        f();
      });

      //renderer.render( scene, camera );
      composer.render();
    }


  }; 

  let Water = false;
  let Sky   = false;

  g3d.Reflectivity = (args, env) => {
    env.reflectivity = interpretate(args[0], env);
  }

  g3d.IOR = (args, env) => {
    env.ior = interpretate(args[0], env);
  }

  g3d.Clearcoat = (args, env) => {
    env.clearcoat = interpretate(args[0], env);
  }

  g3d.LightProbe = (args, env) => {
    //three.js light probe irradiance
  }

  g3d.DefaultLighting = (args, env) => {
    const lighting = [
      { type: "Ambient", color: [0.3, 0.2, 0.4] },
      {
        type: "Directional",
        color: [0.8, 0, 0],
        position: [2, 0, 2]
      },
      {
        type: "Directional",
        color: [0, 0.8, 0],
        position: [2, 2, 2]
      },
      {
        type: "Directional",
        color: [0, 0, 0.8],
        position: [0, 2, 2]
      }
    ];

    function addLight(l) {
      var color = new three.Color().setRGB(l.color[0], l.color[1], l.color[2]);
      var light;

      if (l.type === "Ambient") {
        light = new three.AmbientLight(color, 0.5);
      } else if (l.type === "Directional") {
        console.log('adding direction light');
        console.log(l);
        light = new three.DirectionalLight(color, 1);
        light.position.fromArray(l.position);

      } else if (l.type === "Spot") {
        light = new three.SpotLight(color);
        light.position.fromArray(l.position);
        light.target.position.fromArray(l.target);
        //light.target.updateMatrixWorld(); // This fixes bug in three.js
        light.angle = l.angle;
      } else if (l.type === "Point") {
        light = new three.PointLight(color);
        light.position.fromArray(l.position);

      } else {
        alert("Error: Internal Light Error", l.type);
        return;
      }
      return light;
    } 

    lighting.forEach((el) => env.local.camera.add(addLight(el)) );

  }

  g3d.SkyAndWater = async (args, env) => {
    if (!Water) {
      Water         = (await import('three/examples/jsm/objects/Water')).Water;
      Sky           = (await import('three/examples/jsm/objects/Sky')).Sky;  
    }

    let options = core._getRules(args, env);
    console.log('options:');
    options.dims = options.dims || [10000, 10000];
    options.skyscale = options.skyscale || 10000;
    options.elevation = options.elevation ||  8;
    options.azimuth = options.azimuth || 180;


    console.log(options);

    let sun = new three.Vector3();
    let water;
    // Water

    const waterGeometry = new three.PlaneGeometry(...options.dims);

    water = new Water(
      waterGeometry,
      {
        textureWidth: 512,
        textureHeight: 512,
        waterNormals: new three.TextureLoader().load( 'textures/waternormals.jpg', function ( texture ) {

          texture.wrapS = texture.wrapT = three.RepeatWrapping;

        } ),
        sunDirection: new three.Vector3(),
        sunColor: 0xffffff,
        waterColor: 0x001e0f,
        distortionScale: 3.7,
        fog: true
      }
    );

    water.rotation.x = - Math.PI / 2;
    
    env.local.water = water;

    // Skybox

    const sky = new Sky();
    sky.scale.setScalar( options.skyscale );

    env.local.sky = sky;  

    const skyUniforms = sky.material.uniforms;

    skyUniforms[ 'turbidity' ].value = 10;
    skyUniforms[ 'rayleigh' ].value = 2;
    skyUniforms[ 'mieCoefficient' ].value = 0.005;
    skyUniforms[ 'mieDirectionalG' ].value = 0.8;

    const parameters = {
      elevation: options.elevation,
      azimuth: options.azimuth
    };



    env.local.scene.add( water );
    env.local.scene.add( sky );

    const pmremGenerator = new three.PMREMGenerator( env.local.renderer );
    let renderTarget;

    const phi = three.MathUtils.degToRad( 90 - parameters.elevation );
    const theta = three.MathUtils.degToRad( parameters.azimuth );

    sun.setFromSphericalCoords( 1, phi, theta );

    sky.material.uniforms[ 'sunPosition' ].value.copy( sun );
    water.material.uniforms[ 'sunDirection' ].value.copy( sun ).normalize();

    if ( renderTarget !== undefined ) renderTarget.dispose();

    renderTarget = pmremGenerator.fromScene( sky );

    env.local.scene.environment = renderTarget.texture;  

    //every frame
    env.local.handlers.push(
      function() {
        env.local.water.material.uniforms[ 'time' ].value += 1.0 / 60.0;
      }
    );
  }

  g3d.Graphics3D.destroy = (args, env) => {
    console.log('Graphics3D was removed');
    console.log('env global:'); console.log(env.global);
    console.log('env local:'); console.log(env.local);
    cancelAnimationFrame(env.local.aid);
  }
}
