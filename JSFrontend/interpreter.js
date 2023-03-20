const aflatten = (ary) => ary.flat(Infinity);
var interpretate;
var $objetsStorage = {};
var $promisesAssoc = {};

class Deferred {
  constructor(uid) {
    this.promise = new Promise((resolve, reject)=> {
      this.reject = reject
      this.resolve = resolve
    });
  }
}

interpretate = function (d, env = { 
  element: document.body, 
  mesh: undefined, 
  numerical: false, 
  todom: false, 
  chain: {}
}) {

  if (typeof d === 'undefined') {
    throw 'undefined type (not an object or string!)';
  }
  if (typeof d === 'string') {
    if (env.todom === true) env.element.innerHTML = d;
    if (d.charAt(0) == "'") return d.slice(1, -1);
    return d;
  }
  if (typeof d === 'number') {
    if (env.todom === true) env.element.innerHTML = d;
    return d; 
  }

  if (!(d instanceof Array)) return d;

  this.name = d[0];
  this.args = d.slice(1, d.length);

  console.log(this.name);

  if ('method' in env) return core[this.name][env.method](this.args, env);
  return core[this.name](this.args, env);
};

core._getRules = function(args, env) {
  let rules = {};
  args.forEach((el)=>{
    if(el instanceof Array) {
      if (el[0] === 'Rule') {
        rules[interpretate(el[1], env)] = interpretate(el[2], env);
      }
    }
  });
  return rules; 
}

core.FireEvent = function(args, env) {
  const key  = interpretate(args[0], env);
  const data = interpretate(args[1], env);

  socket.send(`NotebookEmitt[EmittedEvent["${key}", ${data}]]`);
}

core.CallServer = function (args, env) {
  const uid = uuidv4();
  var promise = new Deferred(uid);
  $promisesAssoc[uid] = promise;

  const func = interpretate(args[0], env);
  //const params = JSON.stringify(env).replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"');
  socket.send('NotebookPromise["'+uid+'", ""]['+func+']');
  return promise.promise;
}

core.PromiseResolve = function (args, env) {
  const uid = interpretate(args[0], env);
  const data = JSON.parse(interpretate(args[1], env));
  //todo allow to interprete the result
  $promisesAssoc[uid].resolve(data);
  delete $promisesAssoc[uid];
}

core.UpdateFrontEndExecutable = function (args, env) {
  const key = interpretate(args[0], env);
  var data  = JSON.parse(interpretate(args[1], env));
  $objetsStorage[key].data = data;

  $objetsStorage[key].handlers.forEach(element => {
    let envobject = Object.assign({}, element.env);
    envobject.chain = {}; 
    core.FrontEndExecutable([element.exe], {...envobject, method: 'update'})
  });
}

core.FrontEndDispose = function (args, env) {
  const arr = interpretate(args[0], env);
  arr.forEach((el)=>{
    delete $objetsStorage[el];
  });
  console.log('garbage removed');
}

core.SetFrontEndObject = function (args, env) {
  console.log(args);
  const key = interpretate(args[0], env);

  $objetsStorage[key].data = args[1];
  console.log("new data");
  console.log($objetsStorage[key].data);
  console.log("end");


  $objetsStorage[key].handlers.forEach(element => {
    let envobject = Object.assign({}, element.env);
    envobject.chain = {}; 
    console.log("reactive chain of functions will be applied");
    core.FrontEndExecutable([element.exe], {...envobject, update: 'data'})
  });
}

core.FrontEndExecutable = async function (args, env) {
  const key = interpretate(args[0], env);
  //var chain = {};

  /*if(!env.method) {
    console.log('chain arrived');
    var chain = Object.assign({}, env.chain);
    console.log(chain);

    env.chain = {exe: "'"+key+"'", env: Object.assign({}, env)};
  }*/

  var copy = env;

  if (key in $objetsStorage) {
    //if (Object.keys(chain).length > 0 && $objetsStorage[key].handlers.length === 0) {
    //  $objetsStorage[key].handlers.push(chain);
    //}
    if (copy.hold === true) return $objetsStorage[key].data;
    console.log('already there. getting...');
    return await interpretate($objetsStorage[key].data, copy);
  }
  
  console.log('not here. asking server...');

  return new Promise((resolve, reject) => {
    core.CallServer([`'NotebookGetObject["${key}"]'`], {...copy, hold: true})
      .then((val) => {
        $objetsStorage[key] = {data: [], handlers: []};
        $objetsStorage[key].data = val;
        //console.log('chain info');
        //console.log(chain);
        //if (Object.keys(chain).length > 0 && $objetsStorage[key].handlers.length === 0) {
        //  $objetsStorage[key].handlers.push(chain);
        //}        
        if (copy.hold === true) resolve(val); else resolve(interpretate(val, copy));
      });
    });
}

core.FrontEndExecutableHold = core.FrontEndExecutable;

//to prevent codemirror 6 from drawing it
core.FrontEndRef = function(args, env) {
  return core.FrontEndExecutable(args, env);
}
//hold analogue for the backend
core.FrontEndOnly = function(args, env) {
  return interpretate(args[0], env);
}

core.Rational = function (args, env) {
  if (env.numerical === true) return interpretate(args[0], env)/interpretate(args[1], env);
  
  //return the original form igoring other arguments
  return ["Rational", args[0], args[1]];
}

core.Times = function (args, env) {
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
  return core._getRules(args, env);
};

class jsRule {
  // Constructor
  constructor(left, right) {
    this.left = left;
    this.right = right;
  }
}

core.Rule = function (args, env) {
  //actaully an function generator. can be improved
  const left  = interpretate(args[0], env);
  const right = interpretate(args[1], env);

  return new jsRule(left, right);
};

core.Rule.update = core.Rule;

core.Slot = function (args, env) {
  return env.slot[interpretate(args[0], env)];
}

core.Function = function (args, env) {
  env.todom = false;

}

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