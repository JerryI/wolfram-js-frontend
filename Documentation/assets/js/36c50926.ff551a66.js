"use strict";(self.webpackChunkwlx_docs=self.webpackChunkwlx_docs||[]).push([[8980],{97516:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>o,contentTitle:()=>i,default:()=>l,frontMatter:()=>a,metadata:()=>c,toc:()=>p});var s=n(17624),r=n(4552);const a={env:["WLJS"],package:"wljs-graphics-d3",update:!0,source:"https://github.com/JerryI/wljs-graphics-d3/blob/dev/src/kernel.js"},i=void 0,c={id:"frontend/Reference/Graphics/Inset",title:"Inset",description:"a graphics object, that allows to put another Graphics into the canvas. pos has to be a 2D vector, that specifies the position of the inset.",source:"@site/docs/frontend/Reference/Graphics/Inset.md",sourceDirName:"frontend/Reference/Graphics",slug:"/frontend/Reference/Graphics/Inset",permalink:"/frontend/Reference/Graphics/Inset",draft:!1,unlisted:!1,tags:[],version:"current",lastUpdatedAt:1714824230,formattedLastUpdatedAt:"May 4, 2024",frontMatter:{env:["WLJS"],package:"wljs-graphics-d3",update:!0,source:"https://github.com/JerryI/wljs-graphics-d3/blob/dev/src/kernel.js"},sidebar:"tutorialSidebar",previous:{title:"Image",permalink:"/frontend/Reference/Graphics/Image"},next:{title:"LABColor",permalink:"/frontend/Reference/Graphics/LABColor"}},o={},p=[{value:"Dynamics",id:"dynamics",level:2}];function d(e){const t={a:"a",code:"code",h2:"h2",p:"p",pre:"pre",...(0,r.M)(),...e.components},{Wl:n}=t;return n||function(e,t){throw new Error("Expected "+(t?"component":"object")+" `"+e+"` to be defined: you likely forgot to import, pass, or provide it.")}("Wl",!0),(0,s.jsxs)(s.Fragment,{children:[(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{className:"language-mathematica",children:"Inset[canvas_Graphics, pos_List]\n"})}),"\n",(0,s.jsxs)(t.p,{children:["a graphics object, that allows to put another ",(0,s.jsx)(t.a,{href:"/frontend/Reference/Graphics/",children:"Graphics"})," into the canvas. ",(0,s.jsx)(t.code,{children:"pos"})," has to be a 2D vector, that specifies the position of the inset."]}),"\n",(0,s.jsx)(t.p,{children:"An example"}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{className:"language-mathematica",children:'inset = Graphics[{\n  LightRed,\n  Disk[{0,0},0.1],\n  Black, Directive[FontSize->16], Text["Test", {-1/16,-1/30}]\n}, PlotRange->{{-1,1}, {-1,1}}];\n\nPlot[x, {x,0,10}, Epilog->{Inset[inset]}]\n'})}),"\n",(0,s.jsx)(n,{children:'Plot[x, {x,0,10}, Epilog->{Inset[Graphics[{LightRed,Disk[{0,0},0.1],Black, Directive[FontSize->16], Text["Test", {-1/16,-1/30}]}, ImageSize->350, PlotRange->{{-1,1}, {-1,1}}]]}]'}),"\n",(0,s.jsx)(t.h2,{id:"dynamics",children:"Dynamics"}),"\n",(0,s.jsxs)(t.p,{children:["The second arguments ",(0,s.jsx)(t.code,{children:"pos"})," that specifies the position of an inset does support dynamic updates, i.e. try"]}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{className:"language-mathematica",children:'inset = Graphics[{\n  LightRed,\n  Disk[{-1-0.13,0.9},0.1],\n  Black, Directive[FontSize->16], Text["Test", {-1/16 - 1 - 0.13,-1/30 + 0.9}]\n}, PlotRange->{{-1,1}, {-1,1}}];\n\npts = {0,0};\n\nPlot[x, {x,0,10}, Epilog->{Inset[inset, pts // Offload]}]\n'})}),"\n",(0,s.jsx)(t.p,{children:"and then"}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{className:"language-mathematica",children:"Do[pts = {i,i}; Pause[0.1];, {i, 0, 10, 0.5}]\n"})})]})}function l(e={}){const{wrapper:t}={...(0,r.M)(),...e.components};return t?(0,s.jsx)(t,{...e,children:(0,s.jsx)(d,{...e})}):d(e)}},4552:(e,t,n)=>{n.d(t,{I:()=>c,M:()=>i});var s=n(11504);const r={},a=s.createContext(r);function i(e){const t=s.useContext(a);return s.useMemo((function(){return"function"==typeof e?e(t):{...t,...e}}),[t,e])}function c(e){let t;return t=e.disableParentContext?"function"==typeof e.components?e.components(r):e.components||r:i(e.components),s.createElement(a.Provider,{value:t},e.children)}}}]);