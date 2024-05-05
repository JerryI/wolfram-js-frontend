"use strict";(self.webpackChunkwlx_docs=self.webpackChunkwlx_docs||[]).push([[3288],{66080:(e,n,i)=>{i.r(n),i.d(n,{assets:()=>s,contentTitle:()=>l,default:()=>h,frontMatter:()=>o,metadata:()=>d,toc:()=>a});var t=i(17624),r=i(4552);const o={sidebar_position:6},l=void 0,d={id:"frontend/Guidelines",title:"Guidelines",description:"Still populating with a content",source:"@site/docs/frontend/Guidelines.md",sourceDirName:"frontend",slug:"/frontend/Guidelines",permalink:"/frontend/Guidelines",draft:!1,unlisted:!1,tags:[],version:"current",lastUpdatedAt:1714393090,formattedLastUpdatedAt:"Apr 29, 2024",sidebarPosition:6,frontMatter:{sidebar_position:6},sidebar:"tutorialSidebar",previous:{title:"Snippets",permalink:"/frontend/Snippets"},next:{title:"Advanced",permalink:"/category/advanced"}},s={},a=[{value:"Use shortcuts",id:"use-shortcuts",level:2},{value:"UI Operations",id:"ui-operations",level:3},{value:"Evaluation",id:"evaluation",level:3},{value:"Keep folders organized",id:"keep-folders-organized",level:2},{value:"Use <code>NotebookStore</code> for portability",id:"use-notebookstore-for-portability",level:2},{value:"Install everything locally",id:"install-everything-locally",level:2},{value:"Do not use <code>Dynamic</code>, <code>Manipulate</code>",id:"do-not-use-dynamic-manipulate",level:2},{value:"Dynamic",id:"dynamic",level:3},{value:"Manipulate",id:"manipulate",level:3}];function c(e){const n={a:"a",admonition:"admonition",code:"code",em:"em",h2:"h2",h3:"h3",li:"li",p:"p",pre:"pre",ul:"ul",...(0,r.M)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(n.admonition,{type:"warning",children:(0,t.jsx)(n.p,{children:"Still populating with a content"})}),"\n",(0,t.jsx)(n.h2,{id:"use-shortcuts",children:"Use shortcuts"}),"\n",(0,t.jsx)(n.p,{children:"It improves user experience drastically"}),"\n",(0,t.jsx)(n.h3,{id:"ui-operations",children:"UI Operations"}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsxs)(n.li,{children:["New notebook ",(0,t.jsx)(n.code,{children:"Cmd+N"}),", ",(0,t.jsx)(n.code,{children:"Ctrl+N"})]}),"\n",(0,t.jsxs)(n.li,{children:["Open file ",(0,t.jsx)(n.code,{children:"Cmd+O"}),", ",(0,t.jsx)(n.code,{children:"Ctrl+O"})]}),"\n",(0,t.jsxs)(n.li,{children:["Save ",(0,t.jsx)(n.code,{children:"Cmd+S"}),", ",(0,t.jsx)(n.code,{children:"Ctrl+S"})]}),"\n",(0,t.jsxs)(n.li,{children:["Enter command palette ",(0,t.jsx)(n.code,{children:"Cmd+P"}),", ",(0,t.jsx)(n.code,{children:"Ctrl+P"})]}),"\n",(0,t.jsxs)(n.li,{children:["Hide/Unhide current cell ",(0,t.jsx)(n.code,{children:"Cmd+2"}),", ",(0,t.jsx)(n.code,{children:"Ctrl+W"})]}),"\n",(0,t.jsxs)(n.li,{children:["Clear outputs ",(0,t.jsx)(n.code,{children:"Cmd+U"}),", ",(0,t.jsx)(n.code,{children:"Alt+U"})]}),"\n"]}),"\n",(0,t.jsx)(n.h3,{id:"evaluation",children:"Evaluation"}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsxs)(n.li,{children:["Evaluate ",(0,t.jsx)(n.code,{children:"Shift+Enter"})]}),"\n",(0,t.jsxs)(n.li,{children:["Abort ",(0,t.jsx)(n.code,{children:"Cmd+."}),", ",(0,t.jsx)(n.code,{children:"Alt+."})]}),"\n",(0,t.jsxs)(n.li,{children:["Evaluate initialization cells ",(0,t.jsx)(n.code,{children:"Cmd+I"}),", ",(0,t.jsx)(n.code,{children:"Alt+I"})]}),"\n"]}),"\n",(0,t.jsx)(n.h2,{id:"keep-folders-organized",children:"Keep folders organized"}),"\n",(0,t.jsxs)(n.p,{children:["Various functions may produce ",(0,t.jsx)(n.a,{href:"/frontend/Reference/Decorations/Iconize",children:"Iconize"})," objects, for storing large chunks of data, which are copied to ",(0,t.jsx)(n.code,{children:"./.iconized/"})," folder in the notebook directory. Any dropped images or files will be uploaded to ",(0,t.jsx)(n.code,{children:"./attachments/"})," directory. Therefore it is important to have a clear separation between your projects."]}),"\n",(0,t.jsxs)(n.h2,{id:"use-notebookstore-for-portability",children:["Use ",(0,t.jsx)(n.code,{children:"NotebookStore"})," for portability"]}),"\n",(0,t.jsxs)(n.p,{children:["If you want your notebook to be exported to a single editable ",(0,t.jsx)(n.code,{children:".html"})," ",(0,t.jsx)(n.a,{href:"/frontend/Export/HTML%20file",children:"HTML file"}),", use ",(0,t.jsx)(n.a,{href:"/frontend/Reference/Cells%20and%20Notebook/NotebookStore",children:"NotebookStore"})," as a persistent storage for your raw data. In such case all images, graphs, and stored data will be kept."]}),"\n",(0,t.jsx)(n.h2,{id:"install-everything-locally",children:"Install everything locally"}),"\n",(0,t.jsx)(n.p,{children:"We promote the idea of storing libraries or paclets for Wolfram Language locally for each project. There is no other way to provide the reliable way of computing, storing data, reproducibility and independence from any remote resources"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-mathematica",metastring:'title="example of a built-in package manager"',children:'PacletRepositories[{\n    Github -> "https://github.com/KirillBelovTest/GPTLink"\n}]\n\n<<KirillBelov`GPTLink`\n'})}),"\n",(0,t.jsx)(n.p,{children:"this will create a folder with all used paclets and keep them up to date if needed"}),"\n",(0,t.jsxs)(n.h2,{id:"do-not-use-dynamic-manipulate",children:["Do not use ",(0,t.jsx)(n.code,{children:"Dynamic"}),", ",(0,t.jsx)(n.code,{children:"Manipulate"})]}),"\n",(0,t.jsxs)(n.p,{children:["We rely on ",(0,t.jsx)(n.em,{children:"a completely different architecture"})," to handle interactivity and graphics updates compared to Wolfram Mathematica."]}),"\n",(0,t.jsx)(n.h3,{id:"dynamic",children:"Dynamic"}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.a,{href:"/frontend/Reference/GUI/InputButton",children:"Buttons"}),", ",(0,t.jsx)(n.a,{href:"/frontend/Reference/GUI/InputRange",children:"sliders"})," are event-driven, i.e. you need to subscribe to them using ",(0,t.jsx)(n.a,{href:"/frontend/Reference/Misc/Events#%60EventHandler%60",children:(0,t.jsx)(n.code,{children:"EventHandler"})}),". All dynamic updates are handled using ",(0,t.jsx)(n.a,{href:"/frontend/Reference/Interpreter/Offload",children:"Offload"})," approach. For example"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-mathematica",children:"length = 1.0;\nEventHandler[InputRange[-1,1,0.1], Function[l, length = l]]\n\nGraphics[Rectangle[{-1,-1}, {length // Offload, 1}]]\n"})}),"\n",(0,t.jsx)(n.h3,{id:"manipulate",children:"Manipulate"}),"\n",(0,t.jsxs)(n.p,{children:["In general there is built-in function for simple 2D plots - ",(0,t.jsx)(n.a,{href:"/frontend/Reference/Plotting%20Functions/ManipulatePlot",children:"ManipulatePlot"}),", however, for something more complicated - ",(0,t.jsx)(n.em,{children:"you need to craft it by yourself"})," using building ",(0,t.jsx)(n.a,{href:"/frontend/Reference/Graphics/Offset",children:"Offset"})," and simple graphics primitives such as ",(0,t.jsx)(n.a,{href:"/frontend/Reference/Graphics3D/Line",children:"Line"}),", ",(0,t.jsx)(n.a,{href:"/frontend/Reference/Graphics3D/Polygon",children:"Polygon"})," and etc as building blocks."]})]})}function h(e={}){const{wrapper:n}={...(0,r.M)(),...e.components};return n?(0,t.jsx)(n,{...e,children:(0,t.jsx)(c,{...e})}):c(e)}},4552:(e,n,i)=>{i.d(n,{I:()=>d,M:()=>l});var t=i(11504);const r={},o=t.createContext(r);function l(e){const n=t.useContext(o);return t.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function d(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(r):e.components||r:l(e.components),t.createElement(o.Provider,{value:n},e.children)}}}]);