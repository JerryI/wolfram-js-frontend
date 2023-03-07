import rangeSlider from 'range-slider-input';

core.WEBSlider = function(args, env) {
    let eventuid = interpretate(args[0], env);
    let range    = interpretate(args[1], env);

    env.element.classList.add('web-slider');

    rangeSlider(env.element, {
        value: [range[0], range[1]],
        step: range[2],
        thumbsDisabled: [true, false],
        rangeSlideDisabled: true,
        onInput: (value, userInteraction) => {
            console.log(value);
            core.FireEvent(["'"+eventuid+"'", value[1]]);
        }
    });    
}