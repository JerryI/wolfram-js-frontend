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

EmittedEvent::usage = "internal function called by the frontend to fire an event on a kernel"
EventHandlers::usage = "internal function, which hold the binded function"

Begin["`Private`"]; 


EventBind[EventObject[assoc_], handler_] ^:= (EventHandlers[assoc["id"] ] = handler);
EmittedEvent[id_, data_] := EventHandlers[id][data];

EventRemove[EventObject[assoc_]] ^:= (With[{id = assoc["id"]}, Unset[ EventHandlers[id] ] ]);

End[];

EndPackage[];

