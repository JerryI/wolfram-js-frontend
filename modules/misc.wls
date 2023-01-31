Print[">> Shared Libs V1"];

ShutDown := With[{}, 
    console["log", "stopping all tasks..."];
    PushNotification["modules/misc/shutdown", "Server was down"];
    TaskRemove/@Values@CronTasks; 
    CBackup;
    DeleteFile["running.lock"];
    console["log", "bye"];
    Exit[-1];
];	

console["memory stat"] := (
  settings["memory"]={settings["memory"], Round[MemoryInUse[]/1024,1]/1024//N}//Flatten;
);



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
      {True, state}] ], 
   "CloseFunction" -> Function[state, ClearAll[state] ], 
   "WriteFunction" -> 
    Function[{state, bytes},(*Since we're writing to a cell,
     we don't want that trailing newline.*)
     With[{out = bytes /. {most___, 10} :> FromCharacterCode[{most}]},
       With[{ }, 
       If[out === "", {0, state},
        
        PushNotification["system", "<span style=\"color:red\">"<>ByteArrayToString[out // ByteArray]<>"</span>"];
        StringTemplate["<*Now*>"][] >>> "warnings.log";
        ByteArrayToString[out // ByteArray] >>> "warnings.log";

        {Length@bytes, state}] ] ] ]}
];

Forecast := PushNotification["modules/misc/weather", 
  StringDrop[(StringJoin@(StringTemplate["`` ```` C<br>"][
       CityData[#, "Name"], 
       With[{temp = 
          WeatherForecastData[#, "MaxTemperature"]["FirstValue"][[1]]},
        If[temp < 1, "&#10052;", 
         If[temp > 25, "&#127774;", "&#9925;"]]
        ], 
       WeatherForecastData[#, "MaxTemperature"][
         "FirstValue"][[1]]] & /@ (GeoNearest[Entity["City"], Here, 
        2] // EntityList))), -4]
, "duration" -> Quantity[1, "Days"]];
