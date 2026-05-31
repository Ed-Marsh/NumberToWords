B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

#Macro: Title, Export B4XPages, ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainPage")
End Sub

'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Private Sub Button1_Click
	Log(NumberToWords(123.45))
End Sub

' B4X / B4J Number to Words Converter
' Accepts a Double and returns a String in cheque format

Public Sub NumberToWords(Amount As Double) As String
	If Amount = 0 Then Return "Zero Pounds"
    
	Dim IntPart As Long = Floor(Amount)
	Dim CentsPart As Int = Round((Amount - IntPart) * 100)
    
	Dim Words As String = ConvertIntegerToWords(IntPart)
	If Words = "" Then Words = "Zero"
    
	Dim Result As String = Words & (IIf(IntPart = 1, " Pound", " Pounds"))
    
	If CentsPart > 0 Then
		'(IIf(CentsPart = 1, " Pence", " Pence") is no use for sterling but if you are in the USA then it works for Cent / Cents
		Result = Result & " and " & ConvertIntegerToWords(CentsPart) & (IIf(CentsPart = 1, " Pence", " Pence"))
	End If
    
	Return Result
End Sub

Private Sub ConvertIntegerToWords(n As Long) As String
	Dim Units() As String = Array As String("", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen")
	Dim Tens() As String = Array As String("", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety")
	Dim Scales() As String = Array As String("", "Thousand", "Million", "Billion", "Trillion")
    
	If n = 0 Then Return ""
    
	Dim Words As String = ""
	Dim tempInt As Long = n
	Dim scaleIdx As Int = 0
	Dim chunks As List
	chunks.Initialize
    
	Do While tempInt > 0
		Dim chunk As Int = tempInt Mod 1000
		If chunk > 0 Then
			Dim chunkWords As String = ConvertChunk(chunk, Units, Tens)
			Dim scaleStr As String = Scales(scaleIdx)
			If scaleStr <> "" Then chunkWords = chunkWords & " " & scaleStr
			chunks.InsertAt(0, chunkWords)
		End If
		tempInt = tempInt / 1000
		scaleIdx = scaleIdx + 1
	Loop
    
	For i = 0 To chunks.Size - 1
		Words = Words & chunks.Get(i) & " "
	Next
    
	Return Words.Trim
End Sub

Private Sub ConvertChunk(n As Int, Units() As String, Tens() As String) As String
	Dim words As String = ""
	Dim val As Int = n
    
	If val >= 100 Then
		words = words & Units(val / 100) & " Hundred "
		val = val Mod 100
	End If
    
	If val >= 20 Then
		words = words & Tens(val / 10)
		If val Mod 10 <> 0 Then
			words = words & "-" & Units(val Mod 10)
		End If
		words = words & " "
	Else If val > 0 Then
		words = words & Units(val) & " "
	End If
    
	Return words.Trim
End Sub