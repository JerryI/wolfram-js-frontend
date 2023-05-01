{
    let boxes = {};
    boxes.name = "WebObjects/Boxes";
  
    interpretate.contextExpand(boxes);
  
    boxes.FrameBox = (args, env) => {
        env.element.classList.add('frame-box');
        env.context = boxes;

        const options = core._getRules(args, env) || {};
        
        if ('Background' in options) {
            env.element.style.backgroundColor = env.color;
        }
    }

    boxes.StyleBox = (args, env) => {
        env.context = boxes;
        console.log('style box');
        
        console.log(args);

        const options = core._getRules(args, env) || {};
        
        if ('Background' in options) {
            env.element.style.backgroundColor = env.color;
        }        
    }

    boxes.TemplateBox = (args, env) => {
        env.context = boxes;
        console.log('template box');

        console.log(args);

        const options = core._getRules(args, env) || {};
        
        if ('Background' in options) {
            env.element.style.backgroundColor = env.color;
        }    
    }

    boxes.Opacity = (args, env) => {
        env.opacity = interpretate(args[0], env);
    }
    
    boxes.RGBColor = (args, env) => {
        if (args.length == 3) {
          const color = args.map(el => 255*interpretate(el, env));
          env.color = "rgb("+color[0]+","+color[1]+","+color[2]+")";
        } else {
          console.error('g2d: RGBColor must have three arguments!');
        }
    }
}