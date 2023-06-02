<|"notebook" -> <|"name" -> "Campus", "id" -> "exact-97a4c", 
   "kernel" -> LocalKernel, "objects" -> <||>, 
   "path" -> "/Volumes/Data/Github/wolfram-js-frontend/Conference/Confetti.wl\
", "cell" :> Exit[], "date" -> DateObject[{2023, 5, 30, 13, 8, 
      55.948782`8.500365610573636}, "Instant", "Gregorian", 2.]|>, 
 "cells" -> {<|"id" -> "ea01eeeb-63ee-4606-9d63-c24f80b0f2342dc", 
    "type" -> "input", "data" -> 
     ".md\n# Advanced boxes\nA custom representation", 
    "display" -> "codemirror", "sign" -> "exact-97a4c", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "d1169cc5-0d3c-44a7-8fd7-7efd4ac42b082dc", "type" -> "output", 
    "data" -> "\n# Advanced boxes\nA custom representation", 
    "display" -> "markdown", "sign" -> "exact-97a4c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "bbb407ef-275a-48bf-8f2d-8502c3e919e12dc", "type" -> "input", 
    "data" -> ".html\n<script \
src=\"https://cdn.jsdelivr.net/npm/party-js@latest/bundle/party.min.js\"></sc\
ript>", "display" -> "codemirror", "sign" -> "exact-97a4c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6faba60f-142d-476c-9c53-e299e1f3f17f2dc", "type" -> "output", 
    "data" -> "\n<script \
src=\"https://cdn.jsdelivr.net/npm/party-js@latest/bundle/party.min.js\"></sc\
ript>", "display" -> "html", "sign" -> "exact-97a4c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "06d51869-1641-46b2-a85d-c5a3a1f520a62dc", "type" -> "input", 
    "data" -> ".md\nLet us add some cute stuff to the data", 
    "display" -> "codemirror", "sign" -> "exact-97a4c", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "5c4778f3-07fa-4f06-8fcb-1af42002b36a2dc", "type" -> "output", 
    "data" -> "\nLet us add some cute stuff to the data", 
    "display" -> "markdown", "sign" -> "exact-97a4c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "b502890f-08a1-4b4e-a76d-23cd21529fd22dc", "type" -> "input", 
    "data" -> ".js\n\ncore.Confetti = async (args, env) => {\n  \
setTimeout(()=>\n  party.confetti(env.element, {\n\tcount: \
party.variation.range(0, 30),\n    speed: 200,\n\tsize: \
party.variation.range(0.6, 1.4),\n  }), 500 + core.times * 200);\n  //add \
extra delay\n  core.times = core.times + 1;\n}\n\ncore.times = 0;", 
    "display" -> "codemirror", "sign" -> "exact-97a4c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "fc7b2e8d-91e0-441b-83c1-9485b0f7eee12dc", "type" -> "output", 
    "data" -> "\n\ncore.Confetti = async (args, env) => {\n  \
setTimeout(()=>\n  party.confetti(env.element, {\n\tcount: \
party.variation.range(0, 30),\n    speed: 200,\n\tsize: \
party.variation.range(0.6, 1.4),\n  }), 500 + core.times * 200);\n  //add \
extra delay\n  core.times = core.times + 1;\n}\n\ncore.times = 0;", 
    "display" -> "js", "sign" -> "exact-97a4c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "d5ffa110-ee2a-4181-a24f-1f9845308a442dc", "type" -> "input", 
    "data" -> ".md\nRegister the decorations", "display" -> "codemirror", 
    "sign" -> "exact-97a4c", "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "1a3977b8-5e95-4fff-b440-93b006e9e83b2dc", "type" -> "output", 
    "data" -> "\nRegister the decorations", "display" -> "markdown", 
    "sign" -> "exact-97a4c", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6ab49d87-b3e3-471f-af6e-4f1dd4b2e3422dc", "type" -> "input", 
    "data" -> "d /: MakeBoxes[d, StandardForm] := CustomBox[d, Confetti]", 
    "display" -> "codemirror", "sign" -> "exact-97a4c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6be46cb8-6fb7-4b67-a04c-95e6b492295d2dc", "type" -> "input", 
    "data" -> ".md\nLet's calculate!", "display" -> "codemirror", 
    "sign" -> "exact-97a4c", "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "68ff8572-31eb-4c6d-a124-c81dcb1f86482dc", "type" -> "output", 
    "data" -> "\nLet's calculate!", "display" -> "markdown", 
    "sign" -> "exact-97a4c", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "ee0cb012-d11e-4a4c-b663-d4de5fcba6cb2dc", "type" -> "input", 
    "data" -> "CM6Subscript[Y, l_, m_]:= SphericalHarmonicY[l,m, $Theta$, \
$Phi$];\nTrans = d (CM6Subscript[Y, 1,1] + I CM6Subscript[Y, 1,-1]);", 
    "display" -> "codemirror", "sign" -> "exact-97a4c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a51a262e-f98f-4f3d-9675-1a0a1d2431732dc", "type" -> "input", 
    "data" -> ".md\nIntegrate between state", "display" -> "codemirror", 
    "sign" -> "exact-97a4c", "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "89ae67da-5fb1-45da-94cf-d3707e09a28d2dc", "type" -> "output", 
    "data" -> "\nIntegrate between state", "display" -> "markdown", 
    "sign" -> "exact-97a4c", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6586e7e6-0ce4-4870-b270-fd35fa6baf902dc", "type" -> "input", 
    "data" -> "Table[\n  Integrate[CM6Subscript[Y, 1,m1] Trans \
CM6Subscript[Y, 2,m2] Sin[$Theta$], {$Theta$, 0, Pi}, {$Phi$, 0, 2Pi}]\n, \
{m1, -2,2}, {m2, -2,2}] ", "display" -> "codemirror", 
    "sign" -> "exact-97a4c", "props" -> <|"hidden" -> False|>|>}, 
 "serializer" -> "jsfn3"|>
