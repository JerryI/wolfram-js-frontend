"use strict";(self.webpackChunkwlx_docs=self.webpackChunkwlx_docs||[]).push([[6204],{96560:(M,N,e)=>{e.r(N),e.d(N,{assets:()=>n,contentTitle:()=>c,default:()=>j,frontMatter:()=>D,metadata:()=>T,toc:()=>z});var i=e(17624),s=e(4552);const D={env:["WLJS","Wolfram Kernel"],package:"wljs-graphics3d-threejs",update:!0,source:"https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine/blob/dev/src/kernel.js"},c=void 0,T={id:"frontend/Reference/Graphics3D/Cylinder",title:"Cylinder",description:"represents a cylinder with a radius 1",source:"@site/docs/frontend/Reference/Graphics3D/Cylinder.md",sourceDirName:"frontend/Reference/Graphics3D",slug:"/frontend/Reference/Graphics3D/Cylinder",permalink:"/frontend/Reference/Graphics3D/Cylinder",draft:!1,unlisted:!1,tags:[],version:"current",lastUpdatedAt:1711835046,formattedLastUpdatedAt:"Mar 30, 2024",frontMatter:{env:["WLJS","Wolfram Kernel"],package:"wljs-graphics3d-threejs",update:!0,source:"https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine/blob/dev/src/kernel.js"},sidebar:"tutorialSidebar",previous:{title:"Cuboid",permalink:"/frontend/Reference/Graphics3D/Cuboid"},next:{title:"Emissive",permalink:"/frontend/Reference/Graphics3D/Emissive"}},n={},z=[{value:"Parameters",id:"parameters",level:2},{value:"<code>RGBColor</code>",id:"rgbcolor",level:3},{value:"Methods",id:"methods",level:2},{value:"<code>Volume</code>",id:"volume",level:3},{value:"<code>RegionCentroid</code>",id:"regioncentroid",level:3},{value:"Dynamic updates",id:"dynamic-updates",level:2}];function d(M){const N={code:"code",h2:"h2",h3:"h3",p:"p",pre:"pre",...(0,s.M)(),...M.components},{Wl:e}=N;return e||function(M,N){throw new Error("Expected "+(N?"component":"object")+" `"+M+"` to be defined: you likely forgot to import, pass, or provide it.")}("Wl",!0),(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(N.pre,{children:(0,i.jsx)(N.code,{className:"language-mathematica",children:"Cylinder[{i_List, f_List}]\n"})}),"\n",(0,i.jsx)(N.p,{children:"represents a cylinder with a radius 1"}),"\n",(0,i.jsx)(N.pre,{children:(0,i.jsx)(N.code,{className:"language-mathematica",children:"Cylinder[{i_List, f_List}, r_]\n"})}),"\n",(0,i.jsxs)(N.p,{children:["represents a cylinder with a radius ",(0,i.jsx)(N.code,{children:"r"})]}),"\n",(0,i.jsx)(N.pre,{children:(0,i.jsx)(N.code,{className:"language-mathematica",children:"Graphics3D[ Table[{Hue[RandomReal[], 1., 0.5], Cylinder[RandomReal[10, {2, 3}]]}, {20}]]\n"})}),"\n",(0,i.jsx)(e,{data:"WyJHcmFwaGljczNEIixbIkxpc3QiLFsiTGlzdCIsWyJIdWUiLDAuOTk5NTc2NDY3MDU3MTM4MSwx\nLjAsMC41XSxbIkN5bGluZGVyIixbIkxpc3QiLFsiTGlzdCIsNi4xOTU5NzUyNDMwNDE4MzYsNS42\nMDYyNjQ1NDkxNzc1ODYsOC4xMzQ0MTQwNTIwNzkyODNdLFsiTGlzdCIsMi4xNzQ1MTU5NDkzMjk4\nMzU2LDAuNzg0OTQzMDY4MzUyNTE0OSw5LjkzNzAyNDM1ODMyMDQ1N11dXV0sWyJMaXN0IixbIkh1\nZSIsMC41OTA5NTc5MjE4NTUxMDY0LDEuMCwwLjVdLFsiQ3lsaW5kZXIiLFsiTGlzdCIsWyJMaXN0\nIiw2Ljc0Njg2MzQ4MDk4MzEzNCwzLjMyNTAwMzExMDc3ODQxNDYsMC42NTE1ODI4Nzc1MTIzMjg5\nXSxbIkxpc3QiLDEuNTA2OTc3MzI5NjY0MTc2LDkuNjg2MzQ0Mzk0OTg3MDc0LDAuOTcwOTY2NzM3\nMzc1NTA4OV1dXV0sWyJMaXN0IixbIkh1ZSIsMC4yNjQwOTA2MTEwMTQwOTc3LDEuMCwwLjVdLFsi\nQ3lsaW5kZXIiLFsiTGlzdCIsWyJMaXN0IiwyLjYxODc2MTYxMzQwNzk3OCwwLjM4MzYwOTk1MDQ2\nOTE2NjM1LDYuMzkyMjEwNDkzMzU0NjU3XSxbIkxpc3QiLDIuODAxOTEyMTA1NjA4Njg3OCwyLjk4\nNzc5NTI5NDc0MTMyNSw1LjUwOTQxNDY1ODE0NDE2Nl1dXV0sWyJMaXN0IixbIkh1ZSIsMC4yMDQw\nMjk0MjczODc5NjI2LDEuMCwwLjVdLFsiQ3lsaW5kZXIiLFsiTGlzdCIsWyJMaXN0Iiw0LjE3NTM1\nOTg4OTQzMzA1LDkuMDY4NTEwNDY1NzY0OTQxLDkuMjA3MjMyNDU0MjYzMTQyXSxbIkxpc3QiLDAu\nNTkwMTM3NDU5MDg4OTM2MSwxLjU1MTU2ODk5OTM2NTQwMjUsMC4zNjIyOTQ1OTI1NTgzNTgzXV1d\nXSxbIkxpc3QiLFsiSHVlIiwwLjIwNTExNzA0NjYxOTE3MzQsMS4wLDAuNV0sWyJDeWxpbmRlciIs\nWyJMaXN0IixbIkxpc3QiLDguNjc0NDgzMzg4MTYxODMyLDYuMzk4NTk4Nzc3ODM4NDE2ZS0yLDAu\nNDE5NDQ5OTAwMTM0ODk2Nl0sWyJMaXN0Iiw3LjQ2NDMwOTk2MzM1MjYxMiw1LjE3NTcwNDI2ODY5\nNjczMiw2Ljg5MzkzMjc4NTk2MTcxM11dXV0sWyJMaXN0IixbIkh1ZSIsMC43NTU2Njg1NjA2MTM2\nNTc1LDEuMCwwLjVdLFsiQ3lsaW5kZXIiLFsiTGlzdCIsWyJMaXN0Iiw2LjUyNzkwMTYxNzI1NDQ3\nNSw0LjE0ODQ0ODYxNzE4NDIxMywxLjAwNTI3OTc5MTAxNTQyMTldLFsiTGlzdCIsOS4zNzc3Mzcw\nNjk2OTIwOTUsOS45NjM4NjE1Njg5MDIzNTYsOC4zNTc4NzY2ODc1NTUyMTJdXV1dLFsiTGlzdCIs\nWyJIdWUiLDAuNDU1ODQyODAyODc5NTQ5OCwxLjAsMC41XSxbIkN5bGluZGVyIixbIkxpc3QiLFsi\nTGlzdCIsMy4zMjU3NjU5ODQ0NjQ0NzMsMi4xMTM3MjU1OTMyMjczODYsMi4zMDY0NzExMzU0Nzg1\nNjddLFsiTGlzdCIsOS4yNzM1MDk5NDgyMDU4OTUsMC43MDE2MTUxNDc5MzMyMDU2LDcuMDI2MDkz\nNzU0MzU5NTAxXV1dXSxbIkxpc3QiLFsiSHVlIiwwLjMwNDcxNTM2ODM1OTM2NzEsMS4wLDAuNV0s\nWyJDeWxpbmRlciIsWyJMaXN0IixbIkxpc3QiLDcuODc0NDY0Mzg0Mzk3MzYzLDcuOTI2NTg3MTI5\nMTIxNTU0LDMuMTgxNDY5Nzg3OTQxNTUyXSxbIkxpc3QiLDAuNDUzMDIxNzA5MTI5NTM3LDguMjU3\nNTc1MTE3NDc4OTExLDkuNDY0MTU2MDk5NDY1NDhdXV1dLFsiTGlzdCIsWyJIdWUiLDcuMzAyODE3\nNDE1MDM4NzU0ZS0yLDEuMCwwLjVdLFsiQ3lsaW5kZXIiLFsiTGlzdCIsWyJMaXN0IiwxLjg0Nzk1\nNzI0ODM5MTk1MTUsMS4zOTA0MTk4ODU4OTY1MzI2LDcuNDI4NDgzODQ1NzUwOTMyXSxbIkxpc3Qi\nLDcuMTA3OTg1NDE5ODM5NzA3LDEuNjA2NDIxOTExOTgwMDY3Niw1LjM3OTk3MjQ1MTk4MTc1NTZd\nXV1dLFsiTGlzdCIsWyJIdWUiLDAuMTgxNTc5MTAwMzk1MDk1MjgsMS4wLDAuNV0sWyJDeWxpbmRl\nciIsWyJMaXN0IixbIkxpc3QiLDYuNDQ2NTQ2MTk4NTk2NTUsNC44NDg0NzI4MDc0MjAwMzgsMS4w\nMDIwNDkwNDA2MTI0MDU0XSxbIkxpc3QiLDEuNDc5Nzk4MDQ5MDM5Nzg0NCwwLjQ2MTE0NjUzNzY4\nNjk3NTIsOS4zODAzMzEyNjMwMzUxOTJdXV1dLFsiTGlzdCIsWyJIdWUiLDAuMzg3NjU4NTU1ODgy\nMDA0NywxLjAsMC41XSxbIkN5bGluZGVyIixbIkxpc3QiLFsiTGlzdCIsMC40MzUzMTQ5ODgwNzQ2\nMTk0NCw5LjU1ODI2OTg5OTE1MTY3OSwzLjk3NjgzNjAyMjQ4NzYwMTZdLFsiTGlzdCIsNy4yODUx\nMTgzMDgwMjM4NTgsNi44MTg1OTI0NzAzODA3NTQsMS43MjkzOTQyOTA4NDU0MzA1XV1dXSxbIkxp\nc3QiLFsiSHVlIiwwLjQ1ODM0MTc5MzA4MDU2NiwxLjAsMC41XSxbIkN5bGluZGVyIixbIkxpc3Qi\nLFsiTGlzdCIsMi44NzIxMTU4MDM0MzUwMjYsOS45ODk0Mzg5NzAxODg0Niw2LjU2MzIyMTM3MTE1\nNDk4MV0sWyJMaXN0IiwxLjY4MzU1MjIyNTI5NTczNjQsNC42NDk1OTg0NTAyOTU2NCw4Ljg0Njkx\nMTgwNjI2MTg5XV1dXSxbIkxpc3QiLFsiSHVlIiwwLjE2NDAzMjQ5NTk2ODQwMjUzLDEuMCwwLjVd\nLFsiQ3lsaW5kZXIiLFsiTGlzdCIsWyJMaXN0Iiw0LjkzNjU1ODY0MDk4MzgwMSwxLjk2Mzk5MjA1\nMDM5MDU1ODYsNi4yMTY3MjAyNjM2MDIyMTZdLFsiTGlzdCIsNS4xNDMxNzc1NDYzNTYyMiw4LjMy\nNzUzNDk4NDAwOTMwNCwxLjI1MjU4Mjk3MTY5OTY1NjJdXV1dLFsiTGlzdCIsWyJIdWUiLDAuOTk4\nNzk2Nzk3ODczMzYwMywxLjAsMC41XSxbIkN5bGluZGVyIixbIkxpc3QiLFsiTGlzdCIsNy43NDgw\nOTY4NzIzNDY3ODksOS4xNjU4Mjk0MTU5MzgwNiw5LjU0NzQ5OTE2NjE1NjNdLFsiTGlzdCIsNy40\nMjM3NDQxMDYzMzU5MDMsOS44Mzk2ODQ3NjI1NjMzMzMsNC4wMjc5NTMxNjI3NTQ4OTZdXV1dLFsi\nTGlzdCIsWyJIdWUiLDAuNTg5MTY1NjIzMjA1NTYxMywxLjAsMC41XSxbIkN5bGluZGVyIixbIkxp\nc3QiLFsiTGlzdCIsNS40Njg3NjEzODc3OTA2MjE2ZS0yLDguNzc2OTA4NDIzNDYyMDMyLDMuMjg2\nOTE4NDExNTQwNDYyXSxbIkxpc3QiLDIuNzE5NTU3MzE5OTUzOTQ2LDEuODc4MDc2MzczNDA5NTg5\nNiw3LjEwNDUyNzQ1NDYxMDIyOF1dXV0sWyJMaXN0IixbIkh1ZSIsMC41OTczNTI4NTU1ODg0MTIy\nLDEuMCwwLjVdLFsiQ3lsaW5kZXIiLFsiTGlzdCIsWyJMaXN0Iiw3Ljg0MjE0NTI4MDUzMjY2Miw4\nLjQ0MTM3MTIyNDUyMDgxOCw0LjcyNjQ2MDI4MDgxNDIxOV0sWyJMaXN0Iiw1Ljg4NDU4NTk3MjQw\nMTY4NCwyLjQxMjc3NzQyNzU0NDUyOTcsNS41MDA4MDc2OTY3MjExNTddXV1dLFsiTGlzdCIsWyJI\ndWUiLDAuNDkwNjc4OTk3MzI2MzE5MDMsMS4wLDAuNV0sWyJDeWxpbmRlciIsWyJMaXN0IixbIkxp\nc3QiLDEuMjI5ODg0NzAyMTMxMTk2LDIuMDA4OTgwNzAzNTkxMzUxNiw4LjQ4NzU5NjA4NTcxODgy\nNF0sWyJMaXN0Iiw5LjMwODI2OTg1Njc3MDA1NywzLjA0OTYxNDYzNDQ5ODAyNTcsOC41NjEyMzE3\nMDY3NTMyNTRdXV1dLFsiTGlzdCIsWyJIdWUiLDAuNDAyNzE2ODgxODM2NDc5MjUsMS4wLDAuNV0s\nWyJDeWxpbmRlciIsWyJMaXN0IixbIkxpc3QiLDUuOTA5OTMzNTE2NzI3NjczLDEuMTU1NTg4Nzc4\nNDcwOTQ0NCwxLjMyODUyODM2OTQyMDcxMTNdLFsiTGlzdCIsMS4xODEyNzQyMDY2MTczOTU0LDMu\nMjEyMzcyNDY1NDEzMjQ0LDguNjU0MDM3MzAzMTM4OTM5XV1dXSxbIkxpc3QiLFsiSHVlIiwwLjQz\nNzg4ODY1MDkyMDcyOTYsMS4wLDAuNV0sWyJDeWxpbmRlciIsWyJMaXN0IixbIkxpc3QiLDIuODUw\nODUzOTU4ODc1NjQxLDIuODY2NTY5MzU3NTc2ODUsNC4xMjA5NjYwMzIxODU0MzldLFsiTGlzdCIs\nMC4yNDYxNjM2MjA2MjIzNzU4NCw5LjcwMTMyNDQ4NDQzNTI5Nyw5LjkzMjYzMTQzNDE0ODExN11d\nXV0sWyJMaXN0IixbIkh1ZSIsMC4xMDIzMjQxMTc2NjU4NjgyNCwxLjAsMC41XSxbIkN5bGluZGVy\nIixbIkxpc3QiLFsiTGlzdCIsMy41NjQwOTAwNjU0MDk0MzQ1LDkuMTMzODk2MTY1MDA3OTExLDgu\nOTI1Mzk5NzM4ODI4NTQyXSxbIkxpc3QiLDguODU0MDczOTkzODg0Mzg4LDYuMjQ1MjkxNzc0MTAy\nMjA2LDUuODE4MTU2MjMyOTYzOTgyXV1dXV1d\n",children:"Graphics3D[ Table[{Hue[RandomReal[], 1., 0.5], Cylinder[RandomReal[10, {2, 3}]]}, {20}]]"}),"\n",(0,i.jsx)(N.h2,{id:"parameters",children:"Parameters"}),"\n",(0,i.jsx)(N.h3,{id:"rgbcolor",children:(0,i.jsx)(N.code,{children:"RGBColor"})}),"\n",(0,i.jsx)(N.h2,{id:"methods",children:"Methods"}),"\n",(0,i.jsx)(N.p,{children:"Volume and centroid"}),"\n",(0,i.jsx)(N.h3,{id:"volume",children:(0,i.jsx)(N.code,{children:"Volume"})}),"\n",(0,i.jsx)(N.p,{children:"accepts symbolic values as well"}),"\n",(0,i.jsx)(N.pre,{children:(0,i.jsx)(N.code,{className:"language-mathematica",children:"Volume[Cylinder[{{Subscript[x, 1], Subscript[y, 1], Subscript[z, 1]}, {Subscript[x, 2], Subscript[y, 2], Subscript[z, 2]}}, r]]\n"})}),"\n",(0,i.jsx)(N.h3,{id:"regioncentroid",children:(0,i.jsx)(N.code,{children:"RegionCentroid"})}),"\n",(0,i.jsx)(N.pre,{children:(0,i.jsx)(N.code,{className:"language-mathematica",children:"RegionCentroid[ Cylinder[{{Subscript[x, 1], Subscript[y, 1], Subscript[z, 1]}, {Subscript[x, 2], Subscript[y, 2], Subscript[z, 2]}}, r]]\n"})}),"\n",(0,i.jsx)(N.h2,{id:"dynamic-updates",children:"Dynamic updates"}),"\n",(0,i.jsx)(N.p,{children:"It does support dynamics for coordinates. Radius changes are not implemented!"})]})}function j(M={}){const{wrapper:N}={...(0,s.M)(),...M.components};return N?(0,i.jsx)(N,{...M,children:(0,i.jsx)(d,{...M})}):d(M)}},4552:(M,N,e)=>{e.d(N,{I:()=>T,M:()=>c});var i=e(11504);const s={},D=i.createContext(s);function c(M){const N=i.useContext(D);return i.useMemo((function(){return"function"==typeof M?M(N):{...N,...M}}),[N,M])}function T(M){let N;return N=M.disableParentContext?"function"==typeof M.components?M.components(s):M.components||s:c(M.components),i.createElement(D.Provider,{value:N},M.children)}}}]);