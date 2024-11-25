ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<<KirillBelov`CSockets`
<<KirillBelov`Objects`
<<KirillBelov`Internal`
<<KirillBelov`LTP`
<<KirillBelov`TCPServer`
<<KirillBelov`LTP`JerryI`Events`

tcp = TCPServer[];
tcp["CompleteHandler", "LTP"] = LTPQ -> LTPLength;
tcp["MessageHandler", "LTP"]  = LTPQ -> LTPHandler;

SocketListen[CSocketOpen["127.0.0.1", 38500], tcp@#&]

connected = SocketConnect["127.0.0.1:38500"] // LTPTransport;

Print[connected];
Pause[1];
LTPEvaluate[connected, Print["Fuckoor!!"]];

While[True, Pause[1] ];