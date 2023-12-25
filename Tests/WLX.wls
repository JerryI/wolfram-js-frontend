ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<<JerryI`WLX`
<<JerryI`WLX`Importer`
<<JerryI`WLX`WLJS`

ll = ImportComponent["Tests/WLX.wlx", "Localize"->False];
ll;
ll // Print;
WebUILazyLoad[33] // Print;