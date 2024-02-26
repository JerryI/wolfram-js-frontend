import React, { useEffect, useRef } from 'react';


import JSONCrush from 'jsoncrush';


export default function Sandbox({children, code, width, height}) {
  const ref = useRef();


  const r = JSON.parse(JSONCrush.uncrush(decodeURIComponent(code)));
  const JS = r.js;
  const WL = r.compiled; 
  const includes = r.includes || [];

  const inc = includes.map((e)=>`<script type="module" src="${e}"></script>`).join('');


  const srcdoc = `<html>
  <head>  

    <script>             
    function isElement(o){
      return (
        typeof HTMLElement === "object" ? o instanceof HTMLElement : //DOM2
        o && typeof o === "object" && o !== null && o.nodeType === 1 && typeof o.nodeName==="string"
    );
    }
    </script>
 
  </head>
  <body>
    <div id="canvas" style="text-align:center"></div>

    
    <script type="module" src="https://cdn.jsdelivr.net/gh/JerryI/wljs-interpreter@main/dist/interpreter.js"></script>
    <script type="module" src="https://cdn.jsdelivr.net/gh/JerryI/wljs-interpreter@main/dist/core.js"></script>

    ${inc}
    

    <script type="module">
    console.log('start');
      let global = {};
      let env = {global: global};


        const $f = async () => {
          ${JS}
        };

        const r = await $f();

        console.log('js');

        if (isElement(r)) {
          document.getElementById('canvas').appendChild(r);
        } else {
          console.log(r);
        }
        console.log('op');
        await interpretate(${JSON.stringify(WL)}, env);
        console.log('ok');


    </script>
  </body>
  </html>`;

  return (
    <iframe width={width || "100%"} height={height || "auto"} srcDoc={srcdoc}></iframe>
  )

}


