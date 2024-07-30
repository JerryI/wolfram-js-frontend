"use strict";(self.webpackChunkwlx_docs=self.webpackChunkwlx_docs||[]).push([[8632],{20304:(e,n,A)=>{A.r(n),A.d(n,{assets:()=>s,contentTitle:()=>a,default:()=>c,frontMatter:()=>i,metadata:()=>o,toc:()=>l});var r=A(17624),t=A(4552);const i={},a=void 0,o={id:"frontend/Advanced/Frontend interpretation/Frontend Objects",title:"Frontend Objects",description:"This is a core concept of all interactive elements on frontend",source:"@site/docs/frontend/Advanced/Frontend interpretation/Frontend Objects.md",sourceDirName:"frontend/Advanced/Frontend interpretation",slug:"/frontend/Advanced/Frontend interpretation/Frontend Objects",permalink:"/frontend/Advanced/Frontend interpretation/Frontend Objects",draft:!1,unlisted:!1,tags:[],version:"current",lastUpdatedAt:1720209528e3,frontMatter:{},sidebar:"tutorialSidebar",previous:{title:"Editor manipulation",permalink:"/frontend/Advanced/Frontend interpretation/Editor manipulation"},next:{title:"WLJS Functions",permalink:"/frontend/Advanced/Frontend interpretation/WLJS Functions"}},s={},l=[{value:"Motivation",id:"motivation",level:2},{value:"Compress and reuse large expressions",id:"compress-and-reuse-large-expressions",level:3},{value:"Evaluate expressions on frontend",id:"evaluate-expressions-on-frontend",level:3},{value:"Remarks on containers",id:"remarks-on-containers",level:4},{value:"Inner structure",id:"inner-structure",level:2},{value:"Properties",id:"properties",level:2}];function d(e){const n={a:"a",admonition:"admonition",code:"code",h2:"h2",h3:"h3",h4:"h4",img:"img",li:"li",mermaid:"mermaid",ol:"ol",p:"p",pre:"pre",strong:"strong",...(0,t.M)(),...e.components};return(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)(n.p,{children:"This is a core concept of all interactive elements on frontend"}),"\n",(0,r.jsx)(n.h2,{id:"motivation",children:"Motivation"}),"\n",(0,r.jsx)(n.h3,{id:"compress-and-reuse-large-expressions",children:"Compress and reuse large expressions"}),"\n",(0,r.jsxs)(n.p,{children:["Is intended to reduce the load to on the frontend by packing a large Wolfram Expressions like ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Graphics/",children:"Graphics"})," with all its data to a single line reference ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Frontend%20Objects/FrontEndExecutable",children:"FrontEndExecutable"})," or ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Frontend%20Objects/FrontEndRef",children:"FrontEndRef"}),", which can be interpreted later by the editor in the cell."]}),"\n",(0,r.jsx)(n.p,{children:"Such expressions like"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-mathematica",children:"Plot[x, {x,0,1}]\n"})}),"\n",(0,r.jsxs)(n.p,{children:["are evaluated automatically to just a pointer (using ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Frontend%20Objects/CreateFrontEndObject",children:"CreateFrontEndObject"}),") in the output cell as a display value of a ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Decorations/ViewBox",children:"ViewBox"})]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-mathematica",children:'FrontEndExecutable["746fa2e0-24f7-4003-a7cc-4c77f8b4891d"]\n'})}),"\n",(0,r.jsx)(n.p,{children:"This expression will be interpreted by the editor."}),"\n",(0,r.jsxs)(n.p,{children:["This behavior is controlled by ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Decorations/MakeBoxes",children:"MakeBoxes"})," and represents ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Decorations/StandardForm",children:"StandardForm"})," of any ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Graphics/",children:"Graphics"}),", ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Graphics/Image",children:"Image"})," or other heavy expressions, that demand visual representation."]}),"\n",(0,r.jsx)(n.h3,{id:"evaluate-expressions-on-frontend",children:"Evaluate expressions on frontend"}),"\n",(0,r.jsxs)(n.p,{children:["Some expressions, such as ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Sound/ListPlay",children:"ListPlay"}),", or ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Graphics3D/",children:"Graphics3D"})," can be displayed only outside the Wolfram Kernel, i.e. on the frontend. The last one is browser with Javascript engine in our case."]}),"\n",(0,r.jsxs)(n.p,{children:["For such reason the resulting expressions of interactive or graphical elements are evaluated on Javascript using a tiny Wolfram Language interpreter (WLJS). Every ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Frontend%20Objects/FrontEndExecutable",children:"FrontEndExecutable"})," is executed using WLJS Interpreter using data requested on demand from Wolfram Kernel and outputs to the DOM element in the output cell."]}),"\n",(0,r.jsx)(n.admonition,{type:"info",children:(0,r.jsxs)(n.p,{children:["See more about ",(0,r.jsx)(n.a,{href:"/frontend/Advanced/Frontend%20interpretation/WLJS%20Functions",children:"WLJS Functions"})]})}),"\n",(0,r.jsx)(n.p,{children:"Let us have a loot at the example"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-js",metastring:'title="cell 1"',children:'.js\ncore.MyExpression = async (args, env) => {\n\tenv.element.innerText = "Hello World"\n}\n'})}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-mathematica",children:"MyExpression[] // CreateFrontEndObject\n"})}),"\n",(0,r.jsx)(n.p,{children:"will result"}),"\n",(0,r.jsx)(n.p,{children:(0,r.jsx)(n.img,{src:A(12508).c+"",width:"873",height:"79"})}),"\n",(0,r.jsxs)(n.p,{children:["This entity behaves like a single symbol. Basically, thats how ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Graphics/",children:"Graphics"}),", ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Graphics3D/",children:"Graphics3D"}),", ",(0,r.jsx)(n.a,{href:"/frontend/Reference/GUI/InputRange",children:"InputRange"})," and others are made."]}),"\n",(0,r.jsxs)(n.p,{children:["You ",(0,r.jsx)(n.strong,{children:"can remove an extra step"})," by defining a ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Decorations/StandardForm",children:"StandardForm"})," for your symbol"]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-mathematica",children:"MyExpression /: MakeBoxes[m_MyExpression, StandardForm] := With[{\n\to = CreateFrontEndObject[m]\n},\n\tMakeBoxes[o, StandardForm]\n]\n"})}),"\n",(0,r.jsx)(n.p,{children:"and then evaluate it as a normal one"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-mathematica",children:"MyExpression[] (* no need in CreateFrontEndObject anymore *)\n"})}),"\n",(0,r.jsx)(n.h4,{id:"remarks-on-containers",children:"Remarks on containers"}),"\n",(0,r.jsxs)(n.p,{children:["By the default each ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Frontend%20Objects/FrontEndExecutable",children:"FrontEndExecutable"})," will be evaluated inside a so-called ",(0,r.jsx)(n.a,{href:"/frontend/Advanced/Frontend%20interpretation/WLJS%20Functions#Containers%20Executables",children:"container"}),", that provides al local memory to the function and allows them to be destroyed or updated based on changes of child element. See more in ",(0,r.jsx)(n.a,{href:"/frontend/Advanced/Frontend%20interpretation/WLJS%20Functions",children:"WLJS Functions"})]}),"\n",(0,r.jsx)(n.h2,{id:"inner-structure",children:"Inner structure"}),"\n",(0,r.jsx)(n.p,{children:"Here is a diagram to see the underlying structure and how expressions are transformed"}),"\n",(0,r.jsx)(n.mermaid,{value:'flowchart TB\n\n  \n\nsubgraph Storage\n\nUID1["UID"] --\x3e MyExpression2["MyExpression"]\n\nend\n\n  \n\nsubgraph FrontEndExecutable\n\n  \n\nUID2["UID"]\n\nend\n\n  \n\nsubgraph ViewBox\n\n  \n\nsubgraph FrontEndRef\n\nUID3["UID"]\n\nend\n\n  \n\nsubgraph Display\n\nsubgraph FrontEndExecutable4["FrontEndExecutable"]\n\n  \n\nUID5["UID"]\n\nend\n\nend\n\nend\n\n  \n\nsubgraph WLJSInterpreter["WLJS Interpreter"]\n\nsubgraph Container\n\nMyExpression5["MyExpression"]\n\nDOM1\n\nend\n\n  \n\nend\n\n  \n\nsubgraph Outputcell["Output cell"]\n\nDOM2["DOM"]\n\nText\n\nend\n\n  \n\nStorage --fetch--\x3e MyExpression5\n\n  \n\nFrontEndExecutable4["FrontEndExecutable"] --render--\x3e Container\n\n  \n\nDOM1["DOM"] --\x3e DOM2["DOM"]\n\n  \n\nMyExpression5 --\x3e DOM1["DOM"]\n\n  \n\nFrontEndRef --render--\x3e Text\n\n  \n\nMyExpression1["MyExpression"] --MakeBoxes--\x3e FrontEndExecutable\n\n  \n\nMyExpression1["MyExpression"] --MakeBoxes--\x3e UID1\n\n  \n\nUID1 --\x3e UID2\n\n  \n\nFrontEndExecutable --MakeBoxes--\x3e ViewBox'}),"\n",(0,r.jsx)(n.h2,{id:"properties",children:"Properties"}),"\n",(0,r.jsxs)(n.ol,{children:["\n",(0,r.jsxs)(n.li,{children:["Despite the fact, that this is separate entity, it can still be evaluated again on Wolfram Kernel. ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Frontend%20Objects/FrontEndRef",children:"FrontEndRef"})," will be replaced back to its normal form once you submit a cell for evaluation."]}),"\n",(0,r.jsxs)(n.li,{children:["All working objects are synchronized between the notebook and a Kernel. Once you ",(0,r.jsx)(n.strong,{children:"saved"})," a notebook they are serialized to a file as well. So that even with no running Wolfram Kernel they can be displayed."]}),"\n",(0,r.jsxs)(n.li,{children:["All working objects are exported to ",(0,r.jsx)(n.a,{href:"/frontend/Export/HTML",children:"HTML"})]}),"\n",(0,r.jsxs)(n.li,{children:["All objects are embedded automatically to ",(0,r.jsx)(n.a,{href:"/frontend/Cell%20types/Slides",children:"Slides"})," or ",(0,r.jsx)(n.a,{href:"/frontend/Cell%20types/WLX",children:"WLX"})]}),"\n",(0,r.jsxs)(n.li,{children:[(0,r.jsx)(n.a,{href:"/frontend/Reference/Decorations/StandardForm",children:"StandardForm"})," for all ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Frontend%20Objects/FrontEndExecutable",children:"FrontEndExecutable"})," is ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Decorations/ViewBox",children:"ViewBox"})]}),"\n",(0,r.jsxs)(n.li,{children:[(0,r.jsx)(n.a,{href:"/frontend/Reference/Decorations/WLXForm",children:"WLXForm"})," for all ",(0,r.jsx)(n.a,{href:"/frontend/Reference/Frontend%20Objects/FrontEndExecutable",children:"FrontEndExecutable"})," is a sort of view-box as well"]}),"\n"]})]})}function c(e={}){const{wrapper:n}={...(0,t.M)(),...e.components};return n?(0,r.jsx)(n,{...e,children:(0,r.jsx)(d,{...e})}):d(e)}},12508:(e,n,A)=>{A.d(n,{c:()=>r});const r="data:image/png;base64,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bA1jox7hhfiX60hbqTTvpgbwclkayu+H3Y81wYll+7he37/5QJCVEWe94mvYI0IyYwvLjOvY4BkTGW1XXGEscDGemYO145UA2Jsl04g7Eeo5wPu3oP0vUvT1QJX10nZ9SOaCl2M74oLziCkzpYh1z0+Di+06eU8CJEACJEACJOAZBCjSEvAckEYeKfARUojMjAVcfOmxK1NaijRX2rMNCZCA+wngRdhIvQ9DaGWL+Q2UOHf/SjgjCZAACZAACZBAUiJAkZaAp4mkGnv27JEqVaoYWRgTMJxVV5yBQzZEpLqnkQAJeC4BeOGU5y/2iFHP3QBXRgIkQAIkQAIk4HEEKNI87pFwQSRAAiRAAiRAAiRAAiRAAv9lAtYHVv7LJLh3EiABEiABEiABEiABEiABEvAAAhRpHvAQuAQSIAESIAESIAESIAESIAES0AQo0jQJfpMACZAACZAACZAACZAACZCABxCgSPOAh8AlkAAJkAAJkAAJkAAJkAAJkIAmQJGmSfCbBEiABEiABEiABEiABEiABDyAAEWaBzwELoEESIAESIAESIAESIAESIAENAGKNE2C3yRAAiRAAiRAAiRAAiRAAiTgAQQo0jzgIXAJJEACJEACJEACJEACJEACJKAJUKRpEvwmARIgARIgARIgARIgARIgAQ8gQJHmAQ+BSyABEiABEiABEiABEiABEiABTYAiTZPgNwmQAAmQAAmQAAmQAAmQAAl4AAGKNA94CFwCCZAACZAACZAACZAACZAACWgCyfQFv80E7kVGSPSjGOIgARIgARIgARIgARIgARJI4gR8vLwlpa+/23YZeuqcmiuwQJ5Y56RIs8FDgWYDhLckQAIkQAIkQAIkQAIkkEQJuPtv/3v3I1wiyXBHlzCxEQmQAAmQAAmQAAmQAAmQAAm4hwBFmns4cxYSIAESIAESIAESIAESIAEScIkARZpLmNiIBEiABEiABEiABEiABEiABNxDgGfSHHC+cPyhgxoWP00CuYL8nubwHJsESIAESIAESIAESIAEPJ4APWke/4i4QBIgARIgARIgARIgARIggf8SAYo0B087pFh6BzUsJgESIAESIAESIAESIAESIIGnR4Ai7emx5cgkQAIkQAIkQAIkQAIkQAIkEGcCFGlxRsYOJEACJEACJEACJEACJEACJPD0CCRq4pAVqzeplb5a68Wn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"},4552:(e,n,A)=>{A.d(n,{I:()=>o,M:()=>a});var r=A(11504);const t={},i=r.createContext(t);function a(e){const n=r.useContext(i);return r.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function o(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(t):e.components||t:a(e.components),r.createElement(i.Provider,{value:n},e.children)}}}]);