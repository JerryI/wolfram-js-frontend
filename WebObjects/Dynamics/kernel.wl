Unprotect[Slider]
ClearAll[Slider]

Slider[min_, max_, step_:1] := Module[{view, script, id = CreateUUID[]},
    EventObject[<|"id"->id, "view"->WEBSlider[id, {min, max, step}]|>]
];

(* old alias *)
HTMLSlider = Slider

Unprotect[InputField]
ClearAll[InputField]

InputField[default_] := Module[{view, script, id = CreateUUID[]},
    EventObject[<|"id"->id, "view"->WEBInputField[id, default]|>]
];

CM6Form[EventObject[assoc_]] ^:= If[KeyExistsQ[assoc, "view"], CreateFrontEndObject[assoc["view"]],  EventObject[assoc_]];

CreateFrontEndObject[EventObject[assoc_]] ^:= CreateFrontEndObject[assoc["view"]];
CreateFrontEndObject[EventObject[assoc_], uid_] ^:= CreateFrontEndObject[assoc["view"], uid];


Unprotect[Manipulate]
ClearAll[Manipulate]

SetAttributes[Manipulate, HoldAll]

Manipulate[expr_, {symbol_,min_,max_,step_:1}] := 
Module[{
	serverSide = Null, 
	clientSide=Null, 
	target, 
	objects = <||>,
	function,
	WrapperFunction,
	CreateFrontEndObjectSafe,
	FrontEndExecutableSafe,
	createObjects,
	firstRun,
	panel,
	slider,
	show,
	fakeTarget,
	handler
},

	target = Cases[Hold[expr],
		HoldPattern[CompoundExpression[expr1__,expr2_]] :> Hold[expr2],
		All]//First;

	createObjects[args__]:=(
		(objects[CreateUUID[]] = <|"symbol"->Unique[], "data"->#|>) &/@ List[args]
	);

    firstRun = Module[{symbol = min}, expr] // Hold;
	firstRun /. {Extract[target,1, Head] -> createObjects} // ReleaseHold;
	
	panel := With[{slider = CreateFrontEndObject[slider, "slider-"<>CreateUUID[]], show = CreateFrontEndObject[show, "show-"<>CreateUUID[]]},
		CreateFrontEndObject[Panel[{slider, show}, "panel-"<>CreateUUID[]]]
	];
	
	slider = Slider[min, max, step];
	
	show = function @@ (CreateFrontEndObject[objects[#, "data"], #] &/@ Keys[objects]);
	show = With[{show = show}, FrontEndOnly[show]] /. {function -> Extract[target,1, Head]};
	
	fakeTarget = WrapperFunction[objects[#, "symbol"] &/@ Keys[objects], 
		Table[With[{i = i}, SetFrontEndObject[i, objects[i, "symbol"] ] ], {i, Keys[objects]}] // SendToFrontEndHold
	] /. {WrapperFunction -> Function} /. {SendToFrontEndHold -> SendToFrontEnd};

    
	
	handler = (Function[symbol, expr]) /. {Extract[target,1,Head] -> fakeTarget};
	EventBind[slider, handler];

    ClearAll /@ (objects[#, "symbol"] &/@ Keys[objects]);
  
	
	panel
]