#!/usr/bin/env wolframscript

(* startup script for the evaluation kernel in Entitlement mode *)

Pause[2];

With[{l=LinkConnect["36831", LinkProtocol->"TCPIP"]}, 
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
]

