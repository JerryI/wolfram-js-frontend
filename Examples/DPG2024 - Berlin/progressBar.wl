Module[{progressBar},
progressBar[max_, OptionsPattern[] ] := With[{cell = OptionValue["Cell"]}, LeakyModule[{progress = 0., indicator = 0., handler, timer = AbsoluteTime[]},
    With[{
        cell = CellPrint[ToString[
            Graphics[{LightBlue, Rectangle[{-0.004,-0.12}, {1.004,1.12}], Green, Rectangle[{0,0}, {Offload[indicator],1}]}, PlotRange->{{0,1}, {0,1}}, ImagePadding->0, ImageSize->{300, 20}]
        , StandardForm], "After"->cell]
    },
        handler[n_] := With[{diff = AbsoluteTime[] - timer},
            progress = n;
            If[diff > 0.03,
                indicator = progress / max // N;
                timer = AbsoluteTime[];
            ];

            If[Abs[progress - max] < 0.1, Delete[cell] ];
        ];

        handler
    ]
] ];

    Options[progressBar] = {"Cell":>EvaluationCell[]};

    progressBar
]