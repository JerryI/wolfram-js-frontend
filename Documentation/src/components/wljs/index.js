import React, { useEffect, useRef } from 'react';

import ExecutionEnvironment from '@docusaurus/ExecutionEnvironment';
import { interpolate } from '@docusaurus/Interpolate';
import useIsBrowser from '@docusaurus/useIsBrowser';

//import { Mma } from 'mma-uncompress/src/mma.js';

export default function Wl({children, data}) {
    const ref = useRef(null);
    
    useEffect( () => {

    
      console.warn('Loading component...');
      const element = ref.current;
      let elt = document.createElement("div");
      elt.classList.add("frontend-object");
      elt.setAttribute('data-object', "loading...");
      element.appendChild(elt);
      
      //callid
      const cuid = Date.now() + Math.floor(Math.random() * 100);
      var global = {call: cuid};
  
      let env = {global: global, element: elt}; //Created in CM6
      console.warn('decrypting...');

      try {
        //let decoded = Mma.DecompressDecode(data);
        //decoded = Mma.toArray(decoded.parts[0]);
        let decoded = JSON.parse(atob(data));
        console.log(decoded);
        
        //const decoded = atob(data);

        interpretate(['FrontEndVirtual', decoded], env);
      } catch(error) {
        console.warn('Error!');
        console.warn(error);
      }
      
      /*
      console.log('decoded!');
      console.log(json);
      
  
      //this.ref.push(this.fobj);
  
      */

    }, []);

    return (
        <main id="frontend-editor" className="main-container styles-container-editor">
            <div id="frontend-editor-content" className="group-container" >
                <div ref={ref}></div>
            </div>
        </main>
    )
}


