(* ::Package:: *)

(* ::Chapter:: *)
(*JerryI Transfer Protocol*)


(* ::Section:: *)
(*Begin package*)


BeginPackage["Tinyweb`"]


(* ::Section:: *)
(*Clear names*)


ClearAll["`*"]


(* ::Section:: *)
(*Public names*)


WEBServer::usage = 
"WEBServer[]
WEBServer[opts]"


WEBServerStart::usage = 
"WEBServerStart[server]"


WEBServerStop::usage = 
"WEBServerStop[server]"



WebSocketBroadcast::usage = 
"WebSocketBroadcast[server, exp]"

WebSocketPublish::usage = 
"WebSocketBroadcast[server, exp]"

WebSocketPublishString::usage = 
"WebSocketBroadcast[server, exp]"

WebSocketSubscribe::usage = 
"WebSocketBroadcast[server, exp]"


(* ::Section:: *)
(*Begin private*)
writeLog[server_, message_, args___] :=  
	Block[{$message = StringTemplate[message][args]}, 
		Print[$message];
	]



WebSocketSend[cli_, exp_] := BinaryWrite[SocketObject[cli], constructReply[ExportString[exp,"ExpressionJSON", "Compact" -> -1]]];

Begin["`Private`"]

MIMETypes = Uncompress["1:eJytWFlv3DYQTlsH6N0kva+HPhdaxw1co30r0AMF+hT+gIJLURJtUWRIrsT6J/\
RXd0iudzfirKS1+2Lt0B+HM8M5+d1avaz+\
ffTokT2DP38J66o376iXm5aTQFFBPgsfrVvBqBOqO9fKOsuM0GP8WxFfkffDd1MKde4LoK\
sR7CzB2ELcLL94rGXkXfg67t25bqnoUFBFPoRvL0oeeElbwBIK1OTtO25AoBA/\
zysacEPe28m/\
plYwjFsvyDs7bkAhmLXUESMkrfk5UBjGJkwUvHGyxTAuWSHx0cau1k5gtg/\
L88g34MeM7QPFFtwPq+WBhkBhGK0XMLJ2f39AIJCSmcyxfVEKw5lTBtvADfkq2+Avn/\
9UMFowbrBoKBUjz0abpB2UKRF7A1iS5yN035Ur8K2wZQWAjeSdW0nKjOIdXbe8XF38gPPy\
5A+El9K88+AXykjqbKGqSjC+YxyO0UYxbq3oatnujkR1c6fo5qZ1c1zCbTq+SDf3v+\
h2dySmmyv3DuTRMCohZJ/mDoSGLtf2tCxaaU8+2EVC0A1WEFwNEbqPmDoLzkDVt9k1+aK+\
FeP8EQK5mQ/kZgYTxGpaTT4enTmIruEtlrSaJSENyWwys50lTDub/\
gRTByYDCsXYaP6UP2jLu5JiOUHwQ/\
MDhQglam6jelKVvD0PJMapXgLqxLyhrqkhX4xsf017WlDDGtFj3n6teeSb1ACqRvQIy9Oo\
xGoGFKhrm0noiyDj0Xi4nqlrj+FHCGWfuZ0v4jqikOS2ObB5IJGTpSjjyal+\
A4VxEqWYBCVGFflonC6zgI1I1UdkagZebQS7cUJiFyf1i6jB9lz8SuT2dhM7BHSWQPU0Kr\
Gq4s3Fa9hmb8lLQTVlN3Dh6JZFfHVWW7fsIWNfQ0lGN/\
l7bFpy56qk2VXBGoLUVzJP7DfMXhUSvzF9ZcnX6AYr6o66jUF3lbnvwBoSWrpFkr3mBsuE\
uqsPshdQiF/oULd/PGJlNXCjlYDaekL11qF6/4ZwnK7e2nAL3wifrt1aU/\
LtnMSYYJpK8mJWVVqWopvRM4lh7ymGleRqVgzbQkDZRg1LTK5hWPn9oSbfnYgq6+\
6pLLjXz7PKHkqySF9wsT8fqu8hiap8e7LKMUJPaAUD9cotKAaBMpR8sqsFEPRdYThtI4mI\
b8DZT4HX6zjGplzhC6AxEU7j6fKsBmso0u/7MSNYE34gOEs1+\
TJLf7AKbmsc26B7YOj6PN/DDOcdo+\
MRNPywolXzRcQKifoHSPP3zbASboPPmVY48mkuj9uAs2L+YdtoxF1JHqiGUMUYd+\
WClwgLFSQfc6tNqEzwP4rr2tcH4wpQ3+\
Mzkx3oaUO3HarMiGCMRrGbgfa8qI4I5KAJzoczhzbxoWtEsFnPGLGN23fg7sgYEtanUY+\
3qHYaFk+EtnHfUDv8lSwsT6MiK1tlffc2Y3HPOHq6d/MTR8/\
SE10aloue0ewJIMEsefIa7Ohc1Zfq4DkMKAwj+\
oMHuKAHrIyB4UdvtnZO4RpIjJ0ts7BLTC2avMD9DqLJF0AjZw/h0e7pODwH/\
PFukPn9hIdFyR2tRIv1OgOo9iRjj3olrKbKM8YeHboGfZmlgviIwk0FAXu5usA2mQXG9pC\
nkbAWbQ+dqqgbV8B/sH1rGZPdXRXya+\
EkRZGvPV0GbT0eOr6FQriaiIrFDZ9v87F2IrzS4XZNLqcOtw3nbrUWHTX/\
LOh8gOGMNonhIk6e/\
IJwmu6hLHRNtIyHyO1hKHPIkBdTYp4wUAAzT359oKQT8wSwmHsL9Hb2udDbWS63QpNvsqi\
A1YIpGbpRy7G8OozfRv4DUoPZxg=="]//Association

(* ::Section:: *)
(*Logging*)


constructReply[data_] := 
Module[{utf8data = ExportString[data, "String", CharacterEncoding -> "UTF8"], json, payloadLength, jsonByteLength, buffer, 
    lengthByteCount}, json = utf8data // StringToByteArray // Normal;
    jsonByteLength = utf8data // StringLength;
    buffer = FromDigits[{1, 0, 0, 0, 0, 0, 0, 1}, 2];
        
    If[jsonByteLength <= 125,
        buffer = {buffer, jsonByteLength };
    , 
        If[jsonByteLength >= 126 && jsonByteLength <= 65535,
			buffer = {buffer, 126};
            buffer = {buffer, 
            	  BitAnd[(BitShiftRight[jsonByteLength, 8]), 255]};
             	  buffer = {buffer, BitAnd[jsonByteLength, 255]};
             	  ,
            buffer = {buffer, 127};
            buffer = {buffer, 
               BitAnd[(BitShiftRight[jsonByteLength, 56]), 255]};
            buffer = {buffer, 
               BitAnd[(BitShiftRight[jsonByteLength, 48]), 255]};
            buffer = {buffer, 
               BitAnd[(BitShiftRight[jsonByteLength, 40]), 255]};
            buffer = {buffer, 
               BitAnd[(BitShiftRight[jsonByteLength, 32]), 255]};
            buffer = {buffer, 
               BitAnd[(BitShiftRight[jsonByteLength, 24]), 255]};
            buffer = {buffer, 
               BitAnd[(BitShiftRight[jsonByteLength, 16]), 255]};
            buffer = {buffer, 
               BitAnd[(BitShiftRight[jsonByteLength, 8]), 255]};
            buffer = {buffer, BitAnd[jsonByteLength, 255]};
             
        ]
    ];
   
   Join[buffer // Flatten // ByteArray, StringToByteArray[utf8data]]
   
]



writeLog[server_Symbol?AssociationQ, message_String, args___] :=  
	Block[{$message = StringTemplate[message][args]}, 
		Print[$message];
	]	


(* ::Section:: *)
(*Connection*)

checkDeadConnections[server_Symbol?AssociationQ] := (
(*not everytime*)

	If[server["cnt"] > 3,

		With[{n = Now},
			If[(n - server["connection", #, "time"] > Quantity[7, "Seconds"]) && (!KeyExistsQ[server["connection", #], "donotclose"]), 
				server["connection", #] = .;  Close[SocketObject[#] ];
				writeLog[server, esc["green"]<>"id: "<>#<>" was closed due to inactivity"<>esc["reset"] ];

			] &/@ Keys[ server["connection"] ];
		];
		server["cnt"] = 0;
	,
		server["cnt"] = server["cnt"] + 1;
	]
)


(* ::Section:: *)
(*Handler*)

SetAttributes[checkDeadConnections, HoldFirst]
SetAttributes[handler, HoldFirst]
SetAttributes[HTTP, HoldFirst]
SetAttributes[DecodeApplication, HoldFirst]
SetAttributes[DecodeMultipart, HoldFirst]
SetAttributes[CreateRequest, HoldFirst]
SetAttributes[WebSocketConnect, HoldFirst]
SetAttributes[DecodeMultipartString, HoldFirst]
SetAttributes[WebSocketReceive, HoldFirst]



CreateRequest[server_Symbol?AssociationQ][uuid_] :=
Module[{stream, buffer=""},
	(*merge the data to stream*)
	(*you will never know, where a body with random data will be - better to read as a stream*)
	stream = BufferFlatten[server][uuid] //ByteArrayToString // StringToStream;
	(*kinda shitty way how to break the header and the body*)
	(*also it detects if the HTTP message was splitted into TCP packets*)
	(*go until we will find \r\n*)
	While[!With[{last = Last@(buffer = {buffer, ReadString[stream, "\n"]})}, TrueQ[last == EndOfFile] || TrueQ[last == "\r"] ] ];
	(*get rid of \n, which was not read in the cycle*)
	buffer = {buffer, Read[stream, Character]};

	buffer = buffer // Flatten;
	buffer = StringTrim/@buffer;
	(*only the header or a part of it will be in the buffer*)

	(*ignore empty lines befor the header as it was recommended in HTTP specs.*)
	If[First@buffer == "" || First@buffer == "\n", buffer = Drop[buffer, 1]];
	If[First@buffer == "" || First@buffer == "\n", buffer = Drop[buffer, 1]];

	(*detect broken*)
	If[TrueQ[Last@buffer == EndOfFile],
		writeLog[server, "Partial request. Waiting for other parts..."];
		Close[stream];
		(*just abort everything and let the handler function to accumulate more data*)
		Return[Null, Module];
	];
	

	(*the main part of the header*)
	With[{raw = StringCases[buffer[[1]], RegularExpression["([A-Z]+) /(.*) "] :> {"$1", URLParse["$2"], "$2"}] // First},
		server["connection", uuid, "session"] = raw[[2]];
		server["connection", uuid, "session", "method"] = raw[[1]];
		server["connection", uuid, "session", "rawurl"] = raw[[3]];
	];



	(*the rest is tricky	*)
	server["connection", uuid, "session"] = Join[server["connection", uuid, "session"], Join @@ ((StringCases[#, RegularExpression["(\\S*): (.*)"] :> <|"$1" -> Select[StringCases["$2", RegularExpression["[^; ]*"]], Function[x, StringLength[x] > 0]]|>] // First) & /@ Drop[Drop[buffer,1],-2])];
	
	(*return an extra part to the buffer. it may be a different request or a body*)
	buffer = "";
	buffer = ReadString[stream];
	If[!TrueQ[buffer == EndOfFile],
		writeLog[server, "extra data. be stored in the connection storage"];
		server["connection", uuid, "buffer"] = buffer//StringToByteArray;
		(*set a new length for the rest*)
		server["connection", uuid, "currentLength"] = Length[server["connection", uuid, "buffer"]];
	,
		writeLog[server, "no extra data is available"];
		(*reset the buffer*)
		server["connection", uuid, "buffer"] = {};
		server["connection", uuid, "currentLength"] = 0;
	];
	Close[stream];


	writeLog[server, "Request method: `` with ``", server["connection", uuid, "session", "method"], server["connection", uuid, "session", "rawurl"]];

	(*Upgrade*)
	If[MemberQ[server["connection", uuid, "session", "Connection"], "Upgrade"],
		writeLog[server, "Upgrade connection"];
		(*Safari, Edge, Old Chrome*)
		Switch[First@server["connection", uuid, "session", "Upgrade"],
			"websocket",
			WebSocketConnect[server][uuid]
		];	
		Return[Null, Module];
		writeLog[server, "mathematica error"];
	];

	(* fix url q*)
			
	server["connection", uuid, "session", "Query"] = server["connection", uuid, "session", "Query"]//Association;

	Switch[server["connection", uuid, "session", "method"],
		"GET",
	

			HTTP[server][uuid];
			(*try to create new request using the rest of the data*)
			(*CreateRequest[server][uuid]*)
		,
				
		"POST",
			writeLog[server, "form type: ``", server["connection", uuid, "session", "Content-Type"]//First];
			Switch[server["connection", uuid, "session", "Content-Type"]//First,
				"application/x-www-form-urlencoded",
					(*simple form*)
					writeLog[server, "a simple application form was received"];
					DecodeApplication[server][uuid];
				,
				"multipart/form-data",
					(*multipart form*)
					writeLog[server, "a complicated application form was received"];
					DecodeMultipart[server][uuid];
						
				]
		];

	
]

WebSocketConnect[server_Symbol?AssociationQ][uuid_] :=
Module[{response},
With[
    {
        key = First@server["connection",uuid,"session","Sec-WebSocket-Key"]
    },
            
    (*handshake*)
    writeLog[server, "websockets handshake with key ``", key];

    response = StringJoin @@ {  "HTTP/1.1 101 Switching Protocols\r\n",
                                        "Upgrade: websocket\r\n",
                                        "Connection: Upgrade\r\n",
                                        "Sec-WebSocket-Accept: " <> Hash[StringJoin[key, "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"], "SHA", "Base64Encoding"] <> "\n\n"};
	
    WriteString[SocketObject[uuid], response];    
	

	(*default handler for all cases*)
	server["connection", uuid, "default"] = WebSocketReceive;
	server["connection", uuid, "next"] = WebSocketReceive;
	server["connection", uuid, "donotclose"] = True;
]
]

WebSocketReceive[server_Symbol?AssociationQ][uuid_] :=
With[{data = BufferFlatten[server][uuid]//Normal (*it sucks. unpacking creates more data*)},
Module[{frame},
	(*writeLog[server, "websockets received"];*)

	(*close message detection*)
	If[Take[data, 2] == {136, 130}, 
		writeLog[server, esc["green"]<>"close websocket"<>esc["reset"] ];
		writeLog[server, esc["green"]<>"id "<>uuid<>esc["reset"] ];
		Close[SocketObject[uuid]];
		Unset[server["connection", uuid]];

		Return[Null, Module];
	];

	frame = If[#[[2]] - 128 <= 125, 
			  <|"fin" -> BitGet[#[[1]], 1], 
  				"length" -> #[[2]] - 128, "key" -> #[[{3, 4, 5, 6}]],
  				"received" -> Length[#] - 6, "payload" -> Drop[#, 6]|>,
			  
			  <|"fin" -> BitGet[#[[1]], 1], "received" -> Length[#] - 8, 
  				"length" -> #[[4]] + BitShiftLeft[#[[3]], 8], 
  				"key" -> #[[{5, 6, 7, 8}]], "payload" -> Drop[#, 8]|>] &@ data;
	
	(*writeLog[server, "frame: ``", frame//Compress];*)

    If[frame["received"] < frame["length"],
        
        server["connection", uuid,"buffer"] = data//ByteArray;
		server["connection", uuid,"currentLength"] = Length[data];
		(*considering extra data from the header of the frame, because handle doent care about websokets*)
		server["connection", uuid,"length"] = frame["length"] + If[data[[2]] - 128 <= 125, 6, 8];
    ,

        frame = MapIndexed[BitXor[#1, frame["key"][[Mod[#2[[1]] - 1, 4] + 1]]] &, frame["payload"]] // ByteArray // ByteArrayToString;
        

		(*reset for a new q*)
        server["connection", uuid,"buffer"] = {};
		server["connection", uuid,"currentLength"] = 0;
		server["connection", uuid,"length"] = 0;

		(*client id for the possible communication*)
        Block[{Global`client = uuid},
            ToExpression[frame]
        ];
    ];

]
]



DecodeApplication[server_Symbol?AssociationQ][uuid_] :=
	With[{data = BufferFlatten[server][uuid]//ByteArrayToString, length = ToExpression[First@server["connection", uuid, "session", "Content-Length"]]},
		writeLog[server, "expected: ``, received ``", length, StringLength[data]];
		
		
		If[StringLength[data] < length,
			server["connection", uuid, "length"] = length;	
			server["connection", uuid, "next"] = DecodeApplication;
		,
							
			server["connection", uuid, "session", "data"] = URLParse["?" <> StringTake[data, length]]["Query"]//Association;
			server["connection", uuid, "buffer"] = StringDrop[data, length]//StringToByteArray;
			(*reset the length for a new requests*)
			server["connection", uuid, "currentLength"] = 0;
			server["connection", uuid, "length"] = 0;
			
			HTTP[server][uuid];
		];
		
	]
	
DecodeMultipart[server_Symbol?AssociationQ][uuid_] := 
Module[{stream, bondary,string="",sub="", info},
	With[{data = BufferFlatten[server][uuid]//ByteArrayToString(*it sucks, i dunno how to stream bytearrays*), length = ToExpression[First@server["connection", uuid, "session", "Content-Length"]]},
		writeLog[server, "expected: ``, received ``", length, StringLength[data]];
		
		
		If[StringLength[data] < length,
			server["connection", uuid, "length"] = length;	
			server["connection", uuid, "next"] = DecodeMultipart;
		,
			(*i dont like this convertation. But you cannot stream with byte arrays*)
			server["connection", uuid, "buffer"] = StringDrop[data, length]//StringToByteArray;
			server["connection", uuid, "session", "data"] = <||>;
			
			stream = StringTake[data, length] // StringToStream;
			bondary = StringDrop[server["connection", uuid, "session", "Content-Type"][[2]], StringLength["boundary="]];
			
            While[TrueQ[(string = ReadString[stream, "--" <> bondary]) != "--\r\n"] && ! TrueQ[string == EndOfFile],
 
                sub = string // StringToStream;
                With[{info = Join @@ 
                    StringCases[ReadLine[sub], 
                        RegularExpression["(([^= ]*)=\"([^=]+)\")"] :> <|"$2" -> "$3"|>]},
 
      
 
                	If[KeyExistsQ[info, "filename"],
                	    ReadLine[sub];
  
                	    Read[sub, Character]; Read[sub, Character]; Read[sub, Character]; 
                	    Read[sub, Character];
						
						If[!KeyExistsQ[server["connection", uuid, "session", "data"], info["name"]], server["connection", uuid, "session", "data"][info["name"]] = {}];

						server["connection", uuid, "session", "data"][info["name"]] = {
							server["connection", uuid, "session", "data"][info["name"]],
							<|"filename" -> info["filename"], "data"->Drop[ReadByteArray[sub], -2] |>
						}//Flatten;
  
                	,
  
                	    Read[sub, Character]; Read[sub, Character]; Read[sub, Character]; 
                	    Read[sub, Character];

						server["connection", uuid, "session", "data"][info["name"]] = StringDrop[ReadString[sub], -2];
                	];
				];

				Close[sub]; 
                
            ];

			Close[stream];			
			(*reset the length for a new requests*)

			server["connection", uuid, "currentLength"] = 0;
			server["connection", uuid, "length"] = 0;
			
			HTTP[server][uuid];
		];
		
	]
]

HTTP[server_Symbol?AssociationQ][uuid_] := 
With[{responce =
	Module[{type = "", fullpath, paths = Flatten[{server["path"]}]},
		With[{url = If[StringLength[#] == 0, "index.wsp", #] &@ StringRiffle[server["connection", uuid, "session", "Path"], If[$OperatingSystem == "Windows", "\\", "/"]]},
			type = MIMETypes[url//FileExtension];
			If[!StringQ[type], type = "application/octet-stream"];

			writeLog[server, "url `` type ``; ", url, type];
			
			
			Do[
				fullpath = FileNameJoin[{i,  If[$OperatingSystem == "Windows", StringReplace[url,"/"->"\\"], url]}];
				If[FileExistsQ[fullpath], Break[Do],
					Print["did not find by the path: "<>fullpath];
				];
			, {i, paths}];

			If[FileExistsQ[fullpath] != True,
				writeLog[server, "file `` doesnt exist", fullpath];
				WriteString[SocketObject[uuid], "HTTP/1.1 404 Not found\r\nContent-Length: 0\n\n"];
				Return["HTTP/1.1 404 Not found\r\nContent-Length: 0\n\n", Module];
			];
			If[FileExtension@url == "wsp" && !KeyExistsQ[server,"skipWSP"],
				Block[{WSP`$publicpath = Flatten[{server["path"]}]//First, WSP`session = server["connection", uuid, "session"], WSP`host = server["addr"]},
					With[{content = WSP`LoadPage[url]},
						If[KeyExistsQ[WSP`session, "Redirect"],		
							WriteString[SocketObject[uuid], "HTTP/1.1 303 OK\r\nLocation: /"<> WSP`session["Redirect"] <>"\r\nContent-Type: " <> type <>"\r\nContent-Length: " <> ToString[StringLength[content]] <> "\n\n"];
							WriteString[SocketObject[uuid], content];						
							Return[Null, Module];
						,
							WriteString[SocketObject[uuid], "HTTP/1.1 200 OK\r\nContent-Type: " <> type <>"\r\nContent-Length: " <> ToString[StringLength[content]] <> "\n\n"];
							WriteString[SocketObject[uuid], content];	
							Return[Null, Module];
						];
					];

				];
			,
				writeLog[server, "normal file: ``", fullpath];
				With[{size = FileByteCount[fullpath]},
					writeLog[server, "size: ``", size];
					(*Return[Join[StringToByteArray["HTTP/1.1 200 OK\r\nContent-Type: " <> type <>"\r\nContent-Length: " <> ToString[Length[content]] <> "\n\n"], content], Module];*)	
					WriteString[SocketObject[uuid], "HTTP/1.1 200 OK\r\nCache-Control: max-age=999600\r\nContent-Type: " <> type <>"\r\nContent-Length: " <> ToString[size] <> "\n\n"];
					BinaryWrite[SocketObject[uuid], ReadByteArray[fullpath]];
					Return[Null, Module];		
				];
			];

		];
	]},

	(*writeLog[server, "writting the responce"];
	
	If[StringQ[responce], WriteString[SocketObject[uuid], responce], BinaryWrite[SocketObject[uuid], responce]];*)
	
	(*Unset[server["connection", uuid]];

	If[server["socket-close"],
		writeLog["close socket"];
		Close[SocketObject[uuid]];
		writeLog[server, "closed id"<>esc["red"]<>uuid<>esc["reset"]];
	,
		writeLog["socket was added to trash"];
		server["trash"] = {server["trash"], SocketObject[uuid]};
	];*)
	
	
]

(*FCK I hate this. But what can you do, if the buffer will contain {}. The ByteArray will be converted to normalised one uncontrollably, such a shit*)
BufferFlatten[server_Symbol?AssociationQ][uuid_] := Join@@Select[{server["connection", uuid, "buffer"]}//Flatten, ByteArrayQ];
SetAttributes[BufferFlatten, HoldFirst]

(*a pipeline*)
(*just accumulate*)
handler[server_Symbol?AssociationQ][message_?AssociationQ] := 
Module[{header = "", stream, buffer = {}, responce},
With[{uuid = message["SourceSocket"][[1]]}, 
	If[Not[KeyExistsQ[server["connection"], uuid]], 
		server["connection", uuid] = <|
			"buffer" -> {}, 
			"status" -> "waiting", 
			"default" -> CreateRequest,
			"next"-> Null,
			"length" -> 0, 
			"time" -> Now,
 			"currentLength" -> 0
		|>; 
		(*writeLog[server, esc["red"]<>"[<*Now*>] New client"<>esc["reset"] ];
		writeLog[server, esc["red"]<>"id: "<>uuid<>esc["reset"] ];*)
	,
		(*writeLog[server, esc["magenta"]<>"[<*Now*>] Old client"<>esc["reset"] ];
		writeLog[server, esc["magenta"]<>"id: "<>uuid<>esc["reset"] ];*)
	];

	(*keep alive, until we still have requests*)
	server["connection", "time"] = Now;

	(*If[server["extralog"]//TrueQ,
		writeLog[server, "-------- raw-tcp-data -------"];
		writeLog[server, esc["blue"]<>(message["DataByteArray"]//ByteArrayToString)<>esc["reset"]];
		writeLog[server, "-------- end-tcp-data -------"];
	];*)
	(*writeLog[server, "--- raw data ---"];
	writeLog[server, message["Data"]];
	writeLog[server, "--- end data ---"];*)

	(*writeLog[server, "received: `` bytes", Length[message["DataByteArray"]]];*)

	(*close open connections if it was set to keep them*)
	(*If[!server["socket-close"], 
		If[server["cnt"] > 10,
			writeLog["cleared connections"];
			Close/@Flatten[server["trash"]];
			server["cnt"] = 0;
		,
			server["cnt"] += 1;
		];
	];*)

	(*accumulating the data by default. fast method with nested arrays*)
	(*we have to work with ByteArrays, otherwise websokets will not work. It creates a shitty conversion between string and bytes, cuz there is no method to stream bytearray*)
	server["connection", uuid, "buffer"] = {server["connection", uuid, "buffer"], message["DataByteArray"]};
	 
	(*writeLog[server, "buffer length: ``, must be: ``, real: ``", server["connection", uuid, "currentLength"], server["connection", uuid, "length"], Length@BufferFlatten[server][uuid]];*)
	
	(*go by the default to next*)
	(*writeLog[server, "try default"];*)
	(*let us try to check the headers and may be, we will find something to write an answer*)
	If[server["connection", uuid, "length"] == 0, 
		server["connection", uuid, "default"][server][uuid]; 

		(*from time to time one need to check dead connections*)
		checkDeadConnections[server];
		Return[];
	];
	(*if not*)

	(*accumulation the data if we did not use it in request*)
	server["connection", uuid, "currentLength"] += Length[message["DataByteArray"]];

	writeLog[server, "next call"];
	(*check the condiiton*)
	If[server["connection", uuid, "currentLength"] >= server["connection", uuid, "length"], server["connection", uuid, "next"][server][uuid]];	
]
]



(* ::Section:: *)
(*Server*)


SetAttributes[WEBServer, HoldFirst]


Options[WEBServer] = {
    "addr" -> "127.0.0.1:80", 
	"path" -> {"/"},
	"socket-close" -> True,
	"extra-logging" -> False
}

esc = Association["reset" -> "\033[1;0m",
   "black" -> "\033[1;30m", "red" -> "\033[1;31m",
   "green" -> "\033[1;32m", "yellow" -> "\033[1;33m",
   "blue" -> "\033[1;34m", "magenta" -> "\033[1;35m"];


WEBServer[opts___?OptionQ] := With[{server = Unique["Tinyweb`Objects`Server$"]}, 
    server = <|
		"addr" -> OptionValue[WEBServer, Flatten[{opts}], "addr"], 
		"path" -> OptionValue[WEBServer, Flatten[{opts}], "path"], 
		"extralog" -> OptionValue[WEBServer, Flatten[{opts}], "extra-logging"],
		"socket-close" -> OptionValue[WEBServer, Flatten[{opts}], "socket-close"], 
		"status" -> "Not started", 
		"handler" -> handler[server],
		"log" -> CreateDataStructure["Queue"],
		"nohup" -> False,
		"cnt" -> 0,
		"trash" -> {},
		"self" -> WEBServer[server]
	|>; 
	writeLog[server, "[<*Now*>] WEBServer created"]; 
	Return[WEBServer[server]]
]


WEBServer /: 
WEBServerStart[WEBServer[server_Symbol?AssociationQ]] := (
	writeLog[server, "[<*Now*>] ::Tiny Web Server:: starting"]; 

    If[!MemberQ[$Packages, "WSP`"],
        writeLog[server, "No WSP module was found..."];
        writeLog[server, "Only raw html will be shown"];
        server["skipWSP"] = True;
    ,
		SetWSPPublicPath[server["path"]];
	];

	server["connection"] = <||>;

	server["listener"] = SocketListen[server["addr"], server["handler"]]; 
	
	server["status"] = If[FailureQ[server["listener"]], "failed" ,"listening"];
	writeLog[server, "[<*Now*>] ::Tiny Web Server:: ``", server["status"]]; 
	If[FailureQ[server["listener"]], writeLog[server, "[<*Now*>] ::Tiny Web Server:: ``", server["listener"]//Compress]];
	WEBServer[server]
)


WEBServer /: 
WEBServerStop[WEBServer[server_Symbol?AssociationQ]] := (
	DeleteObject[server["listener"]];
	server["status"] = "stopped";
	
	WEBServer[server]
)

WEBServer /: 
WebSocketSubscribe[WEBServer[server_Symbol?AssociationQ],channel_, client_] := With[{},
	(*usually can be called from client side. so the variable client will be passed*)
	Print[StringTemplate["subscribe `` for `` channel"][client, channel]];
	server["connection", client, "subscription"] = channel;
]



WEBServer /: 
WebSocketBroadcast[WEBServer[server_Symbol?AssociationQ], exp_] := With[
    {
        clients = Select[server["connection"]//Keys, (First@server["connection", #, "session", "Upgrade"] == "websocket") &]
    },

    logWrite[server, StringTemplate["broadcast websocket. number of connections: ``"][Length[clients]]];

    BinaryWrite[SocketObject[#], constructReply[ExportString[exp,"ExpressionJSON", "Compact" -> -1]]]& /@ clients;
        
]

WEBServer /: 
WebSocketBroadcast[WEBServer[server_Symbol?AssociationQ], exp_, exception_] := With[
    {
        clients = Select[server["connection"]//Keys, (First@server["connection", #, "session", "Upgrade"] == "websocket" && # !=  exception) &]

    },

    logWrite[server, StringTemplate["broadcast websocket. number of connections: ``"][Length[clients]]];

    BinaryWrite[SocketObject[#], constructReply[ExportString[exp,"ExpressionJSON", "Compact" -> -1]]]& /@ clients;
        
]

WEBServer /: 
WebSocketPublish[WEBServer[server_Symbol?AssociationQ], exp_, channel_] := With[
    {
        clients = Select[server["connection"]//Keys, (MemberQ[server["connection", #, "session", "Upgrade"], "websocket"] && TrueQ[server["connection", #, "subscription"] === channel]) &]
    },

    (*StringTemplate["broadcast websocket only for subs of `` channel. number of connections: ``"][channel, Length[clients]]//Print;*)

    BinaryWrite[SocketObject[#], constructReply[ExportString[exp,"ExpressionJSON", "Compact" -> -1]]]& /@ clients;
        
]

WEBServer /: 
WebSocketPublishString[WEBServer[server_Symbol?AssociationQ], exp_, channel_] := With[
    {
        clients = Select[server["connection"]//Keys, (MemberQ[server["connection", #, "session", "Upgrade"], "websocket"] && TrueQ[server["connection", #, "subscription"] === channel]) &]
    },

    (*StringTemplate["broadcast websocket only for subs of `` channel. number of connections: ``"][channel, Length[clients]]//Print;*)

    BinaryWrite[SocketObject[#], constructReply[exp]]& /@ clients;
        
]


WEBServer[server_Symbol?AssociationQ][keys__String] := 
server[keys]


WEBServer[server_Symbol?AssociationQ][keys_Symbol] := 
server[ToString[keys]]


WEBServer[server_Symbol?AssociationQ][key_Symbol] := 
server[ToString[key]]


WEBServer /: 
Set[name_Symbol, server_WEBServer] := (
	name /: Set[name[key: _String | _Symbol], value_] := With[{$server = server}, $server[key] = value];
	Block[{WEBServer}, SetAttributes[WEBServer, HoldFirst]; name = server]
)


WEBServer /: 
Set[WEBServer[symbol_Symbol?AssociationQ][key_String], value_] := 
symbol[[key]] = value


WEBServer /: 
Set[WEBServer[symbol_Symbol?AssociationQ][key_Symbol], value_] := 
symbol[[ToString[key]]] = value


(* ::Section:: *)
(*Client*)




WEBServer /: 
MakeBoxes[obj: WEBServer[server_Symbol?AssociationQ], form_] := (
	BoxForm`ArrangeSummaryBox[
		WEBServer, 
		obj, 
		Null, 
		{
			{BoxForm`SummaryItem[{"addr: ", server[["addr"]]}], SpanFromLeft}, 
			{BoxForm`SummaryItem[{"path: ", server[["path"]]}], SpanFromLeft}, 
			{BoxForm`SummaryItem[{"status: ", server[["status"]]}], SpanFromLeft},
			{BoxForm`SummaryItem[{"socket-close: ", server[["socket-close"]]}], SpanFromLeft}
		}, {
			{BoxForm`SummaryItem[{"self: ", server[["self"]]}] /. WEBServer -> Defer, SpanFromLeft}
		}, 
		form
	]
)


End[] (*`Private`*)


(* ::Section:: *)
(*End package*)


EndPackage[] (*JTP`*)
