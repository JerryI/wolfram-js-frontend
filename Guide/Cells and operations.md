## Notebook folder
We need 

## Input cells
Types of input cells
- undefined
- defined

#### Undefined
Just regular wolfram code

#### Defined
- JS
- HTML
- Markdown
  - decorations helpers

Use extensions ==and apply WSP==
```js
.js
console.log('<?wsp var ?>')
```

### Properties
- Hidden

## Output Cells
Display types of them
- html - used for Markdown and HTML
- codemirror - creates CodeMirror editor

# Operations

## Evaluation

```js
socket.send('NotebookOperate["sign", CellObjEvaluate, "id"]')
```

Then inside the `NotebookOperate`

```mathematica
NotebokOperate[] := (

)
```