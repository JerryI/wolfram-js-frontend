$SupportedGraphicsObjectList = {Graphics3D, HTMLForm, WListPloty};

$conversionTemplate = Table[
 With[{item = i},
  item[x__] :> 
   With[{$uuid = CreateUUID[]}, $$$storage[$uuid] = 
     ExportString[item[x] // N, "ExpressionJSON"]; 
    FrontEndExecutable[$uuid]]
  ]
 , {i, $SupportedGraphicsObjectList}];

 
