class ImageCell {
    dispose() {
      
    }
    
    constructor(parent, data) {
      let elt = document.createElement("div");
    
      elt.classList.add("frontend-object");
      parent.element.appendChild(elt);  
  
      let img = document.createElement("img");
      img.style.width = "80vw";
      img.src = data;
      elt.appendChild(img);  
      
      return this;
    }
  }
  
SupportedCellDisplays['image'] = ImageCell;


class FileOutputCell {
    dispose() {
      
    }
    
    constructor(parent, data) {
      const editor = new EditorView({
        doc: data,
        extensions: [
          EditorState.readOnly.of(true),
          syntaxHighlighting(defaultHighlightStyle, { fallback: true }),
          editorCustomTheme
        ],
        parent: parent.element
      }); 
      
      return this;
    }
  }
  
  SupportedCellDisplays['fileprint'] = FileOutputCell;