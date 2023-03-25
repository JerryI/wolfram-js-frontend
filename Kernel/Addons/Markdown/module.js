import {marked} from "marked"
import markedKatex from "marked-katex-extension"


const TexOptions = {
  throwOnError: false
};


marked.use(markedKatex(TexOptions));


class MarkdownCell {
    origin = {}
    
    dispose() {
      
    }
    
    constructor(parent, data) {
      parent.element.innerHTML = marked.parse(data);
      return this;
    }
  }
  
  SupportedCellDisplays['markdown'] = MarkdownCell;