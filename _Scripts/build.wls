#!/usr/bin/env wolframscript
 ->
$HistoryLength = 0
PacletDirectoryLoad[Directory[]]
Get["JerryI`WolframJSFrontend`"]
Get/@{
  "JerryI`WolframJSFrontend`Utils`",
  "JerryI`WolframJSFrontend`Dev`"
  };

LoadBuildFile["config.build.wl"]