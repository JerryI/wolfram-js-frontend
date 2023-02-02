import { EditorView } from "codemirror";

import { StreamLanguage } from "@codemirror/language"
import { mathematica } from "@codemirror/legacy-modes/mode/mathematica"

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

  $objetsstorage = Object.assign({}, $objetsstorage, input["storage"]);


  if (input["parent"] === "") {
    if (input["prev"] !== "") {
      document.getElementById(input["prev"]).parentNode.insertAdjacentHTML('afterend', template);
    } else {
      document.getElementById(input["sign"]).parentNode.insertAdjacentHTML('afterend', template);
    }
    last = input["id"];
  } else {
    document.getElementById(input["parent"]).insertAdjacentHTML('beforeend', template);
  }

  var notebook = input["sign"];
  var uid = input["id"];

  new EditorView({
    doc: input["data"],
    extensions: [
      highlightActiveLineGutter(),
      highlightSpecialChars(),
      history(),
      drawSelection(),
      dropCursor(),
      EditorState.allowMultipleSelections.of(true),
      indentOnInput(),
      syntaxHighlighting(defaultHighlightStyle, { fallback: true }),
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
        { key: "Shift-Enter", preventDefault: true, run: function (editor, key) { console.log(editor.state.doc.toString()); celleval(editor.state.doc.toString(), notebook, uid); } }, ...defaultKeymap, ...historyKeymap
      ]),
      EditorView.updateListener.of((v) => {
        if (v.docChanged) {
          console.log(v.state.doc.toString());
          socket.send(`CellObj["${uid}"]["data"] = "${v.state.doc.toString().replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"')}";`);
        }
      })
    ],
    parent: document.getElementById(input["id"]+"---"+input["type"])
  });

};  

var notebookkernel = false;

core.FrontEndAddKernel = function(args, env) {
  document.getElementById('kernel-status').classList.add('btn-info');
  notebookkernel = true;
}

function celleval(ne, id, cell) {
  console.log(ne);
  global = ne;
  var fixed = ne.replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"');
  console.log(fixed);

  var q = `CellObj["${cell}"]["data"]="${fixed}"; NotebookEvaluate["${id}", "${cell}"]`;
  if(!notebookkernel) {
    alert("no kernel was attached");
    return;
  }

  socket.send(q);
}





