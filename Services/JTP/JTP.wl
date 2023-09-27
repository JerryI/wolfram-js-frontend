(* ::Package:: *)

(* ::Chapter:: *)
(*JerryI Transfer Protocol*)


(* ::Section:: *)
(*Begin package*)


BeginPackage["JTP`"]


(* ::Section:: *)
(*Clear names*)


ClearAll["`*"]


(* ::Section:: *)
(*Public names*)


JTPServer::usage = 
"JTPServer[]
JTPServer[opts]"


JTPServerStart::usage = 
"JTPServerStart[server]"


JTPServerStop::usage = 
"JTPServerStop[server]"


JTPServerDrop::usage = 
"JTPServerDrop[server]"


JTPClient::usage = 
"JTPClient[]
JTPClient[opts]"


JTPClientSend::usage = 
"JTPClientSend[client, expr]"


JTPClientStart::usage = 
"JTPClientStart[client]"


JTPClientStop::usage = 
"JTPClientStop[client]"


JTPClientEvaluate::usage = 
"JTPClientEvaluate[client, expr]"


JTPClientEvaluateAsync::usage = 
"JTPClientEvaluateAsync[client, expr]"

JTPClientEvaluateAsyncNoReply::usage = "just write, no reply"


JTPClientStopListening::usage = 
"JTPClientStopListening[client]"


JTPClientStartListening::usage = 
"JTPClientStartListening[client]"


JTPSend::usage = 
"JTPSend[uuid, expr]"


(* ::Section:: *)
(*Begin private*)

evaluate[uuid_String, expr_] := 
(*virtual env*)
Block[{jsocket = uuid},
	ReleaseHold[ReleaseHold[expr] ]
]

serialize[expr_] := 
With[{data = BinarySerialize[expr//Compress]}, 
    Join[ExportByteArray[Length[data], "UnsignedInteger32"], data]
]

JTPSend[uuid_String, expr_] := (
	BinaryWrite[SocketObject[uuid], serialize[Hold[expr]]]
)

SetAttributes[JTPSend, HoldRest]

Begin["`Private`"]


(* ::Section:: *)
(*Serialization*)





getLength[buffer_DataStructure] := 
Module[{data = buffer["PopBack"]}, 
	While[Length[data] < 4, data = Join[data, buffer["PopBack"]];]; 

	With[{extra = Length[data] - 4},
		If[extra > 0,
			buffer["PushBack", Take[data, -extra]];
			data = Drop[data, -extra];
		];	
	];

	First[ImportByteArray[data, "UnsignedInteger32"]]
]


getLength[data_ByteArray] := 
First[ImportByteArray[data[[1 ;; 4]], "UnsignedInteger32"]]


deserialize[buffer_, length_Integer] := 
Module[{data = buffer["PopBack"]}, 
	While[Length[data] < length, data = Join[data, buffer["PopBack"]];]; 

	With[{extra = Length[data] - length},
		If[extra > 0,
			buffer["PushBack", Take[data, -extra]];
			data = Drop[data, -extra];
		];	
	];
	(*Print[ToString[Uncompress[BinaryDeserialize[data], Hold], InputForm] ];*)
	BinaryDeserialize[data]//Uncompress
]


(* ::Section:: *)
(*Evaluation*)


evaluate[kernel_LinkObject, Hold[expr_]] := 
Module[{$expr = Hold[expr]}, 
    With[{$def = Language`ExtendedFullDefinition[$expr]}, 
        If[LinkReadyQ[kernel], 
            LinkWrite[kernel, Unevaluated[Language`ExtendedFullDefinition[] = $def; expr]], 
            Missing[StringTemplate["Kernel [``] not ready"][kernel]]
        ]
    ]
]



reply[uuid_String, expr_] := 
BinaryWrite[SocketObject[uuid], serialize[expr]]

(*
evaluate[func: _Symbol | _Function, Hold[expr_]] := 
func[expr]
*)

result[kernel_LinkObject] := 
If[LinkReadyQ[kernel], 
    LinkRead[kernel][[1]], 
    Missing[StringTemplate["Kernel [``] not ready"][kernel]]
]


selectKernel[{Evaluate}] := 
Evaluate


selectKernel[kernels: {__LinkObject}] := 
RandomChoice[Select[kernels, LinkReadyQ]]


createAsyncKernels[n_Integer?Positive] := 
Table[LinkLaunch["mathkernel -mathlink"], {n}]


(* ::Section:: *)
(*Logging*)


writeLog[server_, message_, args___] := 
If[!server["nohup"],
	With[{$message = StringTemplate[message][args]}, 
    	(*server["log"]["Push", $message]; *)
		
     
    	Return[$message]
	],
	"nohup"
]

writeLog[server_, message_] := 
If[!server["nohup"],
	Block[{$message = StringTemplate[message][]}, 
    	(*server["log"]["Push", $message]; *)
     
    	Return[$message]
	],
	"nohup"
]


(* ::Section:: *)
(*Connection*)


openFreeSocket[host_String, port_Integer] := 
Block[{$port = port, $socket = SocketOpen[port], $trials = 0}, 
	Print["Looking for a free socket..."];
    While[FailureQ[$socket], 
        $socket = SocketOpen[$port++];
		Print[">> port: "<>ToString[$port]];
		$trials++;
		If[$trials === 10,
			$port = $port - 100;
		];
		If[$trials > 100,
			Print["Failed to open a port"];
			Abort[];
		];
    ]; 
    Return[<|"port" -> $port, "socket"  -> $socket|>]
]


openFreeSocket[assoc_?AssociationQ] := 
openFreeSocket[#host, #port]& @ assoc





connectSocket[host_String, port_Integer] := 
Block[{$port = port, $socket = SocketConnect[{host, port}, "TCP"]}, 
    Return[<|"port" -> $port, "socket"  -> $socket|>]
]


connectSocket[assoc_?AssociationQ] := 
connectSocket[#host, #port]& @ assoc


(* ::Section:: *)
(*Handler*)


SetAttributes[handler, HoldFirst]
SetAttributes[decode, HoldFirst]


handler[server_Symbol?AssociationQ][assoc_?AssociationQ] := 
Module[{set, get, uuid = assoc["SourceSocket"][[1]], data = assoc["DataByteArray"]}, 
	
	writeLog[server, "[<*Now*>] received"];
	set = Function[{key, value}, server["buffer", uuid, key] = value]; 
	get = Function[key, server["buffer", uuid, key]]; 
	If[Not[KeyExistsQ[server["buffer"], uuid]], 
		server["buffer", uuid] = <|
			"data" -> CreateDataStructure["Deque"], 
			"status" -> "Empty", 
			"length" -> 0, 
			"promise" -> server[["promise"]],
			"currentLength" -> 0, 
			"result" -> Null
		|>; 
		writeLog[server, "[<*Now*>] New client"];
	]; 
	Which[
		get["status"] == "Empty",
			writeLog[server, "[<*Now*>] Bucket is empty..."];
			set["length", getLength[data]]; 
			writeLog[server, "expected length: `` bytes", getLength[data]];
			If[ (*prevent writting zero length element. otherwise it will become a normalised byte array*)
				Length[data[[5 ;; ]]] > 0,
			
				set["currentLength", Length[data[[5 ;; ]]]]; 
				get["data"]["PushFront", data[[5 ;; ]]]; 
				
			]; 
			set["status", "Filling"]; , 
			
		get["status"] == "Filling", 
			writeLog[server, "[<*Now*>] Filling the bucket..."];
			set["currentLength", get["currentLength"] + Length[data]]; 
			get["data"]["PushFront", data]; 
	]; 
	writeLog[server, "[<*Now*>] `` length out of ``", get["currentLength"], get["length"] ];

	decode[server][uuid];
]

decode[server_Symbol?AssociationQ][uuid_] := 
Module[{set, get},
	set = Function[{key, value}, server["buffer", uuid, key] = value]; 
	get = Function[key, server["buffer", uuid, key]];

	Which[
		get["length"] <= get["currentLength"],  
			writeLog[server, "[<*Now*>] The length was matched"];
			
			writeLog[server, "evaluate from UUID: "<>uuid];
			server["promise"][uuid, evaluate[uuid, deserialize@@{get["data"], get["length"]}]]; 

			If[get["data"]["EmptyQ"],
				set["status", "Empty"]; 
				set["length", 0]; 
				set["currentLength", 0];	
			,
				set["status", "Filling"]; 
				writeLog[server, "[<*Now*>] Bucket is still not empty..."];
				set["currentLength", get["currentLength"] - get["length"] - 4];
				
				set["length", getLength[get["data"]]]; 
				writeLog[server, "expected next length: `` bytes", get["length"]];
				
				(*go recursively*)
				decode[server][uuid];
			
			];
	];
];


(* ::Section:: *)
(*Server*)


SetAttributes[JTPServer, HoldFirst]


Options[JTPServer] = {
    "host" -> "127.0.0.1", 
    "port" -> 8000, 
    "kernels" -> {Evaluate},
	"nohup" -> False
}


JTPServer[opts___?OptionQ] := With[{server = Unique["JTP`Objects`Server$"]}, 
    server = <|
		"host" -> OptionValue[JTPServer, Flatten[{opts}], "host"], 
		"port" -> OptionValue[JTPServer, Flatten[{opts}], "port"], 
		"kernels" -> OptionValue[JTPServer, Flatten[{opts}], "kernels"], 
		"socket" -> Automatic, 
		"handler" -> handler[server], 
		"listener" -> Automatic, 
		"promise" -> reply,
		"status" -> "Not started", 
		"buffer" -> <||>, 
		"log" -> CreateDataStructure["Queue"], 
		"nohup" -> OptionValue[JTPServer, Flatten[{opts}], "nohup"],
		"self" -> JTPServer[server]
	|>; 
	writeLog[server, "[<*Now*>] JTPServer created"]; 
	Return[JTPServer[server]]
]


JTPServer /: 
MakeBoxes[obj: JTPServer[server_Symbol?AssociationQ], form_] := (
	BoxForm`ArrangeSummaryBox[
		JTPServer, 
		obj, 
		Null, 
		{
			{BoxForm`SummaryItem[{"port: ", server[["port"]]}], SpanFromLeft}, 
			{BoxForm`SummaryItem[{"host: ", server[["host"]]}], SpanFromLeft}, 
			{BoxForm`SummaryItem[{"status: ", server[["status"]]}], SpanFromLeft}
		}, {
			{BoxForm`SummaryItem[{"kernels: ", server[["kernels"]]}], SpanFromLeft}, 
			{BoxForm`SummaryItem[{"self: ", server[["self"]]}] /. JTPServer -> Defer, SpanFromLeft}
		}, 
		form
	]
)


JTPServer /: 
JTPServerStart[JTPServer[server_Symbol?AssociationQ]] := (
	server[[{"port", "socket"}]] = Values[openFreeSocket[server]]; 
	server["listener"] = SocketListen[server["socket"], server["handler"]]; 
	server["status"] = "listening..";
	Echo["JTP: "<>server["status"]];
	writeLog[server, "[<*Now*>] JTPServer started listening"]; 
	JTPServer[server]
)


JTPServer /: 
JTPServerDrop[JTPServer[server_Symbol?AssociationQ], uuid_] := (
	Unset[server["buffer", uuid]];
	Close[SocketObject[uuid]];
 
	JTPServer[server]
)








JTPServer[server_Symbol?AssociationQ][keys__String] := 
server[keys]


JTPServer[server_Symbol?AssociationQ][keys_Symbol] := 
server[ToString[keys]]


JTPServer[server_Symbol?AssociationQ][key_Symbol] := 
server[ToString[key]]


JTPServer /: 
Set[name_Symbol, server_JTPServer] := (
	name /: Set[name[key: _String | _Symbol], value_] := With[{$server = server}, $server[key] = value];
	Block[{JTPServer}, SetAttributes[JTPServer, HoldFirst]; name = server]
)


JTPServer /: 
Set[JTPServer[symbol_Symbol?AssociationQ][key_String], value_] := 
symbol[[key]] = value


JTPServer /: 
Set[JTPServer[symbol_Symbol?AssociationQ][key_Symbol], value_] := 
symbol[[ToString[key]]] = value


(* ::Section:: *)
(*Client*)


JTPClient /: 
JTPClientEvaluate[JTPClient[server_Symbol?AssociationQ], expr_] :=
Module[{raw, length}, 
	BinaryWrite[server["socket"], serialize[Hold[expr]]]; 
	raw = SocketReadMessage[server["socket"]];
	length = getLength[Take[raw, 4]];
	raw = Drop[raw, 4];
	While[Length[raw] < length, raw = Join[raw, SocketReadMessage[server["socket"]]]];
	raw // BinaryDeserialize // Uncompress // ReleaseHold
]

JTPClient /: 
JTPClientEvaluateAsync[JTPClient[server_Symbol?AssociationQ], expr_, opts___?OptionQ] :=
Module[{}, 
	server["listener"] = SocketListen[server["socket"], server["handler"]];
	With[{listener = server["listener"]},
		server["promise"] = Composition[Function[x, DeleteObject[listener]], OptionValue[JTPClientEvaluateAsync, Flatten[{opts}], Promise]];
	];
	
	server["status"] = "temporary listening";
	writeLog[server, "[<*Now*>] JTPClient temporary listening"];

	BinaryWrite[server["socket"], serialize[Hold[expr]]]; 
]

JTPClient /: 
JTPClientEvaluateAsyncNoReply[JTPClient[server_Symbol?AssociationQ], expr_, opts___?OptionQ] :=
Module[{}, 
	BinaryWrite[server["socket"], serialize[Hold[expr]]]; 
]



JTPClient /: 
JTPClientSend[JTPClient[server_Symbol?AssociationQ], expr_] :=
reply[server["socket"][[1]], Hold[expr]]


SetAttributes[JTPClient, HoldFirst]


SetAttributes[JTPClientSend, HoldRest]


SetAttributes[JTPClientEvaluate, HoldRest]

SetAttributes[JTPClientEvaluateAsyncNoReply, HoldRest]


SetAttributes[JTPClientEvaluateAsync, HoldRest]


Options[JTPClientEvaluateAsync] = {
    "Promise" -> Null
}


Options[JTPClient] = {
    "host" -> "127.0.0.1", 
    "port" -> 8000, 
    "kernels" -> {Evaluate},
	"nohup" -> False
}


JTPClient[opts___?OptionQ] := With[{client = Unique["JTP`Objects`Client$"]}, 
    client = <|
		"host" -> OptionValue[JTPClient, Flatten[{opts}], "host"], 
		"port" -> OptionValue[JTPClient, Flatten[{opts}], "port"], 
		"kernels" -> OptionValue[JTPClient, Flatten[{opts}], "kernels"], 
		"socket" -> Automatic, 
		"handler" -> handler[client], 
		"listener" -> Automatic, 
		"promise" -> Null,
		"status" -> "Not connected", 
		"buffer" -> <||>, 
		"log" -> CreateDataStructure["Queue"], 
		"nohup" -> OptionValue[JTPClient, Flatten[{opts}], "nohup"],
		"self" -> JTPClient[client]
	|>; 
	writeLog[client, "[<*Now*>] JTPClient created"]; 
	Return[JTPClient[client]]
]


JTPClient /: 
MakeBoxes[obj: JTPClient[server_Symbol?AssociationQ], form_] := (
	BoxForm`ArrangeSummaryBox[
		JTPClient, 
		obj, 
		Null, 
		{
			{BoxForm`SummaryItem[{"port: ", server[["port"]]}], SpanFromLeft}, 
			{BoxForm`SummaryItem[{"host: ", server[["host"]]}], SpanFromLeft}, 
			{BoxForm`SummaryItem[{"status: ", server[["status"]]}], SpanFromLeft}
		}, {
			{BoxForm`SummaryItem[{"kernels: ", server[["kernels"]]}], SpanFromLeft}, 
			{BoxForm`SummaryItem[{"self: ", server[["self"]]}] /. JTPClient -> Defer, SpanFromLeft}
		}, 
		form
	]
)


JTPClient /: 
JTPClientStart[JTPClient[server_Symbol?AssociationQ]] := (
	server[[{"port", "socket"}]] = Values[connectSocket[server]]; 
	server["status"] = "started";
	writeLog[server, "[<*Now*>] JTPClient started"]; 
	JTPClient[server]
)


JTPClient /: 
JTPClientStartListening[JTPClient[server_Symbol?AssociationQ], opts___?OptionQ] := (
	server["listener"] = SocketListen[server["socket"], server["handler"]];
	server["promise"] = OptionValue[JTPClientStartListening, Flatten[{opts}], Promise];
	server["status"] = "listening";
	writeLog[server, "[<*Now*>] JTPClient listening"]; 
	JTPClient[server]
)


Options[JTPClientStartListening] = {
    Promise -> Null
}


JTPClient /: 
JTPClientStopListening[JTPClient[server_Symbol?AssociationQ]] := (
	server["listener"] = DeleteObject[server["listener"]];
	server["status"] = "started";
	writeLog[server, "[<*Now*>] JTPClient has stopped listening"]; 
	JTPClient[server]
)


JTPClient /: 
JTPClientStop[JTPClient[server_Symbol?AssociationQ]] := (
	server["listener"] = DeleteObject[server["listener"]];
	server["status"] = "terminated";
	If[SocketReadyQ[server["socket"]], SocketReadMessage[server["socket"]]];
	Close[server["socket"]];
	writeLog[server, "[<*Now*>] JTPClient was terminated"]; 
	JTPClient[server]
)
 


JTPClient[server_Symbol?AssociationQ][keys__String] := 
server[keys]


JTPClient[server_Symbol?AssociationQ][keys_Symbol] := 
server[ToString[keys]]


JTPClient[server_Symbol?AssociationQ][key_Symbol] := 
server[ToString[key]]


JTPClient /: 
Set[name_Symbol, server_JTPClient] := (
	name /: Set[name[key: _String | _Symbol], value_] := With[{$server = server}, $server[key] = value];
	Block[{JTPClient}, SetAttributes[JTPClient, HoldFirst]; name = server]
)


JTPClient /: 
Set[JTPClient[symbol_Symbol?AssociationQ][key_String], value_] := 
symbol[[key]] = value


JTPClient /: 
Set[JTPClient[symbol_Symbol?AssociationQ][key_Symbol], value_] := 
symbol[[ToString[key]]] = value


(* ::Section:: *)
(*End private*)


End[] (*`Private`*)


(* ::Section:: *)
(*End package*)


EndPackage[] (*JTP`*)
