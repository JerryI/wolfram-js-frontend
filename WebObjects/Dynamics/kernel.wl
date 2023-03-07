HTMLSlider[min_, max_, step_:1] := Module[{view, script, id = CreateUUID[]},
    EventObject[<|"id"->id, "view"->WEBSlider[id, {min, max, step}]|>]
];

HTMLForm[EventObject[assoc_]] ^:= CreateFrontEndObject[assoc["view"]];