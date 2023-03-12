import * as d3 from "d3";

{
  var Plotly = require('plotly.js-dist');

  function arrDepth(arr) {
    if (arr[0].length === undefined)        return 1;
    if (arr[0][0].length === undefined)     return 2;
    if (arr[0][0][0].length === undefined)  return 3;
  }

  function transpose(matrix) {
    for (var i = 0; i < matrix.length; i++) {
      for (var j = 0; j < i; j++) {
        const temp = matrix[i][j];
        matrix[i][j] = matrix[j][i];
        matrix[j][i] = temp;
      }
    }
  }

  core.ListLinePlotly = async function(args, env) {
      env.numerical = true;
      let arr = await interpretate(args[0], env);
      console.log(arr);
      let newarr = [];

      switch(arrDepth(arr)) {
        case 1:
          newarr.push({y: arr});
        break;
        case 2:
          if (arr[0].length === 2) {
            console.log('1 XY plot');
            transpose(arr);
      
            newarr.push({x: arr[0], y: arr[1]});
          } else {
            console.log('multiple Y plot');
            arr.forEach(element => {
              newarr.push({y: element}); 
            });
          }
        break;
        case 3:
          arr.forEach(element => {
            let newEl = element;
            transpose(newEl);
            newarr.push({x: newEl[0], y: newEl[1]}); 
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
}