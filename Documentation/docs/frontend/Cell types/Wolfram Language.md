---
sidebar_position: 1
---
![](../../Mathinput-ezgif.com-optipng%201.png)


__[Github repo](https://github.com/JerryI/wljs-editor)__

When you open an editor and __start typing__, the following happens
1. each character is send to a server and updates the cell (autosaving)
2. editor tries to figure out the language or a cell type 
3. considering (2) it changes the highlighting and autocomplete / other plugins

In this sense your input cell is __an ultimate tool__.

:::tip
To specify the type of a cell - use a prefix in the first line of the cell
```markdown
.md
# Hello
```
it can be anything `**.**` the behavior is defined by language processors shipped via packages installed (see [Static Evaluation](../Development/Evaluation/Static.md))

**Think about it if it was an anonymous file**
:::

Then whatever you typed, you should press `Shift-Enter` to make magic happens.

:::info
Input cell is a universal text-field and cannot be customized. Output cells can be different and customized via plugins / packages.
:::

Wolfram Language cells support code with built-in syntax highlighting, graphics or any other interactive objects, syntax sugar (fractions) and etc.

## Syntax highlighting
Depending on the language you specify at the first line, it will highlight HTML, Markdown or Javascript. Wolfram Language autocomplete and highlighting can be extended using external packages.

Once you define something in Wolfram Kernel session, the corresponding symbol will appear in the autocomplete window.

## Syntax sugar
All equations typed in the editor are compatible with any WL parser,  i.e. can be used in `wolframscript`, since the syntax sugar and the structure is localized inside comments

For example

$$\sqrt{2\pi}$$
becomes 

```mathematica
(*SqB[*)Sqrt[2\[Pi]](*]SqB*)
```

which is safe for copying to anywhere outside the WLJS ecosystem


The following shortcuts are used for equations typing

- `Ctrl-2` - place a square root on the selected text
- `Ctrl-/` - make a fraction
- `Ctrl--` - make a subscript
- `Ctrl-6` - make a superscript (power)

You can also make your own custom representation of your symbol like in Mathematica using `MakeBoxes`. Please see [InterpretationBox](../Reference/Decorations/InterpretationBox.md), [Interpretation](../Reference/Decorations/Interpretation.md) and [MakeBoxes](../Reference/Decorations/MakeBoxes.md)