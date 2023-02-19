BeginPackage["JerryI`WolframJSFrontend`Notifications`", {"JerryI`WolframJSFrontend`Utils`", "Tinyweb`"}]; 

PushNotification::usage = "PushNotification[from, message, \"duration\" -> duration]"
NotificationMethodRegister::usage = "NotificationMethodRegister overrides the Message Output"

Begin["`Private`"]; 

Options[PushNotification] = {"duration" -> Quantity[2, "Minutes"]};

PushNotification[author_, message_, OptionsPattern[]] := With[{uid = CreateUUID[]},
  JerryI`WolframJSFrontend`notifications[uid] = <|"date" -> Now, "uid"->uid, "author"->author, "message"->message, "duration"->OptionValue["duration"]|>;

  console["log", ">> push notification globally"];

  Block[{id = uid},
      WebSocketBroadcast[JerryI`WolframJSFrontend`server,
        Global`PushMessage[
          LoadPage[ "assets/singletoast.wsp", {state = " immediate"}, "base"->JerryI`WolframJSFrontend`public ]
        ]
      ];  
  ]
];

NotificationMethodRegister := (
  DefineOutputStreamMethod[
    "Toast", {"ConstructorFunction" -> 
      Function[{name, isAppend, caller, opts}, 
       With[{state = Unique["JaBoo"]},
        {True, state}] ], 
     "CloseFunction" -> Function[state, ClearAll[state] ], 
     "WriteFunction" -> 
      Function[{state, bytes},
       With[{out = bytes /. {most___, 10} :> FromCharacterCode[{most}]},
         With[{ }, 
         If[out === "", {0, state},

          PushNotification["system", "<span style=\"color:red\">"<>ByteArrayToString[out // ByteArray]<>"</span>"];

          {Length@bytes, state}] ] ] ]}
  ];

  $Messages = {OpenWrite[Method -> "Toast"]};
)

End[];

EndPackage[]; 