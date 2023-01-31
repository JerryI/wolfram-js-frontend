#!/usr/bin/env wolframscript
(* ::Package:: *)

$env = <|
  "addr" -> "127.0.0.1",
  "port" -> 8090,
  "path" -> "public",
  "storagehost" -> "127.0.0.1:8090",
  "domain" -> "127.0.0.1:8090"
|>;

If[MemberQ[$ScriptCommandLine, "port"],
  $env["port"] = $ScriptCommandLine[[(Position[$ScriptCommandLine, "port"]//First//First) + 1]]//ToExpression;
];

If[MemberQ[$ScriptCommandLine, "ip"],
  With[{ip =  $ScriptCommandLine[[(Position[$ScriptCommandLine, "ip"]//First//First) + 1]], port = ToString[$env["port"]]},
    $env["domain"] = ip<>":"<>port;
    $env["storagehost"] = ip<>":"<>port;
    $env["addr"] = ip;
  ]
];

(* ::Input:: *)
(**)


Print[">> INITIALIZATION STARTS"];

Print[$ScriptCommandLine//ToString];

NullQ[x_]:=TrueQ[x == Null];

CronTasks = <||>;

Print[">> AUTOLAUNCH"];
console["log", message_, args___] := Print[StringTemplate[message][args]];

Do[

  console["log", ">> run: ``", i];
  Import[i];

, {i, SortBy[Select[FileNames["*.wls"], Function[x, x != "start.wls"]], If[StringContainsQ[#, "prior"], -1, 1]& ]}];


While[True,
    Pause[0.1];
    (Block[{This := $loop[#]}, $loop[#, "expression"]//ReleaseHold]; $loop[#] = .) &/@ Keys@$loop;
];