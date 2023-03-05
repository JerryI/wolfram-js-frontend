
var Plotly = require('plotly.js-dist');

core.WListPlotly = function(args, env) {
    const arr = interpretate(args[0], env);
    console.log(arr);

    let newarr = [];
    arr.forEach(element => {
        newarr.push({x: element[0], y: element[1]}); 
    });

    if (env.update === 'data') {
      console.log('UPDATE DATA');

      Plotly.animate(env.element, {
        data: newarr,
      }, {
        transition: {
          duration: 100,
          easing: 'cubic-in-out'
        },
        frame: {
          duration: 100
        }
      });     
      return;
    }

    Plotly.newPlot(env.element, newarr, {autosize: false, width: 500, height: 300, margin: {
        l: 30,
        r: 30,
        b: 30,
        t: 30,
        pad: 4
      }});
  }  
  
  core.WListContourPlotly = function(args, env) {
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
