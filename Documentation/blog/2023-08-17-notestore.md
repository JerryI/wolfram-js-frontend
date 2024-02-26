---
slug: notestore
title: Introducing NotebookStore
authors: jerryi
tags: [frontend]
enableComments: true
---

Sometimes it is easier to ship notebook together with the data it depends on. However, not as a text encoded using BASE64 pasted into a notebook cell - it would just kill the performance, but as a dedicated inner structure, that can be exposed using `NotebookStore`

```mathematica
NotebookStore["key"] = 1+1
NotebookStore["key"] === 1+1
```

As simple as that. This is not real association, but mimics its behavior. To get all keys, use 
```mathematica
Keys[NotebookStore]
```

In the worst case scenario one can use `Iconize`, but that will make the data to be stored inside a notebook cell, which is recommended.

:::tip
For the arrays of data apply `Compress` / `Uncompress` to save up the space
:::