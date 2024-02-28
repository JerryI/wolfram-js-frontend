# Graphics animation & interaction

## Interactive plots
__By the default__, everything you plot using [Plot](../../Reference/Plotting/Plot.md) or [Graphics](../../Reference/Graphics/Graphics.md) or [Graphics3D](../../Reference/Graphics3D/Graphics3D.md) can be dragged or panned or rotated. This behavior is controlled by the options and can be switched off if necessary. For example

```mathematica
Figure = Plot[{x, Sin[x], Sin[x]^2}, {x,0,2Pi}];
```

```jsx
.slide

# Simple plot

<Figure/>

Try to drag it using you mouse
```

The result will look like following

![](../../../../imgs/ezgif.com-optimize%201.gif)

## Animation
In general all visuals can be done in the same way as in regular cells, since it uses the same components.

When a slide becomes visible or a fragment got revealed (see [Transitions and fragments](intro.md#Transitions%20and%20fragments)) it fires an event, where all information is encoded. To enable this - use [SlideEvent](../../Reference/Tools/Slides/SlideEvent.md).

:::info
Put [SlideEvent](../../Reference/Tools/Slides/SlideEvent.md) anywhere on the slide to hook up WL Kernel to all events associated with it
:::

:::tip
Keep the dynamic variables scoped using [LeakyModule](../../Reference/Tools/LeakyModule.md) and allow use explicit event routing like in [Scoping](../Dynamics/Scoping.md) and [routing](../Events%20system/routing.md). Later it will allow you to reuse your components for other slides much easier.
:::

Let us see the simples example

```jsx
.slide

# Animation example

<Figure id={"routed-event-fragment-1"}/>

The figure will be changed, when the fragment below is revealed

<span style="color:red">Magic</span> <!-- .element: class="fragment" data-fragment-index="1" -->

<SlideEvent id={"routed-event"}/>

```

The additional `-fragment-[index]` is added implicitly by [SlideEvent](../../Reference/Tools/Slides/SlideEvent.md) function to all fragments on a slide. While `SlideEvent` is attached only to the slide, where it has been placed.

Now let us make a simple figure

```mathematica
Figure[OptionsPattern[]] := With[{event = EventClone[OptionValue["id"]]},
	EventHandler[EvaluationCell[], {"destroy" -> Function[Null, Delete[event]]}];
	
	...
]

Options[Figure] = {"id"->""}
```

Here we clone a slide event (this is a safe way, if more than 1 handlers will be involved). Afterwards we need to make sure that if one reevaluate the cell, the handler will be removed automatically. That's how you can clean-up handlers after the evaluation.

Now the content

```mathematica
Figure[OptionsPatten[]] := With[{event = EventClone[OptionValue["id"]]},
	EventHandler[EvaluationCell[], {"destroy" -> Function[Null, Delete[event]]}];
	
	LeakyModule[{points},
		(* initial state *)
		points = RandomReal[{-1,1}, {40,2}];
		
		EventHandler[event, Function[Null, 
			(* act when the event happend *)
			points = {Sin[#], Cos[#]} &/@ Range[40]
		]];
		
		Graphics[{Red, Line[points // Offload]}]
	]
]

Options[Figure] = {"id"->""}
```

This little script will plot randomly distributed points as lines for its initial state. When the `event` is fired, it changes the distribution of `points` to a circle. The animation is done by [Graphics](../../Reference/Graphics/Graphics.md)  (i.e. it is a native feature of it and has nothing to do with slides).

:::note
Consider options `TransitionType` and `TransitionDuration` of [Graphics](../../Reference/Graphics/Graphics.md) to control the transition animation.
:::

The expected result will be

![](../../../../imgs/ezgif.com-video-to-gif%201.gif)

Sure the state is not reservable in this case. You need to manage it by your own considering more events generated by [SlideEvent](../../Reference/Tools/Slides/SlideEvent.md).

However, in practice reports are usually linear and do not require to repeat all animations again.

### Append graphics on slide
[Meta-markers](../../../../interpreter/Advanced/meta-markers.md) can work well in a case if one wants to append some data on the existing graphics canvas.



## Buttons, sliders etc
:::caution
To be written. Check shipped examples (`File`$\rightarrow$ `Open Examples`) for that.
In principle just follow [Dynamics](../../Tutorial/Dynamics.md) tutorial
:::

