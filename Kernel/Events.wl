
BeginPackage["JerryI`WolframJSFrontend`Events`"]; 

EventBind::usage = " "
EventObject::usage = " "
EmittedEvent::usage = " "
EventHandlers::usage = " "
EventRemove::usage = " "

Begin["`Private`"]; 


EventBind[EventObject[assoc_], handler_] ^:= (EventHandlers[assoc["id"] ] = handler);
EmittedEvent[id_, data_] := EventHandlers[id][data];

EventRemove[EventObject[assoc_]] ^:= (With[{id = assoc["id"]}, Unset[ EventHandlers[id] ] ]);

End[];

EndPackage[];

