BeginPackage["JerryI`WolframJSFrontend`Colors`"];

Unprotect[RGBColor]
Unprotect[GrayLevel]

StringJoin[Reset, str__]    ^:= StringJoin["\033[1;0m", str]
StringJoin[Black, str__]    ^:= StringJoin["\033[1;30m", str]
StringJoin[Red, str__]      ^:= StringJoin["\033[1;31m", str]
StringJoin[Green, str__]    ^:= StringJoin["\033[1;32m", str]
StringJoin[Yellow, str__]   ^:= StringJoin["\033[1;33m", str]
StringJoin[Blue, str__]     ^:= StringJoin["\033[1;34m", str]
StringJoin[Magenta, str__]  ^:= StringJoin["\033[1;35m", str]

ToString[Reset]    ^:= "\033[1;0m"
ToString[Black]    ^:= "\033[1;30m"
ToString[Red]      ^:= "\033[1;31m"
ToString[Green]    ^:= "\033[1;32m"
ToString[Yellow]   ^:= "\033[1;33m"
ToString[Blue]     ^:= "\033[1;34m"
ToString[Magenta]  ^:= "\033[1;35m"

Print[Reset]    ^:= Print@"\033[1;0m"
Print[Black]    ^:= Print@"\033[1;30m"
Print[Red]      ^:= Print@"\033[1;31m"
Print[Green]    ^:= Print@"\033[1;32m"
Print[Yellow]   ^:= Print@"\033[1;33m"
Print[Blue]     ^:= Print@"\033[1;34m"
Print[Magenta]  ^:= Print@"\033[1;35m"

EndPackage[];