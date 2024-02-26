---
env:
  - Wolfram Kernel
origin: https://github.com/JerryI/wljs-inputs
update: false
---
```mathematica
InputFile[label_String] _EventObject
```
outputs as a drag & drop file-form used to handle file input

## Event generation
For each file dropped it generates an event with filename and its content encoded as Base64 string

```mathematica
<|"data"->"base64 encoded byte array", "name"->"filename"|>
```

## Example
A simple file-form to plot the data from the uploaded file

```mathematica
datap = {{0,0}, {0,0}};
EventHandler[InputFile["Drag and Drop"], Function[file,
  datap = Drop[ImportString[file["data"]//BaseDecode//ByteArrayToString, "TSV"], 1]
]]
ListLinePlotly[datap // Offload]
```

> works with data, where each column is separated by a spacebar or tab aka `TSV`. Click `autoscale` to see the full range

## Dev notes
This is a wrapper over [FileUploadView](FileUploadView.md)

