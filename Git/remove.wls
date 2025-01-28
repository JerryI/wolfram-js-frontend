#!/usr/bin/env wolframscript

PacletDirectoryUnload /@ PacletDirectoryLoad[]; (* FIXME WL autoloads some crap *)

ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

Get[FileNameJoin[{Directory[], "Common", "LPM", "LPM.wl"}] ];

PacletRepositories[{
  Github -> "https://github.com/KirillBelovTest/Objects" -> "master",
  Github -> "https://github.com/JerryI/Internal" -> "master",
  Github -> "https://github.com/JerryI/TCPServer" -> "master",
  Github -> "https://github.com/JerryI/HTTPHandler" -> "master",
  Github -> "https://github.com/JerryI/WebSocketHandler" -> "master",
  Github -> "https://github.com/JerryI/CSocketListener" -> "dev2024",
  Github -> "https://github.com/JerryI/wl-wlx" -> "master",
  Github -> "https://github.com/JerryI/wl-misc" -> "dev",
  Github -> "https://github.com/JerryI/wl-wljs-packages" -> "master"
}, "Directory" -> Directory[], "Passive"->True ]


(* WLJS Package manager *)
<<JerryI`WLJSPM`

WLJS`PM`Repositories[{
  Github -> "https://github.com/JerryI/wljs-editor" -> "dev",
  Github -> "https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine" -> "dev",
  Github -> "https://github.com/JerryI/wljs-sharedlib-d3" -> "master",
  Github -> "https://github.com/JerryI/wljs-sharedlib-mk" -> "master",
  Github -> "https://github.com/JerryI/wljs-sharedlib-three" -> "master",
  Github -> "https://github.com/JerryI/wljs-graphics-d3" -> "dev",
  Github -> "https://github.com/JerryI/wljs-html-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-inputs" -> "dev",
  Github -> "https://github.com/JerryI/wljs-interpreter" -> "dev",
  Github -> "https://github.com/JerryI/wljs-js-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-markdown-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-magic-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-plotly" -> "dev",
  Github -> "https://github.com/JerryI/wljs-cells" -> "dev",
  Github -> "https://github.com/JerryI/wljs-revealjs" -> "dev",
  Github -> "https://github.com/JerryI/wljs-wlx-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-mermaid-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-snippets" -> "dev",
  Github -> "https://github.com/JerryI/wljs-alt-cell-controls" -> "dev",
  Github -> "https://github.com/JerryI/wljs-print-redirect-fix" -> "dev",
  Github -> "https://github.com/JerryI/wljs-export-html" -> "master",
  Github -> "https://github.com/JerryI/wljs-manipulate" -> "master",
  Github -> "https://github.com/JerryI/wljs-sound" -> "master",
  Github -> "https://github.com/JerryI/wljs-video" -> "master",
  Github -> "https://github.com/JerryI/wljs-templates" -> "master",
  Github -> "https://github.com/JerryI/wljs-xterm" -> "master",
  Github -> "https://github.com/JerryI/wljs-excalidraw" -> "master",
  Github -> "https://github.com/JerryI/wljs-toc" -> "master",
  Github -> "https://github.com/JerryI/wljs-wxf-accelerator" -> "master",
  Github -> "https://github.com/JerryI/wljs-neuralnet" -> "master",
  Github -> "https://github.com/JerryI/wljs-docs-archive" -> "master",
  Github -> "https://github.com/JerryI/wljs-demos-archive" -> "master",
  Github -> "https://github.com/JerryI/wljs-debugger" -> "master",
  Github -> "https://github.com/JerryI/wljs-api" -> "master"
}, "Directory" -> Directory[], "UpdateInterval" -> Quantity[99999, "Days"] ]

root = Directory[];

restore[key: (Github -> url_ -> branch_)] := With[{name = JerryI`WLJSPM`Private`$packages[key]["name"]},
    Echo["Removing .git for "<>url];

    SetDirectory[ FileNameJoin[{root, "wljs_packages", name}] ];
    DeleteDirectory[".git", DeleteContents->True];
    (* Run["git clone --branch `` ``"] *)

]


Map[restore, JerryI`WLJSPM`Private`$packages//Keys ];