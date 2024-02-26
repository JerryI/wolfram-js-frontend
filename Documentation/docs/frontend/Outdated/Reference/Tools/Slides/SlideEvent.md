---
env:
  - Wolfram Kernel
update: 
source: https://github.com/JerryI/wljs-revealjs
---
An event-marker for the given slide of the presentation used in [RevealJS](https://github.com/JerryI/wljs-revealjs) plugin
```jsx
<SlideEvent id={"uid"}/>
```
where a string `uid` is used by [`EventHandler`](../../Events/EventHandler.md) to attach an event

## Example
### Slide reveal
You can assign an event handler, when a slide reveals using [WLX](../../../../../wlx/basics.md) language

```jsx
.slide
# Slide 1

Nothing special

---

# Slide 2

Now the event comes

<SlideEvent id={"slide-2"}/>
```

In the next cell
```mathematica
EventHandler["slide-2", Function[Null, Print["Hey!"]]]
```

### Fragment reveal
One can also detect [fragments](https://revealjs.com/fragments/) or any other changes in the slides

```jsx
.slide
# Slide 1

Nothing special

A message <!-- .element: class="fragment" data-fragment-index="1" -->

<SlideEvent id={"slide-1"}/>
```

```mathematica
EventHandler["slide-1-fragment-1", Print["Hey there from fragment!"]&]
```