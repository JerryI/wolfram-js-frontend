#!/usr/bin/env wolframscript
(* ::Package:: *)




Get["CCompilerDriver`"]; 

(*$CCompiler={"Compiler"->GenericCCompiler,
 "CompilerInstallation"->"C:\\mingw64\\bin",
 "CompilerName"->"gcc.exe",
 "ShellOutputFunction"->Print}*)

Block[{$directory, $libSrc, $libDir}, 
	$directory = DirectoryName[If[$InputFileName == "", 
		NotebookFileName[], 
		$InputFileName
	], 2]; 


	$libSrc = File[FileNameJoin[{
		$directory, 
		"Source", 
		"socket_listener.c"
	}]]; 


	$libDir = FileNameJoin[{
		$directory, 
		"LibraryResources", 
		$SystemID
	}]; 


	If[!FileExistsQ[$libDir], CreateDirectory[]];


	Get["CCompilerDriver`"]; 

	
	CreateLibrary[$libSrc, "socket_listener", "TargetDirectory" -> $libDir, "Debug"->True, 	"Libraries"->If[$OperatingSystem === "Windows", {"ws2_32"}, {}]]; 
]; 
