(* ::Package:: *)

(* ::Chapter:: *)
(*CSocketListener*)


(* ::Section:: *)
(*Begin package*)


BeginPackage["KirillBelov`CSocketListener`"]; 


(* ::Section:: *)
(*Names*)


CSocketListen::usage = 
"CSocketListen[port|addr, func] creates listener."; 


CSocketListener::usage = 
"CSocketListener[assoc] listener object."; 


CSocket::usage = 
"CSocket[socketId] socket representation."; 


CEventLoopRun::usage =
"CEventLoopRun[0] starts event loop. RUN IT AT THE VERY LAST MOMENT ONCE"

(* ::Section:: *)
(*Private context*)


Begin["`Private`"]; 


(* ::Section:: *)
(*Implementation*)


CSocket /: BinaryWrite[CSocket[socketId_Integer], bytes_ByteArray] := 
If[socketWrite[socketId, bytes, Length[bytes]] === 0, $Failed, Null]; 


CSocket /: WriteString[CSocket[socketId_Integer], string_String] := 
If[socketWriteString[socketId, string, StringLength[string]] === 0, $Failed, Null]; 


CSocket /: Close[CSocket[socketId_Integer]] := 
closeSocket[socketId]; 


CSocketListen[port_Integer, handler_] := With[{sid = createServer["127.0.0.1", port//ToString]},
Echo["Created server with sid: "<>ToString[sid]];
router[sid] = handler;
CSocketListener[<|
	"Port" -> port, 
	"Host" -> "127.0.0.1",
	"Handler" -> handler, 
	"Task" -> Null
|>]]; 


CSocketListen[addr_String, handler_] := With[{port = StringSplit[addr,":"]//Last, host = StringSplit[addr,":"]//First},
sid = createServer[host, port];
Echo["Created server with sid: "<>ToString[sid]];
router[sid] = handler;

CSocketListener[<|
	"Port" -> ToExpression[port], 
	"Host" -> host,
	"Handler" -> handler, 
	"Task" -> Null
|>]]; 

router[task_, event_, {serverId_, clientId_, data_}] := (
	router[serverId][toPacket[task, event, {serverId, clientId, data}]]
)

CEventLoopRun[i_Integer] := Internal`CreateAsynchronousTask[runLoop, {i}, router[##]&]

CSocketListener /: DeleteObject[CSocketListener[assoc_Association]] := 
stopServer[assoc["Task"][[2]]]; 


(* ::Section:: *)
(*Internal*)


$directory = DirectoryName[$InputFileName, 2]; 


$libFile = FileNameJoin[{
	$directory, 
	"LibraryResources", 
	$SystemID, 
	"socket_listener." <> Internal`DynamicLibraryExtension[]
}]; 


If[!FileExistsQ[$libFile], 
	Get[FileNameJoin[{$directory, "Scripts", "BuildLibrary.wls"}]]
]; 


createServer = LibraryFunctionLoad[$libFile, "create_server", {String, String}, Integer]; 

runLoop = LibraryFunctionLoad[$libFile, "run_uvloop", {Integer}, Integer]; 

stopServer::usage = "stopServer[asyncObjId]"; 
stopServer = LibraryFunctionLoad[$libFile, "stop_server", {Integer}, Integer]; 


socketWrite = LibraryFunctionLoad[$libFile, "socket_write", {Integer, "ByteArray", Integer}, Integer]; 


socketWriteString = LibraryFunctionLoad[$libFile, "socket_write_string", {Integer, String, Integer}, Integer]; 


closeSocket = LibraryFunctionLoad[$libFile, "close_socket", {Integer}, Integer]; 


toPacket[task_, event_, {serverId_, clientId_, data_}] := 
<|
	"Socket" -> CSocket[serverId], 
	"SourceSocket" -> CSocket[clientId], 
	"DataByteArray" -> ByteArray[data]
|>; 


(* ::Section:: *)
(*End private context*)


End[]; 


(* ::Section:: *)
(*End package*)


EndPackage[]; 