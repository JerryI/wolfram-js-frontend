
EmittEvent[id_, data_] := With[{cli = client},
    (* global *)
    EmittedEvent[id, cli, data];
    ( JTPClientSend[settings["processes", #, "listener"], EmittedEvent[id, cli, data]]; ) &/@ Keys[settings["processes"]];
];

EventBind[EventObject[assoc_], handler_] ^:= (EventHandlers[assoc["id"]] = handler);
EmittedEvent[id_, cli_, data_] := EventHandlers[id][cli, data];

TrackedSymbols