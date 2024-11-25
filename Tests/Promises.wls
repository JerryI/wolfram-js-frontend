ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<<JerryI`Misc`Events`
<<JerryI`Misc`Events`Promise`

<<JerryI`Misc`Async`

promise1 = Promise[];
promise2 = Promise[];

promise3 = Promise[];

Then[{1,4, {promise1, promise3}, promise2}, Echo["Resolved: "<>ToString[#] ] &, Echo ];

SetTimeout[
    EventFire[promise1, Resolve, 999]
, 1000];

SetTimeout[
    EventFire[promise2, Resolve, 9919]
, 1500];

SetTimeout[
    EventFire[promise3, Resolve, 7719]
, 2000];

Echo["Started"];


While[True, Pause[1] ];
