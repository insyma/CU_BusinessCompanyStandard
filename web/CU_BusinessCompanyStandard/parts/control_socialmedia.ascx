<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		''	HINU: part zur Einbindung des Includes für Footerinformationen
	
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim include as String = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		' ### FooterInfo Container Definieren und Laden
		Dim SocialMediaIncPage As New ContentUpdate.Page()
		'SocialMediaIncPage.LoadByName("inc_socialmedia")
		SocialMediaIncPage.Load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("inc_Socialmedia").id)
		SocialMediaIncPage.Preview = CUPage.Preview
		include = SocialMediaIncPage.Link
		if CUPage.Id = 27566 then
			include = ".." & SocialMediaIncPage.properties("path").value & SocialMediaIncPage.properties("filename").value
		end if
	End Sub
</script>

<% If CUPage.Arrange = false then 
	if cuPage.Preview then
		Server.Execute(include)
	else 
		response.write("<" + "!--#include virtual=""" & include &""" -->")
	end if
End If %>