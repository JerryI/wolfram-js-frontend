Option Explicit

Function Base64Encode(sText)
    Dim oXML, oNode

    Set oXML = CreateObject("Msxml2.DOMDocument.3.0")
    Set oNode = oXML.CreateElement("base64")
    oNode.dataType = "bin.base64"
    oNode.nodeTypedValue = Stream_StringToBinary(sText)
    Base64Encode = oNode.text
    Set oNode = Nothing
    Set oXML = Nothing
End Function

Function Stream_StringToBinary(Text)
  Const adTypeText = 2
  Const adTypeBinary = 1

  'Create Stream object
  Dim BinaryStream 'As New Stream
  Set BinaryStream = CreateObject("ADODB.Stream")

  'Specify stream type - we want To save text/string data.
  BinaryStream.Type = adTypeText

  'Specify charset For the source text (unicode) data.
  BinaryStream.CharSet = "us-ascii"

  'Open the stream And write text/string data To the object
  BinaryStream.Open
  BinaryStream.WriteText Text

  'Change stream type To binary
  BinaryStream.Position = 0
  BinaryStream.Type = adTypeBinary

  'Ignore first two bytes - sign of
  BinaryStream.Position = 0

  'Open the stream And get binary data from the object
  Stream_StringToBinary = BinaryStream.Read

  Set BinaryStream = Nothing
End Function

Dim box, i, proccessedText, base64EncodedString
box = InputBox(Wscript.Arguments.Item(1), Wscript.Arguments.Item(0), Wscript.Arguments.Item(2))
proccessedText = ""

For i = 1 To Len(box)
    Dim currentChar, charCode
    currentChar = Mid(box, i, 1)
    charCode = Asc(currentChar)
    
    ' Check if the current character is a special character (not a printable ASCII character)
    If charCode < 32 Or charCode > 126 Then
        proccessedText = proccessedText & "\" & charCode & "\"
    ElseIf currentChar = "\" Then
        proccessedText = proccessedText & "/\"
    Else
        proccessedText = proccessedText & currentChar
    End If
Next
base64EncodedString = Base64Encode(proccessedText)
Wscript.Echo "RETURN" & base64EncodedString
