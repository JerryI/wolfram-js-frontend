import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls";
import { Water } from 'three/examples/jsm/objects/Water';
import { Sky } from 'three/examples/jsm/objects/Sky';

import { EffectComposer } from 'three/examples/jsm/postprocessing/EffectComposer';
import { RenderPass } from 'three/examples/jsm/postprocessing/RenderPass.js';
import { UnrealBloomPass } from 'three/examples/jsm/postprocessing/UnrealBloomPass.js';

import { GUI } from 'dat.gui'

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

core.Metalness = (args, env) => {
  env.metalness = interpretate(args[0], env);
}

core.Emissive = (args, env) => {
  var copy = Object.assign({}, env);
  interpretate(args[0], copy);
  env.emissive = copy.color;
}

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

core.Roughness = (args, env) => {
  const o = interpretate(args[0], env);
  if (typeof o !== "number") console.error("Opacity must have number value!");
  console.log(o);
  env.roughness = o;  
}

core.Opacity = (args, env) => {
  var o = interpretate(args[0], env);
  if (typeof o !== "number") console.error("Opacity must have number value!");
  console.log(o);
  env.opacity = o;
};

core.ImageScaled = (args, env) => { };

core.Thickness = (args, env) => { env.thickness = interpretate(args[0], env)};

core.Arrowheads = (args, env) => {
  if (args.length == 1) {
    env.arrowRadius = interpretate(args[0], env);
  } else {
    env.arrowHeight = interpretate(args[1], env);
    env.arrowRadius = interpretate(args[0], env);
  }
};

core.TubeArrow = (args, env) => {
  console.log('Context test');
  console.log(this);

  let radius = 1;
  if (args.length > 1) radius = args[1];
  /**
   * @type {THREE.Vector3}}
   */
  const coordinates = interpretate(args[0], env);

  const material = new THREE.MeshStandardMaterial({
    color: env.color,
    transparent: false,
    roughness: env.roughness,
    opacity: env.opacity,
    metalness: env.metalness,
    emissive: env.emissive
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

  //cone
  const conegeometry = new THREE.ConeBufferGeometry(env.arrowRadius, env.arrowHeight, 32 );
  const cone = new THREE.Mesh(conegeometry, material);
  cone.position.y = dp.length()/2 + env.arrowHeight/2;

  const group = new THREE.Group();
  group.add(cylinder, cone);

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
  group.position = center;
  group.applyMatrix4(matrix);

  //translate its center to the middle target point
  group.position.addScaledVector(middle, -1);

  env.mesh.add(group);

  geometry.dispose();
  conegeometry.dispose();
  material.dispose();
};

core.Arrow = (args, env) => {
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

  const material = new THREE.MeshStandardMaterial({
    color: env.color,
    roughness: env.roughness,
    opacity: env.opacity,
    metalness: env.metalness,
    emissive: env.emissive
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

core.Sky = (args, env) => {
  const sky = new Sky();
	sky.scale.setScalar( 10000 );
	env.mesh.add( sky );
  env.sky = sky;
  env.sun = new THREE.Vector3();

	const skyUniforms = sky.material.uniforms;

	skyUniforms[ 'turbidity' ].value = 10;
	skyUniforms[ 'rayleigh' ].value = 2;
	skyUniforms[ 'mieCoefficient' ].value = 0.005;
	skyUniforms[ 'mieDirectionalG' ].value = 0.8;
}

core.Water = (args, env) => {
  const waterGeometry = new THREE.PlaneGeometry( 10000, 10000 );

	const water = new Water(
		waterGeometry,
		{
			textureWidth: 512,
			textureHeight: 512,
			waterNormals: new THREE.TextureLoader().load( 'textures/waternormals.jpg', function ( texture ) {

        texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
			} ),

      sunDirection: new THREE.Vector3(),
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
  const material = new THREE.MeshStandardMaterial({
    color: env.color,
    transparent: true,
    opacity: env.opacity,
    roughness: env.roughness,
    depthWrite: true,
    metalness: env.metalness,
    emissive: env.emissive
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

  const material = new THREE.MeshStandardMaterial({
    color: env.color,
    transparent: false,
    roughness: env.roughness,
    opacity: env.opacity,
    metalness: env.metalness,
    emissive: env.emissive
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

  const material = new THREE.MeshStandardMaterial({
    color: env.color,
    transparent: env.opacity < 0.9,
    opacity: env.opacity,
    roughness: env.roughness,
    metalness: env.metalness,
    emissive: env.emissive
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

    var material = new THREE.MeshStandardMaterial({
      color: env.color,
      transparent: true,
      opacity: env.opacity,
      depthWrite: true,
      roughness: env.roughness,
      metalness: env.metalness,
      emissive: env.emissive
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

core.PlaneGeometry = () => { new THREE.PlaneGeometry;  };

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
  let ImageSize = options.ImageSize || [400, 400];

  //if only the width is specified
  if (!(ImageSize instanceof Array)) ImageSize = [ImageSize, ImageSize*0.7];
  console.log('Image size');
  console.log(ImageSize);

  /**
  * @type {THREE.Mesh<THREE.Geometry>}
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

    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera( 55, ImageSize[0]/ImageSize[1], 1, 20000 );
    camera.position.set( 3, 3, 10 );

    renderer = new THREE.WebGLRenderer();
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize(ImageSize[0], ImageSize[1]);
    //renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.domElement.style = "margin:auto";
    container.appendChild( renderer.domElement );

    /* postprocess */
		const renderScene = new RenderPass( scene, camera );

		const bloomPass = new UnrealBloomPass( new THREE.Vector2( ImageSize[0], ImageSize[1] ), 1.5, 0.4, 0.85 );
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

    const guiContainer = document.createElement('div');
    guiContainer.classList.add('graphics3d-controller');
    guiContainer.appendChild(gui.domElement);
    container.appendChild( guiContainer );    

    

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
      roughness: 0.5,
      edgecolor: new THREE.Color(0, 0, 0),
      mesh: group,
      metalness: 0,
      emissive: new THREE.Color(0, 0, 0),
      arrowHeight: 20,
      arrowRadius: 5
    }
  
    interpretate(args[0], envcopy);
    
    group.applyMatrix4(new THREE.Matrix4().set(
      1, 0, 0, 0,
      0, 0, 1, 0,
      0,-1, 0, 0,
      0, 0, 0, 1));

    scene.add(group);

    //

    sun = new THREE.Vector3();

    // Water

    const waterGeometry = new THREE.PlaneGeometry( 10000, 10000 );

    water = new Water(
      waterGeometry,
      {
        textureWidth: 512,
        textureHeight: 512,
        waterNormals: new THREE.TextureLoader().load( 'textures/waternormals.jpg', function ( texture ) {

          texture.wrapS = texture.wrapT = THREE.RepeatWrapping;

        } ),
        sunDirection: new THREE.Vector3(),
        sunColor: 0xffffff,
        waterColor: 0x001e0f,
        distortionScale: 3.7,
        fog: true
      }
    );

    water.rotation.x = - Math.PI / 2;

    scene.add( water );

    // Skybox

    const sky = new Sky();
    sky.scale.setScalar( 10000 );
    scene.add( sky );

    const skyUniforms = sky.material.uniforms;

    skyUniforms[ 'turbidity' ].value = 10;
    skyUniforms[ 'rayleigh' ].value = 2;
    skyUniforms[ 'mieCoefficient' ].value = 0.005;
    skyUniforms[ 'mieDirectionalG' ].value = 0.8;

    const parameters = {
      elevation: 8,
      azimuth: 180
    };

    const pmremGenerator = new THREE.PMREMGenerator( renderer );
    let renderTarget;

    function updateSun() {

      const phi = THREE.MathUtils.degToRad( 90 - parameters.elevation );
      const theta = THREE.MathUtils.degToRad( parameters.azimuth );

      sun.setFromSphericalCoords( 1, phi, theta );

      sky.material.uniforms[ 'sunPosition' ].value.copy( sun );
      water.material.uniforms[ 'sunDirection' ].value.copy( sun ).normalize();

      if ( renderTarget !== undefined ) renderTarget.dispose();

      renderTarget = pmremGenerator.fromScene( sky );

      scene.environment = renderTarget.texture;

    }

    updateSun();

    //

    //

    controls = new OrbitControls( camera, renderer.domElement );
    controls.target.set( 0, 1, 0 );
    controls.update();


  }


  function animate() {

    requestAnimationFrame( animate );
    render();
  }

  function render() {
    water.material.uniforms[ 'time' ].value += 1.0 / 60.0;

    //renderer.render( scene, camera );
    composer.render();
  }


};

core.Graphics3D.destroy = (args, env) => {
  console.log('Graphics3D was removed');
}
