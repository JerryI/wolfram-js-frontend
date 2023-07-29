SetDirectory[$InputFileName // DirectoryName]
Get[FileNameJoin[{ParentDirectory[Directory[]], "Kernel", "CSocketListener.wl"}]]

Print["Testing"];
CSocketListen[8010, Echo@# &]
Print["Boom!"];

While[True, Pause[1]]
