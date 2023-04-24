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

var interpretate = (d, env = {}) => {

  if (typeof d === 'undefined') {
    throw 'undefined type (not an object or string!)';
  }
  if (typeof d === 'string') {
    //if (env.todom === true) env.element.innerHTML = d;
    if (d.charAt(0) == "'") return d.slice(1, -1);
    return d;
  }
  if (typeof d === 'number') {
    //if (env.todom === true) env.element.innerHTML = String(d);
    return d; 
  }

  //if not a JSON array, probably a promise object
  if (!(d instanceof Array)) return d;

  //console.log("interpreting...");
  //console.log(d);
  //console.log(env);


  //reading the structure of Wolfram ExpressionJSON
  const name = d[0];
  const args = d.slice(1, d.length);
  

  //checking the context
  if ('context' in env) {
    if (name in env.context) {
      //checking the method
      
      
      if ('method' in env) {
        if (!env.context[name][env.method]) return console.error('method '+env['method']+' is not defined for '+name);
        return env.context[name][env.method](args, env);
      }
      
      //fake frontendexecutable
      //to bring local vars and etc
      if ('virtual' in env.context[name]) {
        const obj = new ExecutableObject('virtual-'+uuidv4(), env, d);
        let virtualenv = obj.assignScope();
        console.log('virtual env');
        console.log(virtualenv);
        return env.context[name](args, virtualenv);    
      }

      return env.context[name](args, env);
    }
  }

  //just go over all contextes defined to find the symbol
  const c = interpretate.contextes;

  for (i = 0; i < c.length; ++i) {
    if (name in c[i]) {
      //console.log('symbol '+name+' was found in '+c[i].name);

      if ('method' in env) {
        if (!c[i][name][env.method]) return console.error('method '+env['method']+' is not defined for '+name);
        return c[i][name][env.method](args, env);
      }

      //fake frontendexecutable
      //to bring local vars and etc
      if ('virtual' in c[i][name]) {
        const obj = new ExecutableObject('virtual-'+uuidv4(), env, d);
        let virtualenv = obj.assignScope();
        console.log('virtual env');
        console.log(virtualenv);        
        return c[i][name](args, virtualenv);    
      }     

      return c[i][name](args, env);    
    }
  };

  console.error('symbol '+name+' is undefined in any contextes available');
};

//contexes, so symbols names might be duplicated, therefore one can specify the propority context in env variable
interpretate.contextes = [];
//add new context
interpretate.contextExpand = (context) => {
  console.log(context.name + ' was added to the contextes of the interpreter');
  interpretate.contextes.push(context);
}

//Server API
let server = {
  promises : {},
  socket: {},
  
  init(socket) {
    this.socket = socket;

    window.onerror = function (message, file, line, col, error) {
      socket.send('NotebookPopupFire["error", "'+error.message+'"]');
      console.log(error);
      return false;
    };
    window.addEventListener("error", function (e) {
      socket.send('NotebookPopupFire["error", "'+e.message+'"]');
      console.log(e);
      return false;
    });
    window.addEventListener('unhandledrejection', function (e) {
      socket.send('NotebookPopupFire["error", "'+e.message+'"]');
      console.log(e);
    });

    console.error = function(e) {
      socket.send('NotebookPopupFire["error", "'+e+'"]');
      console.log(e);
    };
  },

  //evaluate something on the master kernel and make a promise for the reply
  ask(expr) {
    const uid = Date.now() + Math.floor(Math.random() * 100);

    const promise = new Deferred();
    this.promises[uid] = promise;
    
    this.socket.send('NotebookPromise["'+uid+'", ""]['+expr+']');
    
    return promise.promise 
  },
  //fire event on the secondary kernel (your working area) (no reply)
  emitt(uid, data) {
    this.socket.send('NotebookEmitt[EmittedEvent["'+uid+'", '+data+']]');
  },

  //evaluate something on the secondary kernel (your working area) and make a promise for the reply
  askKernel(expr) {
    const uid = Date.now() + Math.floor(Math.random() * 100);

    const promise = new Deferred();
    this.promises[uid] = promise;
    //not implemented
    console.error('askKernel is not implemented');
    this.socket.send('NotebookPromiseKernel["'+uid+'", ""][Hold['+expr+']]');
    
    return promise.promise    
  },

  //evaluate something on the secondary kernel (your working area) (no reply)
  talkKernel(expr) {
    this.socket.send('NotebookEmitt['+expr+']');
  }
}
 

var ObjectHashMap = {}

//storage for the frontend objects / executables
class ObjectStorage {
  refs = {}
  uid = ''
  cached = false
  cache = []
  
  constructor(uid) {
    this.uid = uid;
    ObjectHashMap[uid] = this;
  } 
  
  //assign an instance of FrontEndExecutable to it
  assign(obj) {
    this.refs[obj.instance] = obj;
  }
  
  //remove a reference to the instance of FrontEndExecutable
  dropref(obj) {
    console.log('dropped ref: ' + obj.instance);
    delete this.refs[obj.instance];
  }
  
  //update the data in the storage and go over all assigned objects
  update(newdata) {
    this.cache = newdata;
    Object.keys(this.refs).forEach((ref)=>{
      console.log('Updating... ' + this.refs[ref].uid);
      this.refs[ref].update();
    });
  }
  
  //just get the object (if not in the client -> ask for it and wait)
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

//instance of FrontEndExecutable object
class ExecutableObject {
  env = {}
  
  //uid (not unique) (global)
  uid = ''
  //uid (unique) (internal)
  instance = ''
  
  dead = false
  virtual = false

  //local scope
  local = {}

  assignScope() {
    this.env.local = this.local;
    return this.env;
  }

  //run the code inside
  async execute() {
    console.log('executing '+this.uid+'....');
    let content;
    
    if (this.virtual) console.error('execute() method is not allowed on virtual functions!');

    content = await this.storage.get(this.uid);

    //pass local scope
    this.env.local = this.local;
    console.log('interpreting the content of '+this.uid+'....');
    console.log('content');
    console.log(content);
    return interpretate(content, this.env);
  }

  //dispose the object and all three of object underneath
  //direction: TOP -> BOTTOM
  dispose() {
    if (this.dead) return;
    this.dead = true;

    console.log('DESTORY: ' + this.uid);
    //change the mathod of interpreting
    this.env.method = 'destroy';

    if (this.virtual) console.log('virtual type');
    
    //unregister from the storage class
    if (!this.virtual) this.storage.dropref(this);
    
    let content;
    if (!this.virtual) content = this.storage.get(this.uid); else content = this.virtual;

    //pass local scope
    this.env.local = this.local;    
    //the link between objects will be dead automatically
    interpretate(content, this.env);
  }
  
  //update the state of it and recompute all objects inside
  //direction: BOTTOM -> TOP
  update() {
    console.log('updating...'+this.uid);
    //bubble up (only by 1 level... cuz some BUG, but can still work even with this limitation)
    if (this.parent instanceof ExecutableObject && !(this.child instanceof ExecutableObject)) return this.parent.update(); 
    
    if (this.virtual) console.log('virtual type');

    //change the method of interpreting 
    this.env.method = 'update';
    //pass local scope
    this.env.local = this.local;
    console.log('interprete...'+this.uid);

    let content;
    if (!this.virtual) content = this.storage.get(this.uid); else content = this.virtual;

    return interpretate(content, this.env);
  }

  constructor(uid, env, virtual = false) {
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
    
    //for virtual functions
    if (virtual) {
      console.log('virtual object detected!');
      console.log('local storage is enabled');
      console.log(virtual);
      this.virtual = virtual;
    } else {
      if (uid in ObjectHashMap) this.storage = ObjectHashMap[uid]; else this.storage = new ObjectStorage(uid);
      this.storage.assign(this);
    }
    
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


class jsRule {
  // Constructor
  constructor(left, right) {
    this.left = left;
    this.right = right;
  }
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