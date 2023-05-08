
InputRange[min_, max_, step_:1, opts___] := Module[{view, script, id = CreateUUID[]},
    EventObject[<|"id"->id, "initial"->((min+max)/2//N), "view"->RangeView[{min, max, step, ((min+max)/2//N)}, "Event"->id, opts]|>]
];


InputButton[label_String:"Click"] := Module[{view, script, id = CreateUUID[]},
    EventObject[<|"id"->id, "initial"->False, "view"->ButtonView["Label"->label, "Event"->id]|>]
];

InputToggle[initial_:False, opts___] := Module[{view, script, id = CreateUUID[]},
    EventObject[<|"id"->id, "initial"->initial, "view"->ToggleView[initial, "Event"->id, opts]|>]
];

InputText[initial_:"", opts___] := Module[{view, script, id = CreateUUID[]},
    EventObject[<|"id"->id, "initial"->initial, "view"->TextView[initial, "Event"->id, opts]|>]
];


InputGroup[in_List] := Module[{view}, With[{evid = CreateUUID[]},
	InputGroup[evid] = #[[1]]["initial"] &/@ in;
	
	MapIndexed[With[{n = #2[[1]]},
		EventBind[#1, Function[data, 
			InputGroup[evid] = ReplacePart[InputGroup[evid], n->data];
			EmittedEvent[evid, InputGroup[evid]];
		]]
	]&, in]; 

	view = (Table[CreateFrontEndObject[i, "igroup-"<>CreateUUID[]], {i, in}] // Column);
	EventObject[<|"id"->evid, "initial"->InputGroup[evid], "view"->view|>]
]];

InputGroup[in_Association] := Module[{view}, With[{evid = CreateUUID[]},
	InputGroup[evid] = #[[1]]["initial"] &/@ in;
	
	Map[With[{},
		EventBind[in[#], Function[data, 
			InputGroup[evid] = Join[InputGroup[evid], <|# -> data|>];
			EmittedEvent[evid, InputGroup[evid]];
		]]
	]&, Keys[in]]; 

	view = (Table[CreateFrontEndObject[i, "igroup-"<>CreateUUID[]], {i, in}] // Column);
	EventObject[<|"id"->evid, "initial"->InputGroup[evid], "view"->view|>]
]];

InputWolframLanguage[OptionsPattern[]] := Null;


(* old alias *)
HTMLSlider = InputsRange

Unprotect[InputField]
ClearAll[InputField]

InputField[default_] := Module[{view, script, id = CreateUUID[]},
    EventObject[<|"id"->id, "view"->WEBInputField[id, default]|>]
];

CM6Form[EventObject[assoc_]] ^:= If[KeyExistsQ[assoc, "view"], CreateFrontEndObject[assoc["view"]],  EventObject[assoc]];

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
		CreateFrontEndObject[Column[{slider, show}, "column-"<>CreateUUID[]]]
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