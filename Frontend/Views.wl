
dir        := ImportComponent["Views/Directory.wlx"];
editor     := ImportComponent["Views/Editor.wlx"];
image      := ImportComponent["Views/Image.wlx"];
plot       := ImportComponent["Views/Plot.wlx"];
none       := ImportComponent["Views/None.wlx"];

(* /* view router */ *)

ImageQQ[path_String]   := FileExistsQ[path] && StringMatchQ[path, RegularExpression[".*\\.(png|jpg|svg|bmp|jpeg)$"]]

DatQ[path_String]      := FileExistsQ[path] && StringMatchQ[path, RegularExpression[".*\\.(dat|csv)$"]]

AnyQ[path_String]      := FileExistsQ[path]

View[path_?DirectoryQ] := (Print["Directory!"];     dir[path]   ); 
View[path_?ImageQQ]    := (Print["Image!"];         image[path] );
View[path_?DatQ]       := (Print["Data!"];          plot[path]  );
View[path_?AnyQ]       := (Print["Editor!"];        editor[path]);
View[path_]            := (Print["None!"];          none[path]  );

Wrapper[OptionsPattern[]] := View[OptionValue["Path"]];

Options[Wrapper] = {"Path" -> ""};

Wrapper