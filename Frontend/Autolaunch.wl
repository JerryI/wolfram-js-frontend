BeginPackage["CoffeeLiqueur`Notebook`KernelAutolaunch`", {
  "JerryI`Misc`Events`",
  "JerryI`Misc`Events`Promise`",
  "KirillBelov`CSockets`",
  "KirillBelov`Internal`",
  "KirillBelov`TCPServer`",
  "KirillBelov`WebSocketHandler`",
  "JerryI`Misc`WLJS`Transport`"
}];


Begin["`Internal`"];

Needs["CoffeeLiqueur`ExtensionManager`" -> "WLJSPackages`"];
Needs["CoffeeLiqueur`Notebook`Kernel`" -> "GenericKernel`"];

appendHeld[Hold[list_], a_] := list = Append[list, a];
removeHeld[Hold[list_], a_] := list = (list /. a -> Nothing);
SetAttributes[appendHeld, HoldFirst];
SetAttributes[removeHeld, HoldFirst];

autostart[kernel_, KernelList_, initKernel_, deinitKernel_] := Module[{},
  appendHeld[KernelList, kernel];

  EventHandler[EventClone[kernel], {
    "Exit" -> Function[Null, removeHeld[KernelList, kernel]; deinitKernel[kernel] ],
    "Connected" -> Function[Null, initKernel[kernel] ]
  }];


  kernel // GenericKernel`Start;
];

End[]
EndPackage[]

CoffeeLiqueur`Notebook`KernelAutolaunch`Internal`autostart