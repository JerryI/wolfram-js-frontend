RegisterWebObject[HTMLForm];
RegisterWebObject[TextForm];

RegisterWebObject[FrontEndTruncated];

Global`SVGForm[x_] := ExportString[x, "SVG"]//HTMLForm;

JSRun[x_String, name_String:"JS"] := (StringTemplate["<div class=\"badge badge-danger\">``</div><script>``</script>"][name, x])//HTMLForm;

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


