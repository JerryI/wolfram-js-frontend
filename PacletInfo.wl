(* ::Package:: *)

PacletObject[
  <|
    "Name" -> "JerryI/WolframJSFrontend",
    "Description" -> "Implementation of web-frontend for Wolfram Engine",
    "Creator" -> "Kirill Vasin",
    "License" -> "MIT",
    "PublisherID" -> "JerryI",
    "Version" -> "1.0.0",
    "WolframVersion" -> "13+",
    "Extensions" -> {
      {
        "Kernel",
        "Root" -> "Kernel",
        "Context" -> {
          {"JerryI`WolframJSFrontend`", "Init.wl"}, 
          {"JerryI`WolframJSFrontend`Notifications`", "Notifications.wl"}, 
          {"JerryI`WolframJSFrontend`Starter`", "Starter.wl"},
          {"JerryI`WolframJSFrontend`DBManager`", "DBManager.wl"},
          {"JerryI`WolframJSFrontend`Utils`", "Utils.wl"}
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
