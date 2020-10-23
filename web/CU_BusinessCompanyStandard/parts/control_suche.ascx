<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		''	HINU: part zur Einbindung des Includes für Footerinformationen
	
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim include as String = ""
	dim path as string = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		' ### FooterInfo Container Definieren und Laden
		Dim tempPage As New ContentUpdate.Page()
		'tempPage.LoadByName("inc_Suche")
		tempPage.Load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("PublishMetaIncludes").pages("inc_Suche").id)
		tempPage.Preview = CUPage.Preview
		include = tempPage.Link
		if CUPage.id = CUPage.Web.rubrics("Web").rubrics("ServiceNavigation").pages("HomeSite").id and CUPage.Languagecode = 0 then
	        path = "deu/"
	    end if
	End Sub
</script>

<% If CUPage.Arrange = false AND include <> "" then 
	if cuPage.Preview then
		Server.Execute(include)
	else 
		response.write("<" + "!--#include virtual=""" & include &""" -->")
	end if
End If %>