ListContourPloty[s_List] := WListContourPloty[Transpose[s//N]];

RegisterWebObject[WListContourPloty];

Options[ListLinePloty] = {
    PlotRange -> {{-Infinity, Infinity}, {-Infinity, Infinity}}
};

ListLinePloty[x_List, OptionsPattern[]] := Module[{transp},
    Switch[Depth[x//N],
        3,
            transp = { (Transpose[FilterRange[x, OptionValue[PlotRange] ] ])}
        ,
        4,
            transp = ( Transpose[FilterRange[#, OptionValue[PlotRange] ] ] ) &/@ x
        ,
        2,
            transp = {Table[i, {i, 1, Length[x]}], x}
    ];

    WListPloty[ExportString[transp//N, "JSON"] ]
];

Ploty[f_, range_, op : OptionsPattern[Plot]] := Plot[f, range, op] // Cases[#, Line[x_] :> x, All] & // ListLinePloty[#, op] & ;

RegisterWebObject[WListPloty];