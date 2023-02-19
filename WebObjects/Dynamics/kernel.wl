WebSlider[min_, max_, step_:1] := Module[{view, script, id = CreateUUID[]},
    view = StringTemplate["<input type=\"range\" class=\"form-range\" value=\"``\" min=\"``\" max=\"``\" step=\"``\" id=\"``\">"][min, min, max, step, id];
    script = StringTemplate["<script>
    {
        document.getElementById('``').addEventListener(\"input\", (event) => {
            socket.send('EmittEvent[\"``\", ' + event.target.value + ']');
        })
    }
    </script>"][id, id];

    EventObject[<|"id"->id, "view"->StringJoin[view, script]|>]
];

HTMLForm[EventObject[assoc_]] ^:= HTMLForm[assoc["view"]];