core.HTMLForm = async function (args, env) {
    let options = {};
    options.Method = "innerHTML"; 
    if (args.length > 1) options = core._getRules(args, env);
    env.local.Method = options.Method;
    console.log('options');
    console.log(options);

    const data = await interpretate(args[0], env);

    switch(options.Method) {
        case "Full":
            setInnerHTML(env.element, data);
        break;

        case "innerHTML":
            env.element.innerHTML = data;
        break;

        case "innerText":
            env.element.innerText = data;
        break;
    }    

    
}

core.Alert = (args, env) => {
    alert(interpretate(args[0], env));
}

core.HTMLForm.update = async (args, env) => {
    console.log('HTMLFrom update');
    console.log(env);
    const method = env.local.Method;

    const data = await interpretate(args[0], env);

    switch(method) {
        case "Full":
            setInnerHTML(env.element, data);
        break;

        case "innerHTML":
            env.element.innerHTML = data;
        break;

        case "innerText":
            env.element.innerText = data;
        break;
    }    
}

core.HTMLForm.destroy = (args, env) => {/* just go to the inner three */ interpretate(args[0], env)}

core.TextForm = async function (args, env) {
    const data = await interpretate(args[0], env);
    env.element.innerText = data;
}

core.TextForm.update = async (args, env) => {
    const data = await interpretate(args[0], env);
    env.element.innerText = data;   
}

core.TextForm.destroy = (args, env) => {/* just go to the inner three */ interpretate(args[0], env)}