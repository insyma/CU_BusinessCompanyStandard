<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		''	HINU: part zur Einbindung des Includes für Footerinformationen
	
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim include as String = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		' ### FooterInfo Container Definieren und Laden
		Dim footerInfoIncPage As New ContentUpdate.Page()
			'footerInfoIncPage.LoadByName("inc_FooterInfo")
			footerInfoIncPage.Load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("inc_FooterInfo").id)
			footerInfoIncPage.Preview = CUPage.Preview
			if footerInfoIncPage.ID <> CUPage.ID then
				include = footerInfoIncPage.Link
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