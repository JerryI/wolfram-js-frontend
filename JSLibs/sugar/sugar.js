import { Decoration, ViewPlugin, WidgetType } from "@codemirror/view"
import { isCursorInside } from "./utils"

//credits to https://github.com/fuermosi777

// TODO: when typing *, auto complete the corresponding *

export function mathematicaMath() {
  return [mathematicaMathDecoration]
}

const mathematicaMathDecoration = ViewPlugin.fromClass(
  class {
    decorations = Decoration.none

    constructor(view) {
      this.view = view
      this.recompute()
    }

    recompute(update) {
      let decorations = []
      for (let { from, to } of this.view.visibleRanges) {
        this.getDecorationsFor(from, to, decorations)
      }

      this.decorations = Decoration.set(decorations, true)

      // Iterate all decorations and remove those shouldn't be created.
      let prevFrom, prevTo
      this.decorations = this.decorations.update({
        filter: (from, to) => {
          // Filter out decorations if it's wrapped by another emphasis decoration.
          if (from > prevFrom && to < prevTo) {
            return false
          }
          prevFrom = from
          prevTo = to
          // Filter out decorations when the cursor is inside.
          if (update && isCursorInside(update, from, to)) {
            return false
          }
          return true
        }
      })
    }

    update(update) {
      if (update.docChanged || update.selectionSet || update.viewportChanged) {
        this.recompute(update)
      }
    }

    getDecorationsFor(from, to, decorations) {
      let { doc } = this.view.state

      let r = /Subscript\[([^(\[|\])]+)\]/g
      for (
        let pos = from, cursor = doc.iterRange(from, to), m;
        !cursor.next().done;

      ) {
        if (!cursor.lineBreak) {
          while ((m = r.exec(cursor.value))) {
            console.log(m)
            // An edge case.
            if (m.input[m.index - 1] === "_" || m.input[m.index - 1] === "*")
              continue
            // No all whitespaces.
            if (m[1].trim().length === 0) continue
            let deco = Decoration.replace({
              widget: new SubscriptWidget(m[0], m[1])
            })
            decorations.push(
              deco.range(pos + m.index, pos + m.index + m[0].length)
            )
          }
        }
        pos += cursor.value.length
      }

      r = /Superscript\[([^(\[|\])]+)\]/g
      for (
        let pos = from, cursor = doc.iterRange(from, to), m;
        !cursor.next().done;

      ) {
        if (!cursor.lineBreak) {
          while ((m = r.exec(cursor.value))) {
            console.log(m)
            // An edge case.
            if (m.input[m.index - 1] === "_" || m.input[m.index - 1] === "*")
              continue
            // No all whitespaces.
            if (m[1].trim().length === 0) continue
            let deco = Decoration.replace({
              widget: new SupscriptWidget(m[0], m[1])
            })
            decorations.push(
              deco.range(pos + m.index, pos + m.index + m[0].length)
            )
          }
        }
        pos += cursor.value.length
      }
    }
  },
  {
    decorations: v => v.decorations
  }
)

class SubscriptWidget extends WidgetType {
  constructor(rawValue, visibleValue) {
    super()
    this.rawValue = rawValue
    this.visibleValue = visibleValue
  }
  eq(other) {
    return this.rawValue === other.rawValue
  }
  toDOM() {
    let span = document.createElement("span")
    const r = /([^,]+)/

    const head = this.visibleValue.match(r)[0]
    const substring = this.visibleValue.substring(head.length + 1)

    const sub = document.createElement("sub")
    sub.innerText = substring

    span.textContent = head
    span.appendChild(sub)
    //span.classList.add("cm-bold");
    return span
  }

  ignoreEvent() {
    return false
  }
}

class SupscriptWidget extends WidgetType {
  constructor(rawValue, visibleValue) {
    super()
    this.rawValue = rawValue
    this.visibleValue = visibleValue
  }
  eq(other) {
    return this.rawValue === other.rawValue
  }
  toDOM() {
    let span = document.createElement("span")
    const r = /([^,]+)/

    const head = this.visibleValue.match(r)[0]
    const substring = this.visibleValue.substring(head.length + 1)

    const sub = document.createElement("sup")
    sub.innerText = substring

    span.textContent = head
    span.appendChild(sub)
    //span.classList.add("cm-bold");
    return span
  }

  ignoreEvent() {
    return false
  }
}
