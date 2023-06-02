
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

FrontSubmit::usage = "alias to SendToFrontEnd"

AskMaster::usage = "send expr to master and wait for the result"

MasterResolvePromise::usage = "resolve promise"

$ExtendDefinitions::usage = "extend defs"

Begin["`Private`"]; 

master = Null;
mastersync = Null;
notebook = Null;
path = Null;
oldpath = Null;

Unprotect[NotebookDirectory];
ClearAll[NotebookDirectory];
NotebookDirectory[]

Options[ConnectToMaster] = {"PingCheck"->False};

AskMaster[expr_] := With[{n = notebook}, JTPClientEvaluate[mastersync, expr[n]] ];

MasterResolvePromise[expr_][uid_] := With[{res = expr//ReleaseHold},
  JTPClientEvaluateAsyncNoReply[master, Global`LocalKernelPromiseResolve[uid, res]];
]

ConnectToMaster[params_List, OptionsPattern[]] := (

    master = (JTPClient@@params) // JTPClientStart;
    JTPClientStartListening[master];

    mastersync = (JTPClient@@params) // JTPClientStart;

    (* update the status on the master kernel *)
    JTPClientEvaluateAsyncNoReply[master, Global`LocalKernel["Started"]];

    (*SessionSubmit[ScheduledTask[        
        (* JTPClientEvaluateAsyncNoReply[master, Global`LocalKernel["Pong"]] *), Quantity[1, "Seconds"]]]*)
);

(* might be slow on converting to JSON *)
(* we neeed to use Compress instead *)
SendToFrontEnd[expr_] := With[{i = notebook, e = ExportString[expr, "ExpressionJSON", "Compact" -> -1]}, JTPClientEvaluateAsyncNoReply[master, Global`NotebookFrontEndSend[i][ e ] ] ];

FrontSubmit = SendToFrontEnd

SendToMaster[cbk_][args__] := JTPClientEvaluateAsyncNoReply[master, cbk[args]];

$ExtendDefinitions[uid_, defs_] := With[{id = notebook}, 
Print["a query to extend sent for "<>id];
JTPClientEvaluateAsyncNoReply[master, Global`NExtendSingleDefinition[uid, defs][id] ] ];

AttachNotebook[id_, path_] := ( notebook = id; SetDirectory[path]; Print["Notebook "<>id<>" attached!"];);

DefineOutputStreamMethod[
  "ToastWarning", {"ConstructorFunction" -> 
    Function[{name, isAppend, caller, opts}, 
     With[{state = Unique["JaBoo"]},
      {True, state}]], 
   "CloseFunction" -> Function[state, ClearAll[state]], 
   "WriteFunction" -> 
    Function[{state, bytes},(*Since we're writing to a cell,
     we don't want that trailing newline.*)
     With[{out = bytes /. {most___, 10} :> FromCharacterCode[{most}]},
       With[{ }, 
       If[out === "", {0, state},
       

        With[{text =ByteArrayToString[out // ByteArray], uid = notebook},
            JTPClientEvaluateAsyncNoReply[master, Global`NotebookEventFire[uid]["Warning"][text] ];
        ];

        {Length@bytes, state}]]]]}
];

DefineOutputStreamMethod[
  "ToastPrint", {"ConstructorFunction" -> 
    Function[{name, isAppend, caller, opts}, 
     With[{state = Unique["JaBoo"]},
      {True, state}]], 
   "CloseFunction" -> Function[state, ClearAll[state]], 
   "WriteFunction" -> 
    Function[{state, bytes},(*Since we're writing to a cell,
     we don't want that trailing newline.*)
     With[{out = bytes /. {most___, 10} :> FromCharacterCode[{most}]},
       With[{ }, 
       If[out === "", {0, state},
       

        With[{text =ToString[out], uid = notebook},
            JTPClientEvaluateAsyncNoReply[master, Global`NotebookEventFire[uid]["Print"][text] ];
        ];

        {Length@bytes, state}]]]]}
];

$Messages = {OpenWrite[Method -> "ToastWarning"]};
$Output = {OpenWrite[Method -> "ToastPrint"]};

End[];
EndPackage[];