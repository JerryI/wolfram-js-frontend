
RegisterWebObject[ListContourPlotly];

Plotly[f_, range_, op : OptionsPattern[Plot]] := Plot[f, range, op] // Cases[#, Line[x_] :> x, All] & // ListLinePlotly[#, op] & ;

RegisterWebObject[ListLinePlotly];