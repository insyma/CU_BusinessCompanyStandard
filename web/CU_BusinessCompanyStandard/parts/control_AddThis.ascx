<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		''	HINU: part zur Einbindung des Includes für Footerinformationen
	
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim include as String = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		' ### FooterInfo Container Definieren und Laden
		Dim AddThisInfoIncPage As New ContentUpdate.Page()
		'AddThisInfoIncPage.LoadByName("inc_addthis")
		AddThisInfoIncPage.Load(CUPage.Web.rubrics("Web").rubrics("Seiteneinstellungen").pages("inc_addthis").id)
		AddThisInfoIncPage.Preview = CUPage.Preview
		if AddThisInfoIncPage.ID <> CUPage.ID then
			include = AddThisInfoIncPage.Link
		end if
	End Sub
</script>

<% If CUPage.Arrange = false AND include <> "" AND include <> CUPage.ID then 
	if cuPage.Preview then
		Server.Execute(include)
	else 
		response.write("<" + "!--#include virtual=""" & include &""" -->")
	end if
End If %>