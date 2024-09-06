"use strict";(self.webpackChunkwlx_docs=self.webpackChunkwlx_docs||[]).push([[6640],{82764:(e,n,r)=>{r.r(n),r.d(n,{assets:()=>c,contentTitle:()=>s,default:()=>p,frontMatter:()=>t,metadata:()=>a,toc:()=>l});var i=r(17624),o=r(4552);const t={env:["WLJS"],package:"wljs-graphics3d-threejs",source:"https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine/blob/dev/src/kernel.js",update:!0,numericArray:!0},s=void 0,a={id:"frontend/Reference/Graphics3D/GraphicsComplex",title:"GraphicsComplex",description:"represents an efficient graphics structure for drawing complex 3D objects (or 2D - see GraphicsComplex) storing vertices data in data variable. It replaces indexes found in primitives (can be nested) with a corresponding vertices and colors (if specified)",source:"@site/docs/frontend/Reference/Graphics3D/GraphicsComplex.md",sourceDirName:"frontend/Reference/Graphics3D",slug:"/frontend/Reference/Graphics3D/GraphicsComplex",permalink:"/frontend/Reference/Graphics3D/GraphicsComplex",draft:!1,unlisted:!1,tags:[],version:"current",lastUpdatedAt:1725208486e3,frontMatter:{env:["WLJS"],package:"wljs-graphics3d-threejs",source:"https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine/blob/dev/src/kernel.js",update:!0,numericArray:!0},sidebar:"tutorialSidebar",previous:{title:"GeometricTransformation",permalink:"/frontend/Reference/Graphics3D/GeometricTransformation"},next:{title:"GraphicsGroup",permalink:"/frontend/Reference/Graphics3D/GraphicsGroup"}},c={},l=[{value:"Supported primitives",id:"supported-primitives",level:2},{value:"<code>Line</code>",id:"line",level:3},{value:"<code>Polygon</code>",id:"polygon",level:3},{value:"<code>Point</code>",id:"point",level:3},{value:"Options",id:"options",level:2},{value:"<code>&quot;VertexColors&quot;</code>",id:"vertexcolors",level:3},{value:"Dynamic updates",id:"dynamic-updates",level:2}];function d(e){const n={a:"a",admonition:"admonition",code:"code",h2:"h2",h3:"h3",img:"img",p:"p",pre:"pre",...(0,o.M)(),...e.components},{Wl:t}=n;return t||function(e,n){throw new Error("Expected "+(n?"component":"object")+" `"+e+"` to be defined: you likely forgot to import, pass, or provide it.")}("Wl",!0),(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-mathematica",children:"GraphicsComplex[data_List, primitives_, opts___]\n"})}),"\n",(0,i.jsxs)(n.p,{children:["represents an efficient graphics structure for drawing complex 3D objects (or 2D - see ",(0,i.jsx)(n.a,{href:"/frontend/Reference/Graphics/GraphicsComplex",children:"GraphicsComplex"}),") storing vertices data in ",(0,i.jsx)(n.code,{children:"data"})," variable. It replaces indexes found in ",(0,i.jsx)(n.code,{children:"primitives"})," (can be nested) with a corresponding vertices and colors (if specified)"]}),"\n",(0,i.jsxs)(n.p,{children:["Most plotting functions such as ",(0,i.jsx)(n.a,{href:"/frontend/Reference/Plotting%20Functions/ListPlot3D",children:"ListPlot3D"})," and others use this way showing 3D graphics."]}),"\n",(0,i.jsxs)(n.p,{children:["The implementation of ",(0,i.jsx)(n.a,{href:"/frontend/Reference/Graphics3D/GraphicsComplex",children:"GraphicsComplex"})," is based on a low-level THREE.js buffer position ",(0,i.jsx)(n.a,{href:"https://threejs.org/docs/#api/en/core/BufferAttribute",children:"attribute"})," directly written to a GPU memory."]}),"\n",(0,i.jsx)(n.h2,{id:"supported-primitives",children:"Supported primitives"}),"\n",(0,i.jsx)(n.h3,{id:"line",children:(0,i.jsx)(n.code,{children:"Line"})}),"\n",(0,i.jsx)(n.p,{children:"No restrictions"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-mathematica",children:'v = PolyhedronData["Dodecahedron", "Vertices"] // N;\ni = PolyhedronData["Dodecahedron", "FaceIndices"];\n'})}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-mathematica",children:"GraphicsComplex[v, {Black, Line[i]}] // Graphics3D \n"})}),"\n",(0,i.jsx)(t,{children:'v = PolyhedronData["Dodecahedron", "Vertices"] // N; i = PolyhedronData["Dodecahedron", "FaceIndices"]; GraphicsComplex[v, {Black, Line[i]}] // Graphics3D '}),"\n",(0,i.jsx)(n.h3,{id:"polygon",children:(0,i.jsx)(n.code,{children:"Polygon"})}),"\n",(0,i.jsx)(n.p,{children:"Triangles works faster than quads or pentagons"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-mathematica",children:"GraphicsComplex[v, Polygon[i]] // Graphics3D \n"})}),"\n",(0,i.jsx)(t,{children:'v = PolyhedronData["Dodecahedron", "Vertices"] // N; i = PolyhedronData["Dodecahedron", "FaceIndices"]; GraphicsComplex[v, {Polygon[i]}] // Graphics3D '}),"\n",(0,i.jsx)(n.h3,{id:"point",children:(0,i.jsx)(n.code,{children:"Point"})}),"\n",(0,i.jsx)(n.h2,{id:"options",children:"Options"}),"\n",(0,i.jsx)(n.h3,{id:"vertexcolors",children:(0,i.jsx)(n.code,{children:'"VertexColors"'})}),"\n",(0,i.jsx)(n.p,{children:"Defines sets of colors used for shading vertices"}),"\n",(0,i.jsxs)(n.admonition,{type:"info",children:[(0,i.jsxs)(n.p,{children:[(0,i.jsx)(n.code,{children:'"VertexColors"'})," is a plain list which must have the following form"]}),(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-mathematica",children:'"VertexColors" ->{{r1,g1,b1}, {r2,g2,b2}, ...}\n'})})]}),"\n",(0,i.jsx)(n.h2,{id:"dynamic-updates",children:"Dynamic updates"}),"\n",(0,i.jsxs)(n.p,{children:["It does support dynamic updates for vertices data and colors. Use ",(0,i.jsx)(n.a,{href:"/frontend/Reference/Interpreter/Offload",children:"Offload"})," wrapper."]}),"\n",(0,i.jsx)(n.admonition,{type:"warning",children:(0,i.jsx)(n.p,{children:"Number of points in a mesh cannot be changed"})}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-mathematica",metastring:'title="cell 1"',children:'(* generate mesh *)\nproc = HardcorePointProcess[50, 0.5, 2];\nreg = Rectangle[{-10, -10}, {10, 10}];\nsamples = RandomPointConfiguration[proc, reg]["Points"];\n\n(* triangulate *)\nNeeds["ComputationalGeometry`"];\ntriangles2[points_] := Module[{tr, triples},\n  tr = DelaunayTriangulation[points];\n  triples = Flatten[Function[{v, list},\n      Switch[Length[list],\n        (* account for nodes with connectivity 2 or less *)\n        1, {},\n        2, {Flatten[{v, list}]}, \n        _, {v, ##} & @@@ Partition[list, 2, 1, {1, 1}]\n      ]\n    ] @@@ tr, 1];\n  Cases[GatherBy[triples, Sort], a_ /; Length[a] == 3 :> a[[1]]]]\n\ntriangles = triangles2[samples];\n\n(* sample function *)\nf[p_, {x_,y_,z_}] := z Exp[-(*FB[*)(((*SpB[*)Power[Norm[p - {x,y}](*|*),(*|*)2](*]SpB*))(*,*)/(*,*)(2.))(*]FB*)]\n\n(* initial data *)\nprobe = {#[[1]], #[[2]], f[#, {10, 0, 0}]} &/@ samples // Chop;\ncolors = With[{mm = MinMax[probe[[All,3]]]},\n      (Blend[{{mm[[1]], Blue}, {mm[[2]], Red}}, #[[3]]] )&/@ probe /. {RGBColor -> List} // Chop];\n'})}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-mathematica",metastring:'title="cell 2"',children:'Graphics3D[{\n  GraphicsComplex[probe // Offload, {Polygon[triangles]}, "VertexColors"->Offload[colors]],\n\n  EventHandler[Sphere[{0,0,0}, 0.1], {"transform"->Function[data, With[{pos = data["position"]},\n    probe = {#[[1]], #[[2]], f[#, pos]} &/@ samples // Chop;\n    colors = With[{mm = MinMax[probe[[All,3]]]},\n      (Blend[{{mm[[1]], Blue}, {mm[[2]], Red}}, #[[3]]] )&/@ probe /. {RGBColor -> List} // Chop];\n  ]]}]\n}]\n'})}),"\n",(0,i.jsx)(n.p,{children:"The result is interactive 3D plot"}),"\n",(0,i.jsx)(n.p,{children:(0,i.jsx)(n.img,{src:r(43408).c+"",width:"810",height:"574"})}),"\n",(0,i.jsx)(n.p,{children:"Or the variation of it, if we add a point light source"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-mathematica",children:'light = {0,0,0};\nGraphics3D[{\n  GraphicsComplex[probe // Offload, {Polygon[triangles]}],\n  PointLight[Red, light // Offload],\n\n  EventHandler[Sphere[{0,0,0}, 0.1], {"transform"->Function[data, With[{pos = data["position"]},\n    probe = {#[[1]], #[[2]], f[#, pos]} &/@ samples // Chop;\n    light = pos;\n  ]]}]\n}]\n'})}),"\n",(0,i.jsx)(n.p,{children:(0,i.jsx)(n.img,{src:r(67535).c+"",width:"810",height:"574"})})]})}function p(e={}){const{wrapper:n}={...(0,o.M)(),...e.components};return n?(0,i.jsx)(n,{...e,children:(0,i.jsx)(d,{...e})}):d(e)}},67535:(e,n,r)=>{r.d(n,{c:()=>i});const i=r.p+"assets/images/Gauss3DLight-ezgif.com-optipng-55aa0786b7a01b061d0bc25b91692b8a.png"},43408:(e,n,r)=>{r.d(n,{c:()=>i});const i=r.p+"assets/images/Gaussian3D-ezgif.com-optipng-705015b2beafdce52658122815e639f2.png"},4552:(e,n,r)=>{r.d(n,{I:()=>a,M:()=>s});var i=r(11504);const o={},t=i.createContext(o);function s(e){const n=i.useContext(t);return i.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function a(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(o):e.components||o:s(e.components),i.createElement(t.Provider,{value:n},e.children)}}}]);