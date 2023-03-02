#!/usr/bin/env wolframscript

$HistoryLength = 0
PacletDirectoryLoad[Directory[]]
Needs["CodeParser`"]
Get["JerryI`WolframJSFrontend`"]
Get/@{
  "JerryI`WolframJSFrontend`Cells`", 
  "JerryI`WolframJSFrontend`DBManager`", "JerryI`WolframJSFrontend`Dynamics`", 
  "JerryI`WolframJSFrontend`Evaluator`", "JerryI`WolframJSFrontend`Kernel`",
  "JerryI`WolframJSFrontend`Notebook`", "JerryI`WolframJSFrontend`Notifications`",
  "JerryI`WolframJSFrontend`Starter`", "JerryI`WolframJSFrontend`Utils`",
  "JerryI`WolframJSFrontend`WebObjects`", "JerryI`WolframJSFrontend`Dev`"
  };

$ContextAliases["jsf`"] = "JerryI`WolframJSFrontend`";
console["log", "Hi!"];

JerryI`WolframJSFrontend`ExtendDefinitions = NotebookExtendDefinitions;

SetUpCron := (
  (* ping-pong with frontend *)
  SessionSubmit[ScheduledTask[WebSocketBroadcast[jsf`server, Global`Pong[360.0 Now[[1, -1]] / 60.0 //Round]], Quantity[3, "Seconds"]]];
  (* hidding up the notifications *)
  SessionSubmit[ScheduledTask[(jsf`notifications[#]["hide"] = True) &/@ (Select[jsf`notifications//Keys,  (jsf`notifications[#, "date"] < (Now - jsf`notifications[#, "duration"]))&]), Quantity[2, "Minutes"]]];  
  (* cleanining up the notifications *)
  SessionSubmit[ScheduledTask[(jsf`notifications[#] = .;)&/@ (Select[jsf`notifications//Keys,  (jsf`notifications[#]["date"] < (Now - Quantity[1, "Days"]))&]), Quantity[6, "Hours"]]];  
  (* stats *)
  SessionSubmit[ScheduledTask[console["log", "<*Now*>"], Quantity[20, "Minutes"]]]; 
);

NotebookDefineEvaluators["Default",
  {
    MarkdownQ ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->MarkdownProcessor  |>,
    WSPQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->WSPProcessor       |>,
   (True&)    ->  <|"SyntaxChecker"->WolframCheckSyntax,    "Epilog"->SplitExpression,  "Prolog"->(#&), "Evaluator"->WolframProcessor   |>
  }
];

MarkdownQ[str_] := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.md$"]]] > 0;
WSPQ[str_]      := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.(wsp|html|htm)$"]]] > 0;

JSQ[str_]       := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.(js|jsx)$"]]] > 0;


SplitExpression[astr_] := With[{str = StringReplace[astr, "%"->"$$$out"]},
  StringTake[str, Partition[Join[{1}, #, {StringLength[str]}], 2]] &@
   Flatten[{#1 - 1, #2 + 1} & @@@ 
     Sort@
      Cases[
       CodeParser`CodeConcreteParse[str, 
         CodeParser`SourceConvention -> "SourceCharacterIndex"][[2]], 
       LeafNode[Token`Newline, _, a_] :> Lookup[a, Source, Nothing]]]
];

WolframCheckSyntax[str_String] := 
    Module[{syntaxErrors = Cases[CodeParser`CodeParse[str],(ErrorNode|AbstractSyntaxErrorNode|UnterminatedGroupNode|UnterminatedCallNode)[___],Infinity]},
        If[Length[syntaxErrors]=!=0 ,
            

            Return[StringRiffle[
                TemplateApply["Syntax error `` at line `` column ``",
                    {ToString[#1],Sequence@@#3[CodeParser`Source][[1]]}
                ]&@@@syntaxErrors

            , "\n"], Module];
        ];
        Return[True, Module];
    ];

WolframProcessor[expr_String, signature_String, callback_] := Module[{str = StringTrim[expr], block = False},
  Print["WolframProcessor!"];
  If[StringTake[str, -1] === ";", block = True; str = StringDrop[str, -1]];
  JerryI`WolframJSFrontend`Notebook`Notebooks[signature]["kernel"][WolframEvaluator[str, block, signature], callback, "Link"->"WSTP"];
];    

WSPProcessor[expr_String, signature_String, callback_] := Module[{str = StringDrop[expr, StringLength[First[StringSplit[expr, "\n"]]] ]},
  Print["WSPProcessor!"];
  JerryI`WolframJSFrontend`Notebook`Notebooks[signature]["kernel"][WSPEvaluator[str, signature], callback, "Link"->"WSTP"];
];

MarkdownProcessor[expr_String, signature_String, callback_] := Module[{str = StringDrop[expr, StringLength[First[StringSplit[expr, "\n"]]] ]},
  Print["MarkdownProcessor!"];
  JerryI`WolframJSFrontend`Notebook`Notebooks[signature]["kernel"][MarkdownEvaluator[str, signature], callback, "Link"->"WSTP"];
];

JSProcessor[expr_String, signature_String, callback_] := Module[{},
  Print["JSProcessor!"];
  JerryI`WolframJSFrontend`Notebook`Notebooks[signature]["kernel"][JSEvaluator[str, signature], callback, "Link"->"WSTP"];
];

port = "8090";
ip = "127.0.0.1";

If[MemberQ[$ScriptCommandLine, "port"],
  port = $ScriptCommandLine[[(Position[$ScriptCommandLine, "port"]//First//First) + 1]];
];

If[MemberQ[$ScriptCommandLine, "ip"],
  ip =  $ScriptCommandLine[[(Position[$ScriptCommandLine, "ip"]//First//First) + 1]]
];


FileTypeHandler[path_, types_] := Module[{},
  (* add the path to the server PATH variable for loading pictures from the vault *)
  jsf`server["path"] = Join[Take[jsf`server["path"], 2], {If[DirectoryQ[path], path, DirectoryName[path] ] }];

  (* handlers *)
  (Which@@Flatten[types/.{Rule[a_,b_]:>{path//a, b}}])[path]
]

NotFound[path_] := <|"view" :> LoadPage["template/views/404.wsp"] |>;
EmptyWindow[path_] := <|"view" :> LoadPage["template/views/empty.wsp"] |>;

NotebookQ[path_] := (StringTake[path, -2] === "wl");

$AssoticatedPath = <||>;

PreloadNotebook[path_] := Module[{notebook},
  If[!MemberQ[$AssoticatedPath//Keys, path],
    notebook = Get[path];
    If[notebook["serializer"] =!= "jsfn",  ];

    JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"] ] = notebook["notebook"];
    JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "path"] = path;
    JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "cell"] = JerryI`WolframJSFrontend`Cells`setCellID[JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "cell"] ];
    
    Print[JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"] ]//InputForm//ToString ];
    JerryI`WolframJSFrontend`Cells`CellObjUnpack /@ notebook["cells"];

    $AssoticatedPath[path] = notebook["notebook", "id"];
    Print[$AssoticatedPath];
    Clear[notebook];
    Print["LOADED"];
  ]
]


LoadNotebook[path_] := Module[{},
  <|"view":> LoadPage["template/views/editor.wsp", {notebook = $AssoticatedPath[path]}] |>
];


ImageFileQ[path_] := MemberQ[{"png", "svg", "jpg", "jpeg", "gif"}, FileExtension[path]];
ImageViewer[path_] := <|"view" :> LoadPage["template/views/image.wsp", {url = path}]  |>;

SupportedTypes = {
  DirectoryQ  ->  EmptyWindow,
  NotebookQ   ->  LoadNotebook,
  ImageFileQ  ->  ImageViewer,
  (True&)     ->  NotFound
}




address = ip<>":"<>port;

WSPCache["Off"];

jsf`jtp   =  JTPServer["host" -> ip, "port" -> 8092, "nohup"->True] // JTPServerStart
jsf`jtp["promise"] = Null

jsf`server = WEBServer["addr" -> address, "path" -> {jsf`public, "/", {"/"}}, "socket-close" -> True];
jsf`server = jsf`server // WEBServerStart;

(*NotificationMethodRegister;*)
SetUpCron;

LoadBuildFile["config.build.wl"];
JerryI`WolframJSFrontend`Dev`Private`Rebuild;

console["log", "Open http://`` in your browser", jsf`server["addr"]];

While[True, Pause[1]];