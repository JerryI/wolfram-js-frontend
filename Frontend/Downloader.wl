BeginPackage["JerryI`Notebook`HTTPDownLoader`", {
    "KirillBelov`HTTPHandler`"
    "KirillBelov`HTTPHandler`Extensions`"
}];
    
    Begin["`Internal`"];

    handler[request_] := With[{path = request["Query", "path"]},
        ImportFile[URLDecode[path], "Base"->{Directory[]}]
    ]

    module[OptionsPattern[] ] := With[{http = OptionValue["HTTPHandler"]},
        http["MessageHandler", "Downloader"] = AssocMatchQ[<|"Path" -> "/downloadFile"|>] -> handler;
    ]

    Options[module] = {"HTTPHandler" -> Null}

    End[];

EndPackage[];

JerryI`Notebook`HTTPDownLoader`Internal`module