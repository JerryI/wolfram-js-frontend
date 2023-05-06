
core.RangeView = function(args, env) {
    let uid = interpretate(args[0], env);
    let range    = interpretate(args[1], env);

    let label = '';
    if (args.length > 2) {
        label = interpretate(args[2], env);
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

    enumber.addEventListener('input', (e)=>{
        server.emitt(uid, enumber.value);
        erange.value = enumber.value;
    });

    erange.addEventListener('input', (e)=>{
        server.emitt(uid, erange.value);
        enumber.value = erange.value;
    });       
}



core.RangeView.update = () => {}
core.RangeView.destroy = () => {}


core.ButtonView = function(args, env) {
    let uid = interpretate(args[0], env);

    let label = `Click me`;
    if (args.length > 1) label = interpretate(args[1], env);

    env.element.innerHTML = `<form class="oi-button"><button>${label}</button></form>`;

    env.element.children[0].children[0].addEventListener('click', (e)=>{
        e.preventDefault();
        server.emitt(uid, 'True');
    });

}

core.ButtonView.update = () => {}
core.ButtonView.destroy = () => {}

core.ToggleView = function(args, env) {
    let uid = interpretate(args[0], env);
    const initial = interpretate(args[1], env);

    let checked = '';
    if (initial) checked = 'checked';

    console.log('initial: ');
    console.log(initial);

    let label = '';
    if (args.length > 2) label = interpretate(args[2], env);

    let str = `<form class="oi-toggle">`;
    if (label.length > 0) str += `<label for="oi-toggle-${uid}">${label}</label>`;
    str += `<input class="oi-toggle-input" type="checkbox" name="input" id="oi-toggle-${uid}" ${checked}></form>`;

    env.element.innerHTML = str;

    const box = env.element.children[0].children[env.element.children[0].length - 1];
    box.addEventListener('change', ()=>{
        if (this.checked)
            server.emitt(uid, 'True');
        else
            server.emitt(uid, 'False')
    });

}

core.ToggleView.update = () => {}
core.ToggleView.destroy = () => {}


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