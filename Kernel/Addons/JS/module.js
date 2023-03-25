function __isElement(element) {
    return element instanceof Element || element instanceof HTMLDocument;  
  }
  

class JSCell {
    scope = {}
    createScopedEval = (scope, script) => {return({
      ondestroy: function() {},
      result: Function(`${script}`)
    })}  
    
    dispose() {
      this.scope.ondestroy();
    }
    
    constructor(parent, data) {
      this.origin = parent;
      this.scope = this.createScopedEval({document, core}, data);
      
      const result = this.scope.result();
      if (__isElement(result)) {
        this.origin.element.appendChild(result);
        return this;
      }
      
      const editor = new EditorView({
        doc: String(result),
        extensions: [
          highlightSpecialChars(),
          rosePineDawn,
          EditorState.readOnly.of(true),
          javascript(),
          editorCustomTheme
        ],
        parent: this.origin.element
      });    
      
      return this;
    }
  }
  
  SupportedCellDisplays['js'] = JSCell;