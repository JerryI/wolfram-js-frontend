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
          {"JerryI`WolframJSFrontend`Cells`", "Cells.wl"}, 
          {"JerryI`WolframJSFrontend`Evaluator`", "Evaluator.wl"}, 
          {"JerryI`WolframJSFrontend`Notebook`", "Notebook.wl"}, 
          {"JerryI`WolframJSFrontend`Kernel`", "Kernel.wl"}, 
          {"JerryI`WolframJSFrontend`Utils`", "Utils.wl"}, 
          {"JerryI`WolframJSFrontend`WebObjects`", "WebObjects.wl"}, 
          {"JerryI`WolframJSFrontend`Colors`", "Colors.wl"},
          {"JerryI`WolframJSFrontend`Dev`", "Dev.wl"},
          {"JerryI`WolframJSFrontend`Remote`", "Remote.wl"},
          {"JerryI`WolframJSFrontend`Events`", "Events.wl"},
          {"JerryI`WolframJSFrontend`WSPDynamicsExtension`", "WSPDynamicsExtension.wl"},

          {"JerryI`WolframJSFrontend`HTMLSupport`", "Addons/HTML/HTMLSupport.wl"},
          {"JerryI`WolframJSFrontend`MarkdownSupport`", "Addons/Markdown/MarkdownSupport.wl"},
          {"JerryI`WolframJSFrontend`JSSupport`", "Addons/JS/JSSupport.wl"},
          {"JerryI`WolframJSFrontend`WolframLanguageSupport`", "Addons/WolframLanguage/WolframLanguageSupport.wl"},
          {"JerryI`WolframJSFrontend`MagicFileEditor`", "Addons/MagicEditor/MagicFileEditor.wl"},
          {"JerryI`WolframJSFrontend`SVGBobSupport`", "Addons/SVGBob/SVGBobSupport.wl"},
          {"JerryI`WolframJSFrontend`MermaidSupport`", "Addons/Mermaid/MermaidSupport.wl"}
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
