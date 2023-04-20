import {
  EditorView,
  Decoration,
  ViewPlugin,
  WidgetType,
  MatchDecorator
} from "@codemirror/view";
import { isCursorInside } from "./utils";


export const cellTypesHighlight = ViewPlugin.fromClass(
  class {
    decorations = Decoration.none;

    constructor(view) {
      this.view = view;
      this.recompute();
    }

    recompute(update) {
      let decorations = [];
      for (let { from, to } of this.view.visibleRanges) {
        this.getDecorationsFor(from, to, decorations);
      }

      this.decorations = Decoration.set(decorations, true);

      // Iterate all decorations and remove those shouldn't be created.
      let prevFrom, prevTo;
      this.decorations = this.decorations.update({
        filter: (from, to) => {
          // Filter out decorations if it's wrapped by another emphasis decoration.
          if (from > prevFrom && to < prevTo) {
            return false;
          }
          prevFrom = from;
          prevTo = to;
          // Filter out decorations when the cursor is inside.
          if (update && isCursorInside(update, from, to)) {
            return false;
          }
          return true;
        }
      });
    }

    update(update) {
      if (update.docChanged || update.selectionSet || update.viewportChanged) {
        this.recompute(update);
      }
    }

    getDecorationsFor(from, to, decorations) {
      let { doc } = this.view.state;

      let r = /^\.\w+\s*$/g;
      for (
        let pos = from, cursor = doc.iterRange(from, to), m;
        !cursor.next().done;

      ) {
        if (!cursor.lineBreak) {
          while ((m = r.exec(cursor.value))) {
            console.log('cells.js');
            console.log(m);
            // An edge case.
            //if (m.input[m.index - 1] === "_" || m.input[m.index - 1] === "*")
            //  continue;
            // No all whitespaces.
            //if (m[1].length === 0) continue;
            let deco = Decoration.replace({
              widget: new CellTypeWidget(m[0], m[1])
            });
            decorations.push(
              deco.range(pos + m.index, pos + m.index + m[0].length)
            );
          }
        }
        pos += cursor.value.length;
      }
    }
  },
  {
    decorations: (v) => v.decorations
  }
);

class CellTypeWidget extends WidgetType {
  constructor(rawValue, visibleValue) {
    super();
    this.rawValue = rawValue;
    this.visibleValue = visibleValue;
  }
  eq(other) {
    return this.rawValue === other.rawValue;
  }
  toDOM() {
    let span = document.createElement("div");
    span.classList.add('cell-type-widget');
    const ext = this.rawValue.split('.')
    console.log(ext);
    span.classList.add('cell-type-'+ext[1].trim());
    span.innerText = this.rawValue.trim();
    return span;
  }

  ignoreEvent() {
    return false;
  }
}
