Advanced InputForm!

## Uneditable
All interactive objects like `Graphics`

```mathematica
FrontEndExecutable["uid"]
```

with a link to a JSON object and ==evaluates it== immediantely

### Greek Symbols
То type it, use ESC button in CodeMirror

```mathematica
\[Alpha]
```

Define as atomics

## Editable
For example

```mathematica
Sqrt[] -> to something fance
```
Use a __Hot-Key binding in CodeMirror__

One can make fractions in a way

```mathematica
Frac[x, y] -> real stuff
```

Then, on Mathematica's side one can define

```mathematica
Frac[x_, y_] := x/y;
```