
BeginPackage["JerryI`WolframJSFrontend`Remote`", {"JTP`"}]; 

ConnectToMaster::usage = "Connects to the master-kernel"
SendToMaster::usage = "Send evaluated the data inside the callback to the master kernel"

Begin["`Private`"]; 

master = Null;

ConnectToMaster[params_List] := (
    master = (JTPClient@@params) // JTPClientStart;
    master["promise"] = Null;
    JTPClientEvaluateAsync[master, Global`LocalKernel["Started"]];

    SessionSubmit[ScheduledTask[JTPClientEvaluateAsync[master, Global`LocalKernel["Pong"]], Quantity[0.5, "Seconds"]]]
);

SendToMaster[cbk_][args__] := JTPClientEvaluateAsync[master, cbk[args]];

End[];
EndPackage[];