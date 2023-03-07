
var Plotly = require('plotly.js-dist');

function arrDepth(arr) {
  if (arr[0].length === undefined)        return 1;
  if (arr[0][0].length === undefined)     return 2;
  if (arr[0][0][0].length === undefined)  return 3;
}

core.ListLinePlotly = function(args, env) {
    env.numerical = true;
    const arr = interpretate(args[0], env);
    console.log(arr);
    let newarr = [];

    switch(arrDepth(arr)) {
      case 1:
        newarr.push({y: arr});
      break;
      case 2:
        arr.forEach(element => {
          newarr.push({y: element}); 
        });
      break;
      case 3:
        arr.forEach(element => {
          newarr.push({x: element[0], y: element[1]}); 
        });
      break;      
    }

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
