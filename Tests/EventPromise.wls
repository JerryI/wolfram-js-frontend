ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<<JerryI`Misc`Events`
<<JerryI`Misc`Events`Promise`

<<JerryI`Misc`Async`

event = CreateUUID[];

(* regular *)
EventHandler[event // EventClone, {
    "Start" -> Function[Null,
        Print["OnBefore event fired 1"];
        With[{promise = Promise[]},
            SetTimeout[EventFire[promise, Resolve, "resolved!"], 3000];
            promise
        ]
    ]
}];

(* using advanced pattern matching *)
EventHandler[event // EventClone, {
    any_ :> Function[Null,
        Print[StringTemplate["`` event fired 2"][any] ];
        143
    ]
}];


Echo["-- Started"];


Then[EventFire[event, "Start", Null], Function[Null, Echo["Done!"] ]];


While[True, Pause[1] ];
