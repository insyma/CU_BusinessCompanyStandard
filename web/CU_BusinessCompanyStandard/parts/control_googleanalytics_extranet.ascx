<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		''	HINU: part zur Einbindung des Includes für GoogleAnalytics
	
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim include as String = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		' ### Zentraler Analytics Container definieren und laden
		Dim googleAnalyticsCon As New ContentUpdate.Page()
		googleAnalyticsCon.LoadByName("googleextranet")
		googleAnalyticsCon.Preview = CUPage.Preview
		
		include = googleAnalyticsCon.Link
		
	End Sub
</script>

<% If CUPage.Arrange = false then 
	if not CUPage.Preview then
		response.write("<" + "!--#include virtual=""" & include &""" -->")
	end if
End If %>