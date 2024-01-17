BeginPackage["JerryI`Notebook`AppExtensions`"]

AppExtensions::usage = ""

Begin["`Internal`"];

Templates = <||>;

emptyStringFunction[x__] := ""

AppExtensions`Templates[ opts: OptionsPattern[] ] := With[{template = OptionValue["Template"]},
    If[KeyExistsQ[Templates, template],
        #[opts] &/@ Templates[template]
    ,
        emptyStringFunction[opts]
    ]
]

Options[AppExtensions`Templates] = {"Template" -> ""}

(* global event object *)
AppExtensions`AppEvents      = "AppEvents"; 


AppExtensions`TemplateInjection /: Set[AppExtensions`TemplateInjection[template_String], function_] := With[{},
    If[KeyExistsQ[Templates, template],
        Templates[template] = Append[Templates[template], function];
    ,
        Templates[template] = {function}
    ];
]


End[]
EndPackage[]