BeginPackage["WSP`"]


(* ::Section:: *)
(*Clear names*)


ClearAll["`*"]

LoadPage::usage = 
"LoadPage[filepath, vars]"

LoadString::usage = 
"LoadPage[string, vars]"

AST::usage = 
"LoadPage[filepath]"

Process::usage = 
"LoadPage[filepath]"

Parse::usage = 
"LoadPage[filepath]"

WSPCache::usage = 
"WSPCache[\"On\"]"

(* smart caching. credits https://github.com/KirillBelovTest *)
ClearAll[wcache]

SetAttributes[wcache, HoldFirst]

wcache[expr_, date_DateObject] := (
	wcache[expr, {"Date"}] = date; 
	wcache[expr, date] = expr
);

wcache[expr_, interval_String: "Minute"] := (
	If[DateObjectQ[wcache[expr, {"Date"}]] && DateObject[Now, interval] != wcache[expr, {"Date"}], 
		wcache[expr, wcache[expr, {"Date"}]] =.]; 
	wcache[expr, DateObject[Now, interval]]
);

pcache = wcache;

WSPCache["On"]  := pcache = wcache;
WSPCache["Off"] := pcache = Function[x, x];

LoadPage[p_, vars_:{}, OptionsPattern[]]:=
    Block[vars,
        With[
            
            {$filepath = If[StringQ[$publicpath], 
                                FileNameJoin[{$publicpath,  If[$OperatingSystem == "Windows", StringReplace[p,"/"->"\\"], p]}], 

                                If[StringQ[OptionValue["base"]], 
                                    FileNameJoin[{OptionValue["base"],  If[$OperatingSystem == "Windows", StringReplace[p,"/"->"\\"], p]}],
                                    If[$OperatingSystem == "Windows", StringReplace[p,"/"->"\\"], p]
                                ]
                            ]
            }, 

            Process@(pcache[ With[{stream = Import[$filepath, "String"]}, AST[stream, {}, "Simple"] ] ])
        ]
    ];

Options[LoadPage] = {"base" -> Null};

LoadString[p_, vars_:{}]:=
    Block[vars,
        Process@AST[p, {}, "Simple"]
    ];    

SetAttributes[LoadPage, HoldRest];
SetAttributes[LoadString, HoldRest];

StringFix[str_]:=StringReplace[str,Uncompress["1:eJxTTMoPSmNiYGAoZgESQaU5qcGMQIYSmFQHAFYsBK0="]];
StringUnfix[str_]:=StringReplace[str,Uncompress["1:eJxTTMoPSmNiYGAoZgESQaU5qcGMQIY6mFQCAFZKBK0="]];

Begin["`Private`"]

(*replacement for web objects*)
webrules = {
                Graphics :> (ExportString[#, "SVG"] &@*Graphics),
                Graphics3D :> (ExportString[#, "SVG"] &@*Graphics3D)
           };

(*WARNING! CODE STYLE CAN CAUSE INSTANT DEATH*)



AST[s_, init_ : {}, "Simple"] := Module[
{code = init, text = "", rest = "", last = "", c = "", exp = "", bra = 0, depth = 0, substream, length},
    (*extract everything before *)

    If[s == "", Return[Flatten@code, Module]];

    text = Null;
    length = StringLength[s];

    (*like in C style, probably it will be slower*)
    Do[
        If[StringTake[s, {i,i+4}] == "<?wsp",
            text = StringTake[s, i-1];
            rest = StringDrop[s, i+4];
            Break[];
        ]
        , {i, length-4}    
    ];

    (*pure HTML text*)
    If[TrueQ[text == Null],
        Return[Flatten@{code, "HTML" -> s}, Module];
    ];

    text = StringTrim[text];
    code = {code, "HTML" -> text};

    

    (*extract the WF expression*)
    exp = Null;
    last = "";

    length = StringLength[rest];
    bra = 0; depth = 0;
    Do[
        If[StringTake[rest, {i,i+1}] == "?>",
            If[bra == 0,
                exp = StringTake[rest, i-1];
                last = StringDrop[rest, i+1];   
                Break[];     
            ,
                depth++
            ]

        ];

        If[StringPart[rest,i] == "[", bra++];
        If[StringPart[rest,i] == "]", bra--];    

        , {i, length-1}    
    ];

    If[TrueQ[exp == Null],
        Return[{"HTML" -> "Syntax error!"}, Module];
    ];

    If[depth > 0,
        code = {code, "MODULE" -> AST[exp, {}, "Module"]};
    ,
        code = {code, "WF" -> exp};
    ];

    (*for the rest of the code lines*)
    If[StringLength[last] == 0,
        Flatten@code
        ,  
        AST[last, code, "Simple"]
    ]
]



AST[s_, init_ : {}, "Module"] := Module[
{code = <||>, body = "", rest = "", text = "", c = "", exp = "", bra = 0, depth = 0, substream, subsubstream, tail="", head="", length},

    rest = Null;

    length = StringLength[s];

    (*like in C style, probably it will be slower*)
    Do[
        If[StringTake[s, {i,i+1}] == "?>",
            code["HEAD"] = StringTake[s, i-1];
            rest = StringDrop[s, i+1];
            Break[];
        ]
        , {i, length-1}    
    ];

    If[TrueQ[rest == Null], Return[<| "HEAD"->"", "BODY"->{"HTML"->"Syntax module error!"}, "TAIL"->"" |>, Module]];

    length = StringLength[rest];
    body = "";

    Do[
        If[StringTake[rest, {length-i+1-4, length-i+1}] == "<?wsp",
            code["TAIL"] = StringDrop[rest, length-i+1];
            body = StringTake[rest, length-i+1-4-1];
            Break[];
        ]
        , {i, length}    
    ];

    code["BODY"] = AST[body, {}, "Simple"];

    code
]

Parse[x_] := 
  StringJoin[x["HEAD"] ,
   "{", (Switch[#[[1]], "HTML", StringJoin["+%+" , StringReplace[#[[2]], "\""->"-%-"], "+%+"], 
        "WF", #[[2]], "MODULE", Parse@#[[2]]] <> "," & /@ 
     Drop[x["BODY"], -1]) , (Switch[#[[1]], "HTML", 
       StringJoin["+%+" , StringReplace[#[[2]], "\""->"-%-"], "+%+"], "WF", #[[2]], "MODULE", 
       Parse@#[[2]]] &@Last[x["BODY"]]) , "}" , x["TAIL"]]

Process[x_] := 
  StringJoin@@ToString/@((
   Flatten@(Switch[#[[1]], "HTML", #[[2]], "WF", ReplaceAll[ToExpression@StringReplace[#[[2]], {"+%+" -> "\"", "\r\n" -> "", "-%-" -> "\\\""}], webrules], 
        "MODULE", ReplaceAll[ToExpression@StringReplace[Parse@#[[2]], {"+%+" -> "\"", "\r\n" -> "", "-%-" -> "\\\""}], webrules]] & /@ x)))

End[] (*`Private`*)


(* ::Section:: *)
(*End package*)


EndPackage[] (*JTP`*)