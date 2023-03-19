const GreekMatcher = new MatchDecorator({
    regexp: /\\\[([a-zA-z]+)\]/g,
    decoration: match => Decoration.replace({
      widget: new GreekWidget(match[1]),
    })
  });
  const Greekholder = ViewPlugin.fromClass(class {
    constructor(view) {
      this.Greekholder = GreekMatcher.createDeco(view);
    }
    update(update) {
      this.Greekholder = GreekMatcher.updateDeco(update, this.Greekholder);
    }
  }, {
    decorations: instance => instance.Greekholder,
    provide: plugin => EditorView.atomicRanges.of(view => {
      var _a;
      return ((_a = view.plugin(plugin)) === null || _a === void 0 ? void 0 : _a.Greekholder) || Decoration.none;
    })
  });
  
  class GreekWidget extends WidgetType {
    constructor(name) {
      super();
      this.name = name;
    }
    eq(other) {
      return this.name === other.name;
    }
    toDOM() {
      let elt = document.createElement("span");
      elt.innerHTML = '&'+this.name.toLowerCase().replace('sqrt', 'radic').replace('degree', 'deg')+';';
  
      return elt;
    }
    ignoreEvent() {
      return false; 
    }
  }
