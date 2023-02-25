import { EditorView } from "codemirror";

import { StreamLanguage } from "@codemirror/language"
import { mathematica } from "@codemirror/legacy-modes/mode/mathematica"

import {noctisLilac, smoothy} from 'thememirror'

import { MatchDecorator, WidgetType, keymap } from "@codemirror/view"

import {
  highlightSpecialChars, drawSelection, highlightActiveLine, dropCursor,
  rectangularSelection, crosshairCursor,
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
    document.getElementById(input["id"]).parentNode.remove();
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


  new EditorView({
    doc: input["data"],
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
      placeholders,
      keymap.of([
        { key: "Backspace", run: function (editor, key) { if(editor.state.doc.length === 0) { socket.send(`NotebookOperate["${uid}", CellObjRemoveFull];`); }  } },
        { key: "ArrowUp", run: function (editor, key) {  editorLastId = uid; editorLastCursor = editor.state.selection.ranges[0].to;   } },
        { key: "ArrowDown", run: function (editor, key) { if(editorLastId === uid && editorLastCursor === editor.state.selection.ranges[0].to) { AddCell(uid);  }; editorLastId = uid; editorLastCursor = editor.state.selection.ranges[0].to;   } },
        { key: "Shift-Enter", preventDefault: true, run: function (editor, key) { console.log(editor.state.doc.toString()); celleval(editor.state.doc.toString(), uid); } }, ...defaultKeymap, ...historyKeymap
      ]),
      EditorView.updateListener.of((v) => {
        if (v.docChanged) {
         
          socket.send(`CellObj["${uid}"]["data"] = "${v.state.doc.toString().replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"')}";`);
        }
      }),
      editorCustomTheme
    ],
    parent: document.getElementById(input["id"]+"---"+input["type"])
  });

  if (input["parent"] === "") {
    const body = document.getElementById(input["id"]).parentNode;
    const toolbox = body.getElementsByClassName('frontend-tools')[0];
    const drag    = body.getElementsByClassName('node-settings-drag')[0];
    body.onmouseout  =  function(ev) {toolbox.classList.toggle("tools-show")};
    body.onmouseover =  function(ev) {toolbox.classList.toggle("tools-show")}; 
    drag.addEventListener("click", function (e) {
      document.getElementById(uid+"---input").classList.toggle("cell-hidden");
      const path = drag.getElementsByTagName('path');
        path[0].classList.toggle("path-hidden");
        path[1].classList.toggle("path-hidden");
        path[2].classList.toggle("path-hidden");
      socket.send(`CellObj["${uid}"]["props"] = Join[CellObj["${uid}"]["props"], <|"hidden"->!CellObj["${uid}"]["props"]["hidden"]|>]`);
    });
  } 

};  


var notebookkernel = false;

core.FrontEndAddKernel = function(args, env) {
  document.getElementById('kernel-status').classList.add('btn-info');
  notebookkernel = true;
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