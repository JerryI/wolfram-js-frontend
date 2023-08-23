const logger = document.getElementById('log');

window.electronAPI.handleLogs((event, value) => {
    const el = document.createElement('span');
    el.innerText = value;
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
    el.style.color = "black";

    el.addEventListener('keypress', (event) => {
        if(event.key === 'Enter') {
            event.preventDefault();
            alert("Thanks!"); 
            window.electronAPI.resolveInput(id, el.value);
            el.remove();       
        }
    });

    logger.appendChild(el);
    
    el.focus();
});