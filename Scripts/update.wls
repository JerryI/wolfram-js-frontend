#!/usr/bin/env wolframscript

PacletDirectoryUnload /@ PacletDirectoryLoad[]; (* FIXME WL autoloads some crap *)

ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

Get[FileNameJoin[{Directory[], "Common", "LPM", "LPM.wl"}] ];

DeleteFile /@ {
    ".wl_timestamp",
    ".wljs_timestamp"
};

PacletRepositories[{
  Github -> "https://github.com/KirillBelovTest/Objects" -> "master",
  Github -> "https://github.com/JerryI/Internal" -> "master",
  Github -> "https://github.com/JerryI/TCPServer" -> "master",
  Github -> "https://github.com/JerryI/HTTPHandler" -> "master",
  Github -> "https://github.com/JerryI/WebSocketHandler" -> "master",
  Github -> "https://github.com/JerryI/CSocketListener" -> "dev2024",
  Github -> "https://github.com/JerryI/wl-wlx" -> "master",
  Github -> "https://github.com/JerryI/wl-misc" -> "dev"
}, "Directory" -> Directory[] ]


(* WLJS Package manager *)
Needs["CoffeeLiqueur`ExtensionManager`" -> "WLJSPackages`"];

WLJSPackages`Repositories[{
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-editor" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-sharedlib-d3" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-sharedlib-mk" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-sharedlib-three" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-graphics-d3" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-html-support" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-inputs" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-interpreter" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-js-support" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-markdown-support" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-magic-support" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-plotly" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-cells" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-revealjs" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-wlx-support" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-mermaid-support" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-snippets" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-alt-cell-controls" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-print-redirect-fix" -> "dev",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-export-html" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-manipulate" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-sound" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-video" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-templates" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-xterm" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-excalidraw" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-toc" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-wxf-accelerator" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-neuralnet" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-docs-archive" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-demos-archive" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-debugger" -> "master",
  WLJSPackages`Github -> "https://github.com/JerryI/wljs-api" -> "master"
}, "Directory" -> Directory[], "UpdateInterval" -> Quantity[99999, "Days"] ]

Echo["Updated"];
Print["@Electron, go ahead"];