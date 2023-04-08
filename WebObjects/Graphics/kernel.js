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

      Plotly.newPlot(env.element, newarr, {autosize: false, width: core.DefaultWidth, height: core.DefaultWidth*0.618034, margin: {
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
                duration: 30
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

      Plotly.newPlot(env.element, newarr, {autosize: false, width: core.DefaultWidth, height: core.DefaultWidth*0.618034, margin: {
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
          duration: 300,
          easing: 'cubic-in-out'
        },
        frame: {
          duration: 300
        }
      });     
    }
    
    core.ListLinePlotly.destroy = ()=>{};
}

{
  let d3 = false;

  let g2d = {};
  g2d.name = "WebObjects/Graphics";

  interpretate.contextExpand(g2d);

  g2d.Graphics = async (args, env) => {
    if (!d3) d3 = await import('d3');

    /**
     * @type {Object}
     */  
    let options = core._getRules(args, env);
    

    if (Object.keys(options).length == 0) 
      options = core._getRules(interpretate(args[1], {...env, hold:true}), env);

    console.log(options);

    /**
     * @type {HTMLElement}
     */
    var container = env.element;

    /**
     * @type {[Number, Number]}
     */
    let ImageSize = options.ImageSize || [core.DefaultWidth, 0.618034*core.DefaultWidth];

    const aspectratio = options.AspectRatio || 0.618034;

    //if only the width is specified
    if (!(ImageSize instanceof Array)) ImageSize = [ImageSize, ImageSize*aspectratio];

    console.log('Image size');
    console.log(ImageSize); 

    let margin = {top: 10, right: 30, bottom: 30, left: 60},
    width = ImageSize[0] - margin.left - margin.right,
    height = ImageSize[1] - margin.top - margin.bottom;

    // append the svg object to the body of the page
    let svg = d3.select(container)
    .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform",
            "translate(" + margin.left + "," + margin.top + ")");
    
    const range = options.PlotRange;

    console.log(range);

    // Add X axis --> it is a date format
    let x = d3.scaleLinear()
      .domain(range[0])
      .range([ 0, width ]);
    
    svg.append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x));

    // Add Y axis
    let y = d3.scaleLinear()
      .domain(range[1])
      .range([ height, 0 ]);
    
      svg.append("g")
      .call(d3.axisLeft(y));   
      
      const envcopy = {
        ...env,
        context: g2d,
        svg: svg,
        xAxis: x,
        yAxis: y,
        numerical: true,
        tostring: false,
        color: 'black',
        opacity: 1,
        strokeWidth: 1.5,
        pointSize: 0.013,
        fill: 'none'
      };   

      interpretate(args[0], envcopy);
  }

  g2d.Graphics.update = (args, env) => {}
  g2d.Graphics.destory = (args, env) => {}

  g2d.AbsoluteThickness = (args, env) => {
    env.strokeWidth = interpretate(args[0], env);
  }

  g2d.PointSize = (args, env) => {
    env.pointSize = interpretate(args[0], env);
  }

  g2d.Annotation = core.List;

  g2d.Directive = (args, env) => {
    args.forEach((el) => {
      interpretate(el, env);
    })
  }

  g2d.Opacity = (args, env) => {
    env.opacity = interpretate(args[0], env);
  }

  g2d.RGBColor = (args, env) => {
    if (args.length == 3) {
      const color = args.map(el => 255*interpretate(el, env));
      env.color = "rgb("+color[0]+","+color[1]+","+color[2]+")";
    } else {
      console.error('g2d: RGBColor must have three arguments!');
    }
  }


  g2d.Line = async (args, env) => {
    const data = await interpretate(args[0], env);
    const x = env.xAxis;
    const y = env.yAxis;

    env.svg.append("path")
      .datum(data)
      .attr("fill", "none")
      .attr("stroke", env.color)
      .attr("stroke-width", env.strokeWidth)
      .attr("d", d3.line()
        .x(function(d) { return x(d[0]) })
        .y(function(d) { return y(d[1]) })
        );
  }

  g2d.Point = async (args, env) => {
    const data = await interpretate(args[0], env);
    const x = env.xAxis;
    const y = env.yAxis;

    env.svg.append('g')
    .selectAll("dot")
    .data(data)
    .enter()
    .append("circle")
      .attr("cx", function (d) { return x(d[0]); } )
      .attr("cy", function (d) { return y(d[1]); } )
      .attr("r", env.pointSize*100)
      .style("fill", env.color)
  }

  //plugs
  g2d.Void = (args, env) => {}

  g2d.Identity              = g2d.Void
  g2d.Automatic             = g2d.Void
  g2d.Scaled                = g2d.Void
  g2d.GoldenRatio           = g2d.Void
  g2d.None                  = g2d.Void
  g2d.GrayLevel             = g2d.Void
  g2d.AbsolutePointSize     = g2d.Void
  g2d.CopiedValueFunction   = g2d.Void

}