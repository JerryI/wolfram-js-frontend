BeginPackage["JerryI`WolframJSFrontend`Events`"]; 

(* 
    ::Only for SECONDARY kernel::

    A kernel event system package 
    following KISS principle 

    can be extended by other packages
    for example WebObjects/Dynamics -> Slider
*)

EventObject::usage = "a representation of a simple event. can hold an extra information"

EventBind::usage = "bind a function to an EventObject"
EventRemove::usage = "remove the bond from EventObject"

EventsRack::usage = "a union of many events produces a single event object from many"

EmittedEvent::usage = "internal function called by the frontend to fire an event on a kernel"
EventHandlers::usage = "internal function, which hold the binded function"

EventListener::usage = "internal commnd for frontend"

MiddlewareHandler::usage = "internal command"
MiddlewareListener::usage = "internals"

Begin["`Private`"]; 


EventBind[EventObject[assoc_], handler_] ^:= (EventHandlers[assoc["id"] ] = handler;);
(* shotcut *)
EventObject[assoc_][handler_] := (EventHandlers[assoc["id"] ] = handler;);

EmittedEvent[EventObject[assoc_], data_] := EventHandlers[assoc["id"]][data];

EmittedEvent[id_String, data_] := EventHandlers[id][data];

EventRemove[EventObject[assoc_]] ^:= (With[{id = assoc["id"]}, Unset[ EventHandlers[id] ] ]);

(* an union of many events *)
EventsRack[list_] := With[{uid = CreateUUID[]},
    With[{central = Function[data, EmittedEvent[uid, data]]},
        With[{i = #["id"]}, 
            With[{handler = Function[data, central[Rule[i, data]]]},
                EventBind[#, handler] 
            ]
        ] &/@ list;
    ]
    EventObject[<|"id"->uid|>]
]

Unprotect[EventHandler]
ClearAll[EventHandler]
EventHandler[expr_, ev_List] := Module[{eventsList = {}},
    eventsList = With[{func = #[[2]], type = #[[1]], id = CreateUUID[]},
        EventBind[EventObject[<|"id"->id|>], func];
        type -> id
    ]&/@ ev;

    EventListener[expr, (Sequence@@eventsList)]
]

(* better to use this instead of EventBind *)
EventHandler[EventObject[assoc_Association], handler_] ^:= (
    EventHandlers[assoc["id"]] = handler;
    EventObject[assoc]
)

MiddlewareHandler[expr_, ev_Rule, opts___] := With[{id = CreateUUID[], type = ev[[1]], func = ev[[2]]},
    EventBind[EventObject[<|"id"->id|>], func];

    MiddlewareListener[expr, type, id, opts]
]

End[];

EndPackage[];

