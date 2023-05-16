The aim is to make a compomise between `DisplayForm` and `InputForm` representations of Wolfram Expressions on the frontend's side.

In Matheamtica notebook (`DisplayForm`) everything you type becomes a bunch of __wrapper functions  being executed on a small WL interpreter__, ==which runs on a java-frontend==

what user see
$$\frac{1}{2}$$
what it actually is

```mathematica
Cell[BoxData[FractionBox["1", "2"]], "Input"]
```

i.e. this is an executable object, written as a sort of computable WL functions.

The power of Mathematica's frontend, that it expands and follows the paradigm of WL, where 

> Everything is symbol

to all intergactive objects, including mostly graphics. It makes you feel like you are still operating a bunch of symbolic expressions underneath it

> Graphics is a syntax sugar

```mathematica
Cuboid[]//Graphics3D
% /. {Cuboid :> Sphere}
```

The idea to reproduce the functionality of Mathematica's frontend in this manner is doomed by a few reasons

- frontend functions are poorely documented
- ~~WYSIWIG editor with mutable WL expressions inside is a mess~~ (see [[Decorations#Editable Two-ways binded widgets]])
- even with a ~20 years of development, Mathematica frontend is quite laggy

*With some compromises, giving to a user a full control and abillity to customise the processes under the hood it might result is a extremely flexible and relayable tool.*

Since Mathematica is a paid software, one have to do it from the scratch.

## Ballancing between InputForm and DisplayFrom
In principle, we do not need to make the whole WL expression mutable and interactive. There are only a few cases, where we really need this

1. Graphics, sliders, buttons and etc - __separate objects__
2. Syntax sugar for fractions, square roots, matrixes and etc. - __mixed__

*The first one* (__separate objects__) can be even separated from the actual code-area, since it originally works as inline block (a symbol or an atom). 

In the simples case one could just replace graphic objects with images (svgs) and substitute it to some advanced HTML-like editor, like a lot people did before

- Jupyter
- Wolfram Notebook VS Code extension

Anyway, since `Plot` and `Plot3D` is a set of `Graphics` and `Graphics3D` symbols with a recipy inside made from other symbols, one need to cook it and display to the user, i.e. ==we need a frontend WL interpreter for sure==. Since the portabillity is great - we should use web-stack, where Javascript rules all computations. See [WLJS Interpreter](https://github.com/JerryI/wljs-interpreter)

*The second one* (__mixed__) is rather tricky to implement fully, since it involves mutable WL expressions. 

However, here also we have a solution. Nowadays developers are using sort-of syntax sugar for the live previews of Markdown, where the code you typing is replaced by the corresponding styled object. A good example is Obsidian - notes making app based on CodeMirror 6 Decorations. Which will requeire to write a WL tokenizer inside the editor. TL-DR see [[Decorations]]

### For the sake of perfomance
For the most cases there is no point in interpreting the whole output expression.
Lets have a look at the `DisplayForm` output from Mathematica or Wolfram Engine for
$$\frac{a\times b}{\sqrt{2}}$$
```mathematica
FractionBox[RowBox[{"a", " ", "b"}], SqrtBox["2"]]
```

what I (as @JerryI a maintainer) would like to simplify here - __keep the actual code__ 

```mathematica
FractionBox[a b, SqrtBox[2]]
```

to remove an overhead while editing those expressions. Thankfully, it can easily be done
```mathematica
RowBoxAlt[x_List, y___] := StringJoin @@ (ToString[#] & /@ x)
( (a b)/Sqrt[2] // ToBoxes ) /. {RowBox -> RowBoxAlt} // ToString
```

The issues with styling and etc can also be solved - see [[Decorations#FrameBox, StyleBox... Custom decorations]].

