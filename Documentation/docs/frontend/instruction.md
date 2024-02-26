---
sidebar_position: 1
enableComments: true
sidebar_class_name: green
---
# Quick start
Wolfram Language Notebook __requires  `wolframscript` (see Freeware [Wolfram Engine](https://www.wolfram.com/engine/) or Wolfram Kernel)__ installed on your PC/Mac. This application will check all paths and ask to locate a Wolfram executable if nothing is found.

:::warning
Works only with Wolfram Engine $\geq$ __13.0.0__. The version __13.0.1__ is more preferable.
:::

There are two ways you can choose from

import Tabs from '@theme/Tabs';  
import TabItem from '@theme/TabItem';

## Desktop application
Notebook interface is shipped as an Electron application, which is cross-platform and has most benefits of a native desktop app. __This is the easiest way__


<Tabs  
defaultValue="x86"  
values={[  
{label: 'x86-x64', value: 'x86'},  
{label: 'M1', value: 'M1'},  
]}>  
<TabItem value="x86">

- [Windows](https://github.com/JerryI/wolfram-js-frontend/releases/download/1.0.7/WLJS.Notebook.Setup.0.7.0.exe)
- [MacOS](https://github.com/JerryI/wolfram-js-frontend/releases/download/1.0.7/WLJS.Notebook-0.7.0-Intel.dmg)
- [Linux (Deb)](https://github.com/JerryI/wolfram-js-frontend/releases/download/1.0.7/wljs-frontend_0.7.0_amd64.deb)
- [Linux (AppImage)](https://github.com/JerryI/wolfram-js-frontend/releases/download/1.0.7/WLJS.Notebook-0.7.0.AppImage)

</TabItem>  
<TabItem value="M1">

- [MacOS](https://github.com/JerryI/wolfram-js-frontend/releases/download/1.0.7/WLJS.Notebook-0.7.2-universal.dmg)

</TabItem>  
</Tabs>

It comes with a launcher, that takes care about all updates, files extension association and etc.
## Server application & web-browser
Since this is a web-based application, you can also run on a server. User interface is  reachable from any modern browser. Clone a master branch and run `wolframscript`

```bash
git clone https://github.com/JerryI/wolfram-js-frontend
cd wolfram-js-frontend
wolframscript -f Scripts/start.wls
```

It will take some time to download all core plugins, after that you can start using it by opening your browser 

```bash
...
Open http://127.0.0.1:20560 in your browser
```
