(* ::Package:: *)

(* default paths *)
JerryI`WolframJSFrontend`root           = ParentDirectory[DirectoryName[$InputFileName // AbsoluteFileName]]
Print[JerryI`WolframJSFrontend`root ];
JerryI`WolframJSFrontend`public         = FileNameJoin[{JerryI`WolframJSFrontend`root, "public"}]
JerryI`WolframJSFrontend`defaultvault   = If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], FileNameJoin[{JerryI`WolframJSFrontend`root, "Examples"}]]

JerryI`WolframJSFrontend`$PublicDirectory = Directory[]

JerryI`WolframJSFrontend`WSKernelAddr = "127.0.0.1"

Once[If[PacletFind["KirillBelov/Objects"] === {}, PacletInstall["KirillBelov/Objects"]]]; 
<<KirillBelov`Objects`;

Get[FileNameJoin[{JerryI`WolframJSFrontend`root, "Services","CSocketListener", "Kernel", "CSocketListener.wl"}]]

(*Once[If[PacletFind["KirillBelov/TCPServer"] === {}, PacletInstall["KirillBelov/TCPServer"]]]; 
<<KirillBelov`TCPServer`;*)
Get["https://raw.githubusercontent.com/KirillBelovTest/TCPServer/main/Kernel/TCPServer.wl"]

Once[If[PacletFind["KirillBelov/Internal"] === {}, PacletInstall["KirillBelov/Internal"]]]; 
<<KirillBelov`Internal`;

(* did not update yet *)
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/WSP.wl"]

(*Once[If[PacletFind["KirillBelov/HTTPHandler"] === {}, PacletInstall["KirillBelov/HTTPHandler"]]]; 
<<KirillBelov`HTTPHandler`;*)
Get["https://raw.githubusercontent.com/KirillBelovTest/HTTPHandler/main/Kernel/HTTPHandler.wl"]
Get["https://raw.githubusercontent.com/KirillBelovTest/HTTPHandler/main/Kernel/Extensions.wl"]

Once[If[PacletFind["KirillBelov/WebSocketHandler"] === {}, PacletInstall["KirillBelov/WebSocketHandler"]]]; 
<<KirillBelov`WebSocketHandler`;


Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/PageModule.wl"]
Get["https://raw.githubusercontent.com/JerryI/wl-misc/main/Kernel/Events.wl"]

Get[FileNameJoin[{JerryI`WolframJSFrontend`root, "Services","JTP", "JTP.wl"}]]

SetMIMETable[
    <|
  "ai"->"application/postscript",
  "aif"->"audio/x-aiff", 
  "aifc"->"audio/x-aiff",
  "aiff"->"audio/x-aiff",
  "asc"->"text/plain",
  "asf"->"video/x-ms-asf",
  "asp"->"text/asp",
  "asx"->"video/x-ms-asf",
  "au"->"audio/basic",
  "avi"->"video/avi",
  "bmp"->"image/bmp",
  "bsp"->"text/html",
  "btf"->"image/prs.btif",
  "btif"->"image/prs.btif",
  "c"->"text/plain",
  "cc"->"text/plain",
  "cgm"->"image/cgm",
  "cpp"->"text/plain",
  "css"->"text/css",
  "dcr"->"application/x-director",
  "der"->"application/x-x509-ca-cert",
  "doc"->"application/msword",
  "docm"->"application/vnd.ms-word.document.macroenabled.12",
  "docx"->"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  "dot"->"application/msword",
  "dotm"->"application/vnd.ms-word.template.macroenabled.12",
  "dotx"->"application/vnd.openxmlformats-officedocument.wordprocessingml.template",
  "dtd"->"text/xml",
  "dvi"->"application/x-dvi",
  "eps"->"application/postscript",
  "fpx"->"image/vnd.fpx",
  "gif"->"image/gif",
  "gz"->"application/x-gzip",
  "h"->"text/plain",
  "hh"->"text/plain",
  "hlp"->"application/winhelp",
  "hpp"->"text/plain",
  "htm"->"text/html",
  "html"->"text/html",
  "ico"->"image/ico",
  "ics"->"text/calendar",
  "ief"->"image/ief",
  "iges"->"model/iges",
  "igs"->"model/iges",
  "ini"->"text/plain",
  "jar"->"application/java-archive",
  "jpe"->"image/jpeg",
  "jpeg"->"image/jpeg",
  "jpg"->"image/jpeg",
  "js"->"application/x-javascript",
  "jsp"->"text/html",
  "latex"->"application/x-latex",
  "mesh"->"model/mesh",
  "mid"->"audio/mid",
  "midi"->"audio/mid",
  "mif"->"application/mif",
  "mov"->"video/quicktime",
  "mp3"->"audio/mpeg",
  "mpe"->"video/mpeg",
  "mpeg"->"video/mpeg",
  "mpf"->"text/vnd.ms-mediapackage",
  "mpg"->"video/mpeg",
  "mpp"->"application/vnd.ms-project",
  "mpx"->"application/vnd.ms-project",
  "msh"->"model/mesh",
  "oda"->"application/oda",
  "p7m"->"application/pkcs7-mime",
  "p7s"->"application/pkcs7-signature",
  "pdf"->"application/pdf",
  "pl"->"application/x-perl",
  "png"->"image/png",
  "potm"->"application/vnd.ms-powerpoint.template.macroenabled.12",
  "potx"->"application/vnd.openxmlformats-officedocument.presentationml.template",
  "ppa"->"application/vnd.ms-powerpoint",
  "ppam"->"application/vnd.ms-powerpoint.addin.macroenabled.12",
  "pps"->"application/vnd.ms-powerpoint",
  "ppsm"->"application/vnd.ms-powerpoint.slideshow.macroenabled.12",
  "ppsx"->"application/vnd.openxmlformats-officedocument.presentationml.slideshow",
  "ppt"->"application/vnd.ms-powerpoint",
  "pptm"->"application/vnd.ms-powerpoint.presentation.macroenabled.12",
  "pptx"->"application/vnd.openxmlformats-officedocument.presentationml.presentation",
  "ppz"->"application/vnd.ms-powerpoint",
  "ps"->"application/postscript",
  "qt"->"video/quicktime",
  "ra"->"audio/x-pn-realaudio",
  "ram"->"audio/x-pn-realaudio",
  "rgb"->"image/x-rgb",
  "rm"->"audio/x-pn-realaudio",
  "rtf"->"application/rtf",
  "rtx"->"text/richtext",
  "sap"->"application/x-sapshortcut",
  "scm"->"application/x-screencam",
  "silo"->"model/mesh",
  "sim"->"application/vnd.sap_kw.itutor",
  "sit"->"application/x-stuffit",
  "sl"->"text/vnd.wap.sl",
  "snd"->"audio/basic",
  "spl"->"application/x-futuresplash",
  "svg"->"image/svg+xml",
  "swa"->"application/x-director",
  "swf"->"application/x-shockwave-flash",
  "tar"->"application/x-tar",
  "tex"->"application/x-tex",
  "tht"->"text/thtml",
  "thtm"->"text/thtml",
  "thtml"->"text/thtml",
  "tif"->"image/tiff",
  "tiff"->"image/tiff",
  "tsf"->"application/vnd.ms-excel",
  "txt"->"text/plain",
  "vcf"->"text/x-vcard",
  "vcs"->"text/x-vcalendar",
  "vdo"->"video/vdo",
  "viv"->"video/vnd.vivo",
  "vrml"->"model/vrml",
  "vsd"->"application/vnd.visio",
  "wav"->"audio/x-wav",
  "wbmp"->"text/vnd.wap.wbmp",
  "wmf"->"application/x-msmetafile",
  "wml"->"text/vnd.wap.wml",
  "wmls"->"text/vnd.wap.wmlscript",
  "wp5"->"application/wordperfect5.1",
  "wrl"->"model/vrml",
  "xap"->"application/x-silverlight-app",
  "xbm"->"image/x-xbitmap",
  "xif"->"image/vnd.xiff",
  "xlam"->"application/vnd.ms-excel.addin.macroenabled.12",
  "xls"->"application/vnd.ms-excel",
  "xlsb"->"application/vnd.ms-excel.sheet.binary.macroenabled.12",
  "xlsm"->"application/vnd.ms-excel.sheet.macroenabled.12",
  "xlsx"->"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  "xltm"->"application/vnd.ms-excel.template.macroenabled.12",
  "xltx"->"application/vnd.openxmlformats-officedocument.spreadsheetml.template",
  "xml"->"text/xml",
  "xsd"->"text/xml",
  "xsl"->"text/xml",
  "zip"->"application/x-zip-compressed",
  "wsp"->"text/html"
|>

]
