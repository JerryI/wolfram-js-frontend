core.HTMLForm = function (args, env) {
    let options;
    options.Method = "innerHTML"; 
    if (args.length > 1) options = core._getRules(args, env);
    console.log('options');
    console.log(options);

    switch(options.Method) {
        case "Full":
            setInnerHTML(env.element, interpretate(args[0], env));
        break;

        case "innerHTML":
            env.element.innerHTML = interpretate(args[0], env);
        break;

        case "innerText":
            env.element.innerText = interpretate(args[0], env);
        break;
    }    

    env.local.Method = options.Method;
}

core.HTMLForm.update = (args, env) => {
    switch(env.local.Method) {
        case "Full":
            setInnerHTML(env.element, interpretate(args[0], env));
        break;

        case "innerHTML":
            env.element.innerHTML = interpretate(args[0], env);
        break;

        case "innerText":
            env.element.innerText = interpretate(args[0], env);
        break;
    }    

    env.local.Method = options.Method;    
}

core.HTMLForm.destroy = () => {}