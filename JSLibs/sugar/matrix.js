import {
  EditorView,
  Decoration,
  ViewPlugin,
  WidgetType,
  MatchDecorator
} from "@codemirror/view";
import { isCursorInside } from "./utils";

import { BallancedMatchDecorator } from "./matcher";

import { ListMatch } from "./listmatcher"; 

import { keymap } from "@codemirror/view";
 
import { EditorSelection } from "@codemirror/state";

var subEditor; 

export function matrixWidget(view) {
  subEditor = view;
  return [
    //mathematicaMathDecoration,
    placeholder,
    keymap.of([{ key: "Ctrl-m", run: snippet() }])
  ];
}

function snippet() {
  return ({ state, dispatch }) => {
    if (state.readOnly) return false;
    let changes = state.changeByRange((range) => {
      let { from, to } = range;
      //if (atEof) from = to = (to <= line.to ? line : state.doc.lineAt(to)).to
      const prev = state.sliceDoc(from, to);
      if (prev.length === 0) {
        return {
          changes: { from, to, insert: "CM6Grid[{{_,_},{_,_}}]" },
          range: EditorSelection.cursor(from)
        };
      }
      return {
        changes: { from, to, insert: "CM6Grid[" + prev + "]" },
        range: EditorSelection.cursor(from)
      };
    });

    dispatch(
      state.update(changes, { scrollIntoView: true, userEvent: "input" })
    );
    return true;
  };
}

class Widget extends WidgetType {
  constructor(visibleValue, ref, view) {
    super();
    this.view = view;
    this.visibleValue = visibleValue;
    this.ref = ref;
    this.subEditor = subEditor;
  }
  eq(other) {
    console.log('compare');
    console.log(this.visibleValue.str === other.visibleValue.str)
    return this.visibleValue.str === other.visibleValue.str;
  }
  updateDOM(dom, view) {
    console.log('update widget DOM');
    return true
  }
  toDOM(view) {
    let span = document.createElement("span");
    span.classList.add('matrix');

    const table      = document.createElement("table");
    table.classList.add('container');
    span.appendChild(table);
    
    const tbody      = document.createElement("tbody");
    table.appendChild(tbody);

    const visibleValue = this.visibleValue;

    const recreateString = (args) => {
      const f = args.map((e)=>e.join(','));
      this.visibleValue.str =  'CM6Grid[{{'+f.join('},{')+'}}]';

      const changes = {from: visibleValue.pos, to: visibleValue.pos + visibleValue.length, insert: this.visibleValue.str};
      this.visibleValue.length = this.visibleValue.str.length;

      return changes;
    }

    console.log('create widget DOM!!!!');
    const rows = ListMatch(this.visibleValue.str);

    this.args = [];

    for (let i = 0; i < rows.length; ++i) {

      const tr        = document.createElement("tr");
      const cols = ListMatch(rows[i]);
      this.args.push([]);

      for (let j = 0; j < cols.length; ++j) {
        const td = document.createElement("td");
        this.args[i].push(cols[j]);

        this.subEditor({
          doc: cols[j],
          parent: td,
          update: (upd) => {
            this.args[i][j] = upd;

            const change = recreateString(this.args);
            console.log('insert change');
            console.log(change);
            view.dispatch({changes: change});
          }
        });

        tr.appendChild(td);
      }
      tbody.appendChild(tr);
    }
    
    return span;
  }

  ignoreEvent() {
    return true;
  }
}

const matcher = (ref, view) => {
  return new BallancedMatchDecorator({
    regexp: /CM6Grid\[/,
    decoration: (match) => {
      return Decoration.replace({
        widget: new Widget(match, ref, view)
      });
    }
  });
};

const placeholder = ViewPlugin.fromClass(
  class {
    constructor(view) {
      this.disposable = [];
      this.placeholder = matcher(this.disposable, view).createDeco(view);
    }
    update(update) {
      this.placeholder = matcher(this.disposable, update).updateDeco(
        update,
        this.placeholder
      );
    }
    destroy() {
      console.log("removed holder");
      console.log("disposable");
      console.log(this.disposable);
      this.disposable.forEach((el) => {
        el.dispose();
      });
    }
  },
  {
    decorations: (instance) => instance.placeholder,
    provide: (plugin) =>
      EditorView.atomicRanges.of((view) => {
        var _a;
        return (
          ((_a = view.plugin(plugin)) === null || _a === void 0
            ? void 0
            : _a.placeholder) || Decoration.none
        );
      })
  }
);
