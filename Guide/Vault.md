- List Notebooks in the parent directory
- ~~Open Folder $\rightarrow$ Open Notebook~~
- Open Folder $\rightarrow$ Locate `.mx` and open a file as notebook
- Upload Image (drag and drop) $\rightarrow$ place in in the notebook folder

- When remote kernel operates with `FileNames` and `Import`, `Export` and etc $\rightarrow$ use TCP to send data byte array

## Notebook format

Use assotication and save it as `.mx`
```mathematica
<|
  "id"->,
  "signature"->"we-notebook"
|>
```

and, then, using `Get` get and check if it is a real notebook.

```mathematica
Get[]["signature"] === "we-notebook"
```

Load into the database `Notebooks` and save every minute