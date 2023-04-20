

let mermaidDiagrams = false;

class MermaidCell {
  dispose() {
    
  }
  
  constructor(parent, data) {
    let elt = document.createElement("div");
    const uid = parent.uid;
    
    elt.classList.add("frontend-object");
    parent.element.appendChild(elt);
    parent.element.classList.add('padding-fix');
  
    let cotainer = document.createElement("div");
    cotainer.style.width = "80vw";

    if (!mermaidDiagrams) {
      import("mermaid").then(({ default: mermaid }) => {
        mermaidDiagrams = mermaid;
        mermaidDiagrams.initialize({ startOnLoad: false });
        mermaidDiagrams.render('mermaid-'+uid, data).then((data)=>{
          const {svg, bindFunctions} = data;
          cotainer.innerHTML = svg;
        });  
      });
    
    } else {
      mermaidDiagrams.render('mermaid-'+uid, data).then((data)=>{
        const {svg, bindFunctions} = data;
        cotainer.innerHTML = svg;
      });
    }
  
    elt.appendChild(cotainer);
    
    return this;
  }
}

SupportedCellDisplays['mermaid'] = MermaidCell;