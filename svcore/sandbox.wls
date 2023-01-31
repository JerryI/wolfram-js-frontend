EvaluatorTemporaryStorage = <||>;

SimpleEvaluator[exp_, rules_, storage_, block_, callback_] := (

    Block[{$$$evaluated, $$$storage = <||>},
        Block[  {
                    FrontEndExecutable = Function[uid, If[KeyExistsQ[EvaluatorTemporaryStorage, uid], EvaluatorTemporaryStorage[uid]//ToExpression, ImportString[storage[uid], "ExpressionJSON"] ]  ], 
                    Print = Function[x, callback@@{ToString[x/.rules, InputForm], $$$storage}]
                },

            $$$evaluated = ToExpression[exp];
            $$$out = $$$evaluated;
            If[block === True, $$$evaluated = Null];
        ];

        With[{$$$result = $$$evaluated /.rules}, 
            With[{$$$sresult = ToString[$$$result, InputForm], $$$sstorage = $$$storage, c = callback},
                If[StringLength[$$$sresult] > 1000,
                    With[{dumpid = CreateUUID[], len = StringLength[$$$sresult], short = StringTake[$$$sresult, 50]},
                        EvaluatorTemporaryStorage[dumpid] = $$$sresult;
                        $$$storage[dumpid] = ExportString[FrontEndTruncated[short, len], "ExpressionJSON"];

                        With[{$$$xstorage = $$$storage, $$$xsresult = "FrontEndExecutable[\""<>dumpid<>"\"]"},
                            CEval[ c@@{$$$xsresult, $$$xstorage}; ];
                        ]
                    ]
                ,
                    CEval[ c@@{$$$sresult, $$$sstorage}; ];
                ]
                
            ]
        ];   
    ]);

PushNotification["svcore/sandbox", "<span class=\"badge badge-info\">Kernel attached</span>"];
