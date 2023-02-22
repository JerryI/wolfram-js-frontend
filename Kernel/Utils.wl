BeginPackage["JerryI`WolframJSFrontend`Utils`"];

console::usage = "console[\"log\", message, args]"
NullQ::usage = "NullQ[x]"
Cached::usage = "Cached[expr_, interval_String: \"Minute\"]"
RandomString::usage = "RandomString[length]"
DropHalf::usage = "DropHalf drops a half of a list from the end"

Begin["`Private`"]; 

NullQ[expr_] := expr===Null;

console["log", message_, args___] := Print[StringTemplate[message][args]]
console["memory stat"] := (JerryI`WolframJSFrontend`ram = {JerryI`WolframJSFrontend`ram, Round[MemoryInUse[]/1024,1]/1024//N}//Flatten);

(* smart caching. credits https://github.com/KirillBelovTest *)
ClearAll[Cached]
SetAttributes[Cached, HoldFirst]

Cached[expr_, date_DateObject] := (
	Cached[expr, {"Date"}] = date; 
	Cached[expr, date] = expr
);

Cached[expr_, interval_String: "Minute"] := (
	If[DateObjectQ[Cached[expr, {"Date"}]] && DateObject[Now, interval] != Cached[expr, {"Date"}], 
		Cached[expr, Cached[expr, {"Date"}]] =.]; 
	Cached[expr, DateObject[Now, interval]]
);

RandomString[n_] := Alphabet[][ [RandomInteger[ {1, 26}, n] ] ] // StringJoin;
DropHalf[x_List] := Drop[x,-Length[x]/2 //Round];

End[];

EndPackage[];