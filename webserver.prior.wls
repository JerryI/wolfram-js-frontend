Import["../tinyweb-mathematica/Tinyweb/Tinyweb.wl"];
Import["../tinyweb-mathematica/WSP/WSP.wl"];

server = WEBServer["addr" -> StringTemplate["``:``"][$env["addr"], $env["port"]], "path" -> $env["path"], "socket-close" -> True, "extra-logging"->True];
server = server // WEBServerStart;

console["log", "Open http://``:`` in your browser", $env["addr"], $env["port"]];