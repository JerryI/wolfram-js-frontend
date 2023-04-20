class HTMLCell {
    dispose() {
      
    }
    
    constructor(parent, data) {
      setInnerHTML(parent.element, data);
      parent.element.classList.add('padding-fix');
      return this;
    }
  }
  
  SupportedCellDisplays['html'] = HTMLCell;