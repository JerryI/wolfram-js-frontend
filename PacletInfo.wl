(* ::Package:: *)

PacletObject[
  <|
    "Name" -> "JerryI/WolframJSFrontend",
    "Description" -> "Implementation of web-frontend for Wolfram Engine",
    "Creator" -> "Kirill Vasin",
    "License" -> "MIT",
    "PublisherID" -> "JerryI",
    "Version" -> "2.0.0",
    "WolframVersion" -> "12+",
    "Extensions" -> {
      {
        "Kernel",
        "Root" -> "Kernel",
        "Context" -> {
          {"JerryI`Notebook`", "Notebook.wl"},
          {"JerryI`Notebook`Transactions`", "Transactions.wl"},
          {"JerryI`Notebook`Evaluator`", "Evaluator.wl"},
          {"JerryI`Notebook`Transactions`", "Transactions.wl"},

          {"JerryI`Notebook`Packages`", "Packages.wl"},
          {"JerryI`Notebook`Utils`", "Utils.wl"},
          {"JerryI`Notebook`FrontendObject`", "FrontendObject.wl"},
          {"JerryI`Notebook`Kernel`", "Kernel.wl"},
          {"JerryI`Notebook`LocalKernel`", "LocalKernel.wl"},
          {"KirillBelov`LTP`", "LTP.wl"},
          {"KirillBelov`LTP`JerryI`Events`", "LTPEvents.wl"},
          {"JerryI`Notebook`FrontendObject`", "FrontendObject.wl"},
          {"JerryI`Notebook`MasterKernel`", "MasterKernel.wl"},

          {"JerryI`Notebook`AppExtensions`", "AppExtensions.wl"}
        }
      },
      {"Documentation", "Language" -> "English"},
      {
        "Asset",
        "Assets" -> {
          {"webgui", "public"}
        }
      }
    }
  |>
]
