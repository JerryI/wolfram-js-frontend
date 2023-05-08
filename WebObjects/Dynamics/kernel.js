//as input and output
core.RangeView = async function(args, env) {
    const uid =   uuidv4();

    const type   = core._typeof(args[0][4], env);
    console.log('data typeof');
    console.log(type);

    let range    = await interpretate(args[0], env);

    range[3] = await range[3];

    const options = core._getRules(args, env);

    let label = '';
    if (options.Label) {
        label = options.Label;
    }

    console.log('range');
    console.log(range);

    //env.element.classList.add('web-slider');
    let str = `<form class="oi-range">`;
    if (label.length > 0) str += `<label for="oi-range-${uid}">${label}</label>`;
    str += `<div class="oi-range-input">
            <input type="number" value="${range[3]}" min="${range[0]}" max="${range[1]}" step="${range[2]}" name="number" required="" id="oi-range-${uid}">
            <input type="range" value="${range[3]}" min="${range[0]}" max="${range[1]}" step="${range[2]}" name="range">
        </div>
    </form>`;

    env.element.innerHTML = str;

    let div = env.element.children[0];
    div = div.children[div.children.length - 1];
    const enumber = div.children[0];
    const erange = div.children[1];

    env.local.enumber = enumber;
    env.local.erange = erange;

    enumber.addEventListener('input', (e)=>{
        erange.value = enumber.value;
    });

    erange.addEventListener('input', (e)=>{
        enumber.value = erange.value;
    }); 

    if (options.Event) {
        const evid = options.Event;

        enumber.addEventListener('input', (e)=>{
            server.emitt(evid, enumber.value);
        });

        erange.addEventListener('input', (e)=>{
            server.emitt(evid, erange.value);
        });  
    } 
    
    
    //mutate FE object
    if (type == 'FrontEndRef') {
        console.log('mutable expression');

        const key = interpretate(args[0][4][1], env);
        console.log('key: ');
        console.log(key);

        enumber.addEventListener('input', (e)=>{
            ObjectHashMap[key].update(Number(enumber.value));
        });

        erange.addEventListener('input', (e)=>{
            ObjectHashMap[key].update(Number(erange.value));
        });        

        //prevent from updating itself
        env.local.preventDefault = true;
    }     
}



core.RangeView.update = async (args, env) => {
    if (env.local.preventDefault) return false;

    let range    = await interpretate(args[0], env);
    console.log('newvalue');
    console.log(range);
    
    env.local.enumber.value = await range[3];
    env.local.erange.value = await range[3];
}

core.RangeView.destroy = (args, env) => { /* propagate further */ interpretate(args[0], env)}

//just as input
core.ButtonView = (args, env) => {
    const options = core._getRules(args, env);

    const uid = options.Event;

    let label = `Click me`;
    if (options.Label) label = options.Label;

    env.element.innerHTML = `<form class="oi-button"><button>${label}</button></form>`;

    env.element.children[0].children[0].addEventListener('click', (e)=>{
        e.preventDefault();
        server.emitt(uid, 'True');
    });

}

core.ButtonView.update = () => {}
core.ButtonView.destroy = () => {}

//as input and output only
core.ToggleView = async (args, env) => {
    const options = core._getRules(args, env);
    const uid =  uuidv4();
    const initial = await interpretate(args[0], env);

    let checked = '';
    if (initial) checked = 'checked';

    console.log('initial: ');
    console.log(initial);

    let label = '';
    if (options.Label) label = options.Label;

    let str = `<form class="oi-toggle">`;
    if (label.length > 0) str += `<label for="oi-toggle-${uid}">${label}</label>`;
    str += `<input class="oi-toggle-input" type="checkbox" name="input" id="oi-toggle-${uid}" ${checked}></form>`;

    env.element.innerHTML = str;

    const box = env.element.children[0].children[env.element.children[0].length - 1];

    env.local.box = box;

    if (options.Event) {
        const evid = options.Event;

        box.addEventListener('change', ()=>{
            if (this.checked)
                server.emitt(evid, 'True');
            else
                server.emitt(evid, 'False')
        });
    }   

}

core.ToggleView.update = async (args, env) => {
    const data = await interpretate(args[0], env);
    env.local.box.checked = data;
}

core.ToggleView.destroy = (args, env) => { /* propagate further */ interpretate(args[0], env)}


core.TextView = async (args, env) => {
    const options = core._getRules(args, env);
    const uid =  uuidv4();

    //detect FE
    const type = core._typeof(args[0], env);
    console.log('data typeof');
    console.log(type);

    const text = await interpretate(args[0], env);

    let str = `<form class="oi-text">`;
    if (options.Title) str += `<div style="font: 700 0.9rem sans-serif; margin-bottom: 3px;">${options.Title}</div>`;
    str += `<input name="input" value="${text}" type="text" autocomplete="off"`;
    if (options.Placeholder) str += ` placeholder="${options.Placeholder}"`;
    str += ` style="font-size: 1em;">`;
    if (options.Describtion) str += `<div style="font-size: 0.85rem; font-style: italic; margin-top: 3px;">${options.Describtion}</div>`;
    str += `</form>`;

    env.element.innerHTML = str;

    const input = env.element.getElementsByTagName('input')[0];
    env.local.input = input;

    if (options.Event) {
        const evid = options.Event;
        

        input.addEventListener('input', ()=>{
            server.emitt(evid, input.value);
        });
    }

    //mutate FE object
    if (type == 'FrontEndRef') {
        console.log('mutable expression');



        const key = interpretate(args[0][1], env);

        console.log('key: ');
        console.log(key);        

        input.addEventListener('input', ()=>{
            ObjectHashMap[key].update(input.value);
        });

        //prevent from updating itself
        env.local.preventDefault = true;
    }
}

core.TextView.update = async (args, env) => {
    if (env.local.preventDefault) return false;

    const text = await interpretate(args[0], env);
    env.local.input.value = text;
}

core.TextView.destroy = (args, env) => { interpretate(args[0], env) }

core.WEBInputField = function(args, env) {
    let eventuid = interpretate(args[0], env);
    let value    = interpretate(args[1], env);

    const input = document.createElement('input');
    input.type = 'text';
    input.value = value;

    env.element.appendChild(input);

    input.addEventListener('input', (e)=>{
        core.FireEvent(["'"+eventuid+"'", "'\""+input.value+"\"'"]); 
    });    

    input.addEventListener('click', (e)=>{
        input.focus();
    });
}

core.WEBInputField.destroy = () => {}

core.Column = function(args, env) {

    const objects = interpretate(args[0], {...env, hold:true});
    console.log(objects);
    console.log(env);

    const wrapper = document.createElement('div');
    wrapper.classList.add('column');
    env.element.appendChild(wrapper);

    objects.forEach((e)=>{
        const child = document.createElement('div');
        child.classList.add('child');

        interpretate(e, {...env, element: child});
        wrapper.appendChild(child);
    });

}

core.Column.update = (args, env) => { /* just go to the inner three */ interpretate(args[0], env) }
core.Column.destroy = (args, env) => { /* just go to the inner three */ interpretate(args[0], env) }