BeginPackage["KirillBelov`LTP`JerryI`Events`", {"JerryI`Misc`Events`", "KirillBelov`LTP`"}]

Begin["`Private`"]

LTPTransport /: EventFire[LTPTransport[cli_][event_], opts__] := LTPEvaluate[LTPTransport[cli], EventFire[event, opts] ];

End[]
EndPackage[]