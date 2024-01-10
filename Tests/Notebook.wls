ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<< JerryI`Notebook`;
<< JerryI`Notebook`Evaluator`;
<< JerryI`Misc`Events`;
<< JerryI`Notebook`MasterKernel`;

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
    Print["New Cell!"];
    Print[data];
]}];

kernel = MasterKernel[];
kernel // Kernel`Start;

notebook["Evaluator"] = StandardEvaluator`Container[kernel];

cell // CellObj`Evaluate;

Print[notebook["Cells"]];

cell // CellObj`Evaluate;

Print[notebook["Cells"]];

Echo["Serialization test"];
Print[notebook];
pack = <| 
            "Notebook" -> Notebook`Serialize[notebook], 
            "Cells" -> ( CellObj`Serialize /@ notebook["Cells"]), 
            "serializer" -> "jsfn4" 
|> ;
pack // Print;

Notebook`Deserialize[pack] // Print;


