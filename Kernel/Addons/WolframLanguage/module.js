import { EditorView } from "codemirror";

import {StreamLanguage } from "@codemirror/language"
import {language} from "@codemirror/language"

//import { mathematica } from "@codemirror/legacy-modes/mode/mathematica"
import { mathematica } from "./../JSLibs/mathematica/mathematica"

const wolframlanguage = StreamLanguage.define(mathematica)

import {javascriptLanguage, javascript } from "@codemirror/lang-javascript"

import {markdownLanguage, markdown} from "@codemirror/lang-markdown"

import {htmlLanguage, html} from "@codemirror/lang-html"

import {indentWithTab} from "@codemirror/commands" 

import {smoothy, rosePineDawn} from 'thememirror'
 
import { MatchDecorator, WidgetType, keymap } from "@codemirror/view"

import { mathematicaMath } from "./../JSLibs/sugar/sugar";

import {
  highlightSpecialChars, drawSelection, highlightActiveLine, dropCursor,
  rectangularSelection, crosshairCursor, placeholder,
  highlightActiveLineGutter
} from "@codemirror/view"

import { EditorState, Compartment } from "@codemirror/state"
import { syntaxHighlighting, indentOnInput, bracketMatching, defaultHighlightStyle } from "@codemirror/language"
import { history, historyKeymap } from "@codemirror/commands"
import { highlightSelectionMatches } from "@codemirror/search"
import { autocompletion, closeBrackets } from "@codemirror/autocomplete"

import {
  Decoration,
  ViewPlugin
} from "@codemirror/view"

var editorLastCursor = 0;
var editorLastId = "null";
var forceFocusNext = false;

const languageConf = new Compartment

const regLang = new RegExp('^\s*.(js|md|wsp|html|htm)');

function checkDocType(str) {
  const r = regLang.exec(str);
  if (r == null) return {type: 'mathematica', lang: wolframlanguage}
  switch(r[1]) {
    case 'js': 
      return {type: javascriptLanguage.name, lang: javascript()}; 
    case 'md':
      return {type: markdownLanguage.name, lang: markdown()};
    case 'html':
    case 'htm':
    case 'wsp':
      return {type: htmlLanguage.name, lang: html()};
  }
}

const autoLanguage = EditorState.transactionExtender.of(tr => {
  if (!tr.docChanged) return null
  let docType = checkDocType(tr.newDoc.sliceString(0, 5));

  if (docType.type == 'mathematica') {
 
    if (tr.startState.facet(language).constructor.name == 'StreamLanguage') return null;
    console.log('switching... to mathematica');
    return {
      effects: languageConf.reconfigure(docType.lang)
    }
  } else {
    console.log(tr.startState.facet(language));
    console.log(docType.type);
    console.log(docType.lang);
    if (docType.type == tr.startState.facet(language).name) return null;
    console.log('switching... to js html md');
    return {
      effects: languageConf.reconfigure(docType.lang)
    }
  }
})


const FEMatcher = (ref) => { return new MatchDecorator({
  regexp: /FrontEndExecutable\["([^"]+)"\]/g,
  decoration: match => Decoration.replace({
    widget: new FEWidget(match[1], ref),
  })
}) };

const FEholders = ViewPlugin.fromClass(class {
  constructor(view) {
    this.disposable = [];
    this.FEholders = FEMatcher(this.disposable).createDeco(view);
    
  }
  update(update) {
    this.FEholders = FEMatcher(this.disposable).updateDeco(update, this.FEholders);
  }
  destroy() {
    console.log('removed holder');
    console.log('disposable');
    console.log(this.disposable);
    this.disposable.forEach((el)=>{
        el.dispose();
    });
  }
}, {
  decorations: instance => instance.FEholders,
  provide: plugin => EditorView.atomicRanges.of(view => {
    var _a;
    return ((_a = view.plugin(plugin)) === null || _a === void 0 ? void 0 : _a.FEholders) || Decoration.none;
  })
});

class FEWidget extends WidgetType {
  constructor(name, ref) {
    super();
    this.ref = ref;
    this.name = name;
  }
  eq(other) {
    return this.name === other.name;
  }
  toDOM() {
    let elt = document.createElement("div");
    elt.classList.add("frontend-object");
    elt.setAttribute('data-object', this.name);
    
    //callid
    const cuid = Date.now() + Math.floor(Math.random() * 100);
    var global = {call: cuid};
    let env = {global: global, element: elt}; //Created in CM6
    console.log("CM6: creating an object with key "+this.name);
    this.fobj = new ExecutableObject(this.name, env);
    this.fobj.execute()     

    this.ref.push(this.fobj);

    return elt;
  }
  ignoreEvent() {
    return true; 
  }
  destroy() {
    console.log('widget got destroyed!');
    this.fobj.dispose();
  }
}

import { defaultKeymap } from "@codemirror/commands";

let editorCustomTheme = EditorView.theme({
  "&.cm-focused": {
    outline: "none"
  },
  "&.cm-line": {
    padding: 0
  },
  ".cm-line": {
    padding: 0
  }
});

class CodeMirrorCell {
    origin = {}
    editor = {}
    trash = []
  
    addDisposable(el) {
      this.trash.push(el);
    }
    
    dispose() {
      this.editor.destroy();
    }
    
    constructor(parent, data) {
      this.origin = parent;
      const origin = this.origin;
      
      const initialLang = checkDocType(data).lang;
      console.log('language: ');
      console.log(initialLang);
      const editor = new EditorView({
        doc: data,
        extensions: [
          highlightActiveLineGutter(),
          highlightSpecialChars(),
          history(),
          drawSelection(),
          dropCursor(),
          EditorState.allowMultipleSelections.of(true),
          indentOnInput(),
          bracketMatching(),
          closeBrackets(),
          EditorView.lineWrapping,
          autocompletion(),
          rectangularSelection(),
          crosshairCursor(),
          syntaxHighlighting(defaultHighlightStyle, { fallback: true }),
          highlightActiveLine(),
          highlightSelectionMatches(),
          placeholder('Type Wolfram Expression / .md / .html / .js'),
          FEholders,
          Greekholder,
          languageConf.of(initialLang),
          autoLanguage, 
          mathematicaMath(),
          keymap.of([indentWithTab,
            { key: "Backspace", run: function (editor, key) { if(editor.state.doc.length === 0) { origin.remove() }  } },
            { key: "ArrowUp", run: function (editor, key) {  editorLastId = origin.uid; editorLastCursor = editor.state.selection.ranges[0].to;   } },
            { key: "ArrowDown", run: function (editor, key) { if(editorLastId === origin.uid && editorLastCursor === editor.state.selection.ranges[0].to) { origin.addCellAfter();  }; editorLastId = origin.uid; editorLastCursor = editor.state.selection.ranges[0].to;   } },
            { key: "Shift-Enter", preventDefault: true, run: function (editor, key) { console.log(editor.state.doc.toString()); origin.eval(editor.state.doc.toString()) } }, ...defaultKeymap, ...historyKeymap
          ]),
          
          EditorView.updateListener.of((v) => {
            if (v.docChanged) {
              origin.save(v.state.doc.toString().replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"'));
            }
          }),
            editorCustomTheme
        ],
        parent: this.origin.element
      });
      
      this.editor = editor;
  
      if(forceFocusNext) editor.focus();
      forceFocusNext = false;    
      
      return this;
    }
  }
  
  SupportedCellDisplays['codemirror'] = CodeMirrorCell;