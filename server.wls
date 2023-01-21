$env = <|
    "addr"->"0.0.0.0",
    "port"->8090,
    "path"->"./"
|>;

NullQ[x_] := TrueQ[x === Null];

(*dunno if it helps here*)
$HistoryLength = 0;

Needs["CodeParser`"];
Import["https://raw.githubusercontent.com/JerryI/tinyweb-mathematica/master/Tinyweb/Tinyweb.wl"];
Import["https://raw.githubusercontent.com/JerryI/tinyweb-mathematica/master/WSP/WSP.wl"];

server = WEBServer["addr" -> StringTemplate["``:``"][$env["addr"], $env["port"]], "path" -> $env["path"], "socket-close" -> False];
server = server // WEBServerStart;

(*import modules*)
Import/@FileNames["*.wls", "modules"];

notebooks = <||>;
NotebookCreate["id"->"console"];

While[True,
    Pause[0.1];
];