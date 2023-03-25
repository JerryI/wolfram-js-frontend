class HTMLCell {
    dispose() {
      
    }
    
    constructor(parent, data) {
      setInnerHTML(parent.element, data);
      return this;
    }
  }
  
  SupportedCellDisplays['html'] = HTMLCell;