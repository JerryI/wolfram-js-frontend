import { EditorView } from "codemirror";

import {language} from "@codemirror/language"

//import { mathematica } from "@codemirror/legacy-modes/mode/mathematica"


import {javascriptLanguage, javascript } from "@codemirror/lang-javascript"

import {markdownLanguage, markdown} from "@codemirror/lang-markdown"

import {htmlLanguage, html} from "@codemirror/lang-html"

import {indentWithTab} from "@codemirror/commands" 
 
import { MatchDecorator, WidgetType, keymap } from "@codemirror/view"

/*import { phraseEmphasis } from './../JSLibs/markword/phraseEmphasis';
import { heading, headingRE } from './../JSLibs/markword/heading';
import { wordmarkTheme } from './../JSLibs/markword/wordmarkTheme';
import { link } from './../JSLibs/markword/link';
import { listTask } from './../JSLibs/markword/listTask';
import { image } from './../JSLibs/markword/image';
import { blockquote } from './../JSLibs/markword/blockquote';
import { codeblock } from './../JSLibs/markword/codeblock';
import { webkitPlugins } from './../JSLibs/markword/webkit';

import { frontMatter } from './../JSLibs/markword/frontMatter';*/

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

import { wolframLanguage } from "./../JSLibs/mathematica/mathematica"
import { Arrowholder, Greekholder } from "./../JSLibs/sugar/misc"
import { subscriptWidget } from "./../JSLibs/sugar/subscript"
import { cellTypesHighlight } from "./../JSLibs/sugar/cells"

var editorLastCursor = 0;
var editorLastId = "null";
var forceFocusNext = false;

const languageConf = new Compartment

let globalExtensions = []

const regLang = new RegExp('^\s*.(js|md|wsp|html|htm)');

const markdownPlugins = [
  markdown(),
  /*wordmarkTheme(),
  markdown(),
  listTask(),
  phraseEmphasis(),
  heading(),
  link(),
  image(),
  blockquote(),
  codeblock(),
  frontMatter()*/
]

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

let compactWLEditor = null;

compactWLEditor = (args) => new EditorView({
  doc: args.doc,
  extensions: [
    highlightSpecialChars(),
    drawSelection(),
    dropCursor(),
    indentOnInput(),
    bracketMatching(),
    closeBrackets(),
    syntaxHighlighting(defaultHighlightStyle, { fallback: true }),
    highlightSelectionMatches(),
    wolframLanguage, 
    FEholders, 
    Greekholder, 
    Arrowholder, 
    subscriptWidget(compactWLEditor),
    
    EditorView.updateListener.of((v) => {
      if (v.docChanged) {
        //v.state.doc.toString()
      }
    }),
      editorCustomTheme
  ],
  parent: args.parent
});

const mathematicaPlugins = [
  wolframLanguage, 
  FEholders, 
  Greekholder, 
  Arrowholder, 
  subscriptWidget(compactWLEditor)
]

function checkDocType(str) {
  const r = regLang.exec(str);
  if (r == null) return {type: 'mathematica', lang: mathematicaPlugins}
  switch(r[1]) {
    case 'js': 
      return {type: javascriptLanguage.name, lang: javascript()}; 
    case 'md':
      return {type: markdownLanguage.name, lang: markdownPlugins};
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

import { defaultKeymap } from "@codemirror/commands";

let editorCustomTheme = EditorView.theme({
  "&.cm-focused": {
    outline: "none",
    background: 'inherit'
  },
  ".cm-line": {
    padding: 0,
    'padding-left': '2px',
    'align-items': 'center'
  },
  ".cm-activeLine": {
    'background-color': 'transparent'
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
          highlightSpecialChars(),
          history(),
          drawSelection(),
          dropCursor(),
          indentOnInput(),
          bracketMatching(),
          closeBrackets(),
          EditorView.lineWrapping,
          autocompletion(),
          syntaxHighlighting(defaultHighlightStyle, { fallback: true }),
          highlightSelectionMatches(),
          cellTypesHighlight,
          placeholder('Type Wolfram Expression / .md / .html / .js'),
          languageConf.of(initialLang),
          autoLanguage, 
          keymap.of([indentWithTab,
            { key: "Backspace", run: function (editor, key) { 
              if(editor.state.doc.length === 0) { origin.remove() }  
            } },
            { key: "ArrowLeft", run: function (editor, key) {  
              editor.editorLastCursor = editor.state.selection.ranges[0].to;  
            } },   
            { key: "ArrowRight", run: function (editor, key) {  
              editor.editorLastCursor = editor.state.selection.ranges[0].to;  
            } },                      
            { key: "ArrowUp", run: function (editor, key) {  
              console.log('arrowup');
              console.log(editor.state);
              if (editor?.editorLastCursor === editor.state.selection.ranges[0].to)
                origin.focusPrev(origin);

              editor.editorLastCursor = editor.state.selection.ranges[0].to;  
            } },
            { key: "ArrowDown", run: function (editor, key) { 
              console.log('arrowdown');
              console.log(editor.state);
              if (editor?.editorLastCursor === editor.state.selection.ranges[0].to)
                origin.focusNext(origin);

              editor.editorLastCursor = editor.state.selection.ranges[0].to;  
            } },
            { key: "Shift-Enter", preventDefault: true, run: function (editor, key) { 
              console.log(editor.state.doc.toString()); 
              origin.eval(editor.state.doc.toString()) 
            } }
            , ...defaultKeymap, ...historyKeymap
          ]),
          globalExtensions,
          
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