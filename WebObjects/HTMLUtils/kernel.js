core.HTMLForm = function (args, env) {
    setInnerHTML(env.element, interpretate(args[0]));
}

core.HTMLForm.destroy = () => {}