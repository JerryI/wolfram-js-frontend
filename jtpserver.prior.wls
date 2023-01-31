Import["https://raw.githubusercontent.com/JerryI/tcp-mathematica/main/JTP/JTP.wl"];

jtp = JTPServer["host"->$env["addr"], "port"->334] // JTPServerStart;