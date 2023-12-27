ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<< JerryI`Notebook`;
<< JerryI`Notebook`Evaluator`;
<< JerryI`Misc`Events`;

stat := With[{},
    Print["-----------------------"];
    Print[Notebook`HashMap];
    Print[CellObj`HashMap];
    Print["-----------------------"];
]

notebook = Notebook[];

stat;

cell = CellObj["Notebook" -> notebook, "Data" -> "1+1"];

stat;

EventHandler[notebook, {"New Cell" -> Function[data,
    Print["*********"];
    Print[data];
]}]

evaluator = StaticEvaluator[];
StaticEvaluator /: StandardEvaluator`ReadyQ[evaluator, kernel_] := (
    Print["Boom!"];
    True
)

StaticEvaluator /: StandardEvaluator`Evaluate[evaluator, kernel_, t_] := (
    Print["Eval"];
    EventFire[t, "Result", <|"Data" -> "2"|>]
)


notebook["Evaluator"] = StandardEvaluator[Null];

cell // CellObj`Evaluate;

cell // CellObj`Serialize // Print;

stat;


