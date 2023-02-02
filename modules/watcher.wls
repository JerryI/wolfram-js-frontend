wdates = {};

CheckFiles := (
    If[wdates =!= FileDate/@FileNames["*", wconfig["watch"]], Rebuild];
    wdates = FileDate/@FileNames["*", wconfig["watch"]];
);

Rebuild := (
    Print["rebuilding..."];
    Export["temp/merged.js", StringJoin @@ (Import[#, "String"] &/@ wconfig["merge"]), "String"];
    wconfig["after"];
);

If[MemberQ[$ScriptCommandLine, "dev"],
    SessionSubmit[ScheduledTask[CheckFiles, Quantity[3, "Seconds"]]]
];