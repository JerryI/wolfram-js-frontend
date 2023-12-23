SetDirectory[$InputFileName // DirectoryName // ParentDirectory];

Get[FileNameJoin[{"Services", "LPM.wl"}]];
PacletRepositories[{}, "Directory"->Directory[], "Passive"->True];

Get[FileNameJoin[{"Kernel", "Notebook.wl"}]];

notebook = Notebook[];

Print["real register now in wls"];
EventHandler[notebook, {"New Cell" -> Function[data,
    Print["--- New Cell ---"];
]}];

Print["BOOOM"];
CellObj["Notebook"->notebook];