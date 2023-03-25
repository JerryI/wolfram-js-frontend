import {CompletionContext} from "@codemirror/autocomplete"

const autocompleteVocabulary = [
    {label: "Table", type: "keyword"},
    {label: "Do", type: "keyword"},
    {label: "CreateFrontEndObject", type: "keyword"},
    {label: "Plotly", type: "keyword"},
    {label: "ListLinePlotly", type: "keyword"},
    {label: "SendToFrontEnd", type: "keyword"},
    {label: "Sqrt", type: "keyword"},
    {label: "Graphics3D", type: "keyword"},

    {label: "hello", type: "variable", info: "(World)"},

    {label: ":a:",   type: "text", apply: "\[Alpha]", detail: "macro"},
    {label: ":th:",   type: "text", apply: "\[Theta]", detail: "macro"},
    {label: ":l:",   type: "text", apply: "\[Lambda]", detail: "macro"},
    {label: ":w:",   type: "text", apply: "\[Omega]", detail: "macro"},
    {label: ":t:",   type: "text", apply: "\[Tau]", detail: "macro"},
    {label: ":m:",   type: "text", apply: "\[Mu]", detail: "macro"},
    {label: ":ph:",   type: "text", apply: "\[Phi]", detail: "macro"}
]

function wolframCompletions(cotext) {
    let word = cotext.matchBefore(/\w*/)
    if (word.from == word.to && !cotext.explicit)
      return null
    return {
      from: word.from,
      options: autocompleteVocabulary
    }
  } 