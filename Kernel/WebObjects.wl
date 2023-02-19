

BuildWebObjects := (
  JerryI`WolframJSFrontend`WebObjects`list =...
  FileNames[];

  JerryI`WolframJSFrontend`WebObjects`replacement = Table[
    With[{item = i},
      {
        FrontEndObject[item[x__], $ouid_:CreateUUID[]] :> With[{}, $NewDefinitions[$ouid] = ExportString[item[x], "ExpressionJSON"]; FrontEndExecutable[$ouid]],
        item[x__] :> With[{$ouid = CreateUUID[]}, $NewDefinitions[$ouid] = ExportString[item[x], "ExpressionJSON"]; FrontEndExecutable[$ouid]]
      }
    ]
   , {i, JerryI`WolframJSFrontend`WebObjects`list}];

  JerryI`WolframJSFrontend`WebObjects`replacement = {JerryI`WolframJSFrontend`WebObjects`replacement, 
    FrontEndObject[x_, $ouid_:CreateUUID[]] :> With[{}, $NewDefinitions[$ouid] = ExportString[x, "ExpressionJSON"]; FrontEndExecutable[$ouid]]
  } // Flatten;
);

