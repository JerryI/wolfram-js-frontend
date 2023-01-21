$SupportedGraphicsObjectList = {Graphics3D, HTMLForm};

$conversionTemplate = Table[
 With[{item = i},
  item[x__] :> 
   With[{$uuid = CreateUUID[]}, $$$storage[$uuid] = 
     ExportString[item[x] // N, "ExpressionJSON"]; 
    FrontEndExecutable[$uuid]]
  ]
 , {i, $SupportedGraphicsObjectList}];

 
 SVGForm[x_] := ExportString[x, "SVG"]//HTMLForm;