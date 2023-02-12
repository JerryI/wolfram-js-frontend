SVGForm[x_] := ExportString[x, "SVG"]//HTMLForm;

JSRun[x_String, name_String:"JS"] := (StringTemplate["<div class=\"badge badge-danger\">``</div><script>``</script>"][name, x])//HTMLForm;

ListContourPloty[s_List] := WListContourPloty[Transpose[s//N]];

Options[ListLinePloty] = {
    PlotRange -> {{-Infinity, Infinity}, {-Infinity, Infinity}}
};


 
ListLinePloty[x_List, OptionsPattern[]] := Module[{transp},
    Switch[Depth[x//N],
        3,
            transp = { (Transpose[FilterRange[x, OptionValue[PlotRange] ] ])}
        ,
        4,
            transp = ( Transpose[FilterRange[#, OptionValue[PlotRange] ] ] ) &/@ x
        ,
        2,
            transp = {Table[i, {i, 1, Length[x]}], x}
    ];

    WListPloty[ExportString[transp//N, "JSON"] ]
];

Ploty[f_, range_, op : OptionsPattern[Plot]] := Plot[f, range, op] // Cases[#, Line[x_] :> x, All] & // ListLinePloty[#, op] & ;

Options[WebExport] = {
    Popup -> False 
};

WebOpen[url_] := (
    WebSocketSend[client, FrontEndJSEval[StringTemplate["window.open('``', '_blank')"][url] ] ];
);

WebExport[name_, exp_, OptionsPattern[]] := (
    Export["public/trashcan/"<>name, exp];
    If[OptionValue[Popup],
        WebSocketSend[client, FrontEndJSEval[StringTemplate["window.open('http://'+window.location.hostname+':'+window.location.port+'/trashcan/``', '_blank')"][name]]];
    ];
    StringTemplate["<a href=\"/trashcan/``\" class=\"badge badge-warning\">Download ``</a>"][name, name]//HTMLForm
); 