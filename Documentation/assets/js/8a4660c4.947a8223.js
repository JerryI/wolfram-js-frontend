"use strict";(self.webpackChunkwlx_docs=self.webpackChunkwlx_docs||[]).push([[472],{94944:(e,n,i)=>{i.r(n),i.d(n,{assets:()=>o,contentTitle:()=>r,default:()=>h,frontMatter:()=>l,metadata:()=>a,toc:()=>t});var s=i(17624),d=i(4552);const l={sidebar_position:2},r=void 0,a={id:"frontend/Cell types/Markdown",title:"Markdown",description:"Type .md in the first line of an input cell",source:"@site/docs/frontend/Cell types/Markdown.md",sourceDirName:"frontend/Cell types",slug:"/frontend/Cell types/Markdown",permalink:"/frontend/Cell types/Markdown",draft:!1,unlisted:!1,tags:[],version:"current",lastUpdatedAt:1720209528e3,sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"tutorialSidebar",previous:{title:"Input cell",permalink:"/frontend/Cell types/Input cell"},next:{title:"HTML",permalink:"/frontend/Cell types/HTML"}},o={},t=[{value:"Markdown syntax",id:"markdown-syntax",level:2},{value:"Headings",id:"headings",level:3},{value:"Emphasis",id:"emphasis",level:3},{value:"Lists",id:"lists",level:3},{value:"Links",id:"links",level:3},{value:"Images",id:"images",level:3},{value:"Blockquotes",id:"blockquotes",level:3},{value:"Code",id:"code",level:3},{value:"Tables",id:"tables",level:3},{value:"Highlighter",id:"highlighter",level:3},{value:"Pure HTML",id:"pure-html",level:2},{value:"LaTeX",id:"latex",level:2},{value:"WLX",id:"wlx",level:2},{value:"Embed figures",id:"embed-figures",level:3},{value:"Autoupload",id:"autoupload",level:2},{value:"Drop a file",id:"drop-a-file",level:3},{value:"Paste media file",id:"paste-media-file",level:3}];function c(e){const n={a:"a",admonition:"admonition",blockquote:"blockquote",code:"code",h2:"h2",h3:"h3",img:"img",p:"p",pre:"pre",strong:"strong",...(0,d.M)(),...e.components};return(0,s.jsxs)(s.Fragment,{children:[(0,s.jsxs)(n.blockquote,{children:["\n",(0,s.jsxs)(n.p,{children:["Type ",(0,s.jsx)(n.code,{children:".md"})," in the first line of an input cell"]}),"\n"]}),"\n",(0,s.jsx)(n.p,{children:(0,s.jsx)(n.img,{src:i(83512).c+"",width:"1436",height:"658"})}),"\n",(0,s.jsx)(n.p,{children:(0,s.jsx)(n.img,{src:i(6332).c+"",width:"1436",height:"274"})}),"\n",(0,s.jsx)(n.h2,{id:"markdown-syntax",children:"Markdown syntax"}),"\n",(0,s.jsx)(n.h3,{id:"headings",children:"Headings"}),"\n",(0,s.jsxs)(n.p,{children:["Use ",(0,s.jsx)(n.code,{children:"#"})," for headings, increasing the number of ",(0,s.jsx)(n.code,{children:"#"})," for smaller headings:"]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-markdown",children:".md\n# Heading 1\n## Heading 2\n### Heading 3\n"})}),"\n",(0,s.jsx)(n.h3,{id:"emphasis",children:"Emphasis"}),"\n",(0,s.jsxs)(n.p,{children:["Use ",(0,s.jsx)(n.code,{children:"*"})," or ",(0,s.jsx)(n.code,{children:"_"})," for italics, and ",(0,s.jsx)(n.code,{children:"**"})," or ",(0,s.jsx)(n.code,{children:"__"})," for bold:"]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-markdown",children:".md\n*italic* or _italic_\n**bold** or __bold__\n"})}),"\n",(0,s.jsx)(n.h3,{id:"lists",children:"Lists"}),"\n",(0,s.jsxs)(n.p,{children:["Create unordered lists with ",(0,s.jsx)(n.code,{children:"*"}),", ",(0,s.jsx)(n.code,{children:"+"}),", or ",(0,s.jsx)(n.code,{children:"-"}),", and ordered lists with numbers followed by a period:"]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-markdown",children:".md\n\n- Item 1\n- Item 2\n  - Subitem 1\n\n1. First item\n2. Second item\n   1. Subitem 1\n"})}),"\n",(0,s.jsx)(n.h3,{id:"links",children:"Links"}),"\n",(0,s.jsxs)(n.p,{children:["Create links using ",(0,s.jsx)(n.code,{children:"[text](URL)"}),":"]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-markdown",children:".md\n[Tree](https://en.wikipedia.org/wiki/Tree)\n"})}),"\n",(0,s.jsx)(n.h3,{id:"images",children:"Images"}),"\n",(0,s.jsxs)(n.p,{children:["Embed images using ",(0,s.jsx)(n.code,{children:"![alt text](URL)"}),":"]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-markdown",children:".md\n![Tree](https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg)\n"})}),"\n",(0,s.jsx)(n.admonition,{type:"note",children:(0,s.jsxs)(n.p,{children:["Files can be remote or local (in the notebook folder). ",(0,s.jsx)(n.strong,{children:"Try to drag and drop any image inside markdown cell"})]})}),"\n",(0,s.jsx)(n.h3,{id:"blockquotes",children:"Blockquotes"}),"\n",(0,s.jsxs)(n.p,{children:["Create blockquotes using ",(0,s.jsx)(n.code,{children:">"}),":"]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-markdown",children:".md\n> This is a blockquote.\n"})}),"\n",(0,s.jsx)(n.h3,{id:"code",children:"Code"}),"\n",(0,s.jsx)(n.p,{children:"Inline code uses backticks, and code blocks are wrapped with triple backticks:"}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-markdown",children:".md\n\n`inline code`\n\n"})}),"\n",(0,s.jsx)(n.p,{children:"code block"}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{children:".md\n\n### Horizontal Rule\nCreate a horizontal rule with three or more dashes, asterisks, or underscores:\n\n```markdown\n---\n***\n___\n"})}),"\n",(0,s.jsx)(n.h3,{id:"tables",children:"Tables"}),"\n",(0,s.jsxs)(n.p,{children:["Create tables using pipes ",(0,s.jsx)(n.code,{children:"|"})," and dashes ",(0,s.jsx)(n.code,{children:"-"}),":"]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-markdown",children:".md\n\n| Header 1 | Header 2 |\n|----------|----------|\n| Cell 1   | Cell 2   |\n| Cell 3   | Cell 4   |\n"})}),"\n",(0,s.jsx)(n.h3,{id:"highlighter",children:"Highlighter"}),"\n",(0,s.jsxs)(n.p,{children:["Use ",(0,s.jsx)(n.code,{children:"=="})," wrapper to highlight text, i.e."]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-mathematica",children:".md\n==Hello World==\n"})}),"\n",(0,s.jsx)(n.h2,{id:"pure-html",children:"Pure HTML"}),"\n",(0,s.jsx)(n.p,{children:"One can also use plain HTML tags to stylize markdown or embed media objects"}),"\n",(0,s.jsx)(n.h2,{id:"latex",children:"LaTeX"}),"\n",(0,s.jsxs)(n.p,{children:["We use KaTeX as a render engine, to type a equation wrap it inside ",(0,s.jsx)(n.code,{children:"$"})," or ",(0,s.jsx)(n.code,{children:"$$"})," (for equation block)"]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-markdown",children:".md\n\n$$\nE = \\\\hbar \\\\omega\n$$\n"})}),"\n",(0,s.jsx)(n.admonition,{type:"warning",children:(0,s.jsxs)(n.p,{children:["Unfortunately, you have to escape all backslashes, i.e. instead of ",(0,s.jsx)(n.code,{children:"\\alpha"})," you need to write ",(0,s.jsx)(n.code,{children:"\\\\alpha"}),"."]})}),"\n",(0,s.jsx)(n.h2,{id:"wlx",children:"WLX"}),"\n",(0,s.jsxs)(n.p,{children:["Markdown cells supports features of ",(0,s.jsx)(n.a,{href:"/frontend/Cell%20types/WLX",children:"WLX"})," similar to how it is done in ",(0,s.jsx)(n.a,{href:"/frontend/Reference/Slides/",children:"Slides"})]}),"\n",(0,s.jsx)(n.h3,{id:"embed-figures",children:"Embed figures"}),"\n",(0,s.jsx)(n.h2,{id:"autoupload",children:"Autoupload"}),"\n",(0,s.jsx)(n.h3,{id:"drop-a-file",children:"Drop a file"}),"\n",(0,s.jsx)(n.h3,{id:"paste-media-file",children:"Paste media file"}),"\n",(0,s.jsxs)(n.p,{children:[(0,s.jsx)(n.strong,{children:(0,s.jsx)(n.a,{href:"https://github.com/JerryI/wljs-markdown-support",children:"Github repo"})}),"\nTo switch to Markdown language use ",(0,s.jsx)(n.code,{children:".md"})," prefix on the first line"]})]})}function h(e={}){const{wrapper:n}={...(0,d.M)(),...e.components};return n?(0,s.jsx)(n,{...e,children:(0,s.jsx)(c,{...e})}):c(e)}},6332:(e,n,i)=>{i.d(n,{c:()=>s});const s=i.p+"assets/images/Screenshot 2024-03-13 at 19.29.21-5e8444b770076c7b878a839fea05d474.png"},83512:(e,n,i)=>{i.d(n,{c:()=>s});const s=i.p+"assets/images/Screenshot 2024-03-13 at 19.29.44-bf410a3f91fa786c0f41c414714d5f1b.png"},4552:(e,n,i)=>{i.d(n,{I:()=>a,M:()=>r});var s=i(11504);const d={},l=s.createContext(d);function r(e){const n=s.useContext(l);return s.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function a(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(d):e.components||d:r(e.components),s.createElement(l.Provider,{value:n},e.children)}}}]);