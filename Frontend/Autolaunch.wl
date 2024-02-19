BeginPackage["JerryI`Notebook`KernelAutolaunch`", {
  "JerryI`Notebook`Evaluator`", 
  "JerryI`WLJSPM`", 
  "JerryI`Notebook`Kernel`", 
  "JerryI`Misc`Events`",
  "JerryI`Misc`Events`Promise`",
  "KirillBelov`CSockets`",
  "KirillBelov`Internal`",
  "KirillBelov`TCPServer`",
  "KirillBelov`WebSocketHandler`",
  "JerryI`Misc`WLJS`Transport`"
}];

Begin["`Internal`"];

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


  kernel // Kernel`Start;
];

End[]
EndPackage[]

JerryI`Notebook`KernelAutolaunch`Internal`autostart