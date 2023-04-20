import {
  EditorView,
  Decoration,
  ViewPlugin,
  WidgetType,
  MatchDecorator
} from "@codemirror/view";
import { isCursorInside } from "./utils";

import { BallancedMatchDecorator } from "./matcher";

import { keymap } from "@codemirror/view";
 
import { EditorSelection } from "@codemirror/state";

var subEditor; 

export function subscriptWidget(view) {
  subEditor = view;
  return [
    //mathematicaMathDecoration,
    placeholder,
    keymap.of([{ key: "Ctrl--", run: snippet() }])
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
          changes: { from, to, insert: "Subscript[_,_]" },
          range: EditorSelection.cursor(from)
        };
      }
      return {
        changes: { from, to, insert: "Subscript[" + prev + ", _]" },
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
  constructor(visibleValue, ref) {
    super();
    this.visibleValue = visibleValue;
    this.ref = ref;
    this.subEditor = subEditor;
  }
  eq(other) {
    return this.visibleValue.str === other.visibleValue.str;
  }
  toDOM() {
    let span = document.createElement("span");

    if (this.visibleValue.args.length !== 2) {
      this.visibleValue.args = ["_", "_"];
      console.error("argumets doesnt match");
    }

    const args = this.visibleValue.args;

    const head = document.createElement("span");
    head.classList.add("subscript-tail");

    this.subEditor({
      doc: args[0],
      parent: head
    });

    const sub = document.createElement("sub");
    sub.classList.add("subscript-tail");

    //console.log("bottom string: " + bottomstring);
    this.subEditor({
      doc: args[1],
      parent: sub
    });

    span.appendChild(head);
    span.appendChild(sub);

    //span.classList.add("cm-bold");*/
    return span;
  }

  ignoreEvent() {
    return true;
  }
}

const matcher = (ref) => {
  return new BallancedMatchDecorator({
    regexp: /Subscript\[/,
    decoration: (match) => {
      return Decoration.replace({
        widget: new Widget(match, ref)
      });
    }
  });
};

const placeholder = ViewPlugin.fromClass(
  class {
    constructor(view) {
      this.disposable = [];
      this.placeholder = matcher(this.disposable).createDeco(view);
    }
    update(update) {
      this.placeholder = matcher(this.disposable).updateDeco(
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
