<|"notebook" -> <|"name" -> "Untitled", "id" -> "piloting-c0a3b", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"b0bb4fa3-d9ba-46cf-bef8-be89784130d9" -> "[\n\t\"WEBSlider\",\n\t\"'a1\
750f89-9345-41c1-ae9e-0c87bb43f3be'\",\n\t[\n\t\t\"List\",\n\t\t-10,\n\t\t10,\
\n\t\t1\n\t]\n]", "f69d0c6c-933c-497e-926d-fe093d56df90" -> "[\n\t\"WEBSlider\
\",\n\t\"'95511070-9692-4142-8991-e9a40992eaed'\",\n\t[\n\t\t\"List\",\n\t\t-\
10,\n\t\t10,\n\t\t1\n\t]\n]", "52969334-2bb0-49cd-aa5b-4c1dc06774b9" -> "[\n\
\t\"WEBSlider\",\n\t\"'5e5a1ab0-8698-4f61-8a58-aa9707221308'\",\n\t[\n\t\t\"L\
ist\",\n\t\t-10,\n\t\t10,\n\t\t1\n\t]\n]", 
     "af4f08f7-aa0b-48ea-b69c-5810756b4c6b" -> "[\n\t\"WEBSlider\",\n\t\"'e40\
c8002-9f65-4195-b9b5-573c8dacd276'\",\n\t[\n\t\t\"List\",\n\t\t-10,\n\t\t10,\
\n\t\t1\n\t]\n]", "d62015b3-1074-45d7-acdf-ad0d0bd90b2c" -> "[\n\t\"WEBSlider\
\",\n\t\"'63e828b8-3695-4965-87b5-aee980360bdc'\",\n\t[\n\t\t\"List\",\n\t\t-\
10,\n\t\t30,\n\t\t1\n\t]\n]", "666cf7a2-0c84-48dd-8398-ac5944f210c0" -> "[\n\
\t\"WEBSlider\",\n\t\"'75b0169e-9780-4fa4-8412-4e9671da0e71'\",\n\t[\n\t\t\"L\
ist\",\n\t\t-10,\n\t\t30,\n\t\t1\n\t]\n]", 
     "48869d9f-a6c4-4dfe-90ae-87172cb10841" -> "[\n\t\"WEBSlider\",\n\t\"'8f7\
09faa-b678-4a28-b5a6-10684a17497a'\",\n\t[\n\t\t\"List\",\n\t\t-10,\n\t\t30,\
\n\t\t1\n\t]\n]"|>, "path" -> 
    "/Volumes/Data/Github/wolfram-js-frontend/Demo/BoxScene.wl", 
   "cell" -> "d2c6e3f9-948d-466d-a7c0-a8ef7e6ab1b7", 
   "date" -> DateObject[{2023, 3, 15, 10, 48, 19.251204`8.037032880118515}, 
     "Instant", "Gregorian", 1.]|>, 
 "cells" -> {<|"id" -> "06fb6615-95f2-46e5-aaad-6ec039d27890", 
    "type" -> "output", "data" -> "\nJS part", "display" -> "markdown", 
    "sign" -> "piloting-c0a3b", "prev" -> Null, "next" -> Null, 
    "parent" -> "e446d6a9-0dc6-4856-a7a6-c0ad5190269e", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "333c0d2a-2774-4b19-b084-0a2c6ad8f26a", "type" -> "input", 
    "data" -> "EventRemove[event]", "display" -> "codemirror", 
    "sign" -> "piloting-c0a3b", "prev" -> 
     "73f905ed-7dce-4eb8-92fb-08b65493c54e", "next" -> Null, 
    "parent" -> Null, "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3b4c06ba-8773-4f23-9069-7ca0d6378b87", "type" -> "input", 
    "data" -> ".md\nSlider control", "display" -> "codemirror", 
    "sign" -> "piloting-c0a3b", "prev" -> 
     "d8be44ec-d543-4659-a7fe-6811dbf1c910", 
    "next" -> "9a5c753e-164d-4365-8aac-d8d447a73634", "parent" -> Null, 
    "child" -> "9ff1d7ad-50f8-46d4-ba9d-72e137ba9fc7", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "5d96ec50-da66-4c4d-9347-80f2f29e0b18", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"48869d9f-a6c4-4dfe-90ae-87172cb10841\"]", 
    "display" -> "codemirror", "sign" -> "piloting-c0a3b", "prev" -> Null, 
    "next" -> Null, "parent" -> "9a5c753e-164d-4365-8aac-d8d447a73634", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "5e10d889-09ff-4dd3-b580-d014f558df18", "type" -> "input", 
    "data" -> ".md\nWolfram code", "display" -> "codemirror", 
    "sign" -> "piloting-c0a3b", "prev" -> 
     "9a5c753e-164d-4365-8aac-d8d447a73634", 
    "next" -> "b86ec193-fc66-4567-af28-b1dd3430c8ea", "parent" -> Null, 
    "child" -> "fc11b3bb-94ea-4f51-80d0-8a378f059d26", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "67015036-b2fb-4cc6-81b9-173753535fc6", "type" -> "output", 
    "data" -> "var camera, scene, renderer, bulbLight, bulbMat, hemiLight, \
stats;\nvar ballMat, cubeMat, floorMat;\n\nfunction lerp( b, a, alpha ) {\n \
return a + alpha * ( b - a )\n}var boxMesh1; var boxTarget1= \
[6.31441,5.70552,0.25 ];\nvar boxMesh2; var boxTarget2= \
[-2.03661,5.52526,0.25 ];\nvar boxMesh3; var boxTarget3= \
[6.44717,-2.0417,0.25 ];\nvar boxMesh4; var boxTarget4= \
[-7.28237,-1.97256,0.25 ];\nvar boxMesh5; var boxTarget5= \
[1.08204,5.34262,0.25 ];\nvar boxMesh6; var boxTarget6= \
[1.47394,-6.03334,0.25 ];\nvar boxMesh7; var boxTarget7= \
[-8.11234,-5.27288,0.25 ];\nvar boxMesh8; var boxTarget8= \
[-3.47849,1.74498,0.25 ];\nvar boxMesh9; var boxTarget9= \
[-3.43796,4.91193,0.25 ];\nvar boxMesh10; var boxTarget10= \
[-5.43974,0.618622,0.25 ];\nconst width = 800;\nconst height = 400;\n\nlet \
previousShadowMap = false;\n\n// ref for lumens: \
http://www.power-sure.com/lumens.htm\nconst bulbLuminousPowers = {\n    \
'110000 lm (1000W)': 110000,\n    '3500 lm (300W)': 3500,\n    '1700 lm \
(100W)': 1700,\n    '800 lm (60W)': 800,\n    '400 lm (40W)': 400,\n    '180 \
lm (25W)': 180,\n    '20 lm (4W)': 20,\n    'Off': 0\n};\n\n// ref for solar \
irradiances: https://en.wikipedia.org/wiki/Lux\nconst hemiLuminousIrradiances \
= {\n    '0.0001 lx (Moonless Night)': 0.0001,\n    '0.002 lx (Night \
Airglow)': 0.002,\n    '0.5 lx (Full Moon)': 0.5,\n    '3.4 lx (City \
Twilight)': 3.4,\n    '50 lx (Living Room)': 50,\n    '100 lx (Very \
Overcast)': 100,\n    '350 lx (Office Room)': 350,\n    '400 lx \
(Sunrise/Sunset)': 400,\n    '1000 lx (Overcast)': 1000,\n    '18000 lx \
(Daylight)': 18000,\n    '50000 lx (Direct Sun)': 50000\n};\n\nconst params = \
{\n    shadows: true,\n    exposure: 0.68,\n    bulbPower: Object.keys( \
bulbLuminousPowers )[ 4 ],\n    hemiIrradiance: Object.keys( \
hemiLuminousIrradiances )[ 0 ]\n};\n\nfunction init() {\n    camera = new \
PerspectiveCamera( 50, width / height, 0.1, 100 );\n    camera.position.x = - \
4;\n    camera.position.z = 4;\n    camera.position.y = 2;\n\n    scene = new \
Scene();\n\n    const bulbGeometry = new SphereGeometry( 0.02, 16, 8 );\n    \
bulbLight = new PointLight( 0xffee88, 1, 100, 2 );\n\n    bulbMat = new \
MeshStandardMaterial( {\n        emissive: 0xffffee,\n        \
emissiveIntensity: 1,\n        color: 0x000000\n    } );\n    bulbLight.add( \
new Mesh( bulbGeometry, bulbMat ) );\n    bulbLight.position.set( 0, 2, 0 \
);\n    bulbLight.castShadow = true;\n    scene.add( bulbLight );\n\n    \
hemiLight = new HemisphereLight( 0xddeeff, 0x0f0e0d, 0.02 );\n    scene.add( \
hemiLight );\n\n    floorMat = new MeshStandardMaterial( {\n        \
roughness: 0.8,\n        color: 0xffffff,\n        metalness: 0.2,\n        \
bumpScale: 0.0005\n    } );\n    const textureLoader = new TextureLoader();\n \
   textureLoader.load( 'textures/hardwood2_diffuse.jpg', function ( map ) \
{\n\n        map.wrapS = RepeatWrapping;\n        map.wrapT = \
RepeatWrapping;\n        map.anisotropy = 4;\n        map.repeat.set( 10, 24 \
);\n        map.encoding = sRGBEncoding;\n        floorMat.map = map;\n       \
 floorMat.needsUpdate = true;\n\n    } );\n    textureLoader.load( \
'textures/hardwood2_bump.jpg', function ( map ) {\n\n        map.wrapS = \
RepeatWrapping;\n        map.wrapT = RepeatWrapping;\n        map.anisotropy \
= 4;\n        map.repeat.set( 10, 24 );\n        floorMat.bumpMap = map;\n    \
    floorMat.needsUpdate = true;\n\n    } );\n    textureLoader.load( \
'textures/hardwood2_roughness.jpg', function ( map ) {\n\n        map.wrapS = \
RepeatWrapping;\n        map.wrapT = RepeatWrapping;\n        map.anisotropy \
= 4;\n        map.repeat.set( 10, 24 );\n        floorMat.roughnessMap = \
map;\n        floorMat.needsUpdate = true;\n\n    } );\n\n    cubeMat = new \
MeshStandardMaterial( {\n        roughness: 0.7,\n        color: 0xffffff,\n  \
      bumpScale: 0.002,\n        metalness: 0.2\n    } );\n    \
textureLoader.load( 'textures/brick_diffuse.jpg', function ( map ) {\n\n      \
  map.wrapS = RepeatWrapping;\n        map.wrapT = RepeatWrapping;\n        \
map.anisotropy = 4;\n        map.repeat.set( 1, 1 );\n        map.encoding = \
sRGBEncoding;\n        cubeMat.map = map;\n        cubeMat.needsUpdate = \
true;\n\n    } );\n    textureLoader.load( 'textures/brick_bump.jpg', \
function ( map ) {\n\n        map.wrapS = RepeatWrapping;\n        map.wrapT \
= RepeatWrapping;\n        map.anisotropy = 4;\n        map.repeat.set( 1, 1 \
);\n        cubeMat.bumpMap = map;\n        cubeMat.needsUpdate = true;\n\n   \
 } );\n\n    ballMat = new MeshStandardMaterial( {\n        color: \
0xffffff,\n        roughness: 0.5,\n        metalness: 1.0\n    } );\n    \
textureLoader.load( 'textures/planets/earth_atmos_2048.jpg', function ( map ) \
{\n\n        map.anisotropy = 4;\n        map.encoding = sRGBEncoding;\n      \
  ballMat.map = map;\n        ballMat.needsUpdate = true;\n\n    } );\n    \
textureLoader.load( 'textures/planets/earth_specular_2048.jpg', function ( \
map ) {\n\n        map.anisotropy = 4;\n        map.encoding = \
sRGBEncoding;\n        ballMat.metalnessMap = map;\n        \
ballMat.needsUpdate = true;\n\n    } );\n\n    const floorGeometry = new \
PlaneGeometry( 20, 20 );\n    const floorMesh = new Mesh( floorGeometry, \
floorMat );\n    floorMesh.receiveShadow = true;\n    floorMesh.rotation.x = \
- Math.PI / 2.0;\n    scene.add( floorMesh );\n\n    const boxGeometry = new \
BoxGeometry( 0.5, 0.5, 0.5 );boxMesh1= new Mesh( boxGeometry, cubeMat );\n    \
boxMesh1.position.set(6.31441,0.25,5.70552);\n    boxMesh1.castShadow = \
true;\n    scene.add( boxMesh1 );\n    boxMesh2= new Mesh( boxGeometry, \
cubeMat );\n    boxMesh2.position.set(-2.03661,0.25,5.52526);\n    \
boxMesh2.castShadow = true;\n    scene.add( boxMesh2 );\n    boxMesh3= new \
Mesh( boxGeometry, cubeMat );\n    \
boxMesh3.position.set(6.44717,0.25,-2.0417);\n    boxMesh3.castShadow = \
true;\n    scene.add( boxMesh3 );\n    boxMesh4= new Mesh( boxGeometry, \
cubeMat );\n    boxMesh4.position.set(-7.28237,0.25,-1.97256);\n    \
boxMesh4.castShadow = true;\n    scene.add( boxMesh4 );\n    boxMesh5= new \
Mesh( boxGeometry, cubeMat );\n    \
boxMesh5.position.set(1.08204,0.25,5.34262);\n    boxMesh5.castShadow = \
true;\n    scene.add( boxMesh5 );\n    boxMesh6= new Mesh( boxGeometry, \
cubeMat );\n    boxMesh6.position.set(1.47394,0.25,-6.03334);\n    \
boxMesh6.castShadow = true;\n    scene.add( boxMesh6 );\n    boxMesh7= new \
Mesh( boxGeometry, cubeMat );\n    \
boxMesh7.position.set(-8.11234,0.25,-5.27288);\n    boxMesh7.castShadow = \
true;\n    scene.add( boxMesh7 );\n    boxMesh8= new Mesh( boxGeometry, \
cubeMat );\n    boxMesh8.position.set(-3.47849,0.25,1.74498);\n    \
boxMesh8.castShadow = true;\n    scene.add( boxMesh8 );\n    boxMesh9= new \
Mesh( boxGeometry, cubeMat );\n    \
boxMesh9.position.set(-3.43796,0.25,4.91193);\n    boxMesh9.castShadow = \
true;\n    scene.add( boxMesh9 );\n    boxMesh10= new Mesh( boxGeometry, \
cubeMat );\n    boxMesh10.position.set(-5.43974,0.25,0.618622);\n    \
boxMesh10.castShadow = true;\n    scene.add( boxMesh10 );\n    renderer = new \
WebGLRenderer();\n    renderer.useLegacyLights = false;\n    \
renderer.outputEncoding = sRGBEncoding;\n    renderer.shadowMap.enabled = \
true;\n    renderer.toneMapping = ReinhardToneMapping;\n    \
renderer.setPixelRatio( window.devicePixelRatio );\n    renderer.setSize( \
width, height );\n\n\n    const controls = new OrbitControls( camera, \
renderer.domElement );\n}\n\nfunction animate() {\n\n  requestAnimationFrame( \
animate );\n\n  render();\n\n}\n\nvar skipped = 0;\n\nfunction render() {\n  \
if (skipped > 10) {\n    core.FireEvent([\"'update'\", 0]);\n    skipped = \
0;\n  } else {\n    skipped = skipped + 1;\n  }\n  \n  \
renderer.toneMappingExposure = Math.pow( params.exposure, 5.0 ); // to allow \
for very bright scenes.\n  renderer.shadowMap.enabled = params.shadows;\n  \
bulbLight.castShadow = params.shadows;\n\n  if ( params.shadows !== \
previousShadowMap ) {\n\n    ballMat.needsUpdate = true;\n    \
cubeMat.needsUpdate = true;\n    floorMat.needsUpdate = true;\n    \
previousShadowMap = params.shadows;\n\n  }\n\n  bulbLight.power = \
bulbLuminousPowers[ params.bulbPower ];\n  bulbMat.emissiveIntensity = \
bulbLight.intensity / Math.pow( 0.02, 2.0 ); // convert from intensity to \
irradiance at bulb surface\n\n  hemiLight.intensity = \
hemiLuminousIrradiances[ params.hemiIrradiance ];\n  const time = Date.now() \
* 0.0005;\n\n  bulbLight.position.y = Math.cos( time ) * 0.75 + \
1.25;boxMesh1.position.x = lerp(boxTarget1[0], boxMesh1.position.x, 0.05);\n  \
boxMesh1.position.y = lerp(boxTarget1[2], boxMesh1.position.y, 0.05);\n  \
boxMesh1.position.z = lerp(boxTarget1[1], boxMesh1.position.z, 0.05);\n  \
boxMesh2.position.x = lerp(boxTarget2[0], boxMesh2.position.x, 0.05);\n  \
boxMesh2.position.y = lerp(boxTarget2[2], boxMesh2.position.y, 0.05);\n  \
boxMesh2.position.z = lerp(boxTarget2[1], boxMesh2.position.z, 0.05);\n  \
boxMesh3.position.x = lerp(boxTarget3[0], boxMesh3.position.x, 0.05);\n  \
boxMesh3.position.y = lerp(boxTarget3[2], boxMesh3.position.y, 0.05);\n  \
boxMesh3.position.z = lerp(boxTarget3[1], boxMesh3.position.z, 0.05);\n  \
boxMesh4.position.x = lerp(boxTarget4[0], boxMesh4.position.x, 0.05);\n  \
boxMesh4.position.y = lerp(boxTarget4[2], boxMesh4.position.y, 0.05);\n  \
boxMesh4.position.z = lerp(boxTarget4[1], boxMesh4.position.z, 0.05);\n  \
boxMesh5.position.x = lerp(boxTarget5[0], boxMesh5.position.x, 0.05);\n  \
boxMesh5.position.y = lerp(boxTarget5[2], boxMesh5.position.y, 0.05);\n  \
boxMesh5.position.z = lerp(boxTarget5[1], boxMesh5.position.z, 0.05);\n  \
boxMesh6.position.x = lerp(boxTarget6[0], boxMesh6.position.x, 0.05);\n  \
boxMesh6.position.y = lerp(boxTarget6[2], boxMesh6.position.y, 0.05);\n  \
boxMesh6.position.z = lerp(boxTarget6[1], boxMesh6.position.z, 0.05);\n  \
boxMesh7.position.x = lerp(boxTarget7[0], boxMesh7.position.x, 0.05);\n  \
boxMesh7.position.y = lerp(boxTarget7[2], boxMesh7.position.y, 0.05);\n  \
boxMesh7.position.z = lerp(boxTarget7[1], boxMesh7.position.z, 0.05);\n  \
boxMesh8.position.x = lerp(boxTarget8[0], boxMesh8.position.x, 0.05);\n  \
boxMesh8.position.y = lerp(boxTarget8[2], boxMesh8.position.y, 0.05);\n  \
boxMesh8.position.z = lerp(boxTarget8[1], boxMesh8.position.z, 0.05);\n  \
boxMesh9.position.x = lerp(boxTarget9[0], boxMesh9.position.x, 0.05);\n  \
boxMesh9.position.y = lerp(boxTarget9[2], boxMesh9.position.y, 0.05);\n  \
boxMesh9.position.z = lerp(boxTarget9[1], boxMesh9.position.z, 0.05);\n  \
boxMesh10.position.x = lerp(boxTarget10[0], boxMesh10.position.x, 0.05);\n  \
boxMesh10.position.y = lerp(boxTarget10[2], boxMesh10.position.y, 0.05);\n  \
boxMesh10.position.z = lerp(boxTarget10[1], boxMesh10.position.z, 0.05);\n  \
renderer.render( scene, camera );\n}\n\ncore.UpdatePos = function (args, env) \
{\n  const arr = interpretate(args[0]);boxTarget0= arr[0];\n  boxTarget1= \
arr[1];\n  boxTarget2= arr[2];\n  boxTarget3= arr[3];\n  boxTarget4= \
arr[4];\n  boxTarget5= arr[5];\n  boxTarget6= arr[6];\n  boxTarget7= \
arr[7];\n  boxTarget8= arr[8];\n  boxTarget9= arr[9];\n  \
\n}\n\ninit();\n\nconst uid = requestAnimationFrame( animate \
);\nthis.ondestroy = function() { cancelAnimationFrame( uid ) };\n\nreturn \
renderer.domElement;\n", "display" -> "js", "sign" -> "piloting-c0a3b", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "d8be44ec-d543-4659-a7fe-6811dbf1c910", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "73f905ed-7dce-4eb8-92fb-08b65493c54e", "type" -> "input", 
    "data" -> ".md\nTo Stop simulation", "display" -> "codemirror", 
    "sign" -> "piloting-c0a3b", "prev" -> 
     "b86ec193-fc66-4567-af28-b1dd3430c8ea", 
    "next" -> "333c0d2a-2774-4b19-b084-0a2c6ad8f26a", "parent" -> Null, 
    "child" -> "fb43c1d8-551a-413e-b345-cc1e78fafcc4", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "744a5904-2b9b-495a-8042-81374c35589c", "type" -> "output", 
    "data" -> "\n## Moving boxes", "display" -> "markdown", 
    "sign" -> "piloting-c0a3b", "prev" -> Null, "next" -> Null, 
    "parent" -> "d2c6e3f9-948d-466d-a7c0-a8ef7e6ab1b7", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8029f253-c361-4235-9c7b-af8aa8e2d07d", "type" -> "input", 
    "data" -> "nBoxes = 10;\nwidth = 20;\nheight = 20;\n\nscale = \
-10;\n\nboxCoordinates = Table[\n  {RandomReal[{- width 0.5, width 0.5}], \
RandomReal[{- height 0.5, height 0.5}], 0.25}\n  , {i, \
nBoxes}\n];\n\nboxVelocities = Table[\n  {RandomReal[{- width 0.5, width \
0.5}], RandomReal[{- height 0.5, height 0.5}], 0}\n  , {i, nBoxes}\n];", 
    "display" -> "codemirror", "sign" -> "piloting-c0a3b", 
    "prev" -> "d2c6e3f9-948d-466d-a7c0-a8ef7e6ab1b7", 
    "next" -> "e446d6a9-0dc6-4856-a7a6-c0ad5190269e", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9a5c753e-164d-4365-8aac-d8d447a73634", "type" -> "input", 
    "data" -> "slider = HTMLSlider[-10,30,1];\n\nEventBind[slider, \
Function[data,\n  scale = data\n]];\n\nCreateFrontEndObject[slider]", 
    "display" -> "codemirror", "sign" -> "piloting-c0a3b", 
    "prev" -> "3b4c06ba-8773-4f23-9069-7ca0d6378b87", 
    "next" -> "5e10d889-09ff-4dd3-b580-d014f558df18", "parent" -> Null, 
    "child" -> "5d96ec50-da66-4c4d-9347-80f2f29e0b18", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9ff1d7ad-50f8-46d4-ba9d-72e137ba9fc7", "type" -> "output", 
    "data" -> "\nSlider control", "display" -> "markdown", 
    "sign" -> "piloting-c0a3b", "prev" -> Null, "next" -> Null, 
    "parent" -> "3b4c06ba-8773-4f23-9069-7ca0d6378b87", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "b86ec193-fc66-4567-af28-b1dd3430c8ea", "type" -> "input", 
    "data" -> "event = \
EventObject[<|\"id\"->\"update\"|>];\n\nInteraction[i_, j_] :=  - 0.01 \
(-scale/10) Normalize[i-j] If[i =!= j, 1/Sqrt[(Norm[i-j+0.5])], \
0];\n\nEventBind[event, Function[data,\n  Do[\n    boxVelocities[[i]] = \
boxVelocities[[i]] - Sum[Interaction[boxCoordinates[[i]], \
boxCoordinates[[j]]], {j, nBoxes}];\n    If[boxCoordinates[[i, 1]] > 0.5 \
width || boxCoordinates[[i, 1]] < - 0.5 width || boxCoordinates[[i, 2]] > 0.5 \
height || boxCoordinates[[i, 2]] < - 0.5 height, boxVelocities[[i]] = - \
boxVelocities[[i]]];\n    boxCoordinates[[i]] = boxCoordinates[[i]] + 0.01 \
(-scale/10) boxVelocities[[i]];\n    \n  , {i,1, nBoxes}];\n\n  \
UpdatePos[{Clip[#[[1]], {-width, width}0.5], Clip[#[[2]], {-height, \
height}0.5], #[[3]]}&/@boxCoordinates]//SendToFrontEnd;\n]];", 
    "display" -> "codemirror", "sign" -> "piloting-c0a3b", 
    "prev" -> "5e10d889-09ff-4dd3-b580-d014f558df18", 
    "next" -> "73f905ed-7dce-4eb8-92fb-08b65493c54e", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "d2c6e3f9-948d-466d-a7c0-a8ef7e6ab1b7", "type" -> "input", 
    "data" -> ".md\n## Moving boxes", "display" -> "codemirror", 
    "sign" -> "piloting-c0a3b", "prev" -> Null, 
    "next" -> "8029f253-c361-4235-9c7b-af8aa8e2d07d", "parent" -> Null, 
    "child" -> "744a5904-2b9b-495a-8042-81374c35589c", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "d8be44ec-d543-4659-a7fe-6811dbf1c910", "type" -> "input", 
    "data" -> ".js\n\nvar camera, scene, renderer, bulbLight, bulbMat, \
hemiLight, stats;\nvar ballMat, cubeMat, floorMat;\n\nfunction lerp( b, a, \
alpha ) {\n return a + alpha * ( b - a )\n}\n\n<?wsp Table[ ?>\nvar \
boxMesh<?wsp i?>; var boxTarget<?wsp i?> = [ <?wsp boxCoordinates[[i,1]] ?>, \
<?wsp boxCoordinates[[i,2]] ?>, <?wsp boxCoordinates[[i,3]] ?> ];\n<?wsp , \
{i, nBoxes}] ?>\n  \nconst width = 800;\nconst height = 400;\n\nlet \
previousShadowMap = false;\n\n// ref for lumens: \
http://www.power-sure.com/lumens.htm\nconst bulbLuminousPowers = {\n    \
'110000 lm (1000W)': 110000,\n    '3500 lm (300W)': 3500,\n    '1700 lm \
(100W)': 1700,\n    '800 lm (60W)': 800,\n    '400 lm (40W)': 400,\n    '180 \
lm (25W)': 180,\n    '20 lm (4W)': 20,\n    'Off': 0\n};\n\n// ref for solar \
irradiances: https://en.wikipedia.org/wiki/Lux\nconst hemiLuminousIrradiances \
= {\n    '0.0001 lx (Moonless Night)': 0.0001,\n    '0.002 lx (Night \
Airglow)': 0.002,\n    '0.5 lx (Full Moon)': 0.5,\n    '3.4 lx (City \
Twilight)': 3.4,\n    '50 lx (Living Room)': 50,\n    '100 lx (Very \
Overcast)': 100,\n    '350 lx (Office Room)': 350,\n    '400 lx \
(Sunrise/Sunset)': 400,\n    '1000 lx (Overcast)': 1000,\n    '18000 lx \
(Daylight)': 18000,\n    '50000 lx (Direct Sun)': 50000\n};\n\nconst params = \
{\n    shadows: true,\n    exposure: 0.68,\n    bulbPower: Object.keys( \
bulbLuminousPowers )[ 4 ],\n    hemiIrradiance: Object.keys( \
hemiLuminousIrradiances )[ 0 ]\n};\n\nfunction init() {\n    camera = new \
PerspectiveCamera( 50, width / height, 0.1, 100 );\n    camera.position.x = - \
4;\n    camera.position.z = 4;\n    camera.position.y = 2;\n\n    scene = new \
Scene();\n\n    const bulbGeometry = new SphereGeometry( 0.02, 16, 8 );\n    \
bulbLight = new PointLight( 0xffee88, 1, 100, 2 );\n\n    bulbMat = new \
MeshStandardMaterial( {\n        emissive: 0xffffee,\n        \
emissiveIntensity: 1,\n        color: 0x000000\n    } );\n    bulbLight.add( \
new Mesh( bulbGeometry, bulbMat ) );\n    bulbLight.position.set( 0, 2, 0 \
);\n    bulbLight.castShadow = true;\n    scene.add( bulbLight );\n\n    \
hemiLight = new HemisphereLight( 0xddeeff, 0x0f0e0d, 0.02 );\n    scene.add( \
hemiLight );\n\n    floorMat = new MeshStandardMaterial( {\n        \
roughness: 0.8,\n        color: 0xffffff,\n        metalness: 0.2,\n        \
bumpScale: 0.0005\n    } );\n    const textureLoader = new TextureLoader();\n \
   textureLoader.load( 'textures/hardwood2_diffuse.jpg', function ( map ) \
{\n\n        map.wrapS = RepeatWrapping;\n        map.wrapT = \
RepeatWrapping;\n        map.anisotropy = 4;\n        map.repeat.set( 10, 24 \
);\n        map.encoding = sRGBEncoding;\n        floorMat.map = map;\n       \
 floorMat.needsUpdate = true;\n\n    } );\n    textureLoader.load( \
'textures/hardwood2_bump.jpg', function ( map ) {\n\n        map.wrapS = \
RepeatWrapping;\n        map.wrapT = RepeatWrapping;\n        map.anisotropy \
= 4;\n        map.repeat.set( 10, 24 );\n        floorMat.bumpMap = map;\n    \
    floorMat.needsUpdate = true;\n\n    } );\n    textureLoader.load( \
'textures/hardwood2_roughness.jpg', function ( map ) {\n\n        map.wrapS = \
RepeatWrapping;\n        map.wrapT = RepeatWrapping;\n        map.anisotropy \
= 4;\n        map.repeat.set( 10, 24 );\n        floorMat.roughnessMap = \
map;\n        floorMat.needsUpdate = true;\n\n    } );\n\n    cubeMat = new \
MeshStandardMaterial( {\n        roughness: 0.7,\n        color: 0xffffff,\n  \
      bumpScale: 0.002,\n        metalness: 0.2\n    } );\n    \
textureLoader.load( 'textures/brick_diffuse.jpg', function ( map ) {\n\n      \
  map.wrapS = RepeatWrapping;\n        map.wrapT = RepeatWrapping;\n        \
map.anisotropy = 4;\n        map.repeat.set( 1, 1 );\n        map.encoding = \
sRGBEncoding;\n        cubeMat.map = map;\n        cubeMat.needsUpdate = \
true;\n\n    } );\n    textureLoader.load( 'textures/brick_bump.jpg', \
function ( map ) {\n\n        map.wrapS = RepeatWrapping;\n        map.wrapT \
= RepeatWrapping;\n        map.anisotropy = 4;\n        map.repeat.set( 1, 1 \
);\n        cubeMat.bumpMap = map;\n        cubeMat.needsUpdate = true;\n\n   \
 } );\n\n    ballMat = new MeshStandardMaterial( {\n        color: \
0xffffff,\n        roughness: 0.5,\n        metalness: 1.0\n    } );\n    \
textureLoader.load( 'textures/planets/earth_atmos_2048.jpg', function ( map ) \
{\n\n        map.anisotropy = 4;\n        map.encoding = sRGBEncoding;\n      \
  ballMat.map = map;\n        ballMat.needsUpdate = true;\n\n    } );\n    \
textureLoader.load( 'textures/planets/earth_specular_2048.jpg', function ( \
map ) {\n\n        map.anisotropy = 4;\n        map.encoding = \
sRGBEncoding;\n        ballMat.metalnessMap = map;\n        \
ballMat.needsUpdate = true;\n\n    } );\n\n    const floorGeometry = new \
PlaneGeometry( 20, 20 );\n    const floorMesh = new Mesh( floorGeometry, \
floorMat );\n    floorMesh.receiveShadow = true;\n    floorMesh.rotation.x = \
- Math.PI / 2.0;\n    scene.add( floorMesh );\n\n    const boxGeometry = new \
BoxGeometry( 0.5, 0.5, 0.5 );\n\n    <?wsp Table[ ?>\n    boxMesh<?wsp i ?> = \
new Mesh( boxGeometry, cubeMat );\n    boxMesh<?wsp i ?>.position.set( <?wsp \
boxCoordinates[[i,1]] ?>, <?wsp boxCoordinates[[i,3]] ?>, <?wsp \
boxCoordinates[[i,2]] ?> );\n    boxMesh<?wsp i ?>.castShadow = true;\n    \
scene.add( boxMesh<?wsp i ?> );\n    <?wsp , {i, nBoxes}] ?>\n\n\n    \
renderer = new WebGLRenderer();\n    renderer.useLegacyLights = false;\n    \
renderer.outputEncoding = sRGBEncoding;\n    renderer.shadowMap.enabled = \
true;\n    renderer.toneMapping = ReinhardToneMapping;\n    \
renderer.setPixelRatio( window.devicePixelRatio );\n    renderer.setSize( \
width, height );\n\n\n    const controls = new OrbitControls( camera, \
renderer.domElement );\n}\n\nfunction animate() {\n\n  requestAnimationFrame( \
animate );\n\n  render();\n\n}\n\nvar skipped = 0;\n\nfunction render() {\n  \
if (skipped > 10) {\n    core.FireEvent([\"'update'\", 0]);\n    skipped = \
0;\n  } else {\n    skipped = skipped + 1;\n  }\n  \n  \
renderer.toneMappingExposure = Math.pow( params.exposure, 5.0 ); // to allow \
for very bright scenes.\n  renderer.shadowMap.enabled = params.shadows;\n  \
bulbLight.castShadow = params.shadows;\n\n  if ( params.shadows !== \
previousShadowMap ) {\n\n    ballMat.needsUpdate = true;\n    \
cubeMat.needsUpdate = true;\n    floorMat.needsUpdate = true;\n    \
previousShadowMap = params.shadows;\n\n  }\n\n  bulbLight.power = \
bulbLuminousPowers[ params.bulbPower ];\n  bulbMat.emissiveIntensity = \
bulbLight.intensity / Math.pow( 0.02, 2.0 ); // convert from intensity to \
irradiance at bulb surface\n\n  hemiLight.intensity = \
hemiLuminousIrradiances[ params.hemiIrradiance ];\n  const time = Date.now() \
* 0.0005;\n\n  bulbLight.position.y = Math.cos( time ) * 0.75 + 1.25;\n\n  \
<?wsp Table[ ?>\n  boxMesh<?wsp i ?>.position.x = lerp(boxTarget<?wsp i?>[0], \
boxMesh<?wsp i ?>.position.x, 0.05);\n  boxMesh<?wsp i ?>.position.y = \
lerp(boxTarget<?wsp i?>[2], boxMesh<?wsp i ?>.position.y, 0.05);\n  \
boxMesh<?wsp i ?>.position.z = lerp(boxTarget<?wsp i?>[1], boxMesh<?wsp i \
?>.position.z, 0.05);\n  <?wsp , {i, nBoxes}] ?>\n  \n  renderer.render( \
scene, camera );\n}\n\ncore.UpdatePos = function (args, env) {\n  const arr = \
interpretate(args[0]);\n  <?wsp Table[ ?>\n    boxTarget<?wsp i?> = arr[<?wsp \
i ?>];\n  <?wsp, {i, 0, nBoxes-1}] ?>\n}\n\ninit();\n\nconst uid = \
requestAnimationFrame( animate );\nthis.ondestroy = function() { \
cancelAnimationFrame( uid ) };\n\nreturn renderer.domElement;\n", 
    "display" -> "codemirror", "sign" -> "piloting-c0a3b", 
    "prev" -> "e446d6a9-0dc6-4856-a7a6-c0ad5190269e", 
    "next" -> "3b4c06ba-8773-4f23-9069-7ca0d6378b87", "parent" -> Null, 
    "child" -> "67015036-b2fb-4cc6-81b9-173753535fc6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "df222e62-a98d-4da0-9f0f-18be07a5398d", "type" -> "output", 
    "data" -> "\nTo Stop simulation", "display" -> "markdown", 
    "sign" -> "piloting-c0a3b", "prev" -> 
     "fb43c1d8-551a-413e-b345-cc1e78fafcc4", "next" -> Null, 
    "parent" -> "73f905ed-7dce-4eb8-92fb-08b65493c54e", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "e446d6a9-0dc6-4856-a7a6-c0ad5190269e", "type" -> "input", 
    "data" -> ".md\nJS part", "display" -> "codemirror", 
    "sign" -> "piloting-c0a3b", "prev" -> 
     "8029f253-c361-4235-9c7b-af8aa8e2d07d", 
    "next" -> "d8be44ec-d543-4659-a7fe-6811dbf1c910", "parent" -> Null, 
    "child" -> "06fb6615-95f2-46e5-aaad-6ec039d27890", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "fb43c1d8-551a-413e-b345-cc1e78fafcc4", "type" -> "output", 
    "data" -> "\nTo Stop simulation", "display" -> "markdown", 
    "sign" -> "piloting-c0a3b", "prev" -> Null, 
    "next" -> "df222e62-a98d-4da0-9f0f-18be07a5398d", 
    "parent" -> "73f905ed-7dce-4eb8-92fb-08b65493c54e", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "fc11b3bb-94ea-4f51-80d0-8a378f059d26", "type" -> "output", 
    "data" -> "\nWolfram code", "display" -> "markdown", 
    "sign" -> "piloting-c0a3b", "prev" -> Null, "next" -> Null, 
    "parent" -> "5e10d889-09ff-4dd3-b580-d014f558df18", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn"|>
