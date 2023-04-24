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

export function supscriptWidget(view) {
  subEditor = view;
  return [
    //mathematicaMathDecoration,
    placeholder,
    keymap.of([{ key: "Ctrl-6", run: snippet() }])
  ];
}

function snippet() {
  return ({ state, dispatch }) => {
    if (state.readOnly) return false;
    console.log(state);
    let changes = state.changeByRange((range) => {
      let { from, to } = range;
      //if (atEof) from = to = (to <= line.to ? line : state.doc.lineAt(to)).to
      const prev = state.sliceDoc(from, to);
      if (prev.length === 0) {
        return {
          changes: { from, to, insert: "CM6Superscript[_,_]" },
          range: EditorSelection.cursor(from)
        };
      }
      return {
        changes: { from, to, insert: "CM6Superscript[" + prev + ", _]" },
        range: EditorSelection.cursor(from)
      };
    });

    state.config.nextFocus = true;
    

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
    console.log(view);

    let span = document.createElement("span");

    if (this.visibleValue.args.length !== 2) {
      this.visibleValue.args = ["_", "_"];
      console.error("argumets doesnt match");
    }
    
    console.log('create widget DOM!!!!');
    console.log(this.visibleValue);
 
    const args = this.visibleValue.args;

    const head = document.createElement("span");
    head.classList.add("subscript-tail");
    
    const visibleValue = this.visibleValue;
    
    const recreateString = (args) => {
      this.visibleValue.str =  'CM6Superscript['+args[0]+', '+args[1]+']';
      const changes = {from: visibleValue.pos, to: visibleValue.pos + visibleValue.length, insert: this.visibleValue.str};
      this.visibleValue.length = this.visibleValue.str.length;

      return changes;
    }

    this.subEditor({
      doc: args[0],
      parent: head,
      update: (upd) => {
        this.visibleValue.args[0] = upd;
        const change = recreateString(this.visibleValue.args);
        console.log('insert change');
        console.log(change);
        view.dispatch({changes: change});
      }
    });

    const sub = document.createElement("sup");
    sub.classList.add("subscript-tail");

    const editor = this.subEditor({
      doc: args[1],
      parent: sub,
      update: (upd) => {
        this.visibleValue.args[1] = upd;
        const change = recreateString(this.visibleValue.args);
        console.log('insert change');
        console.log(change);
        view.dispatch({changes: change});
      }      
    });

    
    if (view.viewState.state.config.nextFocus) {
      editor.focus();
      view.viewState.state.config.nextFocus = false;
    }

    span.appendChild(head);
    span.appendChild(sub);

    //span.classList.add("cm-bold");*/
    return span;
  }

  ignoreEvent() {
    return true;
  }
}

const matcher = (ref, view) => {
  return new BallancedMatchDecorator({
    regexp: /CM6Superscript\[/,
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
