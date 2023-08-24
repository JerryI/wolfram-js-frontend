const logger = document.getElementById('log');

window.electronAPI.handleLogs((event, value, color) => {
    if (logger.childNodes.length > 500) {
        let i = 0;
        while (logger.firstChild && i < 100) {
            i++;
            logger.removeChild(logger.firstChild);
        }
    }

    const el = document.createElement('span');
    el.innerText = value;
    if (color) {
        el.style.color = color.replace('red', '#CD5C5C');
    }
    logger.appendChild(el);
    logger.scrollTo({
        top: logger.scrollHeight,
        behavior: 'smooth'
    });
});

window.electronAPI.addPromt((event, id) => {

    const el = document.createElement('input');
    el.type = "text";
    el.style.width = "80vw";
    el.style.lineHeight = "1em";
    el.style.fontWeight = "600";
    el.style.marginTop = "0.5em";
    el.style.color = "gray";

    el.addEventListener('keypress', (event) => {
        if(event.key === 'Enter') {
            event.preventDefault();
            alert("Oki-doki"); 
            window.electronAPI.resolveInput(id, el.value);
            el.remove();       
        }
    });

    logger.appendChild(el);
    
    el.focus();
    logger.scrollTo({
        top: logger.scrollHeight,
        behavior: 'smooth'
    });
});


window.electronAPI.addDialog((event, id) => {

    const el1 = document.createElement('input');
    el1.type = "button";
    el1.value = "Yes";
    el1.style.lineHeight = "1em";
    el1.style.fontWeight = "600";
    el1.style.marginTop = "0.5em";
    el1.style.color = "gray";

    el1.addEventListener('click', (event) => {
        window.electronAPI.resolveInput(id, true);
        el2.remove();  
        el1.remove(); 
    });

    logger.appendChild(el1);



    const el2 = document.createElement('input');
    el2.type = "button";
    el2.value = "No";
    el2.style.lineHeight = "1em";
    el2.style.fontWeight = "600";
    el2.style.marginTop = "0.5em";
    el2.style.color = "gray";

    el2.addEventListener('click', (event) => {
        window.electronAPI.resolveInput(id, false);
        el2.remove();  
        el1.remove();
    });

    logger.appendChild(el2);

    logger.scrollTo({
        top: logger.scrollHeight,
        behavior: 'smooth'
    });

});