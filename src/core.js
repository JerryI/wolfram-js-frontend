const aflatten = (ary) => ary.flat(Infinity);
var core, interpretate;

core = {};

interpretate = function (d, env = { element: document.body, mesh: undefined, numerical: false, todom: false}) {
  if (typeof d === 'undefined') {
    throw 'undefined type (not an object or string!)';
  }
  if (typeof d === 'string') {
    if (env.todom === true) env.element.innerHTML = d;
    return d.slice(1, -1);
  }
  if (typeof d === 'number') {
    if (env.todom === true) env.element.innerHTML = d;
    return d; 
  }

  this.name = d[0];
  this.args = d.slice(1, d.length);

  console.log(this.name);
  
  try {
    return core[this.name](this.args, env);
  }
  catch (e) {
    console.error(e, "not implemented");
  }
};

core.Rational = function (args, env) {

  if (env.todom  === true) {
    const rationalNumber = document.createElement("div");
    rationalNumber.classList.add("frac");

    const numerator = document.createElement("span");
    interpretate(args[0], {...env, element: numerator});

    const separator = document.createElement("span");
    separator.innerHTML = "/";
    separator.classList.add("symbol");

    const denominator = document.createElement("span");
    interpretate(args[1], {...env, element: denominator});
    denominator.classList.add("bottom");

    rationalNumber.appendChild(numerator);
    rationalNumber.appendChild(separator);
    rationalNumber.appendChild(denominator);
    env.element.appendChild(rationalNumber);
    return null;
  }
  if (env.numerical === true) return interpretate(args[0], env)/interpretate(args[1], env);
  
  //return the original form igoring other arguments
  return ["Rational", args[0], args[1]];
}

core.Times = function (args, env) {

  if (env.todom  === true) {
    const product = document.createElement("div");

    const numerator = document.createElement("span");
    interpretate(args[0], {...env, element: numerator});

    const separator = document.createElement("span");
    separator.innerHTML = "x";

    const denominator = document.createElement("span");
    interpretate(args[1], {...env, element: denominator});

    product.appendChild(numerator);
    product.appendChild(separator);
    product.appendChild(denominator);
    env.element.appendChild(product);
    return null;
  }
  if (env.numerical === true) return interpretate(args[0], env)*interpretate(args[1], env);
  
  //TODO: evaluate it before sending its original symbolic form
  return ["Times", ...args];
}

core.List = function (args, env) {
  var copy, e, i, len, list;
  list = [];

  if (env.hold === true) {
    for (i = 0, len = args.length; i < len; i++) {
      e = args[i];
      list.push(e);
    }
    return list;
  }

  
  copy = Object.assign({}, env);
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
  if (env.hasOwnProperty('association')) {

    let copy = Object.assign({}, env);
    delete copy.association;

    env.association[args[0]] = interpretate(args[1], copy);
  }

  //TODO: evaluate it before sending it
  return ["Rule", ...args];
};

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

function downloadByURL(url, name) {
  var link = document.createElement('a');
  link.setAttribute('href', url);
  link.setAttribute('download', name);
  link.click();
}