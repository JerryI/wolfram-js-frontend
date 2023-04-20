let svgbob = false;

class SVGBobCell {
  dispose() {
    
  }
  
  constructor(parent, data) {
    let elt = document.createElement("div");
  
    elt.classList.add("frontend-object");
    parent.element.appendChild(elt);
    parent.element.classList.add('padding-fix');
  
    let container = document.createElement("div");
    container.classList.add('svgbob-object');

    if (!svgbob) {
      import('bob-wasm').then(({ default: bob }) => {
        svgbob = bob;
        svgbob.loadWASM().then(()=>{
          container.innerHTML = svgbob.render ( data ).replace(/(<style>(.|$|^|\n)+<\/style>)/, '');
        });        
      })

    
    } else {
      container.innerHTML = svgbob.render ( data ).replace(/(<style>(.|$|^|\n)+<\/style>)/, '');
    }

    elt.appendChild(container);
    
    return this;
  }
}

SupportedCellDisplays['svgbob'] = SVGBobCell;