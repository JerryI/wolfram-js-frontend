$SupportedGraphicsObjectList = {Graphics3D, HTMLForm, WListPloty, TableForm};

$conversionTemplate = Table[
 With[{item = i},
  item[x__] :> 
   With[{$uuid = CreateUUID[]}, $$$storage[$uuid] = 
     ExportString[item[x], "ExpressionJSON"]; 
    FrontEndExecutable[$uuid]]
  ]
 , {i, $SupportedGraphicsObjectList}];

 
