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

core.WListContourPloty = function(args, env) {
  const data = interpretate(args[0], env);
  Plotly.newPlot(env.element, [{z:data[2], x:data[0], y:data[1], type: 'contour'}],
  {autosize: false, width: 500, height: 300, margin: {
    l: 30,
    r: 30,
    b: 30,
    t: 30,
    pad: 4
  }});

} 

//TableView
core.TableForm = function(args, env) {
  const table = document.createElement('table');
  table.classList.add("table");
  table.classList.add("table-sm");

  const list = interpretate(args[0], {...env, hold:true});

  // create a few data rows 
  for (var i = 0; i < list.length; i++) {
    const dataRow = document.createElement("tr");
    const row = interpretate(list[i], {...env, hold:true});

    for (var j = 0; j < row.length; j++) {
      const dataCell = document.createElement("td");
      const data = interpretate(row[j], {...env, todom:true, element: dataCell});

      dataRow.appendChild(dataCell);
    }


    table.appendChild(dataRow);
  }  

  env.element.appendChild(table);
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






