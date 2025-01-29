BeginPackage["KirillBelov`LTP`Events`", {
    "JerryI`Misc`Events`", "KirillBelov`LTP`", "JerryI`Misc`Events`Promise`"
}]

Begin["`Private`"]

LTPTransport /: EventFire[LTPTransport[cli_][event_], opts__] := LTPEvaluate[LTPTransport[cli], EventFire[event, opts] ];
LTPTransport /: EventFire[LTPTransport[cli_][p_Promise], opts__] := LTPEvaluate[LTPTransport[cli], EventFire[p // First, opts] ];


End[]
EndPackage[]