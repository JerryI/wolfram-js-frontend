# CSocketListener

Compiled for Linux, MacOSX only (Windows soon!).
relies on [libuv](https://github.com/libuv/libuv)

## Examples
### Echo
```shell
wolframscript -f Tests/Basic.wls
```

### Single page
```shell
wolframscript -f Tests/Simple.wls
```

### Dynamic app (involves websockets)
```shell
wolframscript -f Tests/Full.wls
```

## Building
In the `LibraryResurces` we placed all prebuild binaries.
__Skip this section if you want just to run this package__

If there are some issues with a shipped binaries, one can try to compile it.
In general it relies on `libuv`, that has to be crossplatform, however there are some differences in the recipy
### MacOS
no configuring is required
```
brew install libuv
wolframscript -f Scripts/BuildLibrary.wls
```
### Linux
One has to build `libuv` first following [the instructions](https://github.com/libuv/libuv). 
Once you have your `libuv.so` file, place it somewhere and change the line
```mathematica
OSLinker = If[$OperatingSystem === "Windows", {}, If[$OperatingSystem === "MacOSX", {"/usr/local/lib/libuv.a -pthread"}, {"/PATHTOLIBUVSRC/build/libuv.so -pthread"}]]
```
i.e. this line
```
/PATHTOLIBUVSRC/build/libuv.so
```
to the correct path in your system. Then you are ready to build

```
wolframscript -f Scripts/BuildLibrary.wls
```

### Windows
MinGW fails to build the binaries, one has to install Visual Studio Compiler
We do not know...