wconfig = Import["wolfram.config.wls"]; 

CheckFiles := (
    If[wdates =!= FileDate/@FileNames["*.js", wconfig["watch"]], Rebuild];
    wdates = FileDate/@FileNames["*.js", wconfig["watch"]];
);

Rebuild := (
    Print["rebuilding..."];
    Export["temp/merged.js", StringJoin @@ (Import[#, "String"] &/@ wconfig["merge"]), "String"];
    wconfig["after"];
);

If[$ScriptCommandLine[[2]] === "dev",
    SessionSubmit[ScheduledTask[CheckFiles, Quantity[3, "Seconds"]]]
];