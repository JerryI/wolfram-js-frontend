import { EditorView } from "codemirror";

import { StreamLanguage } from "@codemirror/language"
import { mathematica } from "@codemirror/legacy-modes/mode/mathematica"

import {indentWithTab} from "@codemirror/commands"

import {noctisLilac, smoothy} from 'thememirror'

import { MatchDecorator, WidgetType, keymap } from "@codemirror/view"

import {
  highlightSpecialChars, drawSelection, highlightActiveLine, dropCursor,
  rectangularSelection, crosshairCursor, placeholder,
  highlightActiveLineGutter
} from "@codemirror/view"
import { EditorState } from "@codemirror/state"
import { defaultHighlightStyle, syntaxHighlighting, indentOnInput, bracketMatching } from "@codemirror/language"
import { history, historyKeymap } from "@codemirror/commands"
import { highlightSelectionMatches } from "@codemirror/search"
import { autocompletion, closeBrackets } from "@codemirror/autocomplete"

import {
  Decoration,
  ViewPlugin
} from "@codemirror/view"

import {marked} from "marked"
import markedKatex from "marked-katex-extension"

const TexOptions = {
  throwOnError: false
};



marked.use(markedKatex(TexOptions));

const FEMatcher = new MatchDecorator({
  regexp: /FrontEndExecutable\["([^"]+)"\]/g,
  decoration: match => Decoration.replace({
    widget: new FEWidget(match[1]),
  })
});
const FEholders = ViewPlugin.fromClass(class {
  constructor(view) {
    this.FEholders = FEMatcher.createDeco(view);
  }
  update(update) {
    this.FEholders = FEMatcher.updateDeco(update, this.FEholders);
  }
}, {
  decorations: instance => instance.FEholders,
  provide: plugin => EditorView.atomicRanges.of(view => {
    var _a;
    return ((_a = view.plugin(plugin)) === null || _a === void 0 ? void 0 : _a.FEholders) || Decoration.none;
  })
});

class FEWidget extends WidgetType {
  constructor(name) {
    super();
    this.name = name;
  }
  eq(other) {
    return this.name === other.name;
  }
  toDOM() {
    let elt = document.createElement("div");
    elt.classList.add("frontend-object");
    elt.setAttribute('data-object', this.name);
    
    //can call async
    core.FrontEndExecutable(["'"+this.name+"'"], { element: elt });

    return elt;
  }
  ignoreEvent() {
    return false; 
  }
}

import { defaultKeymap } from "@codemirror/commands";

let editorCustomTheme = EditorView.theme({
  "&.cm-focused": {
    outline: "none"
  }
});


core.FrontEndRemoveCell = function (args, env) {
  var input = JSON.parse(interpretate(args[0]));
  if (input["type"] === 'input') {
    document.getElementById(input["id"]).parentNode.remove();
  } else {
    document.getElementById(`${input["id"]}---${input["type"]}`).remove();
  }
};

core.FrontEndMoveCell = function (args, env) {
  var template = interpretate(args[0]);
  var input = JSON.parse(interpretate(args[1]));

  const cell   = document.getElementById(`${input["cell"]["id"]}---output`);
  //make it different id, so it will not conflict
  cell.id = cell.id + '--old';
  const editor = cell.firstChild; 

  const parentcellwrapper = cell.parentNode.parentNode;

  parentcellwrapper.insertAdjacentHTML('afterend', template);
  document.getElementById(`${input["cell"]["id"]}---input`).appendChild(editor);
  cell.remove();

  attachToolbox(input["cell"], input["cell"]["id"]);

}; 

core.FrontEndMorphCell = function (args, env) {
  var input = JSON.parse(interpretate(args[0]));
  console.log(input);

  //not implemented
};

core.FrontEndClearStorage = function (args, env) {
  var input = JSON.parse(interpretate(args[0]));
  console.log(input);

  input["storage"].forEach(element => {
    delete $objetsstorage[element];
  });

  //not implemented
};

core.FrontEndCellError = function (args, env) {
  alert(interpretate(args[1]));
};

core.FrontEndTruncated = function (args, env) {
  env.element.innerHTML = interpretate(args[0]) + " ...";
}

core.FrontEndJSEval = function (args, env) {
  eval(interpretate(args[0]));
} 

core.FrontEndCreateCell = function (args, env) {
  var template = interpretate(args[0]);
  var input = JSON.parse(interpretate(args[1]));

  console.log(template);
  console.log(input);

  if (input["parent"] === "") {
    
    if (input["prev"] !== "") {
      document.getElementById(input["prev"]).parentNode.insertAdjacentHTML('afterend', template);
    } else {
      document.getElementById("frontend-contenteditable").insertAdjacentHTML('beforeend', template);
    }
    last = input["id"];
  } else {
    document.getElementById(input["parent"]).insertAdjacentHTML('beforeend', template);
  }

  var uid = input["id"];

  {
    let el = document.getElementById(input["id"]+"---"+input["type"]);

    switch(input["display"]) {
      case 'codemirror':
        createCodeMirror(el, uid, input["data"]);
        break;
      case 'markdown':
        el.innerHTML = marked.parse(input["data"]);
        break;
      case 'html':
        setInnerHTML(el, input["data"]);
        break;
    };

  }

  if (input["parent"] === "") {
    attachToolbox(input, uid);
  } 

};  

function attachToolbox(input, uid) {
  const body = document.getElementById(input["id"]).parentNode;
  const toolbox = body.getElementsByClassName('frontend-tools')[0];
  const hide    = body.getElementsByClassName('node-settings-hide')[0];
  const addafter   = body.getElementsByClassName('node-settings-add')[0];
  body.onmouseout  =  function(ev) {toolbox.classList.remove("tools-show")};
  body.onmouseover =  function(ev) {toolbox.classList.add("tools-show")}; 

  
  addafter.addEventListener("click", function (e) {
    addcellafter(uid);
  });

  hide.addEventListener("click", function (e) {
    if(document.getElementById(uid).getElementsByClassName('output-cell').length === 0) {
      alert('The are no output cells can be hidden');
      return;
    }
    document.getElementById(uid+"---input").classList.toggle("cell-hidden");
    const svg = hide.getElementsByTagName('svg');
      svg[0].classList.toggle("icon-hidden");
    socket.send(`CellObj["${uid}"]["props"] = Join[CellObj["${uid}"]["props"], <|"hidden"->!CellObj["${uid}"]["props"]["hidden"]|>]`);
  });
}

var editorLastCursor = 0;
var editorLastId = "null";
var forceFocusNext = false;

function createCodeMirror(element, uid, data) {
    const editor = new EditorView({
    doc: data,
    extensions: [
      highlightActiveLineGutter(),
      highlightSpecialChars(),
      history(),
      smoothy,
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
      highlightActiveLine(),
      highlightSelectionMatches(),
      StreamLanguage.define(mathematica),
      placeholder('Type Wolfram Expression / .md / .html / .js'),
      FEholders,
      keymap.of([indentWithTab,
        { key: "Backspace", run: function (editor, key) { if(editor.state.doc.length === 0) { socket.send(`NotebookOperate["${uid}", CellObjRemoveAccurate];`); }  } },
        { key: "ArrowUp", run: function (editor, key) {  editorLastId = uid; editorLastCursor = editor.state.selection.ranges[0].to;   } },
        { key: "ArrowDown", run: function (editor, key) { if(editorLastId === uid && editorLastCursor === editor.state.selection.ranges[0].to) { addcellafter(uid);  }; editorLastId = uid; editorLastCursor = editor.state.selection.ranges[0].to;   } },
        { key: "Shift-Enter", preventDefault: true, run: function (editor, key) { console.log(editor.state.doc.toString()); celleval(editor.state.doc.toString(), uid); } }, ...defaultKeymap, ...historyKeymap
      ]),
      EditorView.updateListener.of((v) => {
        if (v.docChanged) {
         
          socket.send(`CellObj["${uid}"]["data"] = "${v.state.doc.toString().replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"')}";`);
        }
      }),
      editorCustomTheme
    ],
    parent: element
  });

  if(forceFocusNext) editor.focus();
  forceFocusNext = false;
}

function addcellafter(id) {
  var q = 'NotebookOperate["'+id+'", CellObjCreateAfter]';
  forceFocusNext = true;
  socket.send(q);
}

function celleval(ne, cell) {
  console.log(ne);
  console.log(cell);   
  global = ne;
  var fixed = ne.replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"');
  console.log(fixed);

  var q = `CellObj["${cell}"]["data"]="${fixed}"; NotebookEvaluate["${cell}"]`;

  if($KernelStatus !== 'good' && $KernelStatus !== 'working') {
    alert("No active kernel is attached");
    return;
  }

  socket.send(q);
}





