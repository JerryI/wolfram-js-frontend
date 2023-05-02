Unprotect[FrameBox]
FrameBox[x_, opts__] := FrontEndBox[x, ToString[Compress[FrontEndOnly[FrameBox[opts]]], InputForm]]

Unprotect[StyleBox]
StyleBox[x_, opts__] := FrontEndBox[x, ToString[Compress[FrontEndOnly[StyleBox[opts]]], InputForm]]

Normal[FrontEndBox[expr_, view_]] ^:= expr