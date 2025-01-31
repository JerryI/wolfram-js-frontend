BeginPackage["JerryI`Notebook`AppExtensions`"]

AppExtensions::usage = ""
ExtensionEvent::usage = ""

AppExtensions`AppProtocol;
AppExtensions`FrontendEnv;

AppExtensions`WebServers;

AppExtensions`HTTPHandler::usage = ""
AppExtensions`KernelList::usage = ""

Begin["`Internal`"];

Templates = <||>;

emptyStringFunction[x__] := ""

AppExtensions`WebServers = <||>;

AppExtensions`Templates[ opts: OptionsPattern[] ] := With[{template = OptionValue["Template"]},
    If[KeyExistsQ[Templates, template],
        #[opts] &/@ Templates[template]
    ,
        emptyStringFunction[opts]
    ]
]

AppExtensions`HTTPHandler = Null

sidebarIcons = {};
AppExtensions`SidebarIcons := sidebarIcons
AppExtensions`SidebarIcons /: Set[AppExtensions`SidebarIcons, list_List] := (sidebarIcons = Join[sidebarIcons, list])

Options[AppExtensions`Templates] = {"Template" -> ""}

(* global event object *)
AppExtensions`AppEvents      = "AppEvents"; 
AppExtensions`AppProtocol = "AppProtocol$::";

AppExtensions`TemplateInjection /: Set[AppExtensions`TemplateInjection[template_String], function_] := With[{},
    If[KeyExistsQ[Templates, template],
        Templates[template] = Append[Templates[template], function];
    ,
        Templates[template] = {function}
    ];
]


End[]
EndPackage[]