(*stuff for indication progress*)
settings["cpu"] = 0;

GasWarmer := (settings["cpu"] = settings["cpu"] + 10; WebSocketBroadcast[SetSmoke[settings["cpu"] ] ];);
GasColder := (settings["cpu"] = settings["cpu"] - 10; WebSocketBroadcast[SetSmoke[settings["cpu"] ] ];);

GasCool := (WebSocketBroadcast[SetSmoke[0]]; settings["cpu"] = 0);

Options[PushNotification] = {"duration" -> Quantity[2, "Minutes"]};

PushNotification[author_, message_, OptionsPattern[]]:=With[{uid = CreateUUID[]},
  settings["notifications"][uid] = <||>;
  settings["notifications"][uid]["date"] = Now;
  settings["notifications"][uid]["uid"] = uid;
  settings["notifications"][uid]["author"] = author;
  settings["notifications"][uid]["message"] = message;

  settings["notifications"][uid]["duration"] = OptionValue["duration"];

  console["log", ">> push notification globally"];

  Block[{id = uid},
      WebSocketBroadcast[server,
        PushMessage[
          LoadPage["assets/singletoast.wsp", {state = " immediate"}, "base"->$env["path"]]
        ]
      ];  
  ]

];