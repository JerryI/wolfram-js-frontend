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
