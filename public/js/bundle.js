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

core.FrontEndExecutable = function (args, env) {

}

core.FrontEndVariable = function (args, env) {

}

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
let socket;
socket = new WebSocket("ws://"+window.location.hostname+':'+window.location.port);
socket.onopen = function(e) {
  console.log("[open] Соединение установлено");
}; 

socket.onmessage = function(event) {

  let data = JSON.parse(event.data);
  
  interpretate(data);
};

socket.onclose = function(event) {
  console.log(event);
  console.log('Connection lost. Please, update the page to see new changes.');
};

function WSPHttpQueryQuite(command, promise, type = "String") {

  var http = new XMLHttpRequest();
  var url = 'http://'+window.location.hostname+':'+window.location.port+'/utils/query.wsp';
  var params = 'command='+encodeURI(command)+'&type='+type;
  http.open('GET', url+"?"+params, true);

  //Send the proper header information along with the request
  http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
  if (type == "ExpressionJSON" || type == "JSON") {
    http.onreadystatechange = function() {//Call a function when the state changes.
      if(http.readyState == 4 && http.status == 200) {
       
        // http.responseText will be anything that the server return
        promise(JSON.parse(http.responseText));
        
      }
    };
  } else {
    http.onreadystatechange = function() {//Call a function when the state changes.
      if(http.readyState == 4 && http.status == 200) {
  
        // http.responseText will be anything that the server return
        promise(http.responseText);
        
      }
    };
  }

 
  http.send(null);
}

function WSPHttpQuery(command, promise, type = "String") {
  var http = new XMLHttpRequest();
  var url = 'http://'+window.location.hostname+':'+window.location.port+'/utils/query.wsp';
  var params = 'command='+encodeURI(command)+'&type='+type;

  console.log(params);
  http.open('GET', url+"?"+params, true);

  //Send the proper header information along with the request
  http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
  if (type == "ExpressionJSON" || type == "JSON") {
    http.onreadystatechange = function() {//Call a function when the state changes.
      if(http.readyState == 4 && http.status == 200) {
        console.log("RESP: " + http.responseText);
        // http.responseText will be anything that the server return
        promise(JSON.parse(http.responseText));
        document.getElementById('logoFlames').style = "display: none";
        document.getElementById('bigFlames').style = "opacity: 0";
        
      }
    };
  } else {
    http.onreadystatechange = function() {//Call a function when the state changes.
      if(http.readyState == 4 && http.status == 200) {
        console.log("RESP: " + http.responseText);
  
        // http.responseText will be anything that the server return
        promise(http.responseText);
        document.getElementById('logoFlames').style = "display: none";
        document.getElementById('bigFlames').style = "opacity: 0";
      }
    };
  }

  document.getElementById('logoFlames').style = "display: block";
  document.getElementById('bigFlames').style = "opacity: 0.1";
  http.send(null);
}

function WSPHttpBigQuery(command, promise, type = "String") {

    var url = 'http://'+window.location.hostname+':'+window.location.port+'/utils/post.wsp';

    const formData = new FormData();
    formData.append('command', command);


    const request = new XMLHttpRequest();
    request.open("POST", url);
    request.send(formData);

    promise("OK");
}