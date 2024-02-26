---
sidebar_position: 4
---
# Working with graphics

## Easy animations
Since [wljs-graphics-d3](https://github.com/JerryI/wljs-graphics-d3) provides transitions on update, it is extremely easy to make some complicated animations

```mathematica
data = RandomReal[{-1,1}, {400,2}];

FrontEndVirtual[{
    AttachDOM["canvas"];
    Graphics[{RGBColor[1.0,0.,0.5], Point[data]}, "TransitionDuration"->0];
}]; 
 
Table[
  data = (1 - t) RandomReal[{-1,1}, {400,2}] 
            + t Table[{Sin[3i], Cos[2i]}, {i, 0, 6.28, 6.28/400}];
            
  Pause[0.1]; 
, {t, 0, 1, 0.025}]; 
```

Each time we update `data` variable, the transition between frames happends automatically based on selected `TransitionDuration`

import Sandbox from '@site/src/components/sandbox';

<Sandbox code="('wls!'%3CZYQQ%24%5B(Q77AttachDOM%5B%5C'canvas%5C'YQ77G%26%5B(RGBColor%5B1.q0.%2C0.5%5DKPoint%5Bdata%5D)K%5C'%23%5C'-%3E0YQ)Y%20QQWhile%5BTrue%2CQTable%5BQ7%3C%20%7B1%20-%20t%7DZ%5D%20Q777777%2B%20t%20Table%5B(Sin%5B3i%5DKCos%5B2i%5D)K(iK0K6.28K6.28%2F400)YQ777777Q7Pause%5B0.1Y%20QK(tK0K1K0.025)Y%20QQPause%5B2Y%20QQYQ'~js!''~includes!%5B'https%3A%2F%2Fcdn.jsdelivr.net%2Fgh%2FJerryI%2Fwljs-g%26-d3%40latest%2Fdist%2Fkernel.js'~.%2Fcurves.js'%5D~compiled!%5B'Hold'NSe%25U%24'_'NAttachDOM'~%22canvas%22'%5D*G%26'_'*RGBColorX1%2Cq0.5%5D*Poin%259*Rule'~%22%23%22X09z9%5D*WhileXtrueNTable'NSe%25*Plus'*f'*PlusX1*fX-1~t'9Uf'~t'*Table'_'*Sin'*fX3~i'9*Cos'*fX2~i'9%5D_'~iXq6.28*fX6.28*PowerX40q-1999%5D*PauseX0.1%5Dz%5D_'~tXq1%2C0.0259*PauseX2%5Dz9z9)*%2C%5B'7%20%209%5D%5DK%2C%20N*CompoundExpression'*Q%5CnU*%3F'_X-1%2C1%5D_X40q29%5D*X'%2CY%5D%3BZ%20%3F%5B(-1%2C1)K(40q2)_*ListfTimesq0%2Cz%2Cnull%23TransitionDuration%24FrontEndVirtual%25t'~data'%26raphics%3Cdata%20%3D%3FRandomReal%01%3F%3C%26%25%24%23zqf_ZYXUQNK97*_" height="500">Ease</Sandbox>