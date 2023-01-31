Import["https://raw.githubusercontent.com/JerryI/tinyweb-mathematica/master/Tinyweb/Tinyweb.wl"];
Import["https://raw.githubusercontent.com/JerryI/tinyweb-mathematica/master/WSP/WSP.wl"];

server = WEBServer["addr" -> StringTemplate["``:``"][$env["addr"], $env["port"]], "path" -> $env["path"], "socket-close" -> True];
server = server // WEBServerStart;

console["log", "Open http://``:`` in your browser", $env["addr"], $env["port"]];