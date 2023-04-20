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

export function mathematicaMath(view) {
  subEditor = view;
  return [
    //mathematicaMathDecoration,
    Fracholders,
    keymap.of([{ key: "Ctrl-/", run: snippet() }])
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
          changes: { from, to, insert: "Rational[1, 1]" },
          range: EditorSelection.cursor(from)
        };
      }
      return {
        changes: { from, to, insert: "Rational[" + prev + ", 1]" },
        range: EditorSelection.cursor(from)
      };
    });

    dispatch(
      state.update(changes, { scrollIntoView: true, userEvent: "input" })
    );
    return true;
  };
}

class FracWidgetX extends WidgetType {
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
    span.classList.add("frac-holder");

    if (this.visibleValue.args.length !== 2) {
      this.visibleValue.args = ["1", "1"];
      console.error("argumets doesnt match");
    }

    const args = this.visibleValue.args;

    const top = document.createElement("div");

    this.subEditor({
      doc: args[0],
      parent: top
    });

    top.classList.add("frac-top");

    const bottom = document.createElement("div");

    //console.log("bottom string: " + bottomstring);
    this.subEditor({
      doc: args[1],
      parent: bottom
    });

    bottom.classList.add("frac-bottom");

    span.appendChild(top);
    span.appendChild(bottom);
    //span.classList.add("cm-bold");*/
    return span;
  }

  ignoreEvent() {
    return true;
  }
}

const FracMatcher = (ref) => {
  return new BallancedMatchDecorator({
    regexp: /Rational\[/,
    decoration: (match) => {
      return Decoration.replace({
        widget: new FracWidgetX(match, ref)
      });
    }
  });
};

const Fracholders = ViewPlugin.fromClass(
  class {
    constructor(view) {
      this.disposable = [];
      this.Fracholders = FracMatcher(this.disposable).createDeco(view);
    }
    update(update) {
      this.Fracholders = FracMatcher(this.disposable).updateDeco(
        update,
        this.Fracholders
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
    decorations: (instance) => instance.Fracholders,
    provide: (plugin) =>
      EditorView.atomicRanges.of((view) => {
        var _a;
        return (
          ((_a = view.plugin(plugin)) === null || _a === void 0
            ? void 0
            : _a.Fracholders) || Decoration.none
        );
      })
  }
);

/*class FEWidget extends WidgetType {
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

    this.ref.push(this.fobj);

    return elt;
  }
  ignoreEvent() {
    return true;
  }
  destroy() {
    console.log("widget got destroyed!");
    this.fobj.dispose();
  }
}*/
