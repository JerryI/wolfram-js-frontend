{
  let Plotly = false;

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
 
  core.ListPlotly = async function(args, env) {
      if (!Plotly) Plotly = await import('plotly.js-dist-min');
 
      env.numerical = true;
      let arr = await interpretate(args[0], env);
      let newarr = [];

      let options = {};
      if (args.length > 1) options = core._getRules(args, env);

      console.log('options');
      console.log(options);

      switch(arrDepth(arr)) {
        case 1:
          newarr.push({y: arr, mode: 'markers'});
        break;
        case 2:
          if (arr[0].length === 2) {
            console.log('1 XY plot');
            transpose(arr);
      
            newarr.push({x: arr[0], y: arr[1], mode: 'markers'});
          } else {
            console.log('multiple Y plot');
            arr.forEach(element => {
              newarr.push({y: element, mode: 'markers'}); 
            });
          }
        break;
        case 3:
          arr.forEach(element => {
            let newEl = element;
            transpose(newEl);
            newarr.push({x: newEl[0], y: newEl[1], mode: 'markers'}); 
          });
        break;      
      }

      Plotly.newPlot(env.element, newarr, {autosize: false, width: 500, height: 300, margin: {
          l: 30,
          r: 30,
          b: 30,
          t: 30,
          pad: 4
        }});
      
      if (!('RequestAnimationFrame' in options)) return;
      
          console.log('request animation frame mode');
          const list = options.RequestAnimationFrame;
          const event = list[0];
          const symbol = list[1];
          const depth = arrDepth(arr);
          
          const request = function() {
            core.FireEvent(["'"+event+"'", 0]);
          }

          const renderer = function(args2, env2) {
            let arr2 = interpretate(args2[0], env2);
            let newarr2 = [];
      
            switch(depth) {
              case 1:
                newarr2.push({y: arr2});
              break;
              case 2:
                if (arr2[0].length === 2) {
                 
                  transpose(arr2);
            
                  newarr2.push({x: arr2[0], y: arr2[1]});
                } else {
         
                  arr2.forEach(element => {
                    newarr2.push({y: element}); 
                  });
                }
              break;
              case 3:
                arr2.forEach(element => {
                  let newEl = element;
                  transpose(newEl);
                  newarr2.push({x: newEl[0], y: newEl[1]}); 
                });
              break;      
            }

            Plotly.animate(env.element, {
              data: newarr2
            }, {
              transition: {
                duration: 0
              },
              frame: {
                duration: 0,
                redraw: false
              }
            });

            requestAnimationFrame(request);
          } 

          core[symbol] = renderer;
          request();
    }

    core.ListPlotly.destroy = ()=>{};
    
    core.ListLinePlotly = async function(args, env) {
      if (!Plotly) Plotly = await import('plotly.js-dist-min');
      console.log('listlineplot: getting the data...');
      env.numerical = true;
      let arr = await interpretate(args[0], env);
      console.log('listlineplot: got the data...');
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

      Plotly.newPlot(env.element, newarr, {autosize: false, width: 500, height: 300, margin: {
          l: 30,
          r: 30,
          b: 30,
          t: 30,
          pad: 4
        }});  
    }   

    core.ListLinePlotly.update = async (args, env) => {
      env.numerical = true;
      console.log('listlineplot: update: ');
      console.log(args);
      console.log('interpretate!');
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

      console.log("plotly with a new data: ");
      console.log(newarr);
      console.log("env");
      console.log(env);

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
    }
    
    core.ListLinePlotly.destroy = ()=>{};

    core.WListContourPlotly = async function(args, env) {
      if (!Plotly) Plotly = await import('plotly.js-dist-min');

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