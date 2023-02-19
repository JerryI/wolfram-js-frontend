
LocalKernel[ev_, cbk_, OptionsPattern[]] := ev[cbk];
LocalKernel["Abort"] := PushNotification["system", "cannot be aborted"];

RemoteKernel[pid_][ev_, cbk_, OptionsPattern[]] := Module[{},
    RemoteLinks[pid][OptionValue["Link"]]
];

StartRemoteKernel[pid_] := 