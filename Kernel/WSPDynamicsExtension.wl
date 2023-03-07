BeginPackage["JerryI`WolframJSFrontend`WSPDynamicsExtension`", {"Tinyweb`", "WSP`"}];

WSPDynamic::usage = "define dyn"

WSPDynamicGet::usage = "get"

Wrapper::usage = "set calss and tag"

Begin["`Private`"]; 

hashedObjects = <||>;

WSPDynamic[expr_] := Module[{hash},
    hash = "wsp-"<>Hash[Hold[expr], "Expression", "DecimalString"];
    hashedObjects[hash] = Hold[expr];

    {StringTemplate["<`` data-wsp=\"``\" style=\"display:none\">"]["div", hash], ReleaseHold[expr], "</div>"}
];


SetAttributes[Wrapper, HoldFirst]

Options[Wrapper] = {
    "tag" -> "div",
    "class" -> ""
};

SetAttributes[Wrapper, HoldFirst]

Wrapper[WSPDynamic[expr_], OptionsPattern[]] ^:= Module[{hash},
    hash = "wsp-"<>Hash[Hold[expr], "Expression", "DecimalString"];
    hashedObjects[hash] = Hold[expr];

    {StringTemplate["<`` data-wsp=\"``\" class=\"``\">"][OptionValue["tag"], hash, OptionValue["class"]], ReleaseHold[expr], "</"<>OptionValue["tag"]<>">"}
];


SetAttributes[WSPDynamic, HoldFirst]

WSPDynamicGet[uids_, url_] := Module[{result},
    result = Block[{session = URLParse[url], WSP`$publicpath = JerryI`WolframJSFrontend`public},
        session["Query"] = Association[session["Query"]];
        {#, (ToString /@ Flatten[{hashedObjects[#]//ReleaseHold}]) // StringJoin} &/@ uids
    ];

    WebSocketSend[Global`client, Global`PageModulesUpdate[result] ];
];

End[];

EndPackage[];