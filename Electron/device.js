window.electronAPI.load((ev, data) => {
    console.warn({ev, data});
    const ul = document.getElementById('list');
    if (data.list.length > 0) ul.innerHTML = '';

    data.list.forEach((el) => {
        const li = documet.createElement('li');
        const button = document.createElement('button');
        button.classList.add('px-2', 'py-1.5');
        button.innerText = el.name;
        button.addEventListener('click', () => {
            window.electronAPI.choise(el.id);
        });
        li.appendChild(button);
        ul.appendChild(li);
    });
})