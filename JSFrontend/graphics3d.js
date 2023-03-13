import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls";

function computeGroupCenter(group) {
  var center = new THREE.Vector3();
  var children = group.children;
  var count = children.length;
  for (var i = 0; i < count; i++) {
    center.add(children[i].position);
  }
  center.divideScalar(count);
  return center;
}

core.Style = (args, env) => {
  var copy = Object.assign({}, env);

  args.forEach((el) => {
    interpretate(el, copy);
  });
};
/**
 * @description https://threejs.org/docs/#api/en/materials/LineDashedMaterial
 */
core.Dashing = (args, env) => {
  console.log("Dashing not implemented");
}

core.Annotation = (args, env) => {
  args.forEach((el) => {
    interpretate(el, env);
  });
};

core.GraphicsGroup = (args, env) => {
  var group = new THREE.Group();
  var copy = Object.assign({}, env);

  copy.mesh = group;

  args.forEach((el) => {
    interpretate(el, copy);
  });

  env.mesh.add(group);
};

core.RGBColor = (args, env) => {
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

  env.color = new THREE.Color(r, g, b);
};

core.Opacity = (args, env) => {
  var o = interpretate(args[0], env);
  if (typeof o !== "number") console.error("Opacity must have number value!");
  console.log(o);
  env.opacity = o;
};

core.ImageScaled = (args, env) => { };

core.Thickness = (args, env) => { };

core.Arrowheads = (args, env) => { };

core.Arrow = (args, env) => {
  interpretate(args[0], env);
};

core.Tube = (args, env) => {
  var arr = interpretate(args[0], env);
  if (arr.length === 1) arr = arr[0];
  if (arr.length !== 2) {
    console.error("Tube must have 2 vectors!");
    return;
  }

  const points = [
    new THREE.Vector4(...arr[0], 1),
    new THREE.Vector4(...arr[1], 1),
  ];

  points.forEach((p) => {
    p = p.applyMatrix4(env.matrix);
  });

  const origin = points[0].clone();
  const dir = points[1].add(points[0].negate());

  const arrowHelper = new THREE.ArrowHelper(
    dir.normalize(),
    origin,
    dir.length(),
    env.color,
  );
  env.mesh.add(arrowHelper);
  arrowHelper.line.material.linewidth = env.thickness;
};

core.Sphere = (args, env) => {
  var radius = 1;
  if (args.length > 1) radius = args[1];

  const material = new THREE.MeshLambertMaterial({
    color: env.color,
    transparent: false,
    opacity: env.opacity
  });

  function addSphere(cr) {
    const origin = new THREE.Vector4(...cr, 1);
    const geometry = new THREE.SphereGeometry(radius, 20, 20);
    const sphere = new THREE.Mesh(geometry, material);

    sphere.position.set(origin.x, origin.y, origin.z);

    env.mesh.add(sphere);
    geometry.dispose();
  }

  let list = interpretate(args[0], env);

  if (list.length === 1) list = list[0];
  if (list.length === 1) list = list[0];

  if (list.length === 3) {
    addSphere(list);
  } else if (list.length > 3) {
    list.forEach((el) => {
      addSphere(el);
    });
  } else {
    console.log(list);
    console.error("List of coords. for sphere object is less 1");
    return;
  }

  material.dispose();
};

core.Cuboid = (args, env) => {
  //if (params.hasOwnProperty('geometry')) {
  //	var points = [new THREE.Vector4(...interpretate(func.args[0]), 1),
  //				new THREE.Vector4(...interpretate(func.args[1]), 1)];
  //}
  /**
   * @type {THREE.Vector4}
   */
  var diff;
  /**
   * @type {THREE.Vector4}
   */
  var origin;
  var p;

  if (args.length === 2) {
    var points = [
      new THREE.Vector4(...interpretate(args[0], env), 1),
      new THREE.Vector4(...interpretate(args[1], env), 1),
    ];

    origin = points[0]
      .clone()
      .add(points[1])
      .divideScalar(2);
    diff = points[0].clone().add(points[1].clone().negate());
  } else if (args.length === 1) {
    p = interpretate(args[0], env);
    origin = new THREE.Vector4(...p, 1);
    diff = new THREE.Vector4(1, 1, 1, 1);

    //shift it
    origin.add(diff.clone().divideScalar(2));
  } else {
    console.error("Expected 2 or 1 arguments");
    return;
  }

  const geometry = new THREE.BoxGeometry(diff.x, diff.y, diff.z);
  const material = new THREE.MeshLambertMaterial({
    color: env.color,
    transparent: true,
    opacity: env.opacity,
    depthWrite: true
  });

  //material.side = THREE.DoubleSide;

  const cube = new THREE.Mesh(geometry, material);

  //var tr = new THREE.Matrix4();
  //	tr.makeTranslation(origin.x,origin.y,origin.z);

  //cube.applyMatrix(params.matrix.clone().multiply(tr));

  cube.position.set(origin.x, origin.y, origin.z);

  env.mesh.add(cube);

  geometry.dispose();
  material.dispose();
};

core.Center = (args, env) => {
  return "Center";
};

core.Cylinder = (args, env) => {
  let radius = 1;
  if (args.length > 1) radius = args[1];
  /**
   * @type {THREE.Vector3}}
   */
  const coordinates = interpretate(args[0], env);

  const material = new THREE.MeshLambertMaterial({
    color: env.color,
    transparent: false,
    opacity: env.opacity
  });

  //points 1, 2
  const p1 = new THREE.Vector3(...coordinates[0]);
  const p2 = new THREE.Vector3(...coordinates[1]);
  //direction
  const dp = p2.clone().addScaledVector(p1, -1);

  const geometry = new THREE.CylinderGeometry(radius, radius, dp.length(), 20, 1);

  //calculate the center (might be done better, i hope BoundingBox doest not envolve heavy computations)
  geometry.computeBoundingBox();
  const position = geometry.boundingBox;

  const center = position.max.addScaledVector(position.min, -1);

  //default geometry
  const cylinder = new THREE.Mesh(geometry, material);

  //the default axis of a Three.js cylinder is [010], then we rotate it to dp vector.
  //using https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
  const v = new THREE.Vector3(0, 1, 0).cross(dp.normalize());
  const theta = Math.asin(v.length() / dp.length());
  const sc = Math.sin(theta);
  const mcs = 1.0 - Math.cos(theta);

  //Did not find how to write it using vectors
  const matrix = new THREE.Matrix4().set(
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

core.Tetrahedron = (args, env) => {
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

core.GeometricTransformation = (args, env) => {
  var group = new THREE.Group();
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
      var matrix = new THREE.Matrix4().makeTranslation(...dir, 1);
    } else {
      //make it like Matrix4
      p.forEach((el) => {
        el.push(0);
      });
      p.push([0, 0, 0, 1]);

      var matrix = new THREE.Matrix4();
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
    var bbox = new THREE.Box3().setFromObject(group);
    console.log(bbox);
    var center = bbox.max.clone().add(bbox.min).divideScalar(2);
    if (centrans.length > 0) {
      console.log("CENTRANS");
      center = center.fromArray(centrans);
    }
    console.log(center);

    var translate = new THREE.Matrix4().makeTranslation(
      -center.x,
      -center.y,
      -center.z,
    );
    group.applyMatrix4(translate);
    group.applyMatrix4(matrix);
    translate = new THREE.Matrix4().makeTranslation(
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

core.GraphicsComplex = (args, env) => {
  var copy = Object.assign({}, env);

  copy.geometry = new THREE.Geometry();

  interpretate(args[0], copy).forEach((el) => {
    if (typeof el[0] !== "number") console.error("not a triple of number" + el);
    copy.geometry.vertices.push(new THREE.Vector3(el[0], el[1], el[2]));
  });

  const group = new THREE.Group();

  interpretate(args[1], copy);

  env.mesh.add(group);
  copy.geometry.dispose();
};

core.Polygon = (args, env) => {
  if (env.hasOwnProperty("geometry")) {
    /**
     * @type {THREE.Geometry}
     */
    var geometry = env.geometry.clone();

    var createFace = (c) => {
      c = c.map((x) => x - 1);

      switch (c.length) {
        case 3:
          geometry.faces.push(new THREE.Face3(c[0], c[1], c[2]));
          break;

        case 4:
          geometry.faces.push(
            new THREE.Face3(c[0], c[1], c[2]),
            new THREE.Face3(c[0], c[2], c[3]),
          );
          break;

        case 5:
          geometry.faces.push(
            new THREE.Face3(c[0], c[1], c[4]),
            new THREE.Face3(c[1], c[2], c[3]),
            new THREE.Face3(c[1], c[3], c[4]),
          );
          break;
        /**
         * 0 1
         *5    2
         * 4  3
         */
        case 6:
          geometry.faces.push(
            new THREE.Face3(c[0], c[1], c[5]),
            new THREE.Face3(c[1], c[2], c[5]),
            new THREE.Face3(c[5], c[2], c[4]),
            new THREE.Face3(c[2], c[3], c[4])
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
    var geometry = new THREE.Geometry();
    var points = interpretate(args[0], env);

    points.forEach((el) => {
      if (typeof el[0] !== "number") {
        console.error("not a triple of number", el);
        return;
      }
      geometry.vertices.push(new THREE.Vector3(el[0], el[1], el[2]));
    });

    console.log("points");
    console.log(points);

    switch (points.length) {
      case 3:
        geometry.faces.push(new THREE.Face3(0, 1, 2));
        break;

      case 4:
        geometry.faces.push(
          new THREE.Face3(0, 1, 2),
          new THREE.Face3(0, 2, 3));
        break;
      /**
       *  0 1
       * 4   2
       *   3
       */
      case 5:
        geometry.faces.push(
          new THREE.Face3(0, 1, 4),
          new THREE.Face3(1, 2, 3),
          new THREE.Face3(1, 3, 4));
        break;
      /**
       * 0  1
       *5     2
       * 4   3
       */
      case 6:
        geometry.faces.push(
          new THREE.Face3(0, 1, 5),
          new THREE.Face3(1, 2, 5),
          new THREE.Face3(5, 2, 4),
          new THREE.Face3(2, 3, 4)
        );
        break;
      default:
        console.log(points);
        console.error("Cant build complex polygon ::");
    }
  }

  const material = new THREE.MeshLambertMaterial({
    color: env.color,
    transparent: env.opacity < 0.9,
    opacity: env.opacity,

    //depthTest: false
    //depthWrite: false
  });
  console.log(env.opacity);
  material.side = THREE.DoubleSide;

  geometry.computeFaceNormals();
  //complex.computeVertexNormals();
  const poly = new THREE.Mesh(geometry, material);

  //poly.frustumCulled = false;
  env.mesh.add(poly);
  material.dispose();
};

core.Polyhedron = (args, env) => {
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

    const geometry = new THREE.PolyhedronGeometry(vertices, indices);

    var material = new THREE.MeshLambertMaterial({
      color: env.color,
      transparent: true,
      opacity: env.opacity,
      depthWrite: true,
    });

    const mesh = new THREE.Mesh(geometry, material);
    env.mesh.add(mesh);
    geometry.dispose();
    material.dispose();
  }
};

core.GrayLevel = (args, env) => { };

core.EdgeForm = (args, env) => { };

core.Specularity = (args, env) => { };

core.Text = (args, env) => { };

core.Directive = (args, env) => { };

core.Line = (args, env) => {
  if (env.hasOwnProperty("geometry")) {
    const geometry = new THREE.Geometry();

    const points = interpretate(args[0], env);
    points.forEach((el) => {
      geometry.vertices.push((env.geometry.vertices[el - 1]).clone(),);
    });

    const material = new THREE.LineBasicMaterial({
      linewidth: env.thickness,
      color: env.edgecolor,
    });
    const line = new THREE.Line(geometry, material);

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
      points.push(new THREE.Vector4(...p, 1));
    });
    //new THREE.Vector4(...arr[0], 1)

    points.forEach((p) => {
      p = p.applyMatrix4(env.matrix);
    });

    const geometry = new THREE.Geometry().setFromPoints(points);
    const material = new THREE.LineBasicMaterial({
      color: env.edgecolor,
      linewidth: env.thickness,
    });

    env.mesh.add(new THREE.Line(geometry, material));
  }
};

core.Graphics3D = (args, env) => {
  console.log("GRAPHICS3D");

  /*** the part of a code from http://mathics.github.io.  ***/
  var data = {
    axes: {},
    extent: {
      zmax: 1.0,
      ymax: 1.0,
      zmin: -1.0,
      xmax: 1.0,
      xmin: -1.0,
      ymin: -1.0,
    },

    lighting: [
      { type: "Ambient", color: [0.3, 0.2, 0.4] },
      {
        type: "Directional",
        color: [0.8, 0, 0],
        position: [2, 0, 2],
      },
      {
        type: "Directional",
        color: [0, 0.8, 0],
        position: [2, 2, 2],
      },
      {
        type: "Directional",
        color: [0, 0, 0.8],
        position: [0, 2, 2],
      },
    ],

    viewpoint: [1.3, -2.4, 2],
  };
  /**
   * @type {HTMLElement}
   */
  var container = env.element;
  /**
  * @type {THREE.Mesh<THREE.Geometry>}
  */
  var boundbox;
  var hasaxes;

  // Scene
  const scene = new THREE.Scene();

  const group = new THREE.Group();

  const envcopy = {
    ...env,
    numerical: true,
    tostring: false,
    matrix: new THREE.Matrix4().set(
      1, 0, 0, 0,//
      0, 1, 0, 0,//
      0, 0, 1, 0,//
      0, 0, 0, 1),
    color: new THREE.Color(1, 1, 1),
    opacity: 1,
    thickness: 1,
    edgecolor: new THREE.Color(0, 0, 0),
    mesh: group,
  }

  interpretate(args[0], envcopy);

  const bbox = new THREE.Box3().setFromObject(group);
  if (!isFinite(bbox.min.x)) {
    bbox.set(new THREE.Vector3(-1, -1, -1), new THREE.Vector3(1, 1, 1))
  }
  const center = new THREE.Vector3();
  console.log(
    "BBOX CENTER",
    center,
    bbox);
  scene.position = center;

  const focus = center.clone();

  const viewpoint = new THREE.Vector3()
    .fromArray(data.viewpoint)
    .sub(focus);

  const ln = bbox
    .max
    .clone()
    .add(bbox.min.clone().negate())
    .length();

  console.log("Radius is ", ln);

  viewpoint.multiplyScalar(ln);

  const radius = viewpoint.length();

  let theta = Math.acos(viewpoint.z / radius);
  let phi =
    (Math.atan2(viewpoint.y, viewpoint.x) + 2 * Math.PI) % (2 * Math.PI);

  const camera = new THREE.PerspectiveCamera(
    35, // Field of view
    1, // Aspect ratio
    0.1 * radius, // Near plane
    1000 * radius, // Far plane
  );

  function update_camera_position() {
    camera.position.set(
      radius * Math.sin(theta) * Math.cos(phi),
      radius * Math.sin(theta) * Math.sin(phi),
      radius * Math.cos(theta));
    camera.position.add(focus);
    camera.lookAt(focus);
  }

  //update_camera_position();
  camera.up = new THREE.Vector3(0, 0, 1);

  scene.add(camera);

  // Lighting
  function addLight(l) {
    var color = new THREE.Color().setRGB(l.color[0], l.color[1], l.color[2]);
    var light;

    if (l.type === "Ambient") {
      light = new THREE.AmbientLight(color);
    } else if (l.type === "Directional") {
      light = new THREE.DirectionalLight(color, 1);
    } else if (l.type === "Spot") {
      light = new THREE.SpotLight(color);
      light.position.fromArray(l.position);
      light.target.position.fromArray(l.target);
      light.target.updateMatrixWorld(); // This fixes bug in THREE.js
      light.angle = l.angle;
    } else if (l.type === "Point") {
      light = new THREE.PointLight(color);
      light.position.fromArray(l.position);

      // Add visible light sphere
      const lightsphere = new THREE.Mesh(
        new THREE.SphereGeometry(0.007 * radius, 16, 8),
        new THREE.MeshBasicMaterial({ color }),
      );
      lightsphere.position = light.position;
      scene.add(lightsphere);
    } else {
      alert("Error: Internal Light Error", l.type);
      return;
    }
    return light;
  }

  function getInitLightPos(l) {
    // Initial Light position in spherical polar coordinates
    if (Array.isArray(l.position)) {
      var tmppos = new THREE.Vector3(
        l.position[0],
        l.position[1],
        l.position[2],
      );
      var result = { radius: radius * tmppos.length() };

      if (tmppos.length() <= 0.0001) {
        result.theta = 0;
        result.phi = 0;
      } else {
        result.phi =
          (Math.atan2(tmppos.y, tmppos.x) + 2 * Math.PI) % (2 * Math.PI);
        result.theta = Math.asin(tmppos.z / result.radius);
      }
      return result;
    }
    return;
  }

  function positionLights() {
    for (let i = 0; i < lights.length; i++) {
      if (lights[i] instanceof THREE.DirectionalLight) {
        lights[i].position.set(
          initLightPos[i].radius *
          Math.sin(theta + initLightPos[i].theta) *
          Math.cos(phi + initLightPos[i].phi),
          initLightPos[i].radius *
          Math.sin(theta + initLightPos[i].theta) *
          Math.sin(phi + initLightPos[i].phi),
          initLightPos[i].radius *
          Math.cos(theta + initLightPos[i].theta),
        )
        lights[i].position.add(focus);
      }
    }
  }

  const lights = new Array(data.lighting.length);
  const initLightPos = new Array(data.lighting.length);

  for (let i = 0; i < data.lighting.length; i++) {
    initLightPos[i] = getInitLightPos(data.lighting[i]);

    lights[i] = addLight(data.lighting[i]);
    scene.add(lights[i]);
  }

  // BoundingBox
  boundbox = new THREE.Mesh(
    new THREE.BoxGeometry(
      bbox.max.x - bbox.min.x,
      bbox.max.y - bbox.min.y,
      bbox.max.z - bbox.min.z,
    ),
    new THREE.MeshBasicMaterial({ color: 0x666666, wireframe: true }),
  );
  boundbox.position = center;

  const geo = new THREE.EdgesGeometry(
    new THREE.BoxGeometry(
      bbox.max.x - bbox.min.x,
      bbox.max.y - bbox.min.y,
      bbox.max.z - bbox.min.z,
    ),
  ); // or WireframeGeometry( geometry )

  var mat = new THREE.LineBasicMaterial({ color: 0x666666, linewidth: 2 });

  var wireframe = new THREE.LineSegments(
    geo.translate(center.x, center.y, center.z),
    mat,
  );

  //scene.add(wireframe);

  // Draw the Axes
  if (Array.isArray(data.axes.hasaxes)) {
    hasaxes = [
      data.axes.hasaxes[0],
      data.axes.hasaxes[1],
      data.axes.hasaxes[2],
    ];
  } else if (data.axes.hasaxes instanceof Boolean) {
    if (data.axes) {
      hasaxes = [true, true, true];
    } else {
      hasaxes = [false, false, false];
    }
  } else {
    hasaxes = [false, false, false];
  }
  var axesmat = new THREE.LineBasicMaterial({
    color: 0x000000,
    linewidth: 1.5,
  });
  /**
   * @type {THREE.Geometry[]}
   */
  var axesgeom = [];
  var axesindicies = [
    [
      [0, 5],
      [1, 4],
      [2, 7],
      [3, 6],
    ],
    [
      [0, 2],
      [1, 3],
      [4, 6],
      [5, 7],
    ],
    [
      [0, 1],
      [2, 3],
      [4, 5],
      [6, 7],
    ],
  ];
  /**
   * @type {THREE.Geometry[]}
   */
  const axesmesh = new Array(3);
  for (var i = 0; i < 3; i++) {
    if (hasaxes[i]) {
      axesgeom[i] = new THREE.Geometry();
      axesgeom[i].vertices.push(
        boundbox.geometry.vertices[axesindicies[i][0][0]].clone().add(
          boundbox.position,
        ),
      );
      axesgeom[i].vertices.push(
        boundbox.geometry.vertices[axesindicies[i][0][1]].clone().add(
          boundbox.position,
        ),
      );
      axesmesh[i] = new THREE.Line(axesgeom[i], axesmat);
      scene.add(axesmesh[i]);
    }
  }

  function boxEdgeLength(i, j) {
    return toCanvasCoords(boundbox.geometry.vertices[axesindicies[i][j][0]])
      .clone()
      .sub(toCanvasCoords(boundbox.geometry.vertices[axesindicies[i][j][1]]))
      .setZ(0)
      .length();
  }

  function positionAxes() {
    // Automatic axes placement
    var nearj = null;
    var nearl = 10 * radius;
    var farj = null;
    var farl = 0.0;

    const tmpv = new THREE.Vector3();
    for (var j = 0; j < 8; j++) {
      tmpv.addVectors(boundbox.geometry.vertices[j], boundbox.position);
      tmpv.sub(camera.position);
      var tmpl = tmpv.length();
      if (tmpl < nearl) {
        nearl = tmpl;
        nearj = j;
      } else if (tmpl > farl) {
        farl = tmpl;
        farj = j;
      }
    }
    for (var i = 0; i < 3; i++) {
      if (hasaxes[i]) {
        var maxj = null;
        var maxl = 0.0;
        for (var j = 0; j < 4; j++) {
          if (
            axesindicies[i][j][0] !== nearj &&
            axesindicies[i][j][1] !== nearj &&
            axesindicies[i][j][0] !== farj &&
            axesindicies[i][j][1] !== farj
          ) {
            tmpl = boxEdgeLength(i, j);
            if (tmpl > maxl) {
              maxl = tmpl;
              maxj = j;
            }
          }
        }
        axesmesh[i].vertices[0].addVectors(
          boundbox.geometry.vertices[axesindicies[i][maxj][0]],
          boundbox.position,
        );
        axesmesh[i].vertices[1].addVectors(
          boundbox.geometry.vertices[axesindicies[i][maxj][1]],
          boundbox.position,
        );
        axesmesh[i].verticesNeedUpdate = true;
      }
    }
    update_axes();
  }

  // Axes Ticks
  var tickmat = new THREE.LineBasicMaterial({
    color: 0x000000,
    linewidth: 1.2,
  });
  /**
   * @type {THREE.Line<THREE.Geometry>[][]}
   */
  const ticks = new Array(3);
  /**
   * @type {THREE.Line<THREE.Geometry>[][]}
   */
  var ticks_small = new Array(3);
  var ticklength = 0.005 * radius;

  for (var i = 0; i < 3; i++) {
    if (hasaxes[i]) {
      ticks[i] = [];
      for (var j = 0; j < data.axes.ticks[i][0].length; j++) {
        var tickgeom = new THREE.Geometry();
        tickgeom.vertices.push(new THREE.Vector3(), new THREE.Vector3());
        ticks[i].push(new THREE.Line(tickgeom, tickmat));
        scene.add(ticks[i][j]);
      }
      ticks_small[i] = [];
      for (var j = 0; j < data.axes.ticks[i][1].length; j++) {
        var tickgeom = new THREE.Geometry();
        tickgeom.vertices.push(new THREE.Vector3(), new THREE.Vector3());
        ticks_small[i].push(new THREE.Line(tickgeom, tickmat));
        scene.add(ticks_small[i][j]);
      }
    }
  }

  function getTickDir(i) {
    var tickdir = new THREE.Vector3();
    if (i === 0) {
      if (0.25 * Math.PI < theta && theta < 0.75 * Math.PI) {
        if (axesgeom[0].vertices[0].z > boundbox.position.z) {
          tickdir.set(0, 0, -ticklength);
        } else {
          tickdir.set(0, 0, ticklength);
        }
      } else {
        if (axesgeom[0].vertices[0].y > boundbox.position.y) {
          tickdir.set(0, -ticklength, 0);
        } else {
          tickdir.set(0, ticklength, 0);
        }
      }
    } else if (i === 1) {
      if (0.25 * Math.PI < theta && theta < 0.75 * Math.PI) {
        if (axesgeom[1].vertices[0].z > boundbox.position.z) {
          tickdir.set(0, 0, -ticklength);
        } else {
          tickdir.set(0, 0, ticklength);
        }
      } else {
        if (axesgeom[1].vertices[0].x > boundbox.position.x) {
          tickdir.set(-ticklength, 0, 0);
        } else {
          tickdir.set(ticklength, 0, 0);
        }
      }
    } else if (i === 2) {
      if (
        (0.25 * Math.PI < phi && phi < 0.75 * Math.PI) ||
        (1.25 * Math.PI < phi && phi < 1.75 * Math.PI)
      ) {
        if (axesgeom[2].vertices[0].x > boundbox.position.x) {
          tickdir.set(-ticklength, 0, 0);
        } else {
          tickdir.set(ticklength, 0, 0);
        }
      } else {
        if (axesgeom[2].vertices[0].y > boundbox.position.y) {
          tickdir.set(0, -ticklength, 0, 0);
        } else {
          tickdir.set(0, ticklength, 0, 0);
        }
      }
    }
    return tickdir;
  }

  function update_axes() {
    for (var i = 0; i < 3; i++) {
      if (hasaxes[i]) {
        var tickdir = getTickDir(i);
        var small_tickdir = tickdir.clone();
        small_tickdir.multiplyScalar(0.5);
        for (var j = 0; j < data.axes.ticks[i][0].length; j++) {
          var tmpval = data.axes.ticks[i][0][j];

          ticks[i][j].geometry.vertices[0].copy(axesgeom[i].vertices[0]);
          ticks[i][j].geometry.vertices[1].addVectors(
            axesgeom[i].vertices[0],
            tickdir,
          );

          if (i === 0) {
            ticks[i][j].geometry.vertices[0].x = tmpval;
            ticks[i][j].geometry.vertices[1].x = tmpval;
          } else if (i === 1) {
            ticks[i][j].geometry.vertices[0].y = tmpval;
            ticks[i][j].geometry.vertices[1].y = tmpval;
          } else if (i === 2) {
            ticks[i][j].geometry.vertices[0].z = tmpval;
            ticks[i][j].geometry.vertices[1].z = tmpval;
          }

          ticks[i][j].geometry.verticesNeedUpdate = true;
        }
        for (var j = 0; j < data.axes.ticks[i][1].length; j++) {
          tmpval = data.axes.ticks[i][1][j];

          ticks_small[i][j].geometry.vertices[0].copy(axesgeom[i].vertices[0]);
          ticks_small[i][j].geometry.vertices[1].addVectors(
            axesgeom[i].vertices[0],
            small_tickdir,
          );

          if (i === 0) {
            ticks_small[i][j].geometry.vertices[0].x = tmpval;
            ticks_small[i][j].geometry.vertices[1].x = tmpval;
          } else if (i === 1) {
            ticks_small[i][j].geometry.vertices[0].y = tmpval;
            ticks_small[i][j].geometry.vertices[1].y = tmpval;
          } else if (i === 2) {
            ticks_small[i][j].geometry.vertices[0].z = tmpval;
            ticks_small[i][j].geometry.vertices[1].z = tmpval;
          }

          ticks_small[i][j].geometry.verticesNeedUpdate = true;
        }
      }
    }
  }
  update_axes();

  // Axes numbering using divs

  /**
   * @type {HTMLDivElement[][]}
   */
  var ticknums = new Array(3);
  for (var i = 0; i < 3; i++) {
    if (hasaxes[i]) {
      ticknums[i] = new Array(data.axes.ticks[i][0].length);
      for (var j = 0; j < ticknums[i].length; j++) {
        ticknums[i][j] = document.createElement("div");
        ticknums[i][j].innerHTML = data.axes.ticks[i][2][j];

        // Handle Minus signs
        if (data.axes.ticks[i][0][j] >= 0) {
          ticknums[i][j].style.paddingLeft = "0.5em";
        } else {
          ticknums[i][j].style.paddingLeft = 0;
        }

        ticknums[i][j].style.position = "absolute";
        ticknums[i][j].style.fontSize = "0.8em";
        container.appendChild(ticknums[i][j]);
      }
    }
  }

  function toCanvasCoords(position) {
    var pos = position.clone();
    var projScreenMat = new THREE.Matrix4();
    projScreenMat.multiply(camera.projectionMatrix, camera.matrixWorldInverse);
    //.multiplyVector3( pos );
    pos = pos.applyMatrix4(projScreenMat);

    var result = new THREE.Vector3(
      (pos.x + 1) * 200,
      (1 - pos.y) * 200,
      (pos.z + 1) * 200,
    );
    return result;
  }

  function positionticknums() {
    for (let i = 0; i < 3; i++) {
      if (hasaxes[i]) {
        for (let j = 0; j < ticknums[i].length; j++) {
          /**
           * @type {THREE.Vector3}}
           */
          var tickpos3D = ticks[i][j].geometry.vertices[0].clone();
          var tickDir = new THREE.Vector3().sub(
            ticks[i][j].geometry.vertices[0],
            ticks[i][j].geometry.vertices[1],
          );
          //tickDir.multiplyScalar(3);
          tickDir.setLength(3 * ticklength);
          tickDir.x *= 2.0;
          tickDir.y *= 2.0;
          tickpos3D.add(tickDir);
          var tickpos = toCanvasCoords(tickpos3D);
          tickpos.x -= 10;
          tickpos.y += 8;

          ticknums[i][j].style.left = `${tickpos.x.toString()}px`;
          ticknums[i][j].style.top = `${tickpos.y.toString()}px`;
          if (
            tickpos.x < 5 ||
            tickpos.x > 395 ||
            tickpos.y < 5 ||
            tickpos.y > 395
          ) {
            ticknums[i][j].style.display = "none";
          } else {
            ticknums[i][j].style.display = "";
          }
        }
      }
    }
  }

  scene.add(group);
  const renderer = new THREE.WebGLRenderer({
    antialias: true,
    preserveDrawingBuffer: true,
  });
  new OrbitControls(camera, renderer.domElement);
  renderer.setSize(400, 400);
  renderer.setClearColor(0xffffff);
  container.appendChild(renderer.domElement);
  renderer.domElement.style = "margin:auto";
  function render() {
    positionLights();
    renderer.render(scene, camera);
  }

  function animate() {
    requestAnimationFrame(animate);
    render();
  }
  update_camera_position();
  positionAxes();
  animate();
  positionticknums();
};
