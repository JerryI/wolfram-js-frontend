---
env:
  - WLJS
origin: https://github.com/JerryI/wljs-inputs
needsContainer: true
update: false
---
:::note
This is an internal part of [InputFile](InputFile.md)
:::

```mathematica
FileUploadView[label_String, opts__]
```
places a view-component for uploading files

## Event generation
For each file dropped it generates an event with filename and its content encoded as Base64 string

```mathematica
<|"data"->"base64 encoded byte array", "name"->"filename"|>
```


## Options
### `"Event"`
Specifies an `uid` of an event-object, that will be fired on-change.

## Application
It can be used without WLJS frontend on a web page. For instance using [WLX](../../../../wlx/install.md) (another [link](https://jerryi.github.io/wljs-docs/wlx/))

```mathematica
secret   = CreateUUID[];
datap = {{0,0}, {0,0}};

EventHandler[secret, Function[file,
  datap = Drop[ImportString[file["data"]//BaseDecode//ByteArrayToString, "TSV"], 1]
]];

View = FileUploadView["drop here tsv", "Event"->secret] // WLJS;
Plotter = ListLinePlotly[datap // Offload] // WLJS;

<div>
    <View/>
    <Plotter/>
</div>
```



