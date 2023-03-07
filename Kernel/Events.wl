
BeginPackage["JerryI`WolframJSFrontend`Events`"]; 

EventBind::usage = " "
EventObject::usage = " "
EmittedEvent::usage = " "
EventHandlers::usage = " "

Begin["`Private`"]; 


EventBind[EventObject[assoc_], handler_] ^:= (EventHandlers[assoc["id"] ] = handler);
EmittedEvent[id_, data_] := EventHandlers[id][data];

End[];

EndPackage[];

