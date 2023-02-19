(* ::Package:: *)

(* ::Chapter:: *)

(* ::Section::Closed:: *)
(*Begin package*)

BeginPackage["JerryI`WolframJSFrontend`Starter`", {
  "Tinyweb`", "CodeParser`", "JerryI`WolframJSFrontend`Cells`", 
  "JerryI`WolframJSFrontend`DBManager`", "JerryI`WolframJSFrontend`Dynamics`", 
  "JerryI`WolframJSFrontend`Evaluator`", "JerryI`WolframJSFrontend`Kernel`",
  "JerryI`WolframJSFrontend`Notebook`", "JerryI`WolframJSFrontend`Notifications`",
  "JerryI`WolframJSFrontend`Starter`", "JerryI`WolframJSFrontend`Utils`",
  "JerryI`WolframJSFrontend`WebObjects`"
  }]; 

JSFrontendStart::usage = "JSFrontendStart[addr->, port->]"

Begin["`Private`"]; 

$ContextAliases["jsf`"] = "JerryI`WolframJSFrontend`";
console["log", "Hi!"];

Options[JSFrontendStart] = {"addr" -> "127.0.0.1", "port"->8090};

JSFrontendStart[OptionsPattern[]] := (
  jsf`server = WEBServer["addr" -> StringTemplate["``:``"][OptionValue["addr"], OptionValue["port"]], "path" -> jsf`public, "socket-close" -> True, "extra-logging"->True];
  jsf`server = jsf`server // WEBServerStart;

  NotificationMethodRegister;
  DBLoad;
  SetUpCron;
  LoadWebObjects;

  console["log", "Open http://`` in your browser", jsf`server["addr"]];
);

JerryI`WolframJSFrontend`ExtendDefinitions = NotebookExtendDefinitions;

SetUpCron := (
  (* ping-pong with frontend *)
  SessionSubmit[ScheduledTask[WebSocketBroadcast[jsf`server, Global`Pong[]], Quantity[5, "Seconds"]]];
  (* hidding up the notifications *)
  SessionSubmit[ScheduledTask[(jsf`notifications[#]["hide"] = True) &/@ (Select[jsf`notifications//Keys,  (jsf`notifications[#, "date"] < (Now - jsf`notifications[#, "duration"]))&]), Quantity[2, "Minutes"]]];  
  (* cleanining up the notifications *)
  SessionSubmit[ScheduledTask[(jsf`notifications[#] = .;)&/@ (Select[jsf`notifications//Keys,  (jsf`notifications[#]["date"] < (Now - Quantity[1, "Days"]))&]), Quantity[6, "Hours"]]];  
  (* backing up *)
  SessionSubmit[ScheduledTask[DBBack, Quantity[60, "Minutes"]]];
  (* stats *)
  SessionSubmit[ScheduledTask[console["log", "<*Now*>"]; console["memory stat"];, Quantity[20, "Minutes"]]]; 
);

NotebookDefineEvaluators["Default",
  {
    MarkdownQ ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->MarkdownProcessor  |>,
    WSPQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->WSPProcessor       |>,
    (True&)   ->  <|"SyntaxChecker"->WolframCheckSyntax,    "Epilog"->SplitExpression,  "Prolog"->(#&), "Evaluator"->WolframProcessor   |>
  }
];

MarkdownQ[str_] := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.md$"]]] > 0;
WSPQ[str_]      := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.(wsp|html|htm)$"]]] > 0;


(*exprs splitter. credits https://github.com/njpipeorgan *)
SplitExpression[astr_] := With[{str = StringReplace[astr, "%"->"$$$out"]},
  StringTake[str, Partition[Join[{1}, #, {StringLength[str]}], 2]] &@
   Flatten[{#1 - 1, #2 + 1} & @@@ 
     Sort@
      Cases[
       CodeParser`CodeConcreteParse[str, 
         CodeParser`SourceConvention -> "SourceCharacterIndex"][[2]], 
       LeafNode[Token`Newline, _, a_] :> Lookup[a, Source, Nothing]]]
];

(*syntax check. credits https://github.com/njpipeorgan *)
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



End[];

EndPackage[]; 