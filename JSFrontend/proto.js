var core = {};

var arr = {'A': ["List", ["FrontEndExecutable", "'B'"] ], 'B': 1234 };

var interpretate = function (d, env = { 
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

core.List = (args, env) => {
  let copy = Object.assign({}, env);
  copy.list = 7;
  return interpretate(args[0], copy)-111;
}

core.List.destroy = (args, env) => {
  console.log('LIST Destory');
  interpretate(args[0], env);
}

core.List.update = (args, env) => {
  console.log('LIST update');
  let copy = Object.assign({}, env);
  return interpretate(args[0], copy)-111;
}

var ObjectHashMap = {}

class ObjectStorage {
  refs = {}
  uid = ''
  constructor(uid) {
    
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
    this.content = newdata;
    Object.keys(this.refs).forEach((ref)=>{
      console.log('Updating... ' + this.refs[ref].uid);
      this.refs[ref].update();
    });
  }
  
  get() {
      
  }
}

class ExecutableObject {
  env = {}
  
  uid = ''

  content = []

  execute() {
    return interpretate(arr[this.uid], this.env);
  }

  dispose() {
    console.log('DESTORY: ' + this.uid);
    //going down
    this.env.method = 'destroy';
    
    //unregister from the content class
    this.storage.dropref(this);
    
    //the link between objects will be dead automatically
    interpretate(arr[this.uid], this.env);
  }
  
  update() {
    console.log('updating...'+this.uid);
    //bubble up
    if (this.parent instanceof ExecutableObject) return this.parent.update(); 
    
    //update the three
    this.env.method = 'update';
    console.log('interprete...'+this.uid);
    return interpretate(arr[this.uid], this.env);
  }

  constructor(uid, env) {
    console.log('construct');
    
    this.uid = uid;
    this.env = env;
    
    this.instance = Date.now() + Math.floor(Math.random() * 100);
    
    this.env.element = this.env.element || 'body';
    this.env.global.stack = this.env.global.stack || {};
    this.env.global.stack[uid] = this;
    
    this.env.root = this.env.root || {};
    
    if (uid in ObjectHashMap) this.storage = ObjectHashMap[uid]; else this.storage = new ObjectStorage(uid);
    this.storage.assign(this);
    
    if (this.env.root instanceof ExecutableObject) {
      console.log('connection between two: '+this.env.root.uid + ' and a link to '+this.uid);
      this.parent = this.env.root;
    }
    
    this.env.root = this;
    return this;
  }  
};

core.FrontEndExecutable = (args, env) => {
  const key = interpretate(args[0], env);
  //creates an instance with its own separate env
  //we need this local context to create stuff and then, destory it if it necessary
  const obj = new ExecutableObject(key, env);
  
  return obj.execute();
};

core.FrontEndExecutable.update = (args, env) => {
  const key = interpretate(args[0], env);
  return env.global.stack[key].execute();
};

core.FrontEndExecutable.destroy = (args, env) => {
  const key = interpretate(args[0], env);
  env.global.stack[key].dispose();
};

let global = {}; //Created in CM6
let e = {global: global}; //Created in CM6
core.FrontEndExecutable(["'A'"], e)
e

e.global.stack['A'].dispose(); //up to down from codemirror
e.global.stack['B'].update() //down to up from Storage

ObjectHashMap






