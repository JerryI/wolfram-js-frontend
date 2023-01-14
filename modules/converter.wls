$SupportedGraphicsObjectList = {Graphics3D};

$conversionTemplate = Table[
 With[{item = i},
  item[x__] :> 
   With[{$uuid = CreateUUID[]}, $$$storage[$uuid] = 
     ExportString[item[x] // N, "ExpressionJSON"]; 
    FrontEndExecutable[$uuid]]
  ]
 , {i, $SupportedGraphicsObjectList}];