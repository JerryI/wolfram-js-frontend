var WSPHost;

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




function WSPGet(path, params, promise) {

  var http = new XMLHttpRequest();
  var url = 'http://'+window.location.hostname+':'+window.location.port+'/'+path;

  http.open('GET', url+"?"+encodeURI(params), true);

  //Send the proper header information along with the request
  http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

  http.onreadystatechange = function() {//Call a function when the state changes.
    if(http.readyState == 4 && http.status == 200) {
  
      // http.responseText will be anything that the server return
      promise(http.responseText);
      document.getElementById('logoFlames').style = "display: none";
      document.getElementById('bigFlames').style = "opacity: 0";
    }
  };

  document.getElementById('logoFlames').style = "display: block";
  document.getElementById('bigFlames').style = "opacity: 0.1";
  http.send(null);
}

function WSPPost(path, payload, promise) {

  var http = new XMLHttpRequest();
  var url = 'http://'+window.location.hostname+':'+window.location.port+'/'+path;

  http.open('POST', url, true);

  //Send the proper header information along with the request
  http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

  http.onreadystatechange = function() {//Call a function when the state changes.
    if(http.readyState == 4 && http.status == 200) {
  
      // http.responseText will be anything that the server return
      promise(http.responseText);
      document.getElementById('logoFlames').style = "display: none";
      document.getElementById('bigFlames').style = "opacity: 0";
    } else {
      console.log(http.readyState + ': code' + 'status: ' + http.status);
    }
  };

  document.getElementById('logoFlames').style = "display: block";
  document.getElementById('bigFlames').style = "opacity: 0.1";
  var data = new FormData();
  data.append('user', 'person');
  data.append('pwd', 'password');

  http.send(data);
}

var modalsLoaded = [];
    
function modalLoad (id, params = "{}") {
  if(!modalsLoaded.includes(id)) {
    console.log("loading modal...");
    WSPHttpQuery('LoadPage["assets/modal/'+id+'.wsp", '+params+']', function(r) {

      var container = document.createElement("div");
      var uid = uuidv4()
      container.id = uid;
      document.getElementById('modals').appendChild(container);

      setInnerHTML(document.getElementById(uid), r);


      $('#'+id).modal('show');
    });

    modalsLoaded.push(id);
  } else {
    $('#'+id).modal('show');
  }

  

};

function killProcess (id) {
  WSPHttpQuery('ProcessKill["'+id+'"]; "killed"', console.log);
}

function restartProcess (id) {
  WSPHttpQuery('ProcessStart["'+id+'"]; "started"', console.log);
}



