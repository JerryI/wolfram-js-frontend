Kernel`HashMap = <||>

init[o_] := With[{uid = CreateUUID[]},
    o["Hash"] = uid;
    Kernel`HashMap[uid] = o;
    o
];

Kernel /: EventHandler[n_Kernel, opts__] := EventHandler[n["Hash"], opts] 
Kernel /: EventFire[n_Kernel, opts__] := EventFire[n["Hash"], opts]
Kernel /: EventRemove[n_Kernel, opts__] := EventRemove[n["Hash"], opts] 

CreateType[Kernel, init, {}]
