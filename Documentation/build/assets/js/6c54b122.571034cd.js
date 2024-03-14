"use strict";(self.webpackChunkwlx_docs=self.webpackChunkwlx_docs||[]).push([[3216],{2624:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>a,contentTitle:()=>o,default:()=>h,frontMatter:()=>r,metadata:()=>l,toc:()=>c});var s=t(17624),i=t(4552);const r={sidebar_position:4},o=void 0,l={id:"frontend/Cell types/Javascript",title:"Javascript",description:"WebGL demo",source:"@site/docs/frontend/Cell types/Javascript.md",sourceDirName:"frontend/Cell types",slug:"/frontend/Cell types/Javascript",permalink:"/wljs-docs/frontend/Cell types/Javascript",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:4,frontMatter:{sidebar_position:4},sidebar:"tutorialSidebar",previous:{title:"HTML",permalink:"/wljs-docs/frontend/Cell types/HTML"},next:{title:"Files",permalink:"/wljs-docs/frontend/Cell types/Files"}},a={},c=[{value:"Output cell",id:"output-cell",level:2},{value:"Handlers",id:"handlers",level:2},{value:"this.ondestroy",id:"thisondestroy",level:3},{value:"requestAnimationFrame",id:"requestanimationframe",level:3},{value:"Communication with Wolfram Kernel",id:"communication-with-wolfram-kernel",level:2}];function d(e){const n={a:"a",admonition:"admonition",code:"code",em:"em",h2:"h2",h3:"h3",img:"img",p:"p",pre:"pre",strong:"strong",...(0,i.M)(),...e.components};return(0,s.jsxs)(s.Fragment,{children:[(0,s.jsx)(n.p,{children:(0,s.jsx)(n.img,{src:t(85928).c+"",width:"1454",height:"1042"})}),"\n",(0,s.jsx)(n.p,{children:(0,s.jsx)(n.em,{children:"WebGL demo"})}),"\n",(0,s.jsxs)(n.p,{children:[(0,s.jsx)(n.strong,{children:(0,s.jsx)(n.a,{href:"https://github.com/JerryI/wljs-js-support",children:"Github repo"})}),"\nJavascript code is evaluated as a module, i.e. ",(0,s.jsx)(n.strong,{children:"all defined variables are isolated to the cell"}),"."]}),"\n",(0,s.jsxs)(n.admonition,{type:"tip",children:[(0,s.jsxs)(n.p,{children:["To define global variables, use ",(0,s.jsx)(n.code,{children:"window"})," or ",(0,s.jsx)(n.code,{children:"core"})," object."]}),(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-js",children:"window.variable = 1\n"})})]}),"\n",(0,s.jsx)(n.h2,{id:"output-cell",children:"Output cell"}),"\n",(0,s.jsx)(n.p,{children:"The returned value from the function can be a Javascript object or DOM element. The last one will be displayed in the output cell"}),"\n",(0,s.jsx)(n.h2,{id:"handlers",children:"Handlers"}),"\n",(0,s.jsx)(n.p,{children:"There is a few quite useful built-in objects accesable from the cell."}),"\n",(0,s.jsx)(n.h3,{id:"thisondestroy",children:"this.ondestroy"}),"\n",(0,s.jsx)(n.p,{children:"This object is called when a cell has been destroyed. Assign any clean-up function to the given object"}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-js",children:"this.ondestroy = () => {\n\t//clean up the stuff\n}\n"})}),"\n",(0,s.jsx)(n.admonition,{type:"danger",children:(0,s.jsxs)(n.p,{children:["Always clean up any timers using ",(0,s.jsx)(n.code,{children:"this.ondestroy"})," variable. Otherwise those timers and animation loops will continue to work even after reevaluating the cell."]})}),"\n",(0,s.jsx)(n.h3,{id:"requestanimationframe",children:"requestAnimationFrame"}),"\n",(0,s.jsx)(n.p,{children:"It is well-common method used in Javascript to synchronize with a framerate of the browser and render some graphics"}),"\n",(0,s.jsx)(n.admonition,{type:"danger",children:(0,s.jsxs)(n.p,{children:["Do not forget to ",(0,s.jsx)(n.code,{children:"cancelAnimationFrame"})," using ",(0,s.jsx)(n.code,{children:"this.ondestroy"})," method"]})}),"\n",(0,s.jsx)(n.h2,{id:"communication-with-wolfram-kernel",children:"Communication with Wolfram Kernel"}),"\n",(0,s.jsxs)(n.p,{children:["In general one can define any function for WLJS Interpreter using Javascript cells, please see guide here ",(0,s.jsx)(n.a,{href:"FrontSubmit",children:"FrontSubmit"})," and ",(0,s.jsx)(n.a,{href:"/wljs-docs/frontend/Advanced/Events%20system/event-generators#Integration%20with%20server%20/%20client%20via%20WebSockets",children:"Integration with server / client via WebSockets"})]}),"\n",(0,s.jsxs)(n.p,{children:["For the most applications event-based system is used, see ",(0,s.jsx)(n.a,{href:"../Development/Evaluation/Dynamic.md",children:"Dynamic"})]})]})}function h(e={}){const{wrapper:n}={...(0,i.M)(),...e.components};return n?(0,s.jsx)(n,{...e,children:(0,s.jsx)(d,{...e})}):d(e)}},85928:(e,n,t)=>{t.d(n,{c:()=>s});const s=t.p+"assets/images/Screenshot 2024-03-13 at 19.30.35-2c484e51d8c462802bdf587e80e61cea.png"},4552:(e,n,t)=>{t.d(n,{I:()=>l,M:()=>o});var s=t(11504);const i={},r=s.createContext(i);function o(e){const n=s.useContext(r);return s.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function l(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(i):e.components||i:o(e.components),s.createElement(r.Provider,{value:n},e.children)}}}]);