BeginPackage["JerryI`WolframJSFrontend`WSPDynamicsExtension`", {"Tinyweb`", "WSP`"}];

WSPDynamic::usage = "define dyn"

WSPDynamicGet::usage = "get"

Hidden::usage = ""

Wrapper::usage = "set calss and tag"

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