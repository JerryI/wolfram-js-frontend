import { EditorView } from "codemirror";

import { StreamLanguage } from "@codemirror/language"
import { mathematica } from "@codemirror/legacy-modes/mode/mathematica"

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

const placeholderMatcher = new MatchDecorator({
  regexp: /FrontEndExecutable\["([^"]+)"\]/g,
  decoration: match => Decoration.replace({
    widget: new PlaceholderWidget(match[1]),
  })
});
const placeholders = ViewPlugin.fromClass(class {
  constructor(view) {
    this.placeholders = placeholderMatcher.createDeco(view);
  }
  update(update) {
    this.placeholders = placeholderMatcher.updateDeco(update, this.placeholders);
  }
}, {
  decorations: instance => instance.placeholders,
  provide: plugin => EditorView.atomicRanges.of(view => {
    var _a;
    return ((_a = view.plugin(plugin)) === null || _a === void 0 ? void 0 : _a.placeholders) || Decoration.none;
  })
});
class PlaceholderWidget extends WidgetType {
  constructor(name) {
    super();
    this.name = name;
  }
  eq(other) {
    return this.name === other.name;
  }
  toDOM() {
    let elt = document.createElement("span");
    elt.style.cssText = `
              border: 1px solid rgb(200, 200, 200);
              border-radius: 4px;
              padding: 0 3px;
              display:inline-block;
              `;

    interpretate(JSON.parse($objetsstorage[this.name]), { element: elt });

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


var $objetsstorage = {};


core.FrontEndRemoveCell = function (args, env) {
  var input = JSON.parse(interpretate(args[0]));
  if (input["parent"] === "") {
    document.getElementById(input["id"]).parentNode.parentNode.remove();
  } else {
    document.getElementById(`${input["id"]}---${input["type"]}`).remove();
  }
};

core.FrontEndMoveCell = function (args, env) {
  var template = interpretate(args[0]);
  var input = JSON.parse(interpretate(args[1]));

  //document.getElementById(input["cell"]["id"]+"---"+input["cell"]["type"]).remove();
  const cell   = document.getElementById(`${input["cell"]["id"]}---output`);
  //make it different id, so it will not conflict
  cell.id = cell.id + '--old';

  const editor = cell.firstChild; 
  const parentcellwrapper = cell.parentNode.parentNode;

  console.log(parentcellwrapper);
  console.log(cell);
  console.log(editor);

  parentcellwrapper.insertAdjacentHTML('afterend', template);
  console.log(document.getElementById(`${input["cell"]["id"]}---input`));
  document.getElementById(`${input["cell"]["id"]}---input`).appendChild(editor);
  cell.remove();

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

var temp0;
var editorLastCursor = 0;
var editorLastId = "null";
var forceFocusNext = false;

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
      case 'wsp':
        setInnerHTML(el, input["data"]);
        break;
    };

  }

  if (input["parent"] === "") {
    const body = document.getElementById(input["id"]).parentNode;
    const toolbox = body.getElementsByClassName('frontend-tools')[0];
    const hide    = body.getElementsByClassName('node-settings-hide')[0];
    const addafter   = body.getElementsByClassName('node-settings-add')[0];
    body.onmouseout  =  function(ev) {toolbox.classList.toggle("tools-show")};
    body.onmouseover =  function(ev) {toolbox.classList.toggle("tools-show")}; 

    
    addafter.addEventListener("click", function (e) {
      addcellafter(uid);
    });

    hide.addEventListener("click", function (e) {
      document.getElementById(uid+"---input").classList.toggle("cell-hidden");
      const svg = hide.getElementsByTagName('svg');
        svg[0].classList.toggle("icon-hidden");
      socket.send(`CellObj["${uid}"]["props"] = Join[CellObj["${uid}"]["props"], <|"hidden"->!CellObj["${uid}"]["props"]["hidden"]|>]`);
    });
  } 

};  


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
      placeholders,
      keymap.of([
        { key: "Backspace", run: function (editor, key) { if(editor.state.doc.length === 0) { socket.send(`NotebookOperate["${uid}", CellObjRemove];`); }  } },
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






    
core.WListPloty = function(args, env) {
    const arr = JSON.parse(interpretate(args[0]));
    console.log("Ploty.js");
    console.log(arr);
    let newarr = [];
    arr.forEach(element => {
        newarr.push({x: element[0], y: element[1]});
    });
    Plotly.newPlot(env.element, newarr, {autosize: false, width: 500, height: 300, margin: {
        l: 30,
        r: 30,
        b: 30,
        t: 30,
        pad: 4
      }});
  }  
  
  core.WListContourPloty = function(args, env) {
    const data = interpretate(args[0], env);
    Plotly.newPlot(env.element, [{z:data[2], x:data[0], y:data[1], type: 'contour'}],
    {autosize: false, width: 500, height: 300, margin: {
      l: 30,
      r: 30,
      b: 30,
      t: 30,
      pad: 4
    }});
  
  } 

core.HTMLForm = function (args, env) {
    setInnerHTML(env.element, interpretate(args[0]));
}