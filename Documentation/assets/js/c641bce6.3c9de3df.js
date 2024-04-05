"use strict";(self.webpackChunkwlx_docs=self.webpackChunkwlx_docs||[]).push([[1640],{44444:(e,n,r)=>{r.r(n),r.d(n,{assets:()=>a,contentTitle:()=>l,default:()=>h,frontMatter:()=>s,metadata:()=>t,toc:()=>c});var o=r(17624),i=r(4552);const s={},l=void 0,t={id:"frontend/Troubleshooting/Apple Silicon",title:"Apple Silicon",description:"App is damaged, please, move it to the trash bin",source:"@site/docs/frontend/Troubleshooting/Apple Silicon.md",sourceDirName:"frontend/Troubleshooting",slug:"/frontend/Troubleshooting/Apple Silicon",permalink:"/frontend/Troubleshooting/Apple Silicon",draft:!1,unlisted:!1,tags:[],version:"current",lastUpdatedAt:1711835414,formattedLastUpdatedAt:"Mar 30, 2024",frontMatter:{},sidebar:"tutorialSidebar",previous:{title:"Troubleshooting",permalink:"/frontend/Troubleshooting/"},next:{title:"CellPrint",permalink:"/frontend/Reference/Cells and Notebook/CellPrint"}},a={},c=[{value:"Running from the browser",id:"running-from-the-browser",level:2},{value:"Bypassing Gatekeeper",id:"bypassing-gatekeeper",level:2},{value:"Building from source",id:"building-from-source",level:2}];function d(e){const n={a:"a",blockquote:"blockquote",code:"code",em:"em",h2:"h2",li:"li",ol:"ol",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,i.M)(),...e.components};return(0,o.jsxs)(o.Fragment,{children:[(0,o.jsxs)(n.blockquote,{children:["\n",(0,o.jsx)(n.p,{children:"App is damaged, please, move it to the trash bin"}),"\n"]}),"\n",(0,o.jsxs)(n.p,{children:[(0,o.jsx)(n.strong,{children:"If it is your case"})," something went wrong with our notarization process in Apple"]}),"\n",(0,o.jsx)(n.p,{children:"There is a few options for Mac M1/M2 users on how to overcome this issue"}),"\n",(0,o.jsx)(n.h2,{id:"running-from-the-browser",children:"Running from the browser"}),"\n",(0,o.jsx)(n.p,{children:"In principle, once you have Wolfram Engine installed and activated, it is possible to run WLJS Notebook from the terminal like Jupyter Notebook"}),"\n",(0,o.jsxs)(n.ol,{children:["\n",(0,o.jsxs)(n.li,{children:[(0,o.jsx)(n.a,{href:"https://github.com/JerryI/wolfram-js-frontend",children:"Clone repository using"})," ",(0,o.jsx)(n.code,{children:"git"})," or download ",(0,o.jsx)(n.code,{children:"zip"})," archive. Here is a ",(0,o.jsx)(n.a,{href:"https://github.com/JerryI/wolfram-js-frontend/archive/refs/heads/default.zip",children:(0,o.jsx)(n.strong,{children:"direct link"})})]}),"\n",(0,o.jsxs)(n.li,{children:["Unzip the file and open your ",(0,o.jsx)(n.code,{children:"Terminal"})," app in this folder"]}),"\n",(0,o.jsx)(n.li,{children:"Run the command"}),"\n"]}),"\n",(0,o.jsx)(n.pre,{children:(0,o.jsx)(n.code,{className:"language-bash",children:"wolframscript -f Scripts/start.wls\n"})}),"\n",(0,o.jsxs)(n.ol,{start:"4",children:["\n",(0,o.jsx)(n.li,{children:"Once a message has popped up"}),"\n"]}),"\n",(0,o.jsx)(n.pre,{children:(0,o.jsx)(n.code,{className:"language-mathematica",children:"Open http://127.0.0.1:20560 in your browser\n"})}),"\n",(0,o.jsx)(n.p,{children:"open your browser using the corresponding link"}),"\n",(0,o.jsx)(n.h2,{id:"bypassing-gatekeeper",children:"Bypassing Gatekeeper"}),"\n",(0,o.jsx)(n.p,{children:"This is a common solution among most Electron developers, who do not have a paid license form Apple."}),"\n",(0,o.jsxs)(n.ol,{children:["\n",(0,o.jsxs)(n.li,{children:["Install a Desktop app normally from ",(0,o.jsx)(n.a,{href:"/",children:"instruction"})]}),"\n",(0,o.jsx)(n.li,{children:"Open your terminal app and run the command"}),"\n"]}),"\n",(0,o.jsx)(n.pre,{children:(0,o.jsx)(n.code,{className:"language-bash",children:'xattr -cr "<installation location of WLJS Notebook>.app"\n'})}),"\n",(0,o.jsx)(n.p,{children:"Then it should work like normal Desktop app"}),"\n",(0,o.jsx)(n.h2,{id:"building-from-source",children:"Building from source"}),"\n",(0,o.jsx)(n.p,{children:"You can also build a copy of an application by yourself. You will need to install"}),"\n",(0,o.jsxs)(n.ul,{children:["\n",(0,o.jsx)(n.li,{children:(0,o.jsx)(n.em,{children:"Node JS"})}),"\n",(0,o.jsxs)(n.li,{children:[(0,o.jsx)(n.em,{children:"Xcode Command Line"}),"\xa0Tools (possible, may be not necessary)"]}),"\n"]}),"\n",(0,o.jsxs)(n.ol,{children:["\n",(0,o.jsxs)(n.li,{children:[(0,o.jsx)(n.a,{href:"https://github.com/JerryI/wolfram-js-frontend",children:"Clone repository using"})," ",(0,o.jsx)(n.code,{children:"git"})," or download ",(0,o.jsx)(n.code,{children:"zip"})," archive. Here is a ",(0,o.jsx)(n.a,{href:"https://github.com/JerryI/wolfram-js-frontend/archive/refs/heads/default.zip",children:(0,o.jsx)(n.strong,{children:"direct link"})})]}),"\n",(0,o.jsxs)(n.li,{children:["Unzip the file and open your ",(0,o.jsx)(n.code,{children:"Terminal"})," app in this folder"]}),"\n",(0,o.jsx)(n.li,{children:"Run the command"}),"\n"]}),"\n",(0,o.jsx)(n.pre,{children:(0,o.jsx)(n.code,{className:"language-bash",children:"npm i\n"})}),"\n",(0,o.jsxs)(n.ol,{start:"4",children:["\n",(0,o.jsx)(n.li,{children:"Build the binary"}),"\n"]}),"\n",(0,o.jsx)(n.pre,{children:(0,o.jsx)(n.code,{className:"language-bash",children:"npm run dist\n"})}),"\n",(0,o.jsxs)(n.ol,{start:"5",children:["\n",(0,o.jsxs)(n.li,{children:["Locate ",(0,o.jsx)(n.code,{children:".dmg"})," file in the directory ",(0,o.jsx)(n.code,{children:"./dist/"})," and install it from there like a normal App"]}),"\n"]})]})}function h(e={}){const{wrapper:n}={...(0,i.M)(),...e.components};return n?(0,o.jsx)(n,{...e,children:(0,o.jsx)(d,{...e})}):d(e)}},4552:(e,n,r)=>{r.d(n,{I:()=>t,M:()=>l});var o=r(11504);const i={},s=o.createContext(i);function l(e){const n=o.useContext(s);return o.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function t(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(i):e.components||i:l(e.components),o.createElement(s.Provider,{value:n},e.children)}}}]);