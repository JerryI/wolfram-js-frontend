
BeginPackage["JerryI`WolframJSFrontend`Remote`", {"JTP`"}]; 

ConnectToMaster::usage = "Connects to the master-kernel"
SendToMaster::usage = "Send evaluated the data inside the callback to the master kernel"

AttachNotebook::usage = "add notebook id"

SendToFrontEnd::usage = "send to frontend"

Begin["`Private`"]; 

master = Null;
notebook = Null;

Options[ConnectToMaster] = {"PingCheck"->False};

ConnectToMaster[params_List, OptionsPattern[]] := (
    stream = OpenWrite["kernel.log", FormatType -> OutputForm];
    $Output = {stream};

    master = (JTPClient@@params) // JTPClientStart;
    master["promise"] = Print;

    JTPClientEvaluateAsync[master, Global`LocalKernel["Started"]];

    SessionSubmit[ScheduledTask[JTPClientEvaluateAsync[master, Global`LocalKernel["Pong"]], Quantity[1, "Seconds"]]]
);

(* might be slow on converting to JSON *)
SendToFrontEnd[expr_] := With[{i = notebook, e = ExportString[expr, "ExpressionJSON"]}, JTPClientEvaluateAsync[master, Global`NotebookFrontEndSend[i][ e ] ] ];

SendToMaster[cbk_][args__] := JTPClientEvaluateAsync[master, cbk[args]];

AttachNotebook[id_] := (Print["Notebook "<>id<>" attached!"]; notebook = id);

End[];
EndPackage[];