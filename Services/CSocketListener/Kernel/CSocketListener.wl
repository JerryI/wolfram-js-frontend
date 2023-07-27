(* ::Package:: *)

(* ::Chapter:: *)
(*CSocketListener*)


(* ::Section:: *)
(*Begin package*)


BeginPackage["KirillBelov`CSocketListener`"]; 


(* ::Section:: *)
(*Names*)


CSocketListen::usage = 
"CSocketListen[port, func] creates listener."; 


CSocketListener::usage = 
"CSocketListener[assoc] listener object."; 


CSocket::usage = 
"CSocket[socketId] socket representation."; 


(* ::Section:: *)
(*Private context*)


Begin["`Private`"]; 


(* ::Section:: *)
(*Implementation*)


CSocket /: BinaryWrite[CSocket[socketId_Integer], bytes_ByteArray] := 
socketWrite[socketId, bytes, Length[bytes]]; 


CSocket /: WriteString[CSocket[socketId_Integer], string_String] := 
socketWriteString[socketId, string, StringLength[string]]; 


CSocket /: Close[CSocket[socketId_Integer]] := 
closeSocket[socketId]; 


CSocketListen[port_Integer, handler_] := 
CSocketListener[<|
	"Port" -> port, 
	"Handler" -> handler, 
	"Task" -> Internal`CreateAsynchronousTask[createServer, {ToString[port]}, handler[toPacket[##]]&]
|>]; 


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


createServer = LibraryFunctionLoad[$libFile, "create_server", {String}, Integer]; 


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
