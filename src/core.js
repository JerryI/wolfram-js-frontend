const aflatten = (ary) => ary.reduce((a, b) => a.concat(Array.isArray(b) ? flatten(b) : b), [])
var core, interpretate;

core = {};

interpretate = function(d, env = {element: document.body, mesh: undefined}) {
  if (typeof d === 'undefined') {
    throw 'undefined type (not an object or string!)';
  }
  if (typeof d === 'string') {
    return d.slice(1, -1);
  }
  if (typeof d === 'number') {
    return d;
  }
  
  this.name = d[0];
  this.args = d.slice(1, d.length);
  console.log(this.name);
  return core[this.name](this.args, env);
};

core.List = function(args, env) {
  var copy, e, i, len, list;
  copy = Object.assign({}, env);
  list = [];
  for (i = 0, len = args.length; i < len; i++) {
    e = args[i];
    list.push(interpretate(e, copy));
  }
  return list;
};

core.Association = function(args, env) {
  var copy, e, i, len, list;
  copy = Object.assign({}, env);
  copy.association = {};
  
  for (i = 0, len = args.length; i < len; i++) {
    interpretate(args[i], copy);
  }
  
  return copy.association;
};

core.Rule = function(args, env) {
  env.association[args[0]] = args[1];
};

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
  });
}

function parse(input) {
  var i = str.length;
  var brakets = 0;
  while (i--) {
    alert(str[i]);
  }
}