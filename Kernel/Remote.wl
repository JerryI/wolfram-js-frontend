
BeginPackage["JerryI`WolframJSFrontend`Remote`", {"JTP`"}]; 

ConnectToMaster::usage = "Connects to the master-kernel"
SendToMaster::usage = "Send evaluated the data inside the callback to the master kernel"

Begin["`Private`"]; 

master = Null;

Options[ConnectToMaster] = {"PingCheck"->False};

ConnectToMaster[params_List, OptionsPattern[]] := (
    master = (JTPClient@@params) // JTPClientStart;
    master["promise"] = Null;
    JTPClientEvaluateAsync[master, Global`LocalKernel["Started"]];

    SessionSubmit[ScheduledTask[JTPClientEvaluateAsync[master, Global`LocalKernel["Pong"]], Quantity[1, "Seconds"]]]
);

SendToMaster[cbk_][args__] := JTPClientEvaluateAsync[master, cbk[args]];

WebSocketPublish[] := Null;

End[];
EndPackage[];