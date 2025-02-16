window.electronAPI.load((ev, data) => {
    console.warn({ev, data});
    const ul = document.getElementById('list');
    if (data.list.length > 0) ul.innerHTML = '';

    data.list.forEach((el) => {
        const li = document.createElement('li');
        li.classList.add(...('bg-gray-100/50 dark:bg-gray-600/50 text-xs items-center px-4 py-1.5 outline-gray-400 outline-offset-2 ring-1 text-gray-800 ring-inset ring-gray-300 dark:ring-gray-400 hover:outline outline-1 placeholder:text-gray-400 rounded-md dark:text-gray-400'.split(' ')));
        const button = document.createElement('button');
        button.classList.add('h-full', 'w-full');
        button.innerText = el.name;
        button.addEventListener('click', () => {
            window.electronAPI.choise(el.id);
        });
        li.appendChild(button);
        ul.appendChild(li);
    });
})