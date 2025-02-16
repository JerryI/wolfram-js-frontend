BeginPackage["CoffeeLiqueur`Notebook`SettingsUtils`"];
Begin["`Internal`"];

loadConfiguration  := If[FileExistsQ[FileNameJoin[{Directory[], "_settings.wl"}]], Get[FileNameJoin[{Directory[], "_settings.wl"}]], Missing[]];
storeConfiguration[c_Association] := Put[c, FileNameJoin[{Directory[], "_settings.wl"}] ];

initialize[conf_, OptionsPattern[] ] := With[{default = OptionValue["Defaults"]},
    conf = Join[default, (If[MissingQ[#], <||>, #]& ) @ loadConfiguration];
    storeConfiguration[conf]
];

SetAttributes[initialize, HoldFirst];
Options[initialize] = {"Defaults" -> <|"Autostart" -> True|>}

End[]
EndPackage[]

{CoffeeLiqueur`Notebook`SettingsUtils`Internal`initialize, CoffeeLiqueur`Notebook`SettingsUtils`Internal`storeConfiguration}