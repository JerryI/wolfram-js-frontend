NullQ[x_]:=TrueQ[x == Null];

CEval[exp_] := JTPClientEvaluate[kitchen, exp];
SetAttributes[CEval, HoldAll];

PushNotification[x_,y_] := JTPClientEvaluate[kitchen, PushNotification[x,y]];

LoopBack[obj_] := JTPClientEvaluate[kitchen, obj];
SetAttributes[LoopBack, HoldAll];

EventBind[type_, handler_] := (EventHandlers[type] = handler);
EmittedEvent[type_, cli_, data_] := With[{err=MemoryConstrained[EventHandlers[type][cli, data], MEMORYLimit]}, If[err === $Aborted, PushNotification["svcore/lib/eventemitt", StringTemplate["<span style=\"badge badge-danger\">Event handler failed</span> <i>``</i>."]["Out of Memory"] ]; ] ];

WebSocketSend[cli_, data_] := JTPClientEvaluate[kitchen, Tinyweb`WebSocketSend[cli, data]];
WebSocketPublish[exp_, chan_] := JTPClientEvaluate[kitchen, Tinyweb`WebSocketPublish[server, exp, chan]];
WebSocketBroadcast[exp_] := JTPClientEvaluate[kitchen, Tinyweb`WebSocketBroadcast[server, exp]];

logs = {};

console["log", message_, args___] := (logs = {logs, StringTemplate[message][args]});

$loop = <||>;
LoopSubmit[task_] := With[{uid = CreateUUID[]}, 

    $loop[uid] = <| "expression" -> Hold[task],
                    "time" -> Now,
                    "status" -> "running"
                |>;
  
    LoopTask[uid]
];

Unprotect[TaskAbort];
TaskAbort[LoopTask[uid_]] := ($loop[uid, "status"] = "aborted");

SetAttributes[LoopSubmit, HoldFirst];

DefineOutputStreamMethod[
  "Toast", {"ConstructorFunction" -> 
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
        
        PushNotification["svcore", "<span style=\"color:red\">"<>ByteArrayToString[out // ByteArray]<>"</span>"];
        {Length@bytes, state}]]]]}
];

