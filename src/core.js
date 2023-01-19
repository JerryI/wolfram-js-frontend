const aflatten = (ary) => ary.flat(Infinity);
var core, interpretate;

core = {};

interpretate = function (d, env = { element: document.body, mesh: undefined, numerical: false }) {
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
  
  try {
    return core[this.name](this.args, env);
  }
  catch (e) {
    console.error(e, "not implemented");
  }
};

core.Rational = function (args, env) {
  if (env.numerical === true) return interpretate(args[0], env)/interpretate(args[1], env);
  //return the original form igoring other arguments
  return ["Rational", args[0], args[1]];
}

core.List = function (args, env) {
  var copy, e, i, len, list;
  copy = Object.assign({}, env);
  list = [];
  for (i = 0, len = args.length; i < len; i++) {
    e = args[i];
    list.push(interpretate(e, copy));
  }
  return list;
};

core.Association = function (args, env) {
  var copy, e, i, len, list;
  copy = Object.assign({}, env);
  copy.association = {};

  for (i = 0, len = args.length; i < len; i++) {
    interpretate(args[i], copy);
  }

  return copy.association;
};

core.Rule = function (args, env) {
  try {
    env.association[args[0]] = args[1];
  }
  catch (err) {
    console.error(err);
  }
};

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}