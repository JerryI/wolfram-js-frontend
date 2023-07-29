PacletInstall["KirillBelov/Internal"]
<< KirillBelov`Internal`;

SetDirectory[$InputFileName // DirectoryName]
Get[FileNameJoin[{ParentDirectory[Directory[]], "Kernel", "CSocketListener.wl"}]]

PacletInstall["KirillBelov/TCPServer", ForceVersionInstall->True]
<< KirillBelov`TCPServer`;
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/WSP.wl"];


Get["https://raw.githubusercontent.com/KirillBelovTest/HTTPHandler/main/Kernel/HTTPHandler.wl"]
Get["https://raw.githubusercontent.com/KirillBelovTest/HTTPHandler/main/Kernel/Extensions.wl"]

$PublicDirectory = FileNameJoin[{Directory[], "Simple"}]


Print["Staring HTTP server..."];

tcp = TCPServer[];
tcp["CompleteHandler", "HTTP"] = HTTPPacketQ -> HTTPPacketLength;
tcp["MessageHandler", "HTTP"] = HTTPPacketQ -> http;

http = HTTPHandler[];

http["MessageHandler", "Index"] = AssocMatchQ[<|"Path" -> "/"|>] -> (HypertextProcess[#, "index.wsp", "Base" -> $PublicDirectory] &)
http["MessageHandler", "WSP"] = GetFileRequestQ[{"wsp"}] -> (HypertextProcess[#, "Base" -> $PublicDirectory] &)
http["MessageHandler", "WSP"] = GetFileRequestQ[{"png", "html"}] -> (ImportFile[#, "Base" -> $PublicDirectory] &)

(* ::End::*)
httplistener =  Check[CSocketListen["127.0.0.1:8010", tcp@# &], Print["FUCK LibraryLink and Sockets! Using shitty ZMQ..."]; SocketListen["127.0.0.1:8010", tcp@# &]];

SetOptions[WSPEngine, "Cache" -> False];

Pause[1];
CEventLoopRun[0]

StringTemplate["open http://``:``/"][httplistener[[1]]["Host"], httplistener[[1]]["Port"]] // Print;
While[True, Pause[1]];

