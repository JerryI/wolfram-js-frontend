const aflatten = (ary) => ary.flat(Infinity);

class Deferred {
  promise = {}
  reject = {}
  resolve = {}
  
  constructor() {
    this.promise = new Promise((resolve, reject)=> {
      this.reject = reject
      this.resolve = resolve
    });
  }
}  
    
var interpretate = (d, env = { 
  element: document.body, 
  mesh: undefined, 
  numerical: false, 
  todom: false
}) => {

  if (typeof d === 'undefined') {
    throw 'undefined type (not an object or string!)';
  }
  if (typeof d === 'string') {
    if (env.todom === true) env.element.innerHTML = d;
    if (d.charAt(0) == "'") return d.slice(1, -1);
    return d;
  }
  if (typeof d === 'number') {
    if (env.todom === true) env.element.innerHTML = String(d);
    return d; 
  }

  if (!(d instanceof Array)) return d;

  this.name = d[0];
  this.args = d.slice(1, d.length);

  if ('method' in env) return core[this.name][env.method](this.args, env);
  return core[this.name](this.args, env);
};

//Server API
let server = {
  promises : {},
  socket: {},
  
  init(socket) {
    this.socket = socket
  },
  ask(expr) {
    const uid = Date.now() + Math.floor(Math.random() * 100);

    const promise = new Deferred();
    this.promises[uid] = promise;
    
    this.socket.send('NotebookPromise["'+uid+'", ""]['+expr+']');
    
    return promise.promise 
  },
  emitt(uid, data) {
    this.socket.send('NotebookEmitt[EmittedEvent["'+uid+'", '+data+']]');
  },

  askKernel(expr) {
    const uid = Date.now() + Math.floor(Math.random() * 100);

    const promise = new Deferred();
    this.promises[uid] = promise;
    //not implemented
    console.error('askKernel is not implemented');
    this.socket.send('NotebookPromiseKernel["'+uid+'", ""][Hold['+expr+']]');
    
    return promise.promise    
  },

  talkKernel(expr) {
    this.socket.send('NotebookEmitt['+expr+']');
  }
}
 

var ObjectHashMap = {}

class ObjectStorage {
  refs = {}
  uid = ''
  cached = false
  cache = []
  
  constructor(uid) {
    this.uid = uid;
    ObjectHashMap[uid] = this;
  } 
  
  assign(obj) {
    this.refs[obj.instance] = obj;
  }
  
  dropref(obj) {
    console.log('dropped ref: ' + obj.instance);
    delete this.refs[obj.instance];
  }
  
  update(newdata) {
    this.cache = newdata;
    Object.keys(this.refs).forEach((ref)=>{
      console.log('Updating... ' + this.refs[ref].uid);
      this.refs[ref].update();
    });
  }
  
  get() {
    if (this.cached) return this.cache;
    const promise = new Deferred();
    console.log('NotebookGetObject["'+this.uid+'"]');
    server.ask('NotebookGetObject["'+this.uid+'"]').then((data)=>{
      this.cache = JSON.parse(interpretate(data));
      this.cached = true;
      console.log('got from the server. storing in cache...');
      promise.resolve(this.cache);
    })
    
    return promise.promise;  
  }
}

class ExecutableObject {
  env = {}
  
  uid = ''
  
  dead = false

  //local scope
  local = {}

  async execute() {
    console.log('executing '+this.uid+'....');
    const content = await this.storage.get(this.uid);

    //pass local scope
    this.env.local = this.local;
    console.log('interpreting the content of '+this.uid+'....');
    console.log('content');
    console.log(content);
    return interpretate(content, this.env);
  }

  dispose() {
    if (this.dead) return;
    this.dead = true;

    console.log('DESTORY: ' + this.uid);
    //going down
    this.env.method = 'destroy';
    
    //unregister from the storage class
    this.storage.dropref(this);

    //pass local scope
    this.env.local = this.local;    
    //the link between objects will be dead automatically
    interpretate(this.storage.get(this.uid), this.env);
  }
  
  update() {
    console.log('updating...'+this.uid);
    //bubble up (only by 1 level... cuz some BUG)
    if (this.parent instanceof ExecutableObject && !(this.child instanceof ExecutableObject)) return this.parent.update(); 
    
    //update the three
    this.env.method = 'update';
    //pass local scope
    this.env.local = this.local;
    console.log('interprete...'+this.uid);
    return interpretate(this.storage.get(this.uid), this.env);
  }

  constructor(uid, env) {
    console.log('constructing the instance of '+uid+'...');
    
    this.uid = uid;
    this.env = env;
    
    this.instance = Date.now() + Math.floor(Math.random() * 100);
    
    this.env.element = this.env.element || 'body';
    //global scope
    //making a stack-call only for executable objects
    this.env.global.stack = this.env.global.stack || {};
    this.env.global.stack[uid] = this;
    
    this.env.root = this.env.root || {};
    
    if (uid in ObjectHashMap) this.storage = ObjectHashMap[uid]; else this.storage = new ObjectStorage(uid);
    this.storage.assign(this);
    
    if (this.env.root instanceof ExecutableObject) {
      //connecting together
      console.log('connection between two: '+this.env.root.uid + ' and a link to '+this.uid);
      this.parent = this.env.root;
      this.env.root.child = this;
    }
    
    this.env.root = this;
    return this;
  }  
};

core.FrontEndExecutable = async (args, env) => {
  const key = interpretate(args[0], env);
  //creates an instance with its own separate env
  //we need this local context to create stuff and then, destory it if it necessary
  console.log("FEE: creating an object with key "+key);
  const obj = new ExecutableObject(key, env);
  
  const result = await obj.execute()
  return result;  
};

core.FrontEndExecutable.update = async (args, env) => {
  const key = interpretate(args[0], env);
  return await env.global.stack[key].execute();
};

core.FrontEndExecutable.destroy = async (args, env) => {
  const key = interpretate(args[0], env);
  await env.global.stack[key].dispose();
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

  server.emitt(key, data);
}

core.KernelFire = function(args, env) {
  const data = interpretate(args[0], env);

  server.talkKernel(data);
}

core.KernelEvaluate = function(args, env) {
  const data = interpretate(args[0], env);

  server.askKernel(data);
}


core.PromiseResolve = (args, env) => {
  const uid = interpretate(args[0], env);
  server.promises[uid].resolve(args[1]);
  delete server.promises[uid];
}

core.UpdateFrontEndExecutable = function (args, env) {
  const key = interpretate(args[0], env);
  var data  = JSON.parse(interpretate(args[1], env));
  
  ObjectHashMap[key].update(data);
}

core.FrontEndDispose = function (args, env) {
  //no need anymore
  console.log('garbage removed');
}


core.SetFrontEndObject = function (args, env) {
  const key = interpretate(args[0], env);
  ObjectHashMap[key].update(args[1]);
}

core.FrontEndExecutableHold = core.FrontEndExecutable;
//to prevent codemirror 6 from drawing it
core.FrontEndRef = core.FrontEndExecutable;
//another alias
core.FrontEndExecutableWrapper = core.FrontEndExecutable;
//hold analogue for the backend
core.FrontEndOnly = (args, env) => {
  return interpretate(args[0], env);
};

core.FrontEndOnly.update = (args, env) => {
  return interpretate(args[0], env);
};

core.FrontEndOnly.destroy = (args, env) => {
  interpretate(args[0], env);
};

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

core.List.destroy = (args, env) => {
  var copy, i, len, list;
  for (i = 0, len = args.length; i < len; i++) {
    interpretate(args[i], env);
  }
};

core.List.update = (args, env) => {
  var copy, e, i, len, list;
  list = [];

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
  link.remove();
}

var setInnerHTML = function(elm, html) {
  elm.innerHTML = html;
  Array.from(elm.querySelectorAll("script")).forEach( oldScript => {
    const newScript = document.createElement("script");
    Array.from(oldScript.attributes)
      .forEach( attr => newScript.setAttribute(attr.name, attr.value) );
    newScript.appendChild(document.createTextNode(oldScript.innerHTML));
    oldScript.parentNode.replaceChild(newScript, oldScript);
  });
};

function openawindow(url, target='_self') {
  const fake = document.createElement('a');
  fake.target = target;
  fake.href = url;
  fake.click();
}