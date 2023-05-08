core.FormatedTable = async (args, env) => {
    let str = `<form class="oi-formattedtable" style="max-height: 274px;">
        <table style="table-layout: fixed;">`;
    const options = core._getRules(args, env);
    
    if (options.Heading) {
        str += `<thead><tr>`;
        options.Heading.forEach((el)=>{
            str += `<th title="${el}"><span></span>${el}</th>`;
        });
        str += `</tr></thead>`;
    }

    const data = await interpretate(args[0], env);
    str += `<tbody>`;

    data.forEach((row)=>{
        str += `<tr>`;
        row.forEach((col)=>{
            str += `<td>${col}</td>`;
        });
        str += `</tr>`;
    });

    str += `</tbody></table></form>`;
   
    env.element.innerHTML = str;
}

core.FromattedTable.update = core.FromattedTable;
core.FromattedTable.destroy = (args, env) => { interpretate(args[0], env) };