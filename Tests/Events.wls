ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<<JerryI`Misc`Events`
<<JerryI`Misc`Events`Promise`

<<JerryI`Misc`Async`

event = CreateUUID[];

(* regular *)
EventHandler[event, {
    "Start" -> Function[Null,
        Print["OnBefore event fired 1"];
        123
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

EventFire[event, "Start", Null] // Echo;

While[True, Pause[1] ];
