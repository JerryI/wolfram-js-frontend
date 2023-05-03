<|
    "watch" -> {"JSFrontend", "WebObjects", "Kernel/Addons"},
    "recipy" :> (
        (* merge and bundle the files *)
        MergeFiles[{
                (* the core of frontened *)
                "JSFrontend/frontend.js",
                (* all cells types *)
                FileNames["*.js", "Kernel/Addons", Infinity],
                (* all webobjects *)
                FileNames["*.js", "WebObjects", Infinity],

                "JSFrontend/epilog.js"
            } -> "Temp/merged.js"
        ];

        (* rolling up using Node *)
        Print[Green<>"rolling up..."]; Print[Reset];
        RunProcess[{"node", "--max-old-space-size=8192", "./node_modules/.bin/rollup", "--config", "rollup.config.mjs"}]["StandardError"]//Print;
        Print[Green<>"rolling up is done"]; Print[Reset];

        (* merge in the right sequence, because core.js is not a ~real JS module~ and needed to be added separately *)
        MergeFiles[{
                "public/js/merged.js"
            } -> "public/js/merged.js",

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
                "JSFrontend/sockets.js"
            } -> "public/js/sockets.js"
        ]; 

        Print["Bundling for the standalone export app..."];
        (* for standalone app *)
        MergeFiles[{
                "JSFrontend/fakesockets.js"
            } -> "public/js/export/fakesockets.js"
        ];            

        Print[Red<>" the process is not done yet... wait..."];
        Print[Reset];
        (* for standalone app 
        RunProcess[{"node", "--max-old-space-size=8192", "./node_modules/.bin/rollup", "--config", "rollup.standalone.config.mjs"}]//Print;   
        
        Print[Red<>"everything is done!"];
        Print[Reset];*)
    )
|>