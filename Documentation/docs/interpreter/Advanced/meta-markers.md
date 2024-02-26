---
sidebar_position: 4
---
# Meta markers
You can think about them as a unique property assigned to the expression in order to use selectors on them. Sometimes it comes handy to attach or evaluate new object inside the existing instance

```mathematica
FrontEndVirtual[{
	(* attach a dom element to draw *)
    AttachDOM["canvas"], 
    (* mark this instance by uid *)
    Graphics[{PointSize[0.02], MetaMarker["plot"]}] 
}]; 
```

Here we marked this instance and `{}` scope with `plot` marker. Then, one can evaluate an arbitrary function on the place of this marker using `FrontSubmit` expression

```mathematica
FrontSubmit[Point[RandomReal[{- 1,1}, 2]], MetaMarker["plot"]]
```

Then, a point will appear on the corresponding place. Repeating this process over and over we can populate with any graphical object our existing plot even with dynamic binding.

### 🎡 Example
Lets draw some random lines, where each line has a dynamic variable, that specifies the beginning, while the end will be a random fixed value

<details>

```mathematica
(* to be able to animate we need a container *)
FrontEndVirtual[{
	(* attach a dom element to draw *)
    AttachDOM["canvas"], 
    (* mark this instance by uid *)
    Graphics[{PointSize[0.02], MetaMarker["plot"]}] 
}];     

j = 0; 
(* now we can directly inject new points into already existing object *)
last = {0,0};

While[j < 300,         
 With[{try = RandomReal[{- 1,1}, 2]},    
  FrontSubmit[{
    RGBColor[RandomSample[{{1,0,0}, {0,1,1}, {1,0,1}}]//First],    
    Line[{last, try}]
  }, MetaMarker["plot"]];  
 
  last = try;  
 ];   
  
 Pause[0.5];
 j = j + 1;
]; 
```

As one can see, an expression inside `Placed` will be evaluated inside the instance found by the meta-marker. `last` variable is global, therefore it causes a dynamic update of all added lines.

</details>

This will lead to the following results

import Sandbox from '@site/src/components/sandbox';

<Sandbox code="('wls!'%25to%20be%20able%20to%20animate%20we%20need%20a%20containerf%26%5B(7%5Ct%25attach%20a%20dom%20element%20to%20drawf66AttachDOM%5B%5C'canvas%5C'qY66%25mark%20this%20instance%20by%20uidf66G%5E%5B(PointSize%5B0.02q%20Z)%5DY)%2466Y7jN0%3BY%25now%20we%20can%20directly%20inject%20new%20points%20into%20already%20existing%20objectfmTNFindZ%60%3B7lastN(0_)%3B77While%5Bj%20%3C%20500%2C6666Y%20With%5B(tryN%3FReal%5B(-%201X)%3E2%5D)%2C66Y6Placed%5B(766RGBColor%5B%3FSample%5B(%20(0XX)%3E(1_X))%5D%60q66766Line%5B(last%3Etry)%5DY6)%3EmT%2467Y6lastNtry%3B67%20%246Y67%20Pause%5B1%247%20jNj%20%2B%201%3B7%24Y%20'~js!''~includes!%5B'9g%5E-d3%7Fdist%2Fkernel.js'~9interpreter%7Fsrc%2FmetamTs.js'%5D~compiled!%5B'Hold'Q%26'K4AttachDOM'~%22canvas%22'%5D4G%5E'K4PointSize'_.02%5D4%238Uj'_UmT'4First'4Find%23Ulast'K__84While'4Less'~j'%2C500%5DQWith'K4Se%7C4%3FReal'K%2C-1Xq28%5DQPlaced'K4RGBColor'4First'4%3FSample'KK_XX%5DKX_X88%5D4Line'K~las%7C8%5D~mT'Ulas%7Cqnull84Pause'XUj'4Plus'~j'X8%2Cnull8%2Cnull8)4%2C%5B'6%20Y%5Cn8%5D%5D9https%3A%2F%2Fcdn.jsdelivr.net%2Fgh%2FJerryI%2Fwljs-K4List'N%20%3D%20Q4CompoundExpression'4TarkerU%5D4Set'~X%2C1Y%207ZMetaMT%5B%5C'plot%5C'%5D_%2C0f%20*%7D7q%5D%2C%23MetaMT'~%22plot%22'8%24%5D%3B%25%7B*%20%26FrontEndVirtual%3E%2C%20%3FRandom%5Eraphics%60%2F%2FFirst%7Ct'~try'%7F%40main%2F%01%7F%7C%60%5E%3F%3E%26%25%24%23qf_ZYXUTQNK98764_" height="500">Metaexample</Sandbox>


