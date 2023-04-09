<|"notebook" -> <|"name" -> "Housewarming", "id" -> "waverer-dd956", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"myObject" -> <|"json" -> 
        "[\"ListLinePlotly\",[\"List\",1,2,3,4,3,2,1]]", 
       "date" -> DateObject[{2023, 4, 9, 14, 8, 34.600067`8.291651919653178}, 
         "Instant", "Gregorian", 3.]|>, 
     "b97913e3-45cc-43f3-aff7-12b02a0251a8" -> 
      <|"json" -> "[\"ListLinePlotly\",[\"List\",1,2,3,4,3,2,1]]", 
       "date" -> DateObject[{2023, 4, 9, 14, 8, 34.61137`8.291793769924906}, 
         "Instant", "Gregorian", 3.]|>, "myData" -> 
      <|"json" -> "[\"List\",4,2,3,4,3,2,4]", 
       "date" -> DateObject[{2023, 4, 9, 14, 8, 34.719883`8.29315323289599}, 
         "Instant", "Gregorian", 3.]|>, "myPlot" -> 
      <|"json" -> "[\"ListLinePlotly\",[\"List\",1,2,3,4,3,2,1]]", 
       "date" -> DateObject[{2023, 4, 9, 14, 8, 34.659275`8.292394453821304}, 
         "Instant", "Gregorian", 3.]|>, 
     "67930b09-bdde-4632-9d32-f5a905ed36b7" -> 
      <|"json" -> 
        "[\"ListLinePlotly\",[\"FrontEndExecutableHold\",\"'myData'\"]]", 
       "date" -> DateObject[{2023, 4, 9, 14, 8, 34.685156`8.292718632009688}, 
         "Instant", "Gregorian", 3.]|>, 
     "2ddf9a39-5acf-4f5b-89a5-6cb988b4d47c" -> 
      <|"json" -> "[\"ListLinePlotly\",[\"FrontEndRef\",\"'myData'\"]]", 
       "date" -> DateObject[{2023, 4, 9, 14, 8, 34.696449`8.292860009183867}, 
         "Instant", "Gregorian", 3.]|>, 
     "a2038741-7e8e-4324-8738-5e42bccca079" -> 
      <|"json" -> 
        "[\"ListLinePlotly\",[\"FrontEndExecutableHold\",\"'myData'\"]]", 
       "date" -> DateObject[{2023, 4, 9, 14, 8, 34.708314`8.293008497669533}, 
         "Instant", "Gregorian", 3.]|>|>, 
   "path" -> "/root/wolfram-js-frontend/Demo/Frontend-Object.wl", 
   "cell" -> "dcfd59f1-b37d-44bc-900e-c078ea7fe94c", 
   "date" -> DateObject[{2023, 4, 9, 15, 57, 10.131405`7.758244662931468}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "12206a87-d2f4-4180-b9a1-3f7da15b220a", 
    "type" -> "input", "data" -> ".md\nJust do not forget to wrap it in \
`FrontEndRef`, otherwice the Kenrel will subsitute only its content. This is \
also a valid form", "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "5bd450ca-4b48-4f28-a4ef-c5c7554d48b1", 
    "next" -> "60820dd2-8476-4008-af2f-620f1fd82604", "parent" -> Null, 
    "child" -> "5e2245ea-8b76-42af-ba60-a9ea763ebac1", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "1905a834-84b7-4e31-a441-8157b09e48c6", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"2ddf9a39-5acf-4f5b-89a5-6cb988b4d47c\"]", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "60820dd2-8476-4008-af2f-620f1fd82604", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "1df2db8a-7868-429b-a2b2-e989fce697a4", "type" -> "input", 
    "data" -> 
     "FrontEndRef[\"myPlot\"] = ListLinePlotly[RandomReal[{1,4},7]];", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "a4fb2541-c402-46e0-8724-bad515080acf", 
    "next" -> "a337ac85-6b65-4ad6-bf6e-c22aa61dc344", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "20a9642d-0699-4890-a09c-f0bd15ed8d4f", "type" -> "input", 
    "data" -> "ListLinePlotly[{1,2,3,4,3,2,1}]", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> 
     "2da8bddb-3cc1-43f7-af8a-3434b5ca45b8", 
    "next" -> "f302c85d-f6fe-4418-b72c-25330f57d797", "parent" -> Null, 
    "child" -> "ddbc4320-abc8-4862-96c6-e27b4b3c27c8", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "267688db-8c06-4000-8bd2-3a0cec995919", "type" -> "output", 
    "data" -> 
     "\nBehind the scenes and fancy `UpValues` wrapper this happends", 
    "display" -> "markdown", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "3878ea8d-9f1c-4c56-bdb0-c63458a493c2", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "2c18c78f-2c3e-43d2-a883-b51d1d24b69c", "type" -> "output", 
    "data" -> "\n\n### Setting and updating\n\nFor example, we have created \
and object and want to update it's content. Apparently, the best will be to \
demonstrate it using plots", "display" -> "markdown", 
    "sign" -> "waverer-dd956", "prev" -> Null, "next" -> Null, 
    "parent" -> "79641871-795b-44fd-8c29-c7218356023f", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "2da8bddb-3cc1-43f7-af8a-3434b5ca45b8", "type" -> "input", 
    "data" -> ".md\nYou can copy and paste them into any cell of the \
notebook. Each copy is a separate instance of the same frontend \
object.\n\nFor the registered types of frontend object, one can just type \
directly the symbol name.\n\n\n> To see all this kind of symbols/objects, \
please, see `wolfram-js-frontend/WebObjects` folder.\n\n**If the output of \
the cell is not blocked**, then it will automatically apply \
`CreateFrontEndObject` method on it (with a random `uid`)", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "b355fe21-abbe-4a32-b468-be2643d3bdc7", 
    "next" -> "20a9642d-0699-4890-a09c-f0bd15ed8d4f", "parent" -> Null, 
    "child" -> "8556df3d-2df6-4ffa-bd9d-033b1de0d164", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "2fa71255-1599-4832-baa7-02ae34c6028f", "type" -> "output", 
    "data" -> 
     "\nThen we can update only the `myData` object and see, what happends", 
    "display" -> "markdown", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "d745719e-11a8-4f04-bb90-cd742394989d", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3878ea8d-9f1c-4c56-bdb0-c63458a493c2", "type" -> "input", 
    "data" -> 
     ".md\nBehind the scenes and fancy `UpValues` wrapper this happends", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "3eedd93e-871c-47f5-8d86-fa574314eff0", 
    "next" -> "abffda9d-2237-440c-a7ff-50ba4e0a8903", "parent" -> Null, 
    "child" -> "267688db-8c06-4000-8bd2-3a0cec995919", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "39a6a4fa-42af-4694-8955-be5cd6640ccf", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"myData\"]", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> Null, "next" -> Null, 
    "parent" -> "c77f2782-e04d-4111-bf7c-fccd29b35048", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3eedd93e-871c-47f5-8d86-fa574314eff0", "type" -> "input", 
    "data" -> 
     "FrontEndExecutable[\"myPlot\"] = ListLinePlotly[RandomReal[{1,4},7]];", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "a337ac85-6b65-4ad6-bf6e-c22aa61dc344", 
    "next" -> "3878ea8d-9f1c-4c56-bdb0-c63458a493c2", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3fcf994e-1c8e-4bad-846b-fa53d2ed91cc", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"myObject\"]", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> Null, "next" -> Null, 
    "parent" -> "b355fe21-abbe-4a32-b468-be2643d3bdc7", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "40fe456e-261b-46aa-ae0b-70b6e0dfff59", "type" -> "input", 
    "data" -> ".md\nAnd this is valid as well", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> 
     "60820dd2-8476-4008-af2f-620f1fd82604", 
    "next" -> "d373bef3-a397-4f80-a36a-84c08caa45ee", "parent" -> Null, 
    "child" -> "bdfccd79-fdd4-4d36-a966-99b2b12c0528", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "4235787c-e610-4d6a-8072-fb1e0915c596", "type" -> "input", 
    "data" -> ".md\nOr implicitly", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> 
     "c77f2782-e04d-4111-bf7c-fccd29b35048", 
    "next" -> "ee2f666f-d161-4393-bcdf-1081b28f9a9f", "parent" -> Null, 
    "child" -> "cbd5fb31-aed1-47ae-9806-718d920b794a", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "4a6cd701-99ef-4f5d-9065-4a9fb614f624", "type" -> "output", 
    "data" -> "\nYou can store the data there as well", 
    "display" -> "markdown", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "f302c85d-f6fe-4418-b72c-25330f57d797", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "4ec7c263-9e5a-41a4-8437-ec848c04889f", "type" -> "input", 
    "data" -> ".md\nNote, that using just `FrontEndRef[\"myData\"]` is a bit \
faster, because each update causes to all instances of `myData` to be \
reevaluated.", "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "4f51dc9a-04aa-438c-ae86-e82ece56dcdc", "next" -> Null, 
    "parent" -> Null, "child" -> "fb93be3b-d372-4397-85fc-7566228fc9a1", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "4f51dc9a-04aa-438c-ae86-e82ece56dcdc", "type" -> "input", 
    "data" -> "Do[FrontEndExecutable[\"myData\"] = RandomReal[{1,4},7]; \
Pause[0.1], {i, 10}];", "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "d745719e-11a8-4f04-bb90-cd742394989d", 
    "next" -> "4ec7c263-9e5a-41a4-8437-ec848c04889f", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "53fcc41e-b53c-4658-9e54-b2862edfef41", "type" -> "input", 
    "data" -> ".md\nIf one evaluate it, it will return just its content", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "ee2f666f-d161-4393-bcdf-1081b28f9a9f", 
    "next" -> "d2bee85f-66ad-4b7e-affc-5dea68c8b6da", "parent" -> Null, 
    "child" -> "f9885ba3-4f45-4f64-adb2-ff093cc4788b", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "5bd450ca-4b48-4f28-a4ef-c5c7554d48b1", "type" -> "input", 
    "data" -> "ListLinePlotly[FrontEndRef[FrontEndExecutable[\"myData\"]]]", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "9e476574-0a1a-40f4-9de4-ed066cad15a4", 
    "next" -> "12206a87-d2f4-4180-b9a1-3f7da15b220a", "parent" -> Null, 
    "child" -> "987f5e60-549e-441b-8f7c-fa7fb8460cb9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "5e2245ea-8b76-42af-ba60-a9ea763ebac1", "type" -> "output", 
    "data" -> "\nJust do not forget to wrap it in `FrontEndRef`, otherwice \
the Kenrel will subsitute only its content. This is also a valid form", 
    "display" -> "markdown", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "12206a87-d2f4-4180-b9a1-3f7da15b220a", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "5ef16950-8552-4d36-a4e9-c86c93c1e5dd", "type" -> "input", 
    "data" -> 
     "CreateFrontEndObject[ListLinePlotly[RandomReal[{1,4},7]], \"myPlot\"]", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "ca377c9e-5092-40da-9684-8dcb4a45ee7e", 
    "next" -> "a4fb2541-c402-46e0-8724-bad515080acf", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "60820dd2-8476-4008-af2f-620f1fd82604", "type" -> "input", 
    "data" -> "ListLinePlotly[FrontEndRef[\"myData\"]]", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "12206a87-d2f4-4180-b9a1-3f7da15b220a", 
    "next" -> "40fe456e-261b-46aa-ae0b-70b6e0dfff59", "parent" -> Null, 
    "child" -> "1905a834-84b7-4e31-a441-8157b09e48c6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "72e8febe-a9f8-4ab7-858d-7fe48b669726", "type" -> "input", 
    "data" -> 
     "CreateFrontEndObject[ListLinePlotly[{1,2,3,4,3,2,1}], \"myPlot\"]", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "79641871-795b-44fd-8c29-c7218356023f", 
    "next" -> "ca377c9e-5092-40da-9684-8dcb4a45ee7e", "parent" -> Null, 
    "child" -> "bfcf95eb-00a4-4259-8a51-0ab054cdd28f", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "79641871-795b-44fd-8c29-c7218356023f", "type" -> "input", 
    "data" -> ".md\n\n### Setting and updating\n\nFor example, we have \
created and object and want to update it's content. Apparently, the best will \
be to demonstrate it using plots", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> 
     "d2bee85f-66ad-4b7e-affc-5dea68c8b6da", 
    "next" -> "72e8febe-a9f8-4ab7-858d-7fe48b669726", "parent" -> Null, 
    "child" -> "2c18c78f-2c3e-43d2-a883-b51d1d24b69c", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "7df75e52-9811-4bcd-9c25-e366689f30c2", "type" -> "output", 
    "data" -> "\nOr as it is, but it might look weird for you. Just keep in \
mind, that this is still `FrontEndExecutable`", "display" -> "markdown", 
    "sign" -> "waverer-dd956", "prev" -> Null, "next" -> Null, 
    "parent" -> "a337ac85-6b65-4ad6-bf6e-c22aa61dc344", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8556df3d-2df6-4ffa-bd9d-033b1de0d164", "type" -> "output", 
    "data" -> "\nYou can copy and paste them into any cell of the notebook. \
Each copy is a separate instance of the same frontend object.\n\nFor the \
registered types of frontend object, one can just type directly the symbol \
name.\n\n\n> To see all this kind of symbols/objects, please, see \
`wolfram-js-frontend/WebObjects` folder.\n\n**If the output of the cell is \
not blocked**, then it will automatically apply `CreateFrontEndObject` method \
on it (with a random `uid`)", "display" -> "markdown", 
    "sign" -> "waverer-dd956", "prev" -> Null, "next" -> Null, 
    "parent" -> "2da8bddb-3cc1-43f7-af8a-3434b5ca45b8", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "987f5e60-549e-441b-8f7c-fa7fb8460cb9", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"67930b09-bdde-4632-9d32-f5a905ed36b7\"]", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "5bd450ca-4b48-4f28-a4ef-c5c7554d48b1", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9a21c1db-816f-4e35-a382-ea15a1a59cc2", "type" -> "output", 
    "data" -> "\nYou might you this approach as well, if you want.\n\n### \
Linking two objects together / Model-View separation\n\nRecreating the whole \
object with a new data is usually slow. However, nothing can stop you from \
substituing the reference to the data object inside the plotting object", 
    "display" -> "markdown", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "9e476574-0a1a-40f4-9de4-ed066cad15a4", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9e476574-0a1a-40f4-9de4-ed066cad15a4", "type" -> "input", 
    "data" -> ".md\nYou might you this approach as well, if you want.\n\n### \
Linking two objects together / Model-View separation\n\nRecreating the whole \
object with a new data is usually slow. However, nothing can stop you from \
substituing the reference to the data object inside the plotting object", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "abffda9d-2237-440c-a7ff-50ba4e0a8903", 
    "next" -> "5bd450ca-4b48-4f28-a4ef-c5c7554d48b1", "parent" -> Null, 
    "child" -> "9a21c1db-816f-4e35-a382-ea15a1a59cc2", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "a337ac85-6b65-4ad6-bf6e-c22aa61dc344", "type" -> "input", 
    "data" -> ".md\nOr as it is, but it might look weird for you. Just keep \
in mind, that this is still `FrontEndExecutable`", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> 
     "1df2db8a-7868-429b-a2b2-e989fce697a4", 
    "next" -> "3eedd93e-871c-47f5-8d86-fa574314eff0", "parent" -> Null, 
    "child" -> "7df75e52-9811-4bcd-9c25-e366689f30c2", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "a4fb2541-c402-46e0-8724-bad515080acf", "type" -> "input", 
    "data" -> ".md\nThere is a better way to update it by setting the \
reference to that object", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> 
     "5ef16950-8552-4d36-a4e9-c86c93c1e5dd", 
    "next" -> "1df2db8a-7868-429b-a2b2-e989fce697a4", "parent" -> Null, 
    "child" -> "b7893861-b9d9-4fa7-979a-e1ca66b05d3e", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "abbf238f-7a79-4a35-923d-88acc55a4c6b", "type" -> "output", 
    "data" -> "\n# Frontend Object / Executable\nIs a the key-element of the \
frontend. In general it can be decribed as\n- a decoration or displayable \
interactive (possibly) object in the notebook cell\n- a pointer to the \
exectuable WL expression on the frontend/server\n\nIn this regard all \
graphics are frontend objects. Any code you want to store and compute purely \
on frontend are frontend objects.\n\n## Lifecycle\nThe direct representation \
of it is\n\n```mathematica\nFrontEndExecutable[\"uid\"]\n```\nCodeMirror 6 \
(cell editor) finds this pattern and replace it with a corresponding frontend \
object and executes its content immediately. Let us show how to work with \
those objects\n### Creation\nTo create in from the arbitary expression, use \
`FrontEndCreateObject` on any WL expressions supported on the frontend \
interpreter. For example", "display" -> "markdown", 
    "sign" -> "waverer-dd956", "prev" -> Null, "next" -> Null, 
    "parent" -> "dcfd59f1-b37d-44bc-900e-c078ea7fe94c", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "abffda9d-2237-440c-a7ff-50ba4e0a8903", "type" -> "input", 
    "data" -> "SetFrontEndObject[\"myPlot\", \
ListLinePlotly[RandomReal[{1,4},7]]] // SendToFrontEnd;", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "3878ea8d-9f1c-4c56-bdb0-c63458a493c2", 
    "next" -> "9e476574-0a1a-40f4-9de4-ed066cad15a4", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "b355fe21-abbe-4a32-b468-be2643d3bdc7", "type" -> "input", 
    "data" -> 
     "CreateFrontEndObject[ListLinePlotly[{1,2,3,4,3,2,1}], \"myObject\"]", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "dcfd59f1-b37d-44bc-900e-c078ea7fe94c", 
    "next" -> "2da8bddb-3cc1-43f7-af8a-3434b5ca45b8", "parent" -> Null, 
    "child" -> "3fcf994e-1c8e-4bad-846b-fa53d2ed91cc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "b7893861-b9d9-4fa7-979a-e1ca66b05d3e", "type" -> "output", 
    "data" -> "\nThere is a better way to update it by setting the reference \
to that object", "display" -> "markdown", "sign" -> "waverer-dd956", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "a4fb2541-c402-46e0-8724-bad515080acf", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "bdb6fb6a-11a3-4272-8b04-d537f428173c", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"a2038741-7e8e-4324-8738-5e42bccca079\"]", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "d373bef3-a397-4f80-a36a-84c08caa45ee", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "bdfccd79-fdd4-4d36-a966-99b2b12c0528", "type" -> "output", 
    "data" -> "\nAnd this is valid as well", "display" -> "markdown", 
    "sign" -> "waverer-dd956", "prev" -> Null, "next" -> Null, 
    "parent" -> "40fe456e-261b-46aa-ae0b-70b6e0dfff59", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "bfcf95eb-00a4-4259-8a51-0ab054cdd28f", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"myPlot\"]", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> Null, "next" -> Null, 
    "parent" -> "72e8febe-a9f8-4ab7-858d-7fe48b669726", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c5371800-c8b1-42f1-af9e-ba7ea7cae493", "type" -> "output", 
    "data" -> "{1, 2, 3, 4, 3, 2, 1}", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> Null, "next" -> Null, 
    "parent" -> "d2bee85f-66ad-4b7e-affc-5dea68c8b6da", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c77f2782-e04d-4111-bf7c-fccd29b35048", "type" -> "input", 
    "data" -> "CreateFrontEndObject[{4,2,3,4,3,2,4}, \"myData\"]", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "f302c85d-f6fe-4418-b72c-25330f57d797", 
    "next" -> "4235787c-e610-4d6a-8072-fb1e0915c596", "parent" -> Null, 
    "child" -> "39a6a4fa-42af-4694-8955-be5cd6640ccf", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "ca377c9e-5092-40da-9684-8dcb4a45ee7e", "type" -> "input", 
    "data" -> ".md\nUsing the same id `myPlot` one can recreate it implicitly \
in a different cell, but WL will figure out that one needs to update all \
instances with the same id presented on the frontend. Try to call this", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "72e8febe-a9f8-4ab7-858d-7fe48b669726", 
    "next" -> "5ef16950-8552-4d36-a4e9-c86c93c1e5dd", "parent" -> Null, 
    "child" -> "d4ed7775-9757-46c0-ba6f-51a5229bc440", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "cbd5fb31-aed1-47ae-9806-718d920b794a", "type" -> "output", 
    "data" -> "\nOr implicitly", "display" -> "markdown", 
    "sign" -> "waverer-dd956", "prev" -> Null, "next" -> Null, 
    "parent" -> "4235787c-e610-4d6a-8072-fb1e0915c596", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "d2bee85f-66ad-4b7e-affc-5dea68c8b6da", "type" -> "input", 
    "data" -> "FrontEndExecutable[\"myData\"]", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> 
     "53fcc41e-b53c-4658-9e54-b2862edfef41", 
    "next" -> "79641871-795b-44fd-8c29-c7218356023f", "parent" -> Null, 
    "child" -> "c5371800-c8b1-42f1-af9e-ba7ea7cae493", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "d373bef3-a397-4f80-a36a-84c08caa45ee", "type" -> "input", 
    "data" -> "obj = CreateFrontEndObject[{4,2,3,4,3,2,4}, \
\"myData\"];\nListLinePlotly[obj]", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> 
     "40fe456e-261b-46aa-ae0b-70b6e0dfff59", 
    "next" -> "d745719e-11a8-4f04-bb90-cd742394989d", "parent" -> Null, 
    "child" -> "bdb6fb6a-11a3-4272-8b04-d537f428173c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "d4ed7775-9757-46c0-ba6f-51a5229bc440", "type" -> "output", 
    "data" -> "\nUsing the same id `myPlot` one can recreate it implicitly in \
a different cell, but WL will figure out that one needs to update all \
instances with the same id presented on the frontend. Try to call this", 
    "display" -> "markdown", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "ca377c9e-5092-40da-9684-8dcb4a45ee7e", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "d745719e-11a8-4f04-bb90-cd742394989d", "type" -> "input", 
    "data" -> 
     ".md\nThen we can update only the `myData` object and see, what \
happends", "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "d373bef3-a397-4f80-a36a-84c08caa45ee", 
    "next" -> "4f51dc9a-04aa-438c-ae86-e82ece56dcdc", "parent" -> Null, 
    "child" -> "2fa71255-1599-4832-baa7-02ae34c6028f", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "dcfd59f1-b37d-44bc-900e-c078ea7fe94c", "type" -> "input", 
    "data" -> ".md\n# Frontend Object / Executable\nIs a the key-element of \
the frontend. In general it can be decribed as\n- a decoration or displayable \
interactive (possibly) object in the notebook cell\n- a pointer to the \
exectuable WL expression on the frontend/server\n\nIn this regard all \
graphics are frontend objects. Any code you want to store and compute purely \
on frontend are frontend objects.\n\n## Lifecycle\nThe direct representation \
of it is\n\n```mathematica\nFrontEndExecutable[\"uid\"]\n```\nCodeMirror 6 \
(cell editor) finds this pattern and replace it with a corresponding frontend \
object and executes its content immediately. Let us show how to work with \
those objects\n### Creation\nTo create in from the arbitary expression, use \
`FrontEndCreateObject` on any WL expressions supported on the frontend \
interpreter. For example", "display" -> "codemirror", 
    "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> "b355fe21-abbe-4a32-b468-be2643d3bdc7", "parent" -> Null, 
    "child" -> "abbf238f-7a79-4a35-923d-88acc55a4c6b", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "ddbc4320-abc8-4862-96c6-e27b4b3c27c8", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"b97913e3-45cc-43f3-aff7-12b02a0251a8\"]", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "20a9642d-0699-4890-a09c-f0bd15ed8d4f", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "ee2f666f-d161-4393-bcdf-1081b28f9a9f", "type" -> "input", 
    "data" -> "obj = CreateFrontEndObject[{4,2,3,4,3,2,4}, \"myData\"];", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "4235787c-e610-4d6a-8072-fb1e0915c596", 
    "next" -> "53fcc41e-b53c-4658-9e54-b2862edfef41", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "f302c85d-f6fe-4418-b72c-25330f57d797", "type" -> "input", 
    "data" -> ".md\nYou can store the data there as well", 
    "display" -> "codemirror", "sign" -> "waverer-dd956", 
    "prev" -> "20a9642d-0699-4890-a09c-f0bd15ed8d4f", 
    "next" -> "c77f2782-e04d-4111-bf7c-fccd29b35048", "parent" -> Null, 
    "child" -> "4a6cd701-99ef-4f5d-9065-4a9fb614f624", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "f9885ba3-4f45-4f64-adb2-ff093cc4788b", "type" -> "output", 
    "data" -> "\nIf one evaluate it, it will return just its content", 
    "display" -> "markdown", "sign" -> "waverer-dd956", "prev" -> Null, 
    "next" -> Null, "parent" -> "53fcc41e-b53c-4658-9e54-b2862edfef41", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "fb93be3b-d372-4397-85fc-7566228fc9a1", "type" -> "output", 
    "data" -> "\nNote, that using just `FrontEndRef[\"myData\"]` is a bit \
faster, because each update causes to all instances of `myData` to be \
reevaluated.", "display" -> "markdown", "sign" -> "waverer-dd956", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "4ec7c263-9e5a-41a4-8437-ec848c04889f", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn2"|>
