core.HTMLForm = function (args, env) {
    setInnerHTML(env.element, interpretate(args[0]));
}

//extensions

//2D Plot using Ploty.js
core.WListPloty = function(args, env) {
  const arr = JSON.parse(interpretate(args[0]));
  console.log("Ploty.js");
  console.log(arr);
  let newarr = [];
  arr.forEach(element => {
      newarr.push({x: element[0], y: element[1]});
  });
  Plotly.newPlot(env.element, newarr, {autosize: false, width: 500, height: 300, margin: {
      l: 30,
      r: 30,
      b: 30,
      t: 30,
      pad: 4
    }});
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






