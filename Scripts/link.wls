#!/usr/bin/env wolframscript

(* startup script for the evaluation kernel in Entitlement mode *)

Pause[2];

With[{tcplink = Position[$CommandLine, "-tcplink"]},

With[{l=LinkConnect[If[Length[tcplink] > 0, $CommandLine[[tcplink[[1]] + 1]], "36831"], LinkProtocol->"TCPIP"]}, 
    LinkActivate[l]; 
    While[True, 
        With[{r = LinkRead[l]},
            LinkWrite[l, Switch[Head[r],
                EnterTextPacket,
                r[[1]] // ToExpression,
                _,
                r // Evaluate
            ] // ReturnPacket ]
        ];
        
    ]
] ]

