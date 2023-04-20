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
      parent.element.classList.add('padding-fix');
      return this;
    }
  }
  
  SupportedCellDisplays['markdown'] = MarkdownCell;
  /*globalExtensions.push(keymap.of([{ key: "Ctrl-7", run: function() {
    return ({ state, dispatch }) => {
      if (state.readOnly) return false;
      let changes = state.changeByRange((range) => {
        let { from, to } = range;
        //if (atEof) from = to = (to <= line.to ? line : state.doc.lineAt(to)).to
  
        return {
          changes: { from, to, insert: ".md\n" },
          range: EditorSelection.cursor(from + 3)
        };
      });
  
      dispatch(
        state.update(changes, { scrollIntoView: true, userEvent: "input" })
      );
      return true;
    };    
  } }]));*/