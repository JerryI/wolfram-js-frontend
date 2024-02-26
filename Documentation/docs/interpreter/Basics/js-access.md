---
sidebar_position: 3
---
# Javascript integration

For deep overview of functions, containers and advanced control of evaluation process, please, see pages [symbols](../Advanced/symbols.md) and [containers](../Advanced/containers.md)

## Reading objects
Let us define some variable on the page

```js
var variable = Array.apply(null, Array(100)).map(function (_, i) {return [i/100.0 - 1, Math.sin(i/6.28)];});
```

or if you want to isolate it as a module (it is better, since it execute the script in the right sequence and prevents the early evaluation of the next included file)

```html
<script type="module">
	window.variable = ...
</script>
```

:::tip
Always put your scripts into `<script type="module">` tag, since it guarantees that the sequence of executing of those scripts (as they appear in HTML document) will be preserved
:::

All functions of WLJS intepreter must return a javascript primitive data type, therefore it is possible to assign it to a WL symbol directly using `WindowScope`

```mathematica
v = WindowScope["variable"];
```

Then we can plot this array as if it was a `List` 

```mathematica
FrontEndVirtual[{ 
	(* attach a dom element to draw *)
    AttachDOM["canvas"],
    (* our graphics *)
    Graphics[{RGBColor[1.0,1.0,0], Line[v]}, ImageSize->{400,200}] 
}] 
```

import Sandbox from '@site/src/components/sandbox';

<Sandbox code="('wls!'v%20%3D%20%2B%5BZ%24Z%5D%3BNv%2F%2FPrint%3BN%7B*qbe%20ableqanimate%20we%20need%20a%20container%25N%23%5B(%20N%5Ct%7B*%20attach%20a%20dom%20elementqdraw%259AttachDOM%5BZcanvasZ%5D%2C9%7B*%20our%20gX%259GX%5B(PointSize%5B0.05%5DK9QRGBColor%5B1.0%2C1.0%2C0%5D%2C9QLine%5Bv%5DQ9)KZYZ-%3E400KImageSize-%3E(500%2C100)%5D%20N)%5D%3B%20NN'~js!'window.%24%20%3D%20Array.apply%7BnullKArray%7B100%7D%7D.map%7Bfunction%20%7B_Ki%7D%20(return%20%5Bi%2F100.0%20-%201KMath.sin%7Bi%2F6.28%7D%5D%3B)%7D%3B'~includes!%5B'https%3A%2F%2Fcdn.jsdelivr.net%2Fgh%2FJerryI%2Fwljs-gX-d3%40latest%2Fdist%2Fkernel.js'%5D~compiled!%5B'Hold'7CompoundExpression'7Set'~v'7%2B'~%22%24%22'U7Print'~v'%5D7%23%267AttachDOM'~%22canvas%22'%5D7GX%267PointSize'%2C0.05%5D7RGBColor'%2C1%2C1%2C0%5D7Line'~v'U7Rule'~%22Y%22'%2C400%5D7Rule'~ImageSize%26%2C500%2C100UU%5D%2CnullU)7%2C%5B'9NQQK%2C%20N%5CnQ%20%20U%5D%5DXraphicsYTransitionDurationZ%5C'q%20to%20%23FrontEndVirtual%24variable%25%20*%7D%26'7List'%2BWindowScope%01%2B%26%25%24%23qZYXUQNK97_">Sinewave</Sandbox>

## Calling functions
In principle in the this manner the whole WLJS interpeter including all libraries was made. Anything even simple like `List`, `Times` are Javascript functions defined as

```js
core.Function = async (args, env) => {
	//executing arguments
	const arg1 = await interpretate(args[0], copy);
	const arg2 = await interpretate(args[1], copy);
	//...
	//computing something

    //return the result
	return result;
};
```

:::tip
Please, see [Advanced](../Advanced) section for more information about it
:::

🎡  Let us show you a fancy example. 
<details>

This is an adaptation of [@valnub](https://github.com/valnub/particle-animation-javascript/tree/master) animation.
Here is a Javascript function, that creates a bunch of rectangles and animate them according to their speed and position

```js
const canvas = document.createElement('canvas');
canvas.width = 600;
canvas.height = 400;
const context = canvas.getContext('2d');
const particles = [];

function random (min, max) {
  return Math.random() * (max - min) + min;
}

//function definition 
core.Draw = async (args, env) => {
  //position
  const c = await interpretate(args[0], env);
  //velocity
  const v = await interpretate(args[1], env);
  
  const particle = {
    x: c[0],
    y: c[1],
    xvel: v[0],
    yvel: v[1],
    color: `rgba(${random(0, 255)}, ${random(0, 255)}, ${random(0, 255)})`,
    size: 7,
  };
  
  particles.push(particle);
  if (particles.length > 200) {
    particles.shift();
  }
  
  context.clearRect(0, 0, canvas.width, canvas.height);
  for (let i = 0; i < particles.length; i += 1){
    const p = particles[i];
    context.fillStyle = p.color;
    context.fillRect(p.x, p.y, p.size, p.size);
    p.x += p.xvel;
    p.y -= p.yvel;  
  }
};

return canvas;
```

This __code is applicable for [WLJS Playground](../intro.md) (see *Quick start*)__, if you want to run it in a custom environment, you would need to put in inside a module and replace the last line with

```html
<script type="module">
...
//return canvas;
document.body.appendChild(canvas);
</script>
```

Then we can run WL script and call it directly

```mathematica
While[True,
  Draw[{RandomReal[{0,600}],RandomReal[{0,400}]},  RandomReal[{2,-2},2]];
  Pause[0.05]; 
] 
```

WLJS interpreter looks for the particular name `Draw` in the `core` context and pass evaluated arguments to it

</details>

<Sandbox code="('wls!'While%5BTrue%2C3Draw%5B(34X0%2C600)U34X0%2C100)%5D%2034)%2CX2%2C-2)%2C2%5D3%5D%3B3Pause%5B0.05%5D%3B%209%5D%209'~js!'JQ8document.createElement%7B%22Q%22K9Q.width8600ZQ.height8100ZJc%5E8Q.getC%5E%7B%222d%22K9JIs8%5B%5DZ9function%20r%7C_minBmaxk(3return%20Math.r%7C%7Bk*_max%20-%20mink%2B%20minZ)9%209%2F*%20visualization%20by%20%40valnub4*%2F9%26%20see%20https%3A%26github.com%2Fvalnub%2FI-animation-javascript%2Ftree%2Fmaster99Jdraw8async_argsBenvk%3D%3E%20(3JcV0%5DBenvK3JvV1%5DBenvK33JI8(34xYc%5B0U34yYc%5B1U34xvelYv%5B0U34yvelYv%5B1U34colorY%60rgba%7BNBNBN%7D%60%2C34sizeY7%2C3)Z3Is.push%7BIK93if_Is.length%20%3E%2020k(34Is.shift%7BK3)3c%5E.clearRect%7B0B0BQ.widthBQ.heightK93for_let%20i80%7F%3C%20Is.length%7F%2B%251%7D(34Jp8Is%5Bi%5D%23Style8p.color%23Rect%7Bp.xBp.yBp.sizeBp.sizeK34p.x%20%2B%25p.xvel%3B34p.y%20-%25p.yvel%3B49343)93%26window.requestAnimationFrame%7BdrawK9)Z9core.Draw8drawZ9%26draw%7BK99return%20QZ999'~includes!%5B''%5D~compiled!%5B'Hold'OWhile'%2CtrueOCompoundExpression'ODraw'OList'G0%2C600%3FG0%2C100%3F%5DG2%2C-2U2%3FOPause'%2C0.05Unull%3F%5D)3944%20%208%20%259%5CnB%2C%20GOR%7CReal'OList'%2CIparticleJconst%20K%7D%3BN%24(r%7C%7B0B255%7D)O%2C%5B'QcanvasU%5D%2CV8await%20interpretate%7Bargs%5BX4R%7CReal%5B(Y%3A%20Z%3B9_%20%7Bk%7D%20%23%3B34c%5E.fill%25%3D%20%26%2F%2F%3F%5D%5D%5Eontext%7Candom%7F%3B%20i%20%01%7F%7C%5E%3F%26%25%23k_ZYXVUQONKJIGB9843_">Particles</Sandbox>

🎡  One can go event further and plot something more interesting

<details>

```mathematica
x = 0;
y = 0;

While[True, 
  Draw[{x, y},  RandomReal[{2,-2},2]];
  y = 49 (1 + Sin[x/(10)]);    
  x = x + 1;   
  If[x > 599, x = 0];
  Pause[0.01]; 
] 
```

</details>


<Sandbox code="('wls!'x80ky80kJWhile%5BTrueN3Draw%5B(xNy)%2CKRandomReal%5B(2%2C-2)%2C2X%3B3y849%251%7C%20Sin%5Bx%2F%7B10%7D%5DQKK3x8x%7C%201%3BK%203If%5Bx%20%3E%20599Nx80%5D%3B3Pause%5B0.01%5D%3B%20J%5D%20J'~js!'UY8document.createElement%7B%22Y%22QJY.width8600kY.height8100kUcontext8Y.getContext%7B%222d%22QJUOs8%5B%5DkJfunction%20random%25minNmax%7D%20(3return%20Math.random%7B%7D%20*%25max%20-%20min%7D%7C%20mink)J%20J%2F*%20visualization%20by%20%40valnubK*%2FJ%2F%2F%20see%20https%3A%2F%2Fgithub.com%2Fvalnub%2FO-animation-javascript%2Ftree%2FmasterJJUdraw8async%25argsNenv%7D%20%3D%3E%20(3Uc_0%5DNenvQ3Uv_1%5DNenvQ33UO8(3Kx%3Fc%5B0%263Ky%3Fc%5B1%263Kxvel%3Fv%5B0%263Kyvel%3Fv%5B1%263Kcolor%3F%60rgba%7BVNVNV%7D%60%2C3Ksize%3F7%2C3)k3Os.push%7BOQJ3if%25Os.length%20%3E%2020%7D%20(3KOs.shift%7BQ3)3context.clearRect%7B0N0NY.widthNY.heightQJ3for%25let%20i80%3B%20i%20%3C%20Os.length%3B%20i%7C%7F1%7D(3KUp8Os%5Bi%5D%5EStyle8p.color%5ERect%7Bp.xNp.yNp.sizeNp.sizeQ3Kp.x%7C%7Fp.xvel%3B3Kp.y%20-%7Fp.yvel%3BKJ3K3)J3%2F%2Fwindow.requestAnimationFrame%7BdrawQJ)kJcore.Draw8drawkJ%2F%2Fdraw%7BQJJreturn%20YkJJJ'~includes!%5B''%5D~compiled!%5B'Hold'%23Set'~xZ0%5DBSet'~yZ0%5DBWhileZtrue%23Draw'BList'~x'~y'%5DBRandomReal'BListZ2%2C-2%262XBSet'~y'BTimesZ49BPlusZ1BSin'BTimes'~x'BPowerZ10%2C-1XXXBSet'~x'BPlus'~xZ1XBIf'BGreater'~xZ599%5DBSet'~xZ0XBPauseZ0.01%26nullXX)3JK8%20%7FB%2C%5B'J%5CnK%20%20N%2C%20OparticleQ%7D%3BUconst%20V%24(random%7B0N255%7D)X%5D%5DYcanvasZ'%2C_8await%20interpretate%7Bargs%5Bk%3BJ%23BCompoundExpression'B%25%20%7B%26%5D%2C%3F%3A%20%5E%3B3Kcontext.fill%7C%20%2B%7F%3D%20%01%7F%7C%5E%3F%26%25%23k_ZYXVUQONKJB83_">Heavy sine animation</Sandbox>

🎡 Or we can also change the way how it is drawn to

<details>

```mathematica
data = Table[{i, 15 + 30 (1 + Sin[i/(20)])}, {i, 1, 599,10}];
 
While[True,
  Table[
    Draw[i,  RandomReal[{0.1,-0.1},2]];
  , {i, data}];   
  Pause[0.02];   
];
```

</details>

<Sandbox code="('wls!'dataITable%5B(iG15%7F30Z1%7FSin%5Bi%2F%7B20%7D%5D%7D)G(iG1G599%2C10)%5DO%20BWhile%5BTrue%2C4Table%5B4JDraw%5BiG%20RandomReal%5B(0.1%2C-0.1)%2C2U%3B4G(iGdata)%5D%3BJ%204Pause%5B0.02%5D%3BJ%20B%5DOBBB'~js!'NXIdocument.createElement%7B%22X%22%7DOX.widthI600OX.heightI100ONcontextIX.getContext%7B%222d%22%7DONKsI%5B%5DOBfunction%20randomZminGmax%5E(4return%20Math.random%7B%5E*Zmax%20-%20min%7D%7FminO)B%20B%2F*%20visualization%20by%20%40valnubJ*%2FB%7C%20see%20https%3A%7Cgithub.com%2Fvalnub%2FK-animation-javascript%2Ftree%2FmasterBBNdrawIasyncZargsGenv%5E%3D%3E%20(4NcY0%5DGenv%7DO4NvY1%5DGenv%7D%3B44NKI(4Jxkc%5B0_4Jykc%5B1_4Jxvelkv%5B0_4Jyvelkv%5B1_4Jcolork%60rgba%7BQGQGQ%7D%60%2C4Jsizek7%2C4)O4Ks.push%7BK%7DO4ifZKs.length%20%3E%20200%5E(4JKs.shift%7B%7D%3B4)4context.clearRect%7B0G0GX.widthGX.height%7DO4forZlet%20iI0%3B%20i%20%3C%20Ks.length%3B%20i%25%3F1%7D(4JNpIKs%5Bi%5D%23StyleIp.color%23Rect%7Bp.xGp.yGp.sizeGp.size%7D%3B4Jp.x%25%3Fp.xvel%3B4Jp.y%20-%3Fp.yvel%3BJB4J4)B4%7Cwindow.requestAnimationFrame%7Bdraw%7DO)OBcore.DrawIdrawOB%7Cdraw%7B%7DOBreturn%20XOBBB'~includes!%5B''%5D~compiled!%5B'Hold'VSet'~data'8Table'%268Plus'%2C158Times'%2C308Plus'%2C18Sin'8Times'~i'8Power'%2C20%2C-1UUU%5D%26%2C1%2C599%2C10U%5D8While'%2CtrueVTable'VDraw'~i'8RandomReal'8List'%2C0.1%2C-0.1_2U%2Cnull%5D%26~data'U8Pause'%2C0.02_nullU%2CnullU)4BJ8%2C%5B'B%5CnG%2C%20I%20%3FJ%20%20KparticleNconst%20O%3BBQ%24(random%7B0G255%7D)U%5D%5DV8CompoundExpression'8XcanvasYIawait%20interpretate%7Bargs%5BZ%20%7B_%5D%2Ck%3A%20%23%3B4Jcontext.fill%7F%2B%268List'~i'%3F%3D%20%5E%7D%20%7C%2F%2F%7F%25%20%01%7F%7C%5E%3F%26%25%23k_ZYXVUQONKJIGB84_">200 particles</Sandbox>



## Event-based approach
:::caution
This section is in development
:::