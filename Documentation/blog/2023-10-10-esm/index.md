---
slug: esm-into
title: Introducing ESM Javascript cells | Poking Nintendo Pro
authors: jerryi
enableComments: true
---
Have only plain JS cell types is still not enough, when it comes to `import` anything from NPM repository or your local files. Many sandboxes, such as Codepen, RunJS, ReplIT has this option to use NodeJS in the browser. Why don't we have this feature as well?

[__wljs-esm-support__](https://github.com/JerryI/wljs-esm-support) plugin

<!--truncate-->
## Bundling on-fly
The idea is, you have `node` installed on your system and Wolfram Kernel runs an external process

```mathematica
RunProcess[{"node", ...}, Stdin]
```

using some bundler, that support `stdin` method to process the file data instead of actual file. The only one I found is ESBuild. In principle, then, one can feed the content of any cell to it and get the data back to the output cell as a bundled JS file.

## Helper functions
It would be nice to have a simple interface to interact with Node, therefore, I created a special object for that

```mathematica
NPM["name-of-a-package"] // Install 
```
which will install locally to the vault folder a module from npm repository. 

## Example
Let us try the simples possible example. For instance you found a nice package for making fireworks inside your notebook [js-confetti](https://www.npmjs.com/package/js-confetti)

Then you type
```mathematica
NPM["js-confetti"] // Install
```

And finally our `.esm` cell
```js
.esm

import JSConfetti from 'js-confetti'
const jsConfetti = new JSConfetti()
jsConfetti.addConfetti();

const re = document.createElement('span');
re.innerText = "everything is fine!";

this.onreturn = () => {
  return re;
}
```

When you evaluate it, it compiles JS file and embeds the result to the output cell.

## Nintendo Pro controller & Wolfram Engine
This is rather much funnier example. It is known fact, any JS app can interact with gamepads, controllers connected via USB or Bluetooth channel. 

Why not use it to communicate to Wolfram Kernel? 😵‍💫
The overhead from translating the signals OS $\rightarrow$ V8 engine seems to be minimal.

### Reading signals

```mathematica
NPM["switch-pro"] // Install 
```

```js
.esm
import SwitchPro from 'switch-pro'

const switchPro = new SwitchPro(window)

switchPro.addListener((pressed) => {
  server.emitt('joy', `"${JSON.stringify(pressed).replaceAll(/"/g, "'")}"`);
});

core.Rumble = async () => {
  switchPro.vibrate();
}

```

This is super easy, we just redirect all events to WL kernel as JSON string with some minor changes in order to escape double quotes.

:::note
A library `switch-pro` automatically discovers Pro controller and connects to it. No actions are needed.
:::

The last line `Rumble` is to "vibrate" our controller just for fun. We will use it later.

### Handling signals

```mathematica
EventHandler["joy", handler];
```

Now we attached an event-handler to the events from Nintendo controller. Let us decrypt JSON and send it to some plot

```mathematica
point =  {0,0};
handler = Function[cmd,
  Module[{assoc = ImportString[StringReplace[cmd, "'"->"\""], "JSON"] // Association, p = point},
    If[KeyExistsQ[assoc, "RS-DOWN"], p = {p[[1]], -assoc["RS-DOWN"]}];
    If[KeyExistsQ[assoc, "RS-UP"], p = {p[[1]], assoc["RS-UP"]}];
    If[KeyExistsQ[assoc, "RS-LEFT"], p = {-assoc["RS-LEFT"], p[[2]]}];
    If[KeyExistsQ[assoc, "RS-RIGHT"], p = {assoc["RS-RIGHT"], p[[2]]}]; 

    If[Length[Keys[assoc]] == 0, p = {0,0}];

    point = p;
  ]
];

Graphics[{Red, PointSize[0.1], Point[point // Offload]}, TransitionDuration->50, TransitionType->"Linear"]
```

This code looks a bit sketchy, the decoding could be done in a much more efficient manner.
Do not forget about rumbling! But this is no-brainer

```mathematica
EventHandler[InputButton["Rumble"], Function[Null, FrontSubmit[Rumble[]]]] 
```

The result you can see in the video

<iframe width="560" height="315" src="https://www.youtube.com/embed/qhG6PV4NZeA?si=a4wuC7KGR25FZo6I" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

You can download the notebook using the link in the bottom
- [__NintendoPro__](NintendoPro.wln)
