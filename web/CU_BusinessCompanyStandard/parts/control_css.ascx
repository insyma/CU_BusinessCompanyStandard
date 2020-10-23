<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		''	HINU: Control zur Integration des Includes für CSS-Einbindung
	
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim include as String = ""
	Dim include_custom as String = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		' ### FooterInfo Container Definieren und Laden
		Dim footerInfoIncPage As New ContentUpdate.Page()
		'' Laden der Seite, welche das Include erzeugt
		'footerInfoIncPage.LoadByName("inc_CSS")
		footerInfoIncPage.Load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("PublishMetaIncludes").pages("inc_CSS").id)

		'' Preview ja/nein
		footerInfoIncPage.Preview = CUPage.Preview
		'' generiere String für Einbindung
		if footerInfoIncPage.ID <> CUPage.ID then
			include = footerInfoIncPage.Link
		end if
		Dim CustomIncPage As New ContentUpdate.Page()
		'' Laden der Seite, welche das Include erzeugt
		CustomIncPage.Load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("PublishMetaIncludes").pages("inc_custom_css").id)

		'' Preview ja/nein
		CustomIncPage.Preview = CUPage.Preview
		'' generiere String für Einbindung
		if CustomIncPage.ID <> CUPage.ID then
			include_custom = CustomIncPage.Link
		end if
	
	End Sub
</script>

<% If CUPage.Arrange = false AND include <> "" then 
	'' nur wenn nicht imDrag'N'Drop
	if cuPage.Preview then
		'' Direkterstellung bei Preview
		Server.Execute(include)
	else 
		'' String für SSI
		response.write("<" + "!--#include virtual=""" & include &""" -->")
	end if
End If %>
<% If CUPage.Arrange = false AND include_custom <> "" then 
	'' nur wenn nicht imDrag'N'Drop
	if cuPage.Preview then
		'' Direkterstellung bei Preview
		Server.Execute(include_custom)
	else 
		'' String für SSI
		response.write("<" + "!--#include virtual=""" & include_custom &""" -->")
	end if
End If %>