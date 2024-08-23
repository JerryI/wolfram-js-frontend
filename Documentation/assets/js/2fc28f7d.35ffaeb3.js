"use strict";(self.webpackChunkwlx_docs=self.webpackChunkwlx_docs||[]).push([[4304],{56112:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>l,contentTitle:()=>r,default:()=>d,frontMatter:()=>a,metadata:()=>i,toc:()=>c});var o=t(17624),s=t(4552);const a={env:["Wolfram Kernel"],update:null,needsContainer:null,origin:"https://reference.wolfram.com/language/ref/ListContourPlot.html"},r=void 0,i={id:"frontend/Reference/Plotting Functions/ListContourPlot",title:"ListContourPlot",description:"A list version of ContourPlot",source:"@site/docs/frontend/Reference/Plotting Functions/ListContourPlot.md",sourceDirName:"frontend/Reference/Plotting Functions",slug:"/frontend/Reference/Plotting Functions/ListContourPlot",permalink:"/frontend/Reference/Plotting Functions/ListContourPlot",draft:!1,unlisted:!1,tags:[],version:"current",lastUpdatedAt:171482423e4,frontMatter:{env:["Wolfram Kernel"],update:null,needsContainer:null,origin:"https://reference.wolfram.com/language/ref/ListContourPlot.html"},sidebar:"tutorialSidebar",previous:{title:"ListAnimatePlot",permalink:"/frontend/Reference/Plotting Functions/ListAnimatePlot"},next:{title:"ListCurvePathPlot",permalink:"/frontend/Reference/Plotting Functions/ListCurvePathPlot"}},l={},c=[{value:"Example",id:"example",level:2}];function m(e){const n={a:"a",annotation:"annotation",code:"code",h2:"h2",math:"math",mi:"mi",mo:"mo",mrow:"mrow",p:"p",pre:"pre",semantics:"semantics",span:"span",...(0,s.M)(),...e.components},{Wl:t}=n;return t||function(e,n){throw new Error("Expected "+(n?"component":"object")+" `"+e+"` to be defined: you likely forgot to import, pass, or provide it.")}("Wl",!0),(0,o.jsxs)(o.Fragment,{children:[(0,o.jsxs)(n.p,{children:["A list version of ",(0,o.jsx)(n.a,{href:"/frontend/Reference/Plotting%20Functions/ContourPlot",children:"ContourPlot"})]}),"\n",(0,o.jsx)(n.h2,{id:"example",children:"Example"}),"\n",(0,o.jsx)(n.p,{children:"Generate contours from an array of heights"}),"\n",(0,o.jsx)(n.pre,{children:(0,o.jsx)(n.code,{className:"language-mathematica",children:"ListContourPlot[Table[Sin[i + j^2], {i, 0, 3, 0.1}, {j, 0, 3, 0.1}]]\n"})}),"\n",(0,o.jsx)(t,{children:"ListContourPlot[Table[Sin[i + j^2], {i, 0, 3, 0.1}, {j, 0, 3, 0.1}], ImageSize->500]"}),"\n",(0,o.jsxs)(n.p,{children:["Or give explicit ",(0,o.jsxs)(n.span,{className:"katex",children:[(0,o.jsx)(n.span,{className:"katex-mathml",children:(0,o.jsx)(n.math,{xmlns:"http://www.w3.org/1998/Math/MathML",children:(0,o.jsxs)(n.semantics,{children:[(0,o.jsxs)(n.mrow,{children:[(0,o.jsx)(n.mi,{children:"x"}),(0,o.jsx)(n.mo,{separator:"true",children:","}),(0,o.jsx)(n.mi,{children:"y"}),(0,o.jsx)(n.mo,{separator:"true",children:","}),(0,o.jsx)(n.mi,{children:"z"})]}),(0,o.jsx)(n.annotation,{encoding:"application/x-tex",children:"x,y,z"})]})})}),(0,o.jsx)(n.span,{className:"katex-html","aria-hidden":"true",children:(0,o.jsxs)(n.span,{className:"base",children:[(0,o.jsx)(n.span,{className:"strut",style:{height:"0.625em",verticalAlign:"-0.1944em"}}),(0,o.jsx)(n.span,{className:"mord mathnormal",children:"x"}),(0,o.jsx)(n.span,{className:"mpunct",children:","}),(0,o.jsx)(n.span,{className:"mspace",style:{marginRight:"0.1667em"}}),(0,o.jsx)(n.span,{className:"mord mathnormal",style:{marginRight:"0.03588em"},children:"y"}),(0,o.jsx)(n.span,{className:"mpunct",children:","}),(0,o.jsx)(n.span,{className:"mspace",style:{marginRight:"0.1667em"}}),(0,o.jsx)(n.span,{className:"mord mathnormal",style:{marginRight:"0.04398em"},children:"z"})]})})]})," coordinates for the data"]}),"\n",(0,o.jsx)(n.pre,{children:(0,o.jsx)(n.code,{className:"language-mathematica",children:"data = Table[{x = RandomReal[{-2, 2}], y = RandomReal[{-2, 2}], Sin[x y]}, {1000}];\nListContourPlot[data]\n"})}),"\n",(0,o.jsx)(t,{children:"ListContourPlot[Table[{x = RandomReal[{-2, 2}], y = RandomReal[{-2, 2}], Sin[x y]}, {1000}], ImageSize->500]"})]})}function d(e={}){const{wrapper:n}={...(0,s.M)(),...e.components};return n?(0,o.jsx)(n,{...e,children:(0,o.jsx)(m,{...e})}):m(e)}},4552:(e,n,t)=>{t.d(n,{I:()=>i,M:()=>r});var o=t(11504);const s={},a=o.createContext(s);function r(e){const n=o.useContext(a);return o.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function i(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(s):e.components||s:r(e.components),o.createElement(a.Provider,{value:n},e.children)}}}]);