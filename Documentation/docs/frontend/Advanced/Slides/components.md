---
draft: false
---
# Components

Making presentation is quite repetitive process. It is quite common to have some common element shared between different slides.

To overcome this small issue one can use [WLX](../../Cell%20types/WLX.md) language to define heading for instance

```jsx
.wlx
Heading[OptionsPattern[]]] := With[{Title = OptionValue["Title"]},
  <dummy>
    <h1><Title/></h1>
    Some repetative text you need
  </dummy>
] 

Options[Heading] = {"Title"->"Nope"}
```

:::tip
[WLX](../../../../wlx/basics.md)  requires always only one parent element if you has defined a function with XML tags. Use `<dummy>` or `<div>` for that.
:::

and then use it on your slides as if it was a normal tag

```jsx
.slide

<Heading title={"Some title"}/>

<br/><br/>

The actual content

Mb some equations $m \mathbf{a} = \mathbf{F}$
```

Unfortunately it is quite tricky to use normal Markdown inside components, because it requires caret returns between XML/HTML and Markdown tags, which are trimmed by default. However for equations it still works

```jsx
.wlx

Heading[OptionsPattern[]]] := With[{Title = OptionValue["Title"]},
  <dummy>
    <h1><Title/></h1>
    Some repetative text you need
    Here some random equation $x^2 + y^2 + z^2 = r^2 $
  </dummy>
] 

Options[Heading] = {"Title"->"Nope"}
```

## Layout helpers
This is a common case, when components comes handy. Imagine a typical situation, when we need to organize columns in the presentation

```jsx
.wlx

Columns[cols__] := With[{width = 99 / (List[cols]//Length) // Floor},

  With[{Layout = Table[
    <div style="width: {width}%">
      <Col/>
    </div>  
   , {Col, List[cols]}]
  },

    <div style="display:flex">
      <Layout/> 
    </div>
  ]
  
]
```

here we firstly calculated the width of each column based of their number, and then used a normal HTML with CSS to style them.

Since the input argument is not typed, one can use nested tags, or WL expressions as a content for each columns. Here is one of the slides of [@JerryI](https://github.com/JerryI)'s presentation on a recent talk in 2023

```jsx
.slide

# Different ways of calculating properties for magnetic materials

<br/><br/>

<Columns>
  <p style="text-align:left">

## DFT+U
DFT with Columb repulsion between sites allowing to model the localized magnetic moments
    
- lack of $\sim 1~cm^{-1}$ accuracy
- slow and time-consuming
- hard to control the intermediate steps
- feeling of working with "black box"
    
  </p>
  <p style="text-align:left">

## Effective Hamiltonians
Spin Hamiltonian, Heisenberg, etc... randomly picked
    
- non consistent (completely different from compound to compund)
- overparametrized
    
  </p>
  <p style="text-align:left">

## Microscopic theory <!-- .element: class="fragment highlight-red" data-fragment-index="1" -->
Building the energy levels step by step from the isolated ion considering crystal structure and interactions <!-- .element: class="fragment highlight-red" data-fragment-index="1" -->
    
- considered to be outdated
- ~~requires a lot of calculations~~
- hard to threat collective excitations

<span style="color:red">Use Computer Algebra!</span> <!-- .element: class="fragment" data-fragment-index="1" -->
    
  </p>
</Columns>
```

One can see, that this is again a mixture of HTML/XML and Markdown. Each tag entering into `<Columns>` is treated as a separate argument.

But nothing can stop you from using a plain text

```jsx
.slide

<Columns>

# Title
First column
  
  <Identity>

# Other title
Second one
    
  </Identity>
</Columns>
```

:::info
`Identity` or `dummy` or `p` or `div` helps WLX to differentiate between the first and second argument. It is similar to `li` tag used in `ul` HTML tag used for lists.
:::

You can use the full power of modern CSS to style it in a way you like.
