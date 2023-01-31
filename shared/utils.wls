NullQ[x_] := TrueQ[x == Null];

(* smart caching. credits https://github.com/KirillBelovTest *)
ClearAll[cache]
SetAttributes[cache, HoldFirst]

cache[expr_, date_DateObject] := (
	cache[expr, {"Date"}] = date; 
	cache[expr, date] = expr
);

cache[expr_, interval_String: "Minute"] := (
	If[DateObjectQ[cache[expr, {"Date"}]] && DateObject[Now, interval] != cache[expr, {"Date"}], 
		cache[expr, cache[expr, {"Date"}]] =.]; 
	cache[expr, DateObject[Now, interval]]
);

RandomString[n_] := Alphabet[][ [RandomInteger[ {1, 26}, n] ] ] // StringJoin;

(*misc*)
FilterRange[data_, r_] := 
  Select[data, (#[[1]] >= r[[1, 1]] && #[[1]] <= r[[1, 2]] && #[[2]] >=
        r[[2, 1]] && #[[2]] <= r[[2, 2]]) &];

DropHalf[x_] := Drop[x,-Length[x]/2 //Round];
		
lowpass[FilterEdge_, Q_, x_, sample_] := 
  1 - ((Tanh[(x - Length[sample[[All, 2]]]/2 + FilterEdge)/Q] + 1)/
     2 - (Tanh[(x - Length[sample[[All, 2]]]/2 - FilterEdge)/Q] + 1)/
     2);