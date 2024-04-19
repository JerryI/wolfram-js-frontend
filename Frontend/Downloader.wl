BeginPackage["JerryI`Notebook`HTTPDownLoader`", {
    "KirillBelov`HTTPHandler`",
    "KirillBelov`HTTPHandler`Extensions`",
    "KirillBelov`Internal`"
}]
    
    Begin["`Internal`"]

    handler[request_] := With[{path = request["Query", "path"]},
        (*dangerous stuff. I Asked to take an absolute path to a file like that *)
        ImportFile[URLDecode[path], "Base"->Nothing]
    ]

    module[OptionsPattern[] ] := With[{http = OptionValue["HTTPHandler"]},
        Echo["Downloads module was attached"];
        http["MessageHandler", "Downloader"] = AssocMatchQ[<|"Path" -> "/downloadFile/"|>] -> handler;
    ]

    Options[module] = {"HTTPHandler" -> Null}

    End[]

EndPackage[]

JerryI`Notebook`HTTPDownLoader`Internal`module