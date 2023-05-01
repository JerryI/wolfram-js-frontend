Unprotect[FrameBox]
FrameBox[x_, opts__] := FrontEndBox[x, ToString[Compress[FrontEndOnly[FrameBox[opts]]], InputForm]]

Unprotect[StyleBox]
StyleBox[x_, opts__] := FrontEndBox[x, ToString[Compress[FrontEndOnly[StyleBox[opts]]], InputForm]]

Unprotect[TemplateBox]
TemplateBox[x_, opts__] := FrontEndBox[x, ToString[Compress[FrontEndOnly[TemplateBox[opts]]], InputForm]]

Normal[FrontEndBox[expr_, view_]] ^:= expr