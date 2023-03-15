BeginPackage["JerryI`WolframJSFrontend`WSPDynamicsExtension`", {"Tinyweb`", "WSP`"}];

(*
    ::Only for MASTER kernel::

    WSP Extension for dynamically updatable HTML blocks
    - creates a wrapper around using DIV element
    - stores unevaluated expressions in the memory
    - simulates the natural loading routine with a given fake session and generates result
*)

WSPDynamic::usage = "mark a dynamic element"
WSPDynamicGet::usage = "get the updated dynamic element with a substituted session"
(* can be improved a lot.... *)

Begin["`Private`"]; 

hashedObjects = <||>;

ClearAll[WSPDynamic]
SetAttributes[WSPDynamic, HoldFirst]

WSPDynamic[expr_, ihash_:Null] := Module[{hash = ihash}, 
    If[!StringQ[hash],
        hash = "wsp-"<>Hash[Hold[expr], "Expression", "DecimalString"];
    ];

    hashedObjects[hash] = <|"hidden"->False, "expr"->Hold[expr]|>;

    {StringTemplate["<`` data-wsp=\"``\">"]["div", hash], ReleaseHold[expr], "</div>"}
];


WSPDynamicGet[uids_, s_] := Module[{result},
    result = Block[{session = s, WSP`$publicpath = JerryI`WolframJSFrontend`public},
        
        DeleteMissing[
            With[{},
                If[hashedObjects[#,"hidden"],
                    hashedObjects[#, "expr"]//ReleaseHold;
                    Missing[]
                ,
                    {#, (ToString /@ Flatten[{hashedObjects[#, "expr"]//ReleaseHold}]) // StringJoin} 
                ]
            
            ]&/@ uids
        ]
    ];

    WebSocketSend[Global`client, Global`PageModulesUpdate[result] ];
];

End[];

EndPackage[];