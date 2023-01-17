import { EditorView} from "codemirror";

import {StreamLanguage} from "@codemirror/language"
import {mathematica} from "@codemirror/legacy-modes/mode/mathematica"

import {MatchDecorator, WidgetType, keymap} from "@codemirror/view"

import {highlightSpecialChars, drawSelection, highlightActiveLine, dropCursor,
  rectangularSelection, crosshairCursor,
  highlightActiveLineGutter} from "@codemirror/view"
import {EditorState} from "@codemirror/state"
import {defaultHighlightStyle, syntaxHighlighting, indentOnInput, bracketMatching} from "@codemirror/language"
import {history, historyKeymap} from "@codemirror/commands"
import {highlightSelectionMatches} from "@codemirror/search"
import {autocompletion, closeBrackets} from "@codemirror/autocomplete"

import * as THREE from 'three'; 


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

function RGBtoColor(i,k,j) {
  var r = Math.round(255*i);
  var g = Math.round(255*k);
  var b = Math.round(255*j);
  
  return(new THREE.Color("rgb("+r+","+g+","+b+")")); 
}

core.Style = function(args, env) {
  var copy = Object.assign({}, env);
  
  args.forEach(function(el) {
      interpretate(el, copy);
  });
}	

core.Annotation = function(args, env) {
  args.forEach(function(el) {
      interpretate(el, env);
  });
}	

core.GraphicsGroup = function(args, env) {
  var group = new THREE.Group();
  var copy = Object.assign({}, env);
  
  copy.mesh = group;
  
  args.forEach(function(el) {
      interpretate(el, copy);
  });
  
  env.mesh.add(group);
}

core.RGBColor = function(args, env) {
  if (args.length !== 3) console.error( "RGB values should be triple!");

  var r = Math.round(255*interpretate(args[0]));
  var g = Math.round(255*interpretate(args[1]));
  var b = Math.round(255*interpretate(args[2]));
  
  env.color = new THREE.Color("rgb("+r+","+g+","+b+")");			
}

core.Opacity = function(args, env) {
  var o = interpretate(args[0]);
  if (typeof o !== 'number') console.error( "Opacity must have number value!");
  console.log(o);
  env.opacity = o;
} 

core.ImageScaled = function(args, env) {

}

core.Thickness = function(args, env) {

}

core.Arrowheads = function(args, env) {

}

core.Arrow = function(args, env) {
  interpretate(args[0], env);
}

core.Tube = function(args, env) {
  var arr = interpretate(args[0]);
  if (arr.length ===  1) arr = arr[0];
  if (arr.length !== 2) console.error( "Tube must have 2 vectors!");
  
  var points = [new THREE.Vector4(...arr[0], 1),
              new THREE.Vector4(...arr[1], 1)];
  
  points.forEach(function(p) {
      p = p.applyMatrix4(env.matrix);
  });

  var origin = points[0].clone();
  var dir = points[1].add(points[0].negate());
  
  var arrowHelper = new THREE.ArrowHelper(dir.normalize(), origin, dir.length(), env.color);
  env.mesh.add(arrowHelper);
  arrowHelper.line.material.linewidth = env.thickness;
}

core.Sphere = function(args, env) {
  var radius = 1;
  if (args.length > 1) radius = args[1];
  
  var material = new THREE.MeshLambertMaterial({
      color:env.color,
      transparent:false,
      opacity:env.opacity,
  });				
  
  function addSphere(cr) {
      var origin = new THREE.Vector4(...cr, 1);
      var geometry = new THREE.SphereGeometry( radius, 20, 20 );
      var sphere = new THREE.Mesh( geometry, material );
      
      sphere.position.x = origin.x; 
      sphere.position.y = origin.y; 
      sphere.position.z = origin.z;

      env.mesh.add( sphere );
      geometry.dispose(); 			
  }	

  var list = interpretate(args[0]);
  
  if (list.length === 1) list=list[0];
  if (list.length === 1) list=list[0];
  
  if (list.length === 3) {
      addSphere(list);
  } else if (list.length > 3) {
      list.forEach(function(el) {
          addSphere(el);		
      });	
  } else {
      console.log(list);
      console.error( "List of coords. for sphere object is less 1");
  }
  
  material.dispose();    
}
  
core.Cuboid = function(args, env) {
  //if (params.hasOwnProperty('geometry')) {
  //	var points = [new THREE.Vector4(...interpretate(func.args[0]), 1),
  //				new THREE.Vector4(...interpretate(func.args[1]), 1)];				
  //}
  console.log("Cuboid");
  var points, diff, origin, p;
  
  if (args.length === 2) {
  
      points = [new THREE.Vector4(...interpretate(args[0]), 1),
              new THREE.Vector4(...interpretate(args[1]), 1)];			
  
      origin = points[0].clone().add(points[1].clone()).divideScalar(2);
      diff = points[0].clone().add(points[1].clone().negate());
  
  } else if (args.length === 1) {
      p = interpretate(args[0]);
      origin = new THREE.Vector4(...p, 1);
      diff = new THREE.Vector4(1,1,1, 1);
      
      //shift it
      origin.add(diff.clone().divideScalar(2))
  } else {
      console.error( "Expected 2 or 1 arguments");
  }
  
  
  var geometry = new THREE.BoxGeometry(diff.x, diff.y, diff.z);
  var material = new THREE.MeshLambertMaterial({
      color:env.color,
      transparent:true,
      opacity:env.opacity,
      depthWrite: true
  });
  
  //material.side = THREE.DoubleSide;
  
  var cube = new THREE.Mesh( geometry, material );
  
  //var tr = new THREE.Matrix4();
  //	tr.makeTranslation(origin.x,origin.y,origin.z);
  
  //cube.applyMatrix(params.matrix.clone().multiply(tr));
  
  
  
  cube.position.x = origin.x; 
  cube.position.y = origin.y; 
  cube.position.z = origin.z; 
  
  
  env.mesh.add(cube);
  
  geometry.dispose();
  material.dispose();

}

core.Center = function(args, env) {
  return 'Center';
}

core.Cylinder = function(args, env) {
//some troubles with positioning...
//fixme  
var radius = 1;
if (args.length > 1) radius = args[1];

var coordinates = interpretate(args[0]);


let material = new THREE.MeshLambertMaterial({
  color:env.color,
  transparent:false,
  opacity:env.opacity,
});  

//point 1
var p1 = new THREE.Vector4(...coordinates[0], 1);
//point 2 - 1
var dp = new THREE.Vector4(...coordinates[1], 1).addScaledVector(p1, -1);

var geometry = new THREE.CylinderGeometry(radius, radius, dp.length(), 20, 1);

var cylinder = new THREE.Mesh( geometry, material );

//fethcing the angle of rotation of the cylider
let phi   = Math.atan2(dp.y, dp.x);
let theta = Math.acos(dp.z / dp.length());

console.log(phi + "   " + theta);

var euler = new THREE.Euler(phi, theta, 0, 'XYZ' );
var matrix = new THREE.Matrix4().makeRotationFromEuler(euler);

//some troubles with positioning...
//fixme
cylinder.position.x = p1.x; 
cylinder.position.y = p1.y; 
cylinder.position.z = p1.z; 

let group = new THREE.Group();
group.add(cylinder);
group.applyMatrix4(matrix);

env.mesh.add(group);

geometry.dispose();
material.dispose();

}

core.Tetrahedron = function(args, env) {
  var points = interpretate(args[0]);
  var faces = [];
  console.log("Points of tetrahedron:");
  console.log(points);
  
  faces.push([points[0], points[1], points[2]]);
  faces.push([points[0], points[1], points[3]]);
  faces.push([points[1], points[2], points[3]]);
  faces.push([points[0], points[3], points[2]]);

  var fake = ["List"];
  
  var listVert = function(cord) {
          return([
                  "List",
                  cord[0],
                  cord[1],
                  cord[2]
                  ]);
  }
      
  faces.forEach(function(fs) {

      var struc = [
                      "Polygon",
                      [
                          "List",
                          listVert(fs[0]),
                          listVert(fs[1]),
                          listVert(fs[2])
                      ]
                  ];
      fake.push(struc);
  });
  console.log(fake);
  interpretate(fake, env);
}
      

core.GeometricTransformation = function(args, env) {
  
  var group = new THREE.Group();
  //Если center, то наверное надо приметь matrix 
  //к каждому объекту относительно родительской группы.
  var p = interpretate(args[1]);
  var centering = false;
  var centrans = [];
  
  
  
  
  if (p.length === 1) { p = p[0]; }
  if (p.length === 1) { p = p[0]; }
  else if (p.length === 2) {
      console.log(p);
      if (p[1] === 'Center') {
          
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
      
  
      if (typeof p[0] === 'number') {
          var dir = p;
          var matrix = new THREE.Matrix4().makeTranslation(...dir,1);
      } else {
          
          //make it like Matrix4
          p.forEach(function(el) {
              el.push(0);
          });
          p.push([0,0,0,1]);
          

          var matrix = new THREE.Matrix4();
          console.log("Apply matrix to group::");
          matrix.set(...aflatten(p));
      }
  } else {
      console.log(p);
      console.error( "Unexpected length matrix: :: " + p);
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
      var center = new THREE.Vector3().addVectors(bbox.max,bbox.min).divideScalar(2);
      if (centrans.length > 0) {
          console.log("CENTRANS");
          center = center.fromArray(centrans);
      }
      console.log(center);
      
      var	translate = new THREE.Matrix4().makeTranslation(-center.x,-center.y,-center.z,1);
      group.applyMatrix(translate);
      group.applyMatrix(matrix);
          translate = new THREE.Matrix4().makeTranslation(center.x,center.y,center.z,1);
      group.applyMatrix(translate);
  } else {
      group.applyMatrix(matrix);
  }
  
  env.mesh.add(group);
  
}

core.GraphicsComplex = function(args, env) {			
  var copy = Object.assign({}, env);
  
  copy.geometry = new THREE.Geometry();
  
  interpretate(args[0]).forEach(function(el) {
      if (typeof el[0] !== 'number') console.error( "not a triple of number"+el);
      copy.geometry.vertices.push(
          new THREE.Vector3(el[0],el[1],el[2])
      );
  });

  var group = new THREE.Group();
  
  
  interpretate(args[1], copy);
  
  env.mesh.add(group);	
  copy.geometry.dispose();
}

core.Polygon = function(args, env) {	
  if (env.hasOwnProperty('geometry')) {
      var geometry = env.geometry.clone();

      var createFace = function(c) {
          
          switch(c.length) {
              case 3:
                  geometry.faces.push(new THREE.Face3(c[0]-1,c[1]-1,c[2]-1));
              break;
              
              case 4:
                  geometry.faces.push(new THREE.Face3(c[0]-1,c[1]-1,c[2]-1));
                  geometry.faces.push(new THREE.Face3(c[0]-1,c[2]-1,c[3]-1));
              break;
              
              case 5:
                  geometry.faces.push(new THREE.Face3(c[0]-1,c[1]-1,c[4]-1));
                  geometry.faces.push(new THREE.Face3(c[1]-1,c[2]-1,c[3]-1));
                  geometry.faces.push(new THREE.Face3(c[1]-1,c[3]-1,c[4]-1));
              break;
              
              default:
                  console.log(c);
                  console.log(c.length);
                  console.error( "Cant produce complex polygons! at"+c);
              
          }
      }
      
      var a = interpretate(args[0]);
      if (a.length === 1) {
          a = a[0];
      }
      
      if (typeof a[0] === 'number') {
          console.log("Create single face");
          createFace(a);
      } else {
          console.log("Create multiple face");
          console.log(a);
          a.forEach(function(el) {
          
              createFace(el);
          });
      }
  } else {
      
      var geometry = new THREE.Geometry();
      var points = interpretate(args[0]);
  
      points.forEach(function(el) {
          if (typeof el[0] !== 'number') console.error( "not a triple of number"+el);
          geometry.vertices.push(
              new THREE.Vector3(el[0],el[1],el[2])
          );					
      });
      
      console.log("points");
      console.log(points);
      
      switch(points.length) {
          case 3:
              geometry.faces.push(new THREE.Face3(0,1,2));
          break;
          
          case 4:
              geometry.faces.push(new THREE.Face3(0,1,2));
              geometry.faces.push(new THREE.Face3(0,2,3));
          break;
          
          case 5:
              geometry.faces.push(new THREE.Face3(0,1,4));
              geometry.faces.push(new THREE.Face3(1,2,3));
              geometry.faces.push(new THREE.Face3(1,3,4));
          break;
          
          default:
              console.log(points);
              console.error( "Cant build complex polygon ::");
      }
      
  }
  
  var material = new THREE.MeshLambertMaterial({
      color:env.color,
      transparent: env.opacity < 0.9? true : false,
      opacity:env.opacity,

      //depthTest: false
      //depthWrite: false
  });
  console.log(env.opacity);
  material.side = THREE.DoubleSide;
  
  geometry.computeFaceNormals();
  //complex.computeVertexNormals();
  var poly = new THREE.Mesh(geometry, material);
  
  //poly.frustumCulled = false;
  env.mesh.add(poly);
  material.dispose();
}

core.Polyhedron = function(args, env) {
if(args[1][1].length > 4) {
  //non-optimised variant to work with 4 vertex per face
  interpretate([ "GraphicsComplex", args[0], [ "Polygon", args[1]] ], env);
} else {
  //reguar one. gpu-fiendly
  /**
   * @type {number[]}
   */
  const indices = interpretate(args[1]).flat(4).map(i=>i-1);  
  /**
   * @type {number[]}
   */
  const vertices = interpretate(args[0]).flat(4);

  const geometry = new THREE.PolyhedronGeometry(vertices, indices);

  var material = new THREE.MeshLambertMaterial({
    color:env.color,
    transparent:true,
    opacity:env.opacity,
    depthWrite: true
  });

  const mesh = new THREE.Mesh(geometry, material);
  env.mesh.add(mesh);
  geometry.dispose();
  material.dispose();
}
}

core.GrayLevel = function(args, env) {

}

core.EdgeForm = function(args, env) {

}	

core.Specularity = function(args, env) {

}

core.Text = function(args, env) {

}

core.Directive = function(args, env) {

}

core.Line = function(args, env) {
  if (env.hasOwnProperty('geometry')) {
      var geometry = new THREE.Geometry();
      
      var points = interpretate(args[0]);
      points.forEach(function(el) {
          geometry.vertices.push(new THREE.Vector3().copy(env.geometry.vertices[el-1]));
      });
      
      var material = new THREE.LineBasicMaterial( { linewidth: env.thickness, color: env.edgecolor } );
      var line = new THREE.Line( geometry, material );
      
      line.material.polygonOffset = true;
      line.material.polygonOffsetFactor = 1;
      line.material.polygonOffsetUnits = 1;
      
      env.mesh.add(line);
      
      geometry.dispose();
      material.dispose();
  } else {
      var arr = interpretate(args[0]);
      if (arr.length ===  1) arr = arr[0];
      //if (arr.length !== 2) console.error( "Tube must have 2 vectors!");
      console.log("points: "+arr.length);
  
      var points = [];
      arr.forEach(function(p) {
          points.push(new THREE.Vector4(...p, 1));
      });
      //new THREE.Vector4(...arr[0], 1)
      
      points.forEach(function(p) {
          p = p.applyMatrix4(env.matrix);
      });

      const geometry = new THREE.BufferGeometry().setFromPoints( points );
      const material = new THREE.LineBasicMaterial({
          color: env.edgecolor,
          linewidth: env.thickness
      });
      
      env.mesh.add(new THREE.Line( geometry, material ));
      
  }
}


core.Graphics3D = function(args, env) {
  console.log("GRAPHICS3D");

  /*** the part of a code from http://mathics.github.io.  ***/
  var data = {"axes": {}, 
              "extent": {"zmax": 1.0, "ymax": 1.0, "zmin": -1.0, "xmax": 1.0, "xmin": -1.0, "ymin": -1.0}, 

              "lighting": [ {"type": "Ambient", "color": [0.3, 0.2, 0.4]},
                              {"type": "Directional", "color": [0.8, 0., 0.],
                              "position": [2, 0, 2]},
                              {"type": "Directional", "color": [0., 0.8, 0.],
                              "position": [2, 2, 2]},
                              {"type": "Directional", "color": [0., 0., 0.8],
                              "position": [0, 2, 2]}],
   
              "viewpoint":[1.3, -2.4, 2]};
  /**
   * @type {HTMLElement}
   */
  var container = env.element;
  
  var camera, scene, renderer, boundbox, hasaxes, viewpoint,
    isMouseDown = false, onMouseDownPosition,
    tmpx, tmpy, tmpz, 
    theta, onMouseDownTheta, phi, onMouseDownPhi;

  // Scene
  scene = new THREE.Scene();
  
  var group = new THREE.Group();
  
  var envcopy = Object.assign({}, env);
      envcopy.matrix = new THREE.Matrix4();
      envcopy.color = RGBtoColor(1,1,1);
      envcopy.opacity = 1;
      envcopy.thickness = 1;
      envcopy.edgecolor = RGBtoColor(0,0,0);
  
      envcopy.matrix.set( 1,0,0,0,
                          0,1,0,0,
                          0,0,1,0,
                          0,0,0,1 );

      envcopy.mesh = group;
  
  interpretate(args[0], envcopy);
  
  var bbox = new THREE.Box3().setFromObject(group);
      
  var center = new THREE.Vector3().addVectors(bbox.max,bbox.min).divideScalar(2);
  console.log("BBOX CENTER");
  console.log(center);
  console.log(bbox);
  //var	translate = new THREE.Matrix4().makeTranslation(-center.x,-center.y,-center.z,1);
  //group.applyMatrix(translate);	
  scene.position = center;
  
                  
    
  // Center of the scene
  //var center = new THREE.Vector3(
  //  0.5 * (data.extent.xmin + data.extent.xmax),
  //  0.5 * (data.extent.ymin + data.extent.ymax), 
  //  0.5 * (data.extent.zmin + data.extent.zmax));
  
  // Where the camera is looking
  var focus = new THREE.Vector3(center.x, center.y, center.z);
  
  // Viewpoint
  viewpoint = new THREE.Vector3(data.viewpoint[0], data.viewpoint[1], data.viewpoint[2]).sub(focus);
  
  var ln = new THREE.Vector3().addVectors(bbox.max,bbox.min.clone().negate()).length();
  
  console.log("Radius is "+ln);
  
  viewpoint.x *= ln; 
  viewpoint.y *= ln; 
  viewpoint.z *= ln;
  
  var radius = viewpoint.length()
  
  onMouseDownTheta = theta = Math.acos(viewpoint.z / radius);
  onMouseDownPhi = phi = (Math.atan2(viewpoint.y, viewpoint.x) + 2*Math.PI) % (2 * Math.PI);

  
  
  
  camera = new THREE.PerspectiveCamera(
    35,             // Field of view
    1,            // Aspect ratio
    0.1*radius,     // Near plane
    1000*radius     // Far plane
  );
  
  function update_camera_position() {
    camera.position.x = radius * Math.sin(theta) * Math.cos(phi);
    camera.position.y = radius * Math.sin(theta) * Math.sin(phi);
    camera.position.z = radius * Math.cos(theta);
    camera.position.add(focus);
    camera.lookAt(focus);
  }
  
  //update_camera_position();
  camera.up = new THREE.Vector3(0,0,1);
  
  scene.add(camera);
  
  // Lighting
  function addLight(l) {
    var color = new THREE.Color().setRGB(l.color[0], l.color[1], l.color[2]);
    var light;
  
    if (l.type === "Ambient") {
      light = new THREE.AmbientLight(color.getHex());
    } else if (l.type === "Directional") {
      light = new THREE.DirectionalLight(color.getHex(), 1);
    } else if (l.type === "Spot") {
      light = new THREE.SpotLight(color.getHex());
      light.position.set(l.position[0], l.position[1], l.position[2]);
      light.target.position.set(l.target[0], l.target[1], l.target[2]);
      light.target.updateMatrixWorld(); // This fixes bug in THREE.js
      light.angle = l.angle;
    } else if (l.type === "Point") {
      light = new THREE.PointLight(color.getHex());
      light.position.set(l.position[0], l.position[1], l.position[2]);
  
      // Add visible light sphere
      var lightsphere = new THREE.Mesh(
        new THREE.SphereGeometry(0.007*radius, 16, 8),
        new THREE.MeshBasicMaterial({color: color.getHex()})
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
    if (l.position instanceof Array) {
      var tmppos = new THREE.Vector3(l.position[0], l.position[1], l.position[2]);
      var result = {"radius": radius * tmppos.length()};
  
      if (tmppos.length() <= 0.0001) {
        result.theta = 0;
        result.phi = 0;
      } else {
        result.phi = (Math.atan2(tmppos.y, tmppos.x) + 2 * Math.PI) % (2 * Math.PI);
        result.theta = Math.asin(tmppos.z / result.radius);
      }
      return result;
    }
    return;
  }
  
  function positionLights() {
    for (var i = 0; i < lights.length; i++) {
      if (lights[i] instanceof THREE.DirectionalLight) {
        lights[i].position.x = initLightPos[i].radius * Math.sin(theta + initLightPos[i].theta) * Math.cos(phi + initLightPos[i].phi);
        lights[i].position.y = initLightPos[i].radius * Math.sin(theta + initLightPos[i].theta) * Math.sin(phi + initLightPos[i].phi);
        lights[i].position.z = initLightPos[i].radius * Math.cos(theta + initLightPos[i].theta);
        lights[i].position.add(focus);
      }
    }
  }
  
  var lights = new Array(data.lighting.length);
  var initLightPos = new Array(data.lighting.length);
  
  for (var i = 0; i < data.lighting.length; i++) {
    initLightPos[i] = getInitLightPos(data.lighting[i]);
    
    lights[i] = addLight(data.lighting[i]);
    scene.add(lights[i]);
  }
  
  // BoundingBox
  boundbox = new THREE.Mesh(
    new THREE.BoxGeometry(
      bbox.max.x - bbox.min.x,
      bbox.max.y - bbox.min.y,
      bbox.max.z - bbox.min.z),
    new THREE.MeshBasicMaterial({color: 0x666666, wireframe: true})
  );
  boundbox.position = center;

  var geo = new THREE.EdgesGeometry( new THREE.BoxGeometry(
      bbox.max.x - bbox.min.x,
      bbox.max.y - bbox.min.y,
      bbox.max.z - bbox.min.z) ); // or WireframeGeometry( geometry )
  
  var mat = new THREE.LineBasicMaterial( { color: 0x666666, linewidth: 2 } );
  
  var wireframe = new THREE.LineSegments( geo.translate(center.x,center.y,center.z), mat );				
  
  
  //scene.add(wireframe);  
  
  // Draw the Axes
  if (Array.isArray(data.axes.hasaxes)) {
    hasaxes = [data.axes.hasaxes[0], data.axes.hasaxes[1], data.axes.hasaxes[2]];
  } else if (data.axes.hasaxes instanceof Boolean) {
    if (data.axes) {
      hasaxes = [true, true, true];
    } else {
      hasaxes = [false, false, false];
    }
  } else {
    hasaxes = [false, false, false];
  }
  var axesmat = new THREE.LineBasicMaterial({ color: 0x000000, linewidth : 1.5 });
  var axesgeom = [];
  var axesindicies = [
    [[0,5], [1,4], [2,7], [3,6]],
    [[0,2], [1,3], [4,6], [5,7]],
    [[0,1], [2,3], [4,5], [6,7]]
  ];
  /**
   * @type {THREE.Geometry[]}
   */
  var axesmesh = new Array(3);
  for (var i=0; i<3; i++) {
    if (hasaxes[i]) {
      axesgeom[i] = new THREE.Geometry();
      axesgeom[i].vertices.push(new THREE.Vector3().addVectors(
        boundbox.geometry.vertices[axesindicies[i][0][0]], boundbox.position)
      );
      axesgeom[i].vertices.push(new THREE.Vector3().addVectors(
        boundbox.geometry.vertices[axesindicies[i][0][1]], boundbox.position)
      );
      axesmesh[i] = new THREE.Line(axesgeom[i], axesmat);
      axesmesh[i].geometry.dynamic = true;
      scene.add(axesmesh[i]);
    }
  }
  
  function boxEdgeLength(i, j) {
    edge = new THREE.Vector3().sub(
      toCanvasCoords(boundbox.geometry.vertices[axesindicies[i][j][0]]),
      toCanvasCoords(boundbox.geometry.vertices[axesindicies[i][j][1]])
    );
    edge.z = 0;
    return edge.length();
  }
  
  function positionAxes() {
    // Automatic axes placement
    nearj = null;
    nearl = 10*radius;
    farj = null;
    farl = 0.0;
    
    var tmpv = new THREE.Vector3();
    for (var j = 0; j < 8; j++) {
      tmpv.addVectors(boundbox.geometry.vertices[j], boundbox.position);
      tmpv.sub(camera.position);
      tmpl = tmpv.length();
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
        maxj = null;
        maxl = 0.0;
        for (var j = 0; j < 4; j++) {
          if (axesindicies[i][j][0] !== nearj && axesindicies[i][j][1] !== nearj && axesindicies[i][j][0] !== farj && axesindicies[i][j][1] !== farj) {
            tmpl = boxEdgeLength(i, j);
            if (tmpl > maxl) {
              maxl = tmpl;
              maxj = j;
            }
          }
        }
        axesmesh[i].geometry.vertices[0].addVectors(boundbox.geometry.vertices[axesindicies[i][maxj][0]], boundbox.position);
        axesmesh[i].geometry.vertices[1].addVectors(boundbox.geometry.vertices[axesindicies[i][maxj][1]], boundbox.position);
        axesmesh[i].geometry.verticesNeedUpdate = true;
      }
    }
    update_axes();
  }
  
  // Axes Ticks
  var tickmat = new THREE.LineBasicMaterial({ color: 0x000000, linewidth : 1.2 });
  /**
   * @type {THREE.Line[][]}
   */
  var ticks = new Array(3);
  /**
   * @type {THREE.Line[][]}
   */
  var ticks_small = new Array(3);
  var ticklength = 0.005*radius;
  
  for (var i = 0; i < 3; i++) {
    if (hasaxes[i]) {
      ticks[i] = [];
      for (var j = 0; j < data.axes.ticks[i][0].length; j++) {
        var tickgeom = new THREE.Geometry();
        tickgeom.vertices.push(new THREE.Vector3());
        tickgeom.vertices.push(new THREE.Vector3());
        ticks[i].push(new THREE.Line(tickgeom, tickmat));
        scene.add(ticks[i][j]);
      }
      ticks_small[i] = [];
      for (var j = 0; j < data.axes.ticks[i][1].length; j++) {
         var tickgeom = new THREE.Geometry();
         tickgeom.vertices.push(new THREE.Vector3());
         tickgeom.vertices.push(new THREE.Vector3());
         ticks_small[i].push(new THREE.Line(tickgeom, tickmat));
         scene.add(ticks_small[i][j]);
      }
    }
  }
  
  function getTickDir(i) {
    var tickdir = new THREE.Vector3();
    if (i === 0) {
      if (0.25*Math.PI < theta && theta < 0.75*Math.PI) {
        if (axesgeom[0].vertices[0].z > boundbox.position.z) {
          tickdir.set(0, 0, -ticklength);
        } else {
          tickdir.set(0, 0, ticklength);
        }
      } else {
        if (axesgeom[0].vertices[0].y > boundbox.position.y) {
          tickdir.set(0,-ticklength, 0);
        } else {
          tickdir.set(0, ticklength, 0);
        }
      }
    } else if (i === 1) {
      if (0.25*Math.PI < theta && theta < 0.75*Math.PI) {
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
      if ((0.25*Math.PI < phi && phi < 0.75*Math.PI) || (1.25*Math.PI < phi && phi < 1.75*Math.PI)) {
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
          ticks[i][j].geometry.vertices[1].addVectors(axesgeom[i].vertices[0], tickdir);
  
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
          ticks_small[i][j].geometry.vertices[1].addVectors(axesgeom[i].vertices[0], small_tickdir);
  
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
  var ticknums = new Array(3);
  for (var i = 0; i < 3; i++) {
    if (hasaxes[i]) {
      ticknums[i] = new Array(data.axes.ticks[i][0].length);
      for (var j = 0; j < ticknums[i].length; j++) {
        ticknums[i][j] = document.createElement('div');
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
  
    var result = new THREE.Vector3((pos.x + 1 ) * 200, (1-pos.y) * 200, (pos.z + 1 ) * 200);
    return result;
  }
  
  function positionticknums() {
    for (var i = 0; i < 3; i++) {
      if (hasaxes[i]) {
        for (var j = 0; j < ticknums[i].length; j++) {
          var tickpos3D = ticks[i][j].geometry.vertices[0].clone();
          var tickDir = new THREE.Vector3().sub(ticks[i][j].geometry.vertices[0], ticks[i][j].geometry.vertices[1]);
          //tickDir.multiplyScalar(3);
          tickDir.setLength(3*ticklength);
          tickDir.x *= 2.0;
          tickDir.y *= 2.0;
          tickpos3D.add(tickDir);
          var tickpos = toCanvasCoords(tickpos3D);
          tickpos.x -= 10;
          tickpos.y += 8;
  
          ticknums[i][j].style.left = tickpos.x.toString() + "px";
          ticknums[i][j].style.top = tickpos.y.toString() + "px";
          if (tickpos.x < 5 || tickpos.x > 395 || tickpos.y < 5 || tickpos.y > 395) {
            ticknums[i][j].style.display = "none";
          }
          else {
            ticknums[i][j].style.display = "";
          }
        }
      }
    }
  }
  
  

  scene.add(group);
  //loader = new THREE.JSONLoader();

  //loader.load( JSON.parse(str));
  //loader.onLoadComplete=function(mesh){scene.add( mesh )} 
  
  // Plot the primatives
  /*for (var indx = 0; indx < data.elements.length; indx++) {
    var type = data.elements[indx].type;
    switch(type) {
      case "point":
        scene.add(drawPoint(data.elements[indx]));
        break;
      case "line":
        scene.add(drawLine(data.elements[indx]));
        break;
      case "polygon":
        scene.add(drawPolygon(data.elements[indx]));
        break;
      case "sphere":
        scene.add(drawSphere(data.elements[indx]));
        break;
      case "cube":
        scene.add(drawCube(data.elements[indx]));
        break;
      default:
        alert("Error: Unknown type passed to drawGraphics3D");
    }
  }*/
  
  // Renderer (set preserveDrawingBuffer to deal with issue
  // of weird canvas content after switching windows)

  renderer = new THREE.WebGLRenderer({antialias: true, preserveDrawingBuffer: true});
  
  renderer.setSize(400, 400);
  renderer.setClearColor( 0xffffff );
  container.appendChild(renderer.domElement);
  renderer.domElement.style = "margin:auto";
  
  function render() {
    positionLights();
    renderer.render( scene, camera );
  }
  
  function toScreenCoords(position) {
    return position.clone().applyMatrix3(camera.matrixWorldInverse);
  }
  
  function ScaleInView() {
    var tmp_fov = 0.0;
    //var proj2d = new THREE.Vector3();
  
    /*for (var i=0; i<boundbox.geometry.vertices.length; i++) {
      proj2d = proj2d.addVectors(boundbox.geometry.vertices[i], boundbox.position);
      proj2d = toScreenCoords(proj2d);
  
      angle = 114.59 * Math.max(
         Math.abs(Math.atan(proj2d.x/proj2d.z) / camera.aspect),
         Math.abs(Math.atan(proj2d.y/proj2d.z))
      );
      tmp_fov = Math.max(tmp_fov, angle);
    }*/
    //console.log(bbox);
    var height = bbox.min.clone().sub(bbox.max).length();
    var dist = center.clone().sub(camera.position).length();
    tmp_fov = 2 * Math.atan( height / ( 2 * dist ) ) * ( 180 / Math.PI );
    
    camera.fov = tmp_fov + 5;
    camera.updateProjectionMatrix();
  }
  

  /**
   * 
   * @param {MouseEvent} event 
   * @description Mouse Interactions
   */
  function onDocumentMouseDown( event ) {
    event.preventDefault();
  
    isMouseDown = true;
    isShiftDown = false;
    isCtrlDown = false;
  
    onMouseDownTheta = theta;
    onMouseDownPhi = phi;
  
    onMouseDownPosition.x = event.clientX;
    onMouseDownPosition.y = event.clientY;
  
    onMouseDownFocus = new THREE.Vector3().copy(focus);
  }
  /**
   * 
   * @param {MouseEvent} event 
   */
  function onDocumentMouseMove(event) {
    event.preventDefault();
  
    if (isMouseDown) {
      positionticknums();
  
      if (event.shiftKey) {
        // console.log("Pan");
        if (! isShiftDown) {
          isShiftDown = true;
          onMouseDownPosition.x = event.clientX;
          onMouseDownPosition.y = event.clientY;
          autoRescale = false;
          container.style.cursor = "move";
        }
        var camz = new THREE.Vector3().sub(focus, camera.position);
        camz.normalize();
  
        var camx = new THREE.Vector3(
            - radius * Math.cos(theta) * Math.sin(phi) * (theta<0.5*Math.PI?1:-1),
            radius * Math.cos(theta) * Math.cos(phi) * (theta<0.5*Math.PI?1:-1),
            0
        );
        camx.normalize();
  
        var camy = new THREE.Vector3();
        camy.cross(camz, camx);
  
        focus.x = onMouseDownFocus.x + (radius / 400)*(camx.x * (onMouseDownPosition.x - event.clientX) + camy.x * (onMouseDownPosition.y - event.clientY));
        focus.y = onMouseDownFocus.y + (radius / 400)*(camx.y * (onMouseDownPosition.x - event.clientX) + camy.y * (onMouseDownPosition.y - event.clientY));
        focus.z = onMouseDownFocus.z + (radius / 400)*(camx.z * (onMouseDownPosition.x - event.clientX) + camy.z * (onMouseDownPosition.y - event.clientY));
  
        update_camera_position();
  
      } else if (event.ctrlKey) {
        // console.log("Zoom");
        if (! isCtrlDown) {
          isCtrlDown = true;
          onCtrlDownFov = camera.fov;
          onMouseDownPosition.x = event.clientX;
          onMouseDownPosition.y = event.clientY;
          autoRescale = false;
          container.style.cursor = "crosshair";
        }
        camera.fov =  onCtrlDownFov + 20 * Math.atan((event.clientY - onMouseDownPosition.y)/50);
        
        camera.fov = Math.max(1, Math.min(camera.fov, 150));
        //console.log("fov"+camera.fov);
        camera.updateProjectionMatrix();
        //console.log(JSON.stringify(camera));
      } else {
        // console.log("Spin");
        if (isCtrlDown || isShiftDown) {
          onMouseDownPosition.x = event.clientX;
          onMouseDownPosition.y = event.clientY;
          isShiftDown = false;
          isCtrlDown = false;
          container.style.cursor = "pointer";
        }
  
        phi = 2 * Math.PI * (onMouseDownPosition.x - event.clientX) / 400 + onMouseDownPhi;
        phi = (phi + 2 * Math.PI) % (2 * Math.PI);
        theta = 2 * Math.PI * (onMouseDownPosition.y - event.clientY) / 400 + onMouseDownTheta;
        var epsilon = 1e-12; // Prevents spinnging from getting stuck
        theta = Math.max(Math.min(Math.PI - epsilon, theta), epsilon);
  
        update_camera_position();
      }
      render();
    } else {
      container.style.cursor = "pointer";
    }
  }
  /**
   * 
   * @param {MouseEvent} event 
   */
  function onDocumentMouseUp(event) {
    event.preventDefault();
  
    isMouseDown = false;
    container.style.cursor = "pointer";
  
    if (autoRescale) {
        ScaleInView();
        render();
    }
    positionAxes();
    render();
    positionticknums();
  }
  
  // Bind Mouse events
  container.addEventListener('mousemove', onDocumentMouseMove, false);
  container.addEventListener('mousedown', onDocumentMouseDown, false);
  container.addEventListener('mouseup', onDocumentMouseUp, false);
  container.addEventListener('touchmove', onDocumentMouseMove, false);
  onMouseDownPosition = new THREE.Vector2();
  var autoRescale = true;
  
  update_camera_position();
  positionAxes();
  render(); // Rendering twice updates camera.matrixWorldInverse so that ScaleInView works properly
  ScaleInView(); 
  render();     
  positionticknums();	
  /*** the part of a code from http://mathics.github.io.  ***/
}


import {Decoration, 
    ViewPlugin} from "@codemirror/view"

    const placeholderMatcher = new MatchDecorator({
      regexp: /FrontEndExecutable\["(.+)"\]/g,
      decoration: match => Decoration.replace({
          widget: new PlaceholderWidget(match[1]),
      })
  });
  const placeholders = ViewPlugin.fromClass(class {
      constructor(view) {
          this.placeholders = placeholderMatcher.createDeco(view);
      }
      update(update) {
          this.placeholders = placeholderMatcher.updateDeco(update, this.placeholders);
      }
  }, {
      decorations: instance => instance.placeholders,
      provide: plugin => EditorView.atomicRanges.of(view => {
          var _a;
          return ((_a = view.plugin(plugin)) === null || _a === void 0 ? void 0 : _a.placeholders) || Decoration.none;
      })
  });
  class PlaceholderWidget extends WidgetType {
      constructor(name) {
          super();
          this.name = name;
      }
      eq(other) {
          return this.name == other.name;
      }
      toDOM() {
          let elt = document.createElement("span");
          elt.style.cssText = `
              border: 1px solid rgb(200, 200, 200);
              border-radius: 4px;
              padding: 0 3px;
              display:inline-block;
              `;
  
              interpretate(JSON.parse($objetsstorage[this.name]), {element: elt});
  
          return elt;
      }
      ignoreEvent() {
          return false;
      }
  }

import {defaultKeymap} from "@codemirror/commands";


var $objetsstorage = {};

core.FrontEndRemoveCell = function(args, env) {
  var input = JSON.parse(interpretate(args[0]));
  if(input["parent"] === "") {
    document.getElementById(input["id"]).remove();
  } else {
    document.getElementById(input["id"]+"---"+input["type"]).remove();
  }
}

core.FrontEndMoveCell = function(args, env) {
  var input = JSON.parse(interpretate(args[0]));

  //document.getElementById(input["cell"]["id"]+"---"+input["cell"]["type"]).remove();

  const cell = document.getElementById(input["cell"]["id"]+"---output");

  const parent = document.getElementById(input["parent"]["id"]);

  console.log(parent);
  console.log(cell);

  cell.id = input["cell"]["id"]+"---"+input["cell"]["type"];

  const newDiv = document.createElement("div");
  newDiv.id = input["cell"]["id"];
  newDiv.classList.add("parent-node");      

  parent.insertAdjacentElement('afterend', newDiv);

  newDiv.appendChild(cell);

  //buggy thing

}

core.FrontEndMorphCell = function(args, env) {
  var input = JSON.parse(interpretate(args[0]));
  console.log(input);

  //not implemented
}

core.FrontEndClearStorage = function(args, env) {
  var input = JSON.parse(interpretate(args[0]));
  console.log(input);

  input["storage"].forEach(element => {
    delete $objetsstorage[element];
  });
  
  //not implemented
}

core.FrontEndCreateCell = function(args, env) {
  var input = JSON.parse(interpretate(args[0]));
  console.log(input);

  $objetsstorage = Object.assign({}, $objetsstorage, input["storage"]);

  var target;

  if (input["parent"] === "") {
    // create a new div element
    const newDiv = document.createElement("div");
    newDiv.id = input["id"];
    newDiv.classList.add("parent-node");

    if(input["prev"] != "") {

      //console.log(input["prev"]);
      console.log(input["prev"]);
      const p = document.getElementById(input["prev"]);
      console.log(p);
      p.insertAdjacentElement('afterend', newDiv);

    } else {

      document.getElementById(input["sign"]).appendChild(newDiv);

    }

    target = newDiv;
    last = input["id"];
  } else {
    target = document.getElementById(input["parent"]);
  }

  var notebook = input["sign"];
  var uuid = input["id"];

  //var newCell = CodeMirror(target, {value: input["data"], mode:  "mathematica", extraKeys: {
  //  "Shift-Enter": function(instance) { 
  //     eval(instance.getValue(), notebook, uuid);
  //  },
  // }});

  //newCell.on("blur",function(cm,change){ socket.send('CellObj["'+cm.display.wrapper.id.split('---')[0]+'"]["data"] = "'+cm.getValue().replaceAll('\"','\\"')+'";'); });

  var wrapper = document.createElement("div");
  target.appendChild(wrapper);

  wrapper.id = input["id"]+"---"+input["type"];

  wrapper.classList.add(input["type"] + '-node');

  /*const editor = new EditorView({
    doc: input["data"], 
    extensions: [placeholders, minimalSetup,
    
      keymap({
        "Shift-Enter": (state, dispatch) => {
          eval(state.doc.toString(), notebook, uuid);
        }
      })
    ],
    parent: wrapper
  });*/

  var uid = input["id"];

  const editor =  new EditorView({
      doc: input["data"],
      extensions: [
          highlightActiveLineGutter(),
          highlightSpecialChars(),
          history(),
          drawSelection(),
          dropCursor(),
          EditorState.allowMultipleSelections.of(true),
          indentOnInput(),
          syntaxHighlighting(defaultHighlightStyle, { fallback: true }),
          bracketMatching(),
          closeBrackets(),
          autocompletion(),
          rectangularSelection(),
          crosshairCursor(),
          highlightActiveLine(),
          highlightSelectionMatches(),
          StreamLanguage.define(mathematica),
          placeholders,
          keymap.of([
              { key: "Shift-Enter", preventDefault: true, run: function (editor, key) { console.log(editor.state.doc.toString()); celleval(editor.state.doc.toString(), notebook, uuid); } }, ...defaultKeymap, ...historyKeymap
          ]),
          EditorView.updateListener.of((v) => {
              if (v.docChanged) {
                  console.log(v.state.doc.toString());
                  socket.send('CellObj["'+uid+'"]["data"] = "'+v.state.doc.toString().replaceAll('\"','\\"')+'";');
              }
          })
      ],
      parent: wrapper
  });      

}

function celleval(ne, id, cell) {
  console.log(ne);
  global = ne;
  var fixed = ne.replaceAll('\"','\\"');
  console.log(fixed);

  var q = 'CellObj["'+cell+'"]["data"]="'+fixed+'"; NotebookEvaluate["'+id+'", "'+cell+'"]';
  socket.send(q);
}

