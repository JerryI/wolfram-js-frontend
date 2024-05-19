BeginPackage["Misc`QuadarticInterpolation`"]
Begin["`Private`"]

quadraticInterpolation[f_, vars__, OptionsPattern[]] := Module[{
  variables =  List[vars],
  rules,
  constant,
  quadratic,
  final,
  cached,
  mdcache,
  calculated = <||>,
  linear,
  handler, count = 0
},

  If[OptionValue["Monitor"] =!= Null,
    handler = OptionValue["Monitor"][ (Length[variables] Length[variables] - Length[variables]) / 2  + 2 Length[variables]];
  ];

  cached[expr_, {i_,j_}] := mdcache[expr, Sort[{i,j}]];
  SetAttributes[cached, HoldFirst];

  mdcache[expr_, {i_,j_}] := If[KeyExistsQ[calculated, {i,j}],
    calculated[{i,j}]
  ,
    calculated[{i,j}] = expr
  ];

  SetAttributes[mdcache, HoldFirst];

  rules = (#[[1]] -> #[[2]]) &/@ variables;
  
  constant = Hold[f] /. rules // ReleaseHold;

  linear = Table[
    With[{
      r = {i[[1]] -> 1.}
    },

      count++;
      handler[count];

      (Hold[f] /. r /. rules // ReleaseHold) - constant
    ]
    
  , {i, variables}];

  quadratic = Table[
    cached[With[{
      f11 = With[{
        r = {i[[1]] -> 1., j[[1]] -> 1.}
      },
        (Hold[f] /. r /. rules // ReleaseHold)
      ],

      fm1m1 = With[{
        r = {i[[1]] -> -1., j[[1]] -> -1.}
      },
        (Hold[f] /. r /. rules // ReleaseHold)
      ],

      f1m1 = With[{
        r = {i[[1]] -> 1., j[[1]] -> -1.}
      },
        (Hold[f] /. r /. rules // ReleaseHold)
      ],

      fm11 = With[{
        r = {i[[1]] -> -1., j[[1]] -> 1.}
      },
        (Hold[f] /. r /. rules // ReleaseHold)
      ]      
      
    },
      count++;
      handler[count];

      Print["Checking... ", i, j];

      (*FB[*)((f11 - f1m1 - fm11 + fm1m1)(*,*)/(*,*)(4.))(*]FB*)
    ], {i,j}]
    
  , {i, variables}, {j, variables}];

  final = Sum[
    With[{l = linear[[i]]},
      Slot[i] Hold[l]
    ]
  , {i, Length[linear]}] + Sum[
    With[{
      q = (*FB[*)((1)(*,*)/(*,*)(2))(*]FB*)quadratic[[i, j]]
    },
      Slot[i]Slot[j] Hold[q]
    ]
  , {i, Length[linear]}, {j, Length[linear]}] + With[{c = constant}, Hold[c] ];

  With[{
    r = final
  },
    (r &) /. {Hold -> Identity}
  ]
]

SetAttributes[quadraticInterpolation, HoldFirst]

Options[quadraticInterpolation] = {"Monitor"->Null}

End[]
EndPackage[]

Misc`QuadarticInterpolation`Private`quadraticInterpolation