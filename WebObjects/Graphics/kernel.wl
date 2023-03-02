ListContourPlotly[s_List] := WListContourPlotly[Transpose[s//N]];

RegisterWebObject[WListContourPlotly];

Options[ListLinePlotly] = {
    PlotRange -> {{-Infinity, Infinity}, {-Infinity, Infinity}}
};

ListLinePlotly[x_List, OptionsPattern[]] := Module[{transp},
    Switch[Depth[x//N],
        3,
            transp = { (Transpose[x])}
        ,
        4,
            transp = ( Transpose[#] ) &/@ x
        ,
        2,
            transp = {Table[i, {i, 1, Length[x]}], x}
    ];

    WListPlotly[transp//N]
];

Plotly[f_, range_, op : OptionsPattern[Plot]] := Plot[f, range, op] // Cases[#, Line[x_] :> x, All] & // ListLinePlotly[#, op] & ;

RegisterWebObject[WListPlotly];