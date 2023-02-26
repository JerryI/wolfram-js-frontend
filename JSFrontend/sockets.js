let socket;
const wsconnected = new Event("wsconnected");

socket = new WebSocket("ws://"+window.location.hostname+':'+window.location.port);
socket.onopen = function(e) {
  console.log("[open] Соединение установлено");
  window.dispatchEvent(wsconnected);
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