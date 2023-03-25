
BeginPackage["JerryI`WolframJSFrontend`Remote`", {"JTP`"}]; 

(* 
    ::Only for SECONDARY kernel::

    A remote/local kernel essential package
    used to communicate with a master kernel and evaluation
*)

ConnectToMaster::usage = "Connects to the master-kernel"
SendToMaster::usage = "Send evaluated the data inside the callback to the master kernel"

AttachNotebook::usage = "add the notebook id"
SendToFrontEnd::usage = "send to frontend directly, if the notebook id is known"

AskMaster::usage = "send expr to master and wait for the result"

Begin["`Private`"]; 

master = Null;
mastersync = Null;
notebook = Null;
path = Null;
oldpath = Null;

Options[ConnectToMaster] = {"PingCheck"->False};

AskMaster[expr_] := With[{n = notebook}, JTPClientEvaluate[mastersync, expr[n]] ];

ConnectToMaster[params_List, OptionsPattern[]] := (


    stream = OpenWrite["kernel.log", FormatType -> OutputForm];
    $Output = {stream};

    master = (JTPClient@@params) // JTPClientStart;
    JTPClientStartListening[master];

    mastersync = (JTPClient@@params) // JTPClientStart;

    (* update the status on the master kernel *)
    JTPClientEvaluateAsyncNoReply[master, Global`LocalKernel["Started"]];

    (*SessionSubmit[ScheduledTask[        
        (* JTPClientEvaluateAsyncNoReply[master, Global`LocalKernel["Pong"]] *), Quantity[1, "Seconds"]]]*)
);

(* might be slow on converting to JSON *)
SendToFrontEnd[expr_] := With[{i = notebook, e = ExportString[expr, "ExpressionJSON", "Compact" -> -1]}, JTPClientEvaluateAsyncNoReply[master, Global`NotebookFrontEndSend[i][ e ] ] ];

SendToMaster[cbk_][args__] := JTPClientEvaluateAsyncNoReply[master, cbk[args]];

AttachNotebook[id_, path_] := (Print["Notebook "<>id<>" attached!"];  notebook = id; SetDirectory[path]);

End[];
EndPackage[];