Unprotect[FrameBox]
FrameBox[x_, opts__] := FrontEndBox[x, ToString[ExportString[FrontEndOnly[FrameBox[opts]], "ExpressionJSON", "Compact" -> 0], InputForm]//URLEncode]

Unprotect[StyleBox]
StyleBox[x_, opts__] := FrontEndBox[x, ToString[ExportString[FrontEndOnly[StyleBox[opts]], "ExpressionJSON", "Compact" -> 0], InputForm]//URLEncode]
