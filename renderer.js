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