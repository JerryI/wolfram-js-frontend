## Static evaluation

#### Editor in the browser
When you open an editor and __start typing__, the following happends
1. each character is send to a server and updates the cell (autosaving)
2. editor tries to figure out the language or a cell type 
3. considering (2) it changes the highlighting and autocomplete / other plugins

In this sence your input cell is __an ultimate tool__.

![[ezgif.com-video-to-gif-4.gif]]

To specify the type it uses a prefix in the first line of the cell

```markdown
.md
# Hello
```

it can be anything `**.**` the behavior is defined by so-called `Addons` [[Writting Plugins]] to the frontend.

Then whatever you typed, you should press `Shift-Enter` to make magic happend

### 1. WL Processing
JS sends the data via websockets to the server and sets the status of the cell to  `working`

```mermaid
flowchart
  subgraph Browser
  In[Input Cell]
  Out[Output Cell]
    subgraph JS Engine
        direction RL
        WJ[Wolfram Interpreter];
    end
    WJ[Interpreter] --> Out[Output Cell]
  end
  In[InputCell]-- WebSockets -->B[Preprocessor]
  subgraph Master Kernel
    B[Preprocessor]
    V[Postprocessor]
    subgraph Addons
        Wolfram
        Markdown
        Mermaid
        HTML
        JS
    end
    Addons -.- B[Preprocessor]
  end
  subgraph Secondary Kernel
    B[Preprocessor]-- TCP/WSTP -->E[Evaluator] -- TCP --> V[Postprocessor] -- WebSockets --> WJ[Interpreter]
  end
```

#### Processing on Master Kernel
Firstly the preprocessing happends on the first master-kernel. 

All cells operations are performed via `Kernel/Cells` module under `Kernel/Notebook` wrapper

```mermaid

flowchart TB
subgraph Browser
JS
subgraph Frontend

InputCells
OutputCells
UI

end

end

Frontend --"Shift+Enter"--> Evaluate
subgraph Notebook["Notebook API"]

  Evaluate
  Events
  Processors
  subgraph MyNotebook["Notebook"]
	  Kernel
  end
end
Events --"Create Cell"--> Frontend 
Processors ---> CEvaluate
CEvaluate ---> Processors

Evaluate --"Meta-data"-->CEvaluate

subgraph Cells["Cell API"]
  CEvaluate["Evaluate"]
  CCallback["Callback"]

  CCallback --- CEvaluate
end

CEvaluate --> Kernel

Kernel --Async--> CCallback

subgraph KernelAPI["Kernel API"]
  Kernel1["Local Kernel"]
  Kernel2["Remote Kernel"]
end

CCallback--Fire-->Events

Kernel <--> KernelAPI
```

It applies all available processors to the input expression listed in `jsfn'Processors` . This is an example with Markdown language

```mathematica
{
	MarkdownQ -> <|"SyntaxChecker"->(True&), "Epilog"->(#&), "Prolog"->(#&), "Evaluator"->MarkdownProcessor |>,
}
```

The pipeline for `Processors` is following

```mermaid
flowchart TD
  In["Input String"]
  In --check--> MarkdownQ
  MarkdownQ --False--> MermaidQ
  MermaidQ --False--> WolframQ
  WolframQ --False--> ERR["Error!"]

  WolframQ--True-->SyntaxChecker
  MarkdownQ--True-->MProcessor
  MermaidQ--True-->MMProcessor

  subgraph Kernel["Kernel API"]
	  LocalKernel
	  RemoteKernel
  end
  
  subgraph WProcessor["Wolfram Processor"]
  direction LR
	SyntaxChecker-->Epilog["Epilog"]
	Epilog["Epilog"]-->Evaluator
	Evaluator --Async-->Prolog

  end
  Evaluator-->Kernel
Kernel --> Evaluator

Prolog-->Callback
  


  subgraph MProcessor["Markdown Processor"]
	
  end

  subgraph MMProcessor["Mermaid Processor"]
	
  end
```

Here evaluator function (`WolframProcessor`) can decide if it returns the result immediately or send to the evaluation to the secondary kernel with a callback included. Also it determines the final output cell subtype (wolfram, html, mermaid) see [[#Default cell types]] to be interpreted by the frontend running in the browser.

#### Evaluation on the secondary kernel | Kernel API
The expression arrives in a form of string and then converts to the Wolfram Expression with a held head. See `Kernel/Evaluator`

To support fully [[Frontend Object]] it replace them with an actual wolfram expressions. If it is not available on the kernel it makes a query to the master kernel and download them.

All non-native boxes, decorations (see [[Decorations#Editable Two-ways binded widgets]]) are replaced with the corresponding Wolfram Expressions.

The result evaluates normally. However if it encounters the creation function for [[Frontend Object]] or registered Frontend Objects (see [[Writting WebObject]]) like `Graphics`, `Plotly` it replaces them with `FrontEndExecutable` and stores the compressed to JSON data for them into the local storage to be shared lately with the master kernel and a notebook.

On the very last stage it converts the result to sort of `Boxes` (see [[Decorations#Editable Two-ways binded widgets]]).

If the resulting string is too long, then instead of a string it returns a pointer to the corresponding data to prevent frontend overloading

```mermaid
flowchart TB
In["Input String"]

subgraph FrontEndObjects
direction TB
	Object1
	Object2
	Object3["..."]
end


ToExpression --Get--> FrontEndObjects

subgraph MasterKernel
subgraph Notebook
	subgraph FrontEndObjectsGlobal["FrontEndObjects"]
	direction TB
		ObjectG1["Object1"]
		ObjectG2["Object2"]
		ObjectG3["..."]
	end
end
end

subgraph WebObjects
direction TB
	WebObject1
	WebObject2
	WebObject3["..."]
end

FrontEndObjectsGlobal --Sync--> FrontEndObjects
FrontEndObjects --Sync--> FrontEndObjectsGlobal

Evaluate

ToExpression --> Evaluate

Evaluate --Append-->FrontEndObjects

Evaluate-->ReplaceAll

ReplaceAll--Look-->WebObjects

WebObjects--Append-->FrontEndObjects

ReplaceAll-->ConvertToBoxes-->Out

Out["Output String"]


In --> ToExpression
```

The result, created frontend objects, the cell type are shared via provided callback function with a master kernel. As well as syncs updated or created [[Frontend Object]] s.

### 2. JS Processing
Once the message is decoded by the frontend in your browser, it creates a cell and fetches the corresponding handler to display the result in a cell. 

For example, here the handler function for `markdown`

```js
class MarkdownCell {
	dispose() {}
	constructor(parent, data) {
		//parse markdown code and draw it to DOM element
		parent.element.innerHTML = marked.parse(data);
		return this;
	}
}
```

After that the user can see the content. It also takes care about syntax highlighting and anything else. This process is boosted by the server side rendering, i.e. the server also provides DOM template for the cell wrapper, controls, buttons (as much as possible) to release an extra load from the client.

Any action with a cell must be aprooved by the server via Notebook API functions. If you remove the cell or add a new one the client waits the server's reply for it. Therefore it makes sure that the data is synced perfectly.

### Default cell types
There are a few built-in cell types available for the user

#### Wolfram Language
Works out of the box and has all features as an input cell
```mathematica
1+1
2
```

#### Markdown
Provides Markdown language with LaTeX support and WSP template engine
```markdown
.md
# Hello World!
- 1
- 2
```

![](imgs/Screenshot%202023-03-31%20at%2016.09.54.png)

WSP template engine allows to use Wolfram Language to process the text like PHP (see [more here](https://github.com/JerryI/tinyweb-mathematica)). For example, to create a list in Markdown one can do
```md
.md
# A list of items
<?wsp Table[ ?>
- <?wsp i ?>th element
<?wsp , {i,1,5}] ?>
```
it will produce
```md
# A list of items
- 1th element
- 2th element
- 3th element
- 4th element
- 5th element
```

#### HTML
You can also write plain HTML with WSP templates as well
```html
.html
<h1>Hello World</h1>
```

![](imgs/Screenshot%202023-03-31%20at%2016.09.04.png)

#### Mermaid
Draw beautiful diagrams by code (WSP is supported)
```bash
```shell
.mermaid
pie title NETFLIX
         "Time spent looking for movie" : 90
         "Time spent watching it" : 10
```

![](imgs/Screenshot%202023-03-31%20at%2016.01.28.png)

##### Image/File viewer/editor
It is questinable if it a good idea to implement it in the following syntax. The prefix itself defines the urls and the type of the processor. 

However, for now you can drop any image available in the folder of your notebook
```shell
randompic.png
```

![](imgs/Screenshot%202023-03-31%20at%2016.06.38.png)

to print the content of any file
```
filename.txt
```

to create or to write to a file
```
filename.txt
Hello World
```

![](imgs/Screenshot%202023-03-31%20at%2016.07.58.png)

##### SVG Art
This feature was added mostly for fun. If you like to draw using symbols, you should definitely try a new creating - [SVGBob](https://github.com/ivanceras/svgbob). Written in Rust and packed as a WASM module
```shell
.svgbob
--------->
```

![](imgs/Screenshot%202023-03-31%20at%2015.59.37.png)


### Writting your own processor | Editor
🚧  To be written

## Dynamic evaluation
To support dynamics and two-ways data binding it relies on the event-based evaluation. For each asynchronious evaluation on the secondary kernel via Kernel API

- an event has to be fired by the frontend (browser)
- a direct request must be send by the frontend

### Event system
It uses a very simplified event system, where an event object has an id and the data inside. Each event object can be assigned only to the one handler

```mermaid
flowchart LR

subgraph EventObject
	id
	data
end

subgraph EventHandler
	Function
end

EventObject --Call-->EventHandler
```

in the code anywhere one can use
```mathematica
event = EventObject[<|"id"->"uid"|>]
EventBind[event, Function[data,
	Print["Fired!"];
	Print[data]
]]
```
to fire an event one need to evaluate
```mathematica
EmittedEvent["uid", "Hello world"]
```

The trick is that one can subsitute anything inbetween 

```mermaid
flowchart LR

subgraph Frontend
subgraph Event1["Event"]
	id1["id"]
	data1["data"]
end
end

subgraph MasterKernel

end

subgraph SecondaryKernel
subgraph EventHandler
	Function
end
end

Event1--Fire-->MasterKernel--Fire-->EventHandler

```

on JS side (frontend) it looks like
```js
server.emitt('uid', data)
```

A silder, a button, an animation on the frontend __are a just event-generators__ with a fancy view boxes (see [[Making Frontend Views for symbols]]).

#### A direct request by the frontend to the secondary kernel
On JS side it is possible to evaluate any arbitary function on the secodnary kernel by calling
```js
server.talkKernel('Print["Hi!"]')
```

#### How to reply back?
To make fire the chain backwards we rely on the direct communication between frontend and the secondary kernel. Secondary kernel is always aware, to which notebook it is connected. Then to execute any frontend function (see [[Frontend functions]]) one can call

```mathematica
SendToFrontEnd[ Alert["Hello World"] ];
```

ie.

```mermaid
flowchart RL

subgraph Frontend
WLJS --> Alert!
end

MasterKernel

SecondaryKernel


SecondaryKernel--Alert-->MasterKernel--Alert-->WLJS

```

One can transfer any arbitary symbolic or non-symbolic data to it and even perform [[Heterogenesis computation]] there. With some syntax sugar it provides a nice interface to interact with [[Frontend objects]].

### Promises
The given examples above are focused on the async evaluation and etc. But what if we need get some data from the master or secondary kernel and then, perform some calculations using that?

it uses `NotebookPromise` api together with JS's `promise` in a way like
```js
server.ask('1+1').then((result)=>{
	alert(result)
})

//or for thesecondary kernel
server.askKernel('1+1').then((result)=>{
	alert(result)
})
```

it allows you to write efficient async code with synchronous communication.