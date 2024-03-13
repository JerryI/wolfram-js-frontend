It allows to use [Wolfram Language XML](https://jerryi.github.io/wlx-docs/docs/Reference/WLX/) in your cell. It comes handy when making a a complex cell structure or stylizing it using the power of HTML/CSS/JS.

![](../../Screenshot%202024-03-13%20at%2019.28.47.png)
## Embed figures into a custom layout
Plot a figure into a symbol __starting from the capital letter__

```mathematica
Figure = Plot[Sinc[5x], {x,-5,5}]
```

then type in a new cell

```jsx
.wlx

<div>
  <style>
    @keyframes tilt-shaking {
      0% { transform: rotate(0deg); }
      25% { transform: rotate(5deg); }
      50% { transform: rotate(0eg); }
      75% { transform: rotate(-5deg); }
      100% { transform: rotate(0deg); }
    }
  </style>
  <div style="animation: tilt-shaking 0.35s infinite">
    <Figure/>
  </div>
</div>
```

Then you plot will shake infinitely ;)

## Making components
Let us define some hybrid WL function

```jsx
.wlx

Heading[Text_, OptionPattern[]] := With[{color = OptionValue["Color"]},
	<h2 style="color: {color}"><Text/></h2>;
]

Options[Heading] = {"Color"->"black"}
```

then we can use it in our layout

```jsx
.wlx

<Heading Color={"blue"}>
  Hello World!
</Heading>
```

:::tip
Utilize the power of WLX while making [Slides](Slides.md) 
:::

All WL expressions __are accessible from there as well__

```jsx
.wlx

<TextString>
	<Now/>
</TextString>
```

## Two-columns layout using Flexbox
You can fine-tune the layout, since you are dealing with pure HTML and CSS. For example, here we have a slider and a plot aligned to a row

```jsx
.wlx

Module[{Slider = InputRange[0.1,1,0.1,0.5], Figure, lines},
  EventHandler[Slider, Function[data, lines = {#, Sinc[#/data]}& /@ Range[-5,5,0.1]]];
  Slider // EventFire;

  Figure = Graphics[Line[lines // Offload], ImageSize->350];

  <div style="display: flex">
    <div><Slider/></div>
    <div><Figure/></div>
  </div>
]
```


