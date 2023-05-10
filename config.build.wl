<|
    "watch" -> {"Src"},
    "recipy" :> (
        (* remove old *)
        DeleteFile /@ FileNames["*", "public/dist"];
        (* merge and bundle the files *)
        MergeFiles[{
                (* the core of frontened *)
                "Src/frontend.js",
                (* all cells types 
                FileNames["*.js", "Kernel/Addons", Infinity],
                (* all webobjects *)
                FileNames["*.js", "WebObjects", Infinity],*)

                "Src/epilog.js"
            } -> "Temp/merged.js"
        ];

        MergeFiles[{
                (* the core of frontened *)
                "Styles/main.css",
                "Styles/ui.css",
                
                (* all cells types *)
                FileNames["*.css", "Kernel/Addons", Infinity],
                (* all webobjects *)
                FileNames["*.css", "WebObjects", Infinity]
            } -> "public/dist/merged.css"
        ];        

        (* rolling up using Node *)
        Print[Green<>"rolling up..."]; Print[Reset];
        RunProcess[{"node", "--max-old-space-size=8192", "./node_modules/.bin/rollup", "--config", "rollup.config.mjs"}]["StandardError"]//Print;
        Print[Green<>"rolling up is done"]; Print[Reset];

        (* merge in the right sequence, because core.js is not a ~real JS module~ and needed to be added separately *)
        MergeFiles[{
                "public/dist/merged.js"
            } -> "public/dist/merged.js",

            (* annoying bugs as a consiquence of non-strict compilation using Rollup *)
            (* chromee issue was on Firefox browsers as well as on Vivalldi *)
            (* Safari - OK, Chrome - OK, Firefox - OK, Vivaldi - OK *)

            "PostProcess" -> (StringReplace[#, {
                "const top = typeof globalThis"->"const top0 = typeof globalThis", 
                "chrome"->"chromee"
            }]&)
        ];

        (* merge in the right sequence, because core.js is not a ~real JS module~ and needed to be added separately *)
        MergeFiles[{  
                "Src/sockets.js"
            } -> "public/dist/sockets.js"
        ]; 

        Print["Bundling for the standalone export app..."];
        (* for standalone app *)
        MergeFiles[{
                "Src/fakesockets.js"
            } -> "public/dist/export/fakesockets.js"
        ];            

        Print[Red<>" the process is not done yet... wait..."];
        Print[Reset];
        (* for standalone app 
        RunProcess[{"node", "--max-old-space-size=8192", "./node_modules/.bin/rollup", "--config", "rollup.standalone.config.mjs"}]//Print;   
        
        Print[Red<>"everything is done!"];
        Print[Reset];*)
    )
|>