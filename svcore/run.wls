Import["https://raw.githubusercontent.com/JerryI/tcp-mathematica/main/JTP/JTP.wl"];
(*import shared libraries*)
Import/@FileNames["*.wls", "shared"];

(*only for the SVCORE*)
Import["svcore/lib.wls"];

(*definitions*)
MEMORYLimit = 200 1024 1024;

kitchen = (JTPClient@@Uncompress[$kitchen]) // JTPClientStart;

eventlistener = JTPServer[] // JTPServerStart;
eventlistener["promise"] = Null;

$data = With[{uid = $id, eengine = List["host" -> eventlistener["host"], "port" -> eventlistener["port"]]},
    JTPClientEvaluate[kitchen, ProcessCheckIn[uid, eengine]]
];

$Die := With[{uid = $id, l = Flatten[logs]},
    JTPClientEvaluate[kitchen, ProcessCheckOut[uid, l]];
    Exit[];
];

$Messages = {OpenWrite[Method -> "Toast"]};

$data["prolog"]//ReleaseHold;

With[{symbol = Symbol[#["symbol"]], val = #["value"]}, Set[symbol, val]] &/@ $data["init"];

If[MemoryConstrained[Import[$data["task"]], MEMORYLimit] === $Aborted, PushNotification["svcore/run/import", "<span style=\"badge badge-danger\">Memory limit was exeeded</span>"]; $Die];

$data["epilog"]//ReleaseHold;

While[True, 
    (Block[{This := $loop[#]}, If[MemoryConstrained[$loop[#, "expression"]//ReleaseHold, MEMORYLimit] === $Aborted, PushNotification["svcore/run/loop", "<span style=\"badge badge-danger\">Memory limit was exeeded</span>"] ] ]; $loop[#] = .) &/@ Keys@$loop;
    Pause[0.1];
];

PushNotification["svcore/run/loop", "<span style=\"badge badge-danger\">loop error</span> unwanted exit of the loop. Restarting the loop"];

While[True, 
    (Block[{This := $loop[#]}, If[MemoryConstrained[$loop[#, "expression"]//ReleaseHold, MEMORYLimit] === $Aborted, PushNotification["svcore/run/loop", "<span style=\"badge badge-danger\">Memory limit was exeeded</span>"] ] ]; $loop[#] = .) &/@ Keys@$loop;
    Pause[0.1];
];

PushNotification["svcore/run/loop", "<span style=\"badge badge-danger\">loop error</span> bye"];

$Die;





