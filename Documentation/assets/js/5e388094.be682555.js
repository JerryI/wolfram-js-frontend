"use strict";(self.webpackChunkwlx_docs=self.webpackChunkwlx_docs||[]).push([[7104],{48428:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>l,contentTitle:()=>d,default:()=>u,frontMatter:()=>i,metadata:()=>c,toc:()=>s});var r=n(17624),o=n(4552);const i={env:["WLJS"],package:"wljs-editor",source:"https://github.com/JerryI/wljs-editor/blob/dev/src/EditorKernel.wl",context:"Notebook`EditorUtils`"},d=void 0,c={id:"frontend/Reference/Interpreter/FrontEditorSelected",title:"FrontEditorSelected",description:"Manipulates the last selected input cell's editor",source:"@site/docs/frontend/Reference/Interpreter/FrontEditorSelected.md",sourceDirName:"frontend/Reference/Interpreter",slug:"/frontend/Reference/Interpreter/FrontEditorSelected",permalink:"/frontend/Reference/Interpreter/FrontEditorSelected",draft:!1,unlisted:!1,tags:[],version:"current",lastUpdatedAt:1711835414,formattedLastUpdatedAt:"Mar 30, 2024",frontMatter:{env:["WLJS"],package:"wljs-editor",source:"https://github.com/JerryI/wljs-editor/blob/dev/src/EditorKernel.wl",context:"Notebook`EditorUtils`"},sidebar:"tutorialSidebar",previous:{title:"AttachDOM",permalink:"/frontend/Reference/Interpreter/AttachDOM"},next:{title:"FrontEndVirtual",permalink:"/frontend/Reference/Interpreter/FrontEndVirtual"}},l={},s=[{value:"op",id:"op",level:2},{value:"<code>&quot;Get&quot;</code>",id:"get",level:3},{value:"<code>&quot;Set&quot;</code>",id:"set",level:3},{value:"<code>&quot;Evaluate&quot;</code>",id:"evaluate",level:3}];function a(e){const t={a:"a",admonition:"admonition",code:"code",h2:"h2",h3:"h3",p:"p",pre:"pre",strong:"strong",...(0,o.M)(),...e.components};return(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)(t.p,{children:"Manipulates the last selected input cell's editor"}),"\n",(0,r.jsx)(t.pre,{children:(0,r.jsx)(t.code,{className:"language-mathematica",children:"FrontEndEditorSelected[op_String, Null | data_String] Null | _String\n"})}),"\n",(0,r.jsx)(t.admonition,{type:"warning",children:(0,r.jsxs)(t.p,{children:["This has to be executed in WLJS interpreter, i.e. using ",(0,r.jsx)(t.a,{href:"/frontend/Reference/Frontend%20IO/FrontSubmit",children:"FrontSubmit"})," or ",(0,r.jsx)(t.a,{href:"/frontend/Reference/Frontend%20IO/FrontFetchAsync",children:"FrontFetchAsync"})]})}),"\n",(0,r.jsx)(t.h2,{id:"op",children:"op"}),"\n",(0,r.jsx)(t.p,{children:"There are following operations available"}),"\n",(0,r.jsx)(t.h3,{id:"get",children:(0,r.jsx)(t.code,{children:'"Get"'})}),"\n",(0,r.jsxs)(t.p,{children:["Returns ",(0,r.jsx)(t.strong,{children:"selected string"}),". For example"]}),"\n",(0,r.jsx)(t.pre,{children:(0,r.jsx)(t.code,{className:"language-mathematica",children:'With[{win = CurrentWindow[]},\n  EventHandler[InputButton[], Function[Null, \n    \n      Then[FrontFetchAsync[FrontEditorSelected["Get"], "Window"->win], Function[result,\n        Print[result];\n      ]\n    ]\n  ]]\n]\n'})}),"\n",(0,r.jsx)(t.h3,{id:"set",children:(0,r.jsx)(t.code,{children:'"Set"'})}),"\n",(0,r.jsx)(t.p,{children:"Inserts or replaces selected text with a provided string"}),"\n",(0,r.jsx)(t.pre,{children:(0,r.jsx)(t.code,{className:"language-mathematica",children:'With[{win = CurrentWindow[]},\n  EventHandler[InputButton["Replace"],\n    Function[Null, \n      FrontSubmit[FrontEditorSelected["Set", "Yo"], "Window"->win];\n    ]\n  ]\n] \n'})}),"\n",(0,r.jsx)(t.h3,{id:"evaluate",children:(0,r.jsx)(t.code,{children:'"Evaluate"'})}),"\n",(0,r.jsx)(t.admonition,{type:"danger",children:(0,r.jsx)(t.p,{children:"Not implemented"})})]})}function u(e={}){const{wrapper:t}={...(0,o.M)(),...e.components};return t?(0,r.jsx)(t,{...e,children:(0,r.jsx)(a,{...e})}):a(e)}},4552:(e,t,n)=>{n.d(t,{I:()=>c,M:()=>d});var r=n(11504);const o={},i=r.createContext(o);function d(e){const t=r.useContext(i);return r.useMemo((function(){return"function"==typeof e?e(t):{...t,...e}}),[t,e])}function c(e){let t;return t=e.disableParentContext?"function"==typeof e.components?e.components(o):e.components||o:d(e.components),r.createElement(i.Provider,{value:t},e.children)}}}]);