var core = {};
core.name = "Core Context";
interpretate.contextExpand(core);

core.DefaultWidth = 600;

core.ConsoleLog = [];

core.GarbageCollected = async (args, env) => {
    if ('element' in env) {
      env.element.innerText = '- Garbage -';
    }
    console.log('garbage collected');
}

core.True = (args, env) => {
  return true;
}

core.False = (args, env) => {
  return false;
}

core.FrontEndExecutable = async (args, env) => {
    const key = interpretate(args[0], env);
    //creates an instance with its own separate env
    //we need this local context to create stuff and then, destory it if it necessary
    console.log("FEE: creating an object with key "+key);
    //new local scope, global is the same
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
  
  core._typeof = function(args, env) {
    if (typeof args === 'string') {
      return 'string';
    }
    if (typeof args === 'number') {
      return 'number';
    }
    if (args instanceof Array) {
      return args[0];
    }

    return 'undefined';
  }
  
  core._getRules = function(args, env) {
    let rules = {};
    if (env.hold) {
      args.forEach((el)=>{
        if(el instanceof Array) {
          if (el[0] === 'Rule') {
            rules[interpretate(el[1], {...env, hold:false})] = el[2];
          }
        }
      });
    } else {
      args.forEach((el)=>{
        if(el instanceof Array) {
          if (el[0] === 'Rule') {
            rules[interpretate(el[1], {...env, hold:false})] = interpretate(el[2], env);
          }
        }
      });
    }

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
  
  core.Power = (args, env) => {
    if (!env.numerical) return ["Power", ...args];
    
    const val = interpretate(args[0], env);
    const p   = interpretate(args[1], env);
  
    return Math.pow(val,p);
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
  
  core.List = async function (args, env) {
    var copy, e, i, len, list;
    list = [];
  
    if (env.hold === true) {
      console.log('holding...');
      for (i = 0, len = args.length; i < len; i++) {
        e = args[i];

        list.push(e);
      }
      return list;
    }
    
    copy = Object.assign({}, env);
    for (i = 0, len = args.length; i < len; i++) {
      e = args[i];

      list.push(await interpretate(e, copy));
    }

    return list;
  };
  
  core.List.destroy = (args, env) => {
    var copy, i, len, list;
    for (i = 0, len = args.length; i < len; i++) {
      interpretate(args[i], env);
    }
  };
  
  core.List.update = async (args, env) => {
    var copy, e, i, len, list;
    list = [];
  
    copy = Object.assign({}, env);
    for (i = 0, len = args.length; i < len; i++) {
      e = args[i];
      list.push(await interpretate(e, copy));
    }
    return list;
  };
  
  core.Association = function (args, env) {
    return core._getRules(args, env);
  };

  core.Rule = function (args, env) {
    //actaully an function generator. can be improved
    const left  = interpretate(args[0], env);
    const right = interpretate(args[1], env);
  
    return new jsRule(left, right);
  };
  
  core.Rule.update = core.Rule;

  core.Function = (args, env) => {
    //void
  }
