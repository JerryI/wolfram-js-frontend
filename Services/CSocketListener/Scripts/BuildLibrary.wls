#!/usr/bin/env wolframscript
(* ::Package:: *)




Get["CCompilerDriver`"]; 

(*$CCompiler={"Compiler"->GenericCCompiler,
 "CompilerInstallation"->"C:\\mingw64\\bin",
 "CompilerName"->"gcc.exe",
 "ShellOutputFunction"->Print}*)

OSFolder = If[$OperatingSystem === "Windows", "Windows", "Unix"];
OSLibs = If[$OperatingSystem === "Windows", {"ws2_32"}, {}];

OSLinker = If[$OperatingSystem === "Windows", {"ws2_32"}, {"/usr/local/lib/libuv.a -pthread"}];

Block[{$directory, $libSrc, $libDir}, 
	$directory = DirectoryName[If[$InputFileName == "", 
		NotebookFileName[], 
		$InputFileName
	], 2]; 


	$libSrc = File[FileNameJoin[{
		$directory, 
		"Source", 
		OSFolder,
		"socket_listener.c"
	}]]; 


	$libDir = FileNameJoin[{
		$directory, 
		"LibraryResources", 
		$SystemID
	}]; 


	If[!FileExistsQ[$libDir], CreateDirectory[]];


	Get["CCompilerDriver`"]; 

	CreateLibrary[$libSrc, "socket_listener" , "TargetDirectory" -> $libDir, "Debug"->True, "LinkerOptions"->OSLinker,	"Libraries"->OSLibs]
]; 
