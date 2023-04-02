import rangeSlider from 'range-slider-input';

core.WEBSlider = function(args, env) {
    let eventuid = interpretate(args[0], env);
    let range    = interpretate(args[1], env);

    console.log('range');
    console.log(range);

    env.element.classList.add('web-slider');

    rangeSlider(env.element, {
        min: range[0], 
        max: range[1],
        step: range[2],
        value: [range[0], range[0]],
        thumbsDisabled: [true, false],
        rangeSlideDisabled: true,
        onInput: (value, userInteraction) => {
            console.log(value);
            core.FireEvent(["'"+eventuid+"'", value[1]]);
        }
    });    
}

core.WEBSlider.update = () => {}
core.WEBSlider.destroy = () => {}

core.WEBInputField = function(args, env) {
    let eventuid = interpretate(args[0], env);
    let value    = interpretate(args[1], env);

    const input = document.createElement('input');
    input.type = 'text';
    input.value = value;

    env.element.appendChild(input);

    input.addEventListener('input', (e)=>{
        core.FireEvent(["'"+eventuid+"'", "'"+input.value+"'"]); 
    });    
}

core.WEBInputField.destroy = () => {}

core.Panel = function(args, env) {

    const objects = interpretate(args[0], {...env, hold:true});
    console.log(objects);
    console.log(env);

    const wrapper = document.createElement('div');
    wrapper.classList.add('panel');
    env.element.appendChild(wrapper);

    objects.forEach((e)=>{
        const child = document.createElement('div');
        child.classList.add('child');

        interpretate(e, {...env, element: child});
        wrapper.appendChild(child);
    });

}

core.Panel.update = (args, env) => { /* just go to the inner three */ interpretate(args[0], env) }
core.Panel.destroy = (args, env) => { /* just go to the inner three */ interpretate(args[0], env) }