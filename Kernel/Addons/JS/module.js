function __isElement(element) {
    return element instanceof Element || element instanceof HTMLDocument;  
  }
  
class ScopedEval {
  ondestroy = function() {}
  error  = false
    
  constructor(scope, script) {
    this.script = '(() => {'+ script + '})()';
  }
    
  eval() {
    try {
      return eval(this.script);
    } catch(err) {
      this.error = err;
    }
  }
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
      this.scope = new ScopedEval({}, data)
      
      const result = this.scope.eval();

      if (this.scope.error) {
        const errorDiv = document.createElement('div');
        errorDiv.innerText = this.scope.error;
        errorDiv.classList.add('err-js');
        this.origin.element.appendChild(errorDiv);
        return this;
      }

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