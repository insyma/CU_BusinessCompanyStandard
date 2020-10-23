<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">	
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		'''*** Script, um automatisch bei erster Vorschau /Publikation Caption der Seite als Seitentitel einzutragen und auszugeben ***'''
		'''*** nur bei Projekten in einer Sprache sinnvoll und zu verwenden ***'''
		'if CUPage.Containers("inhalt").Containers.count > 0 then
		'	if CUPage.Containers("settings").Fields("Seitentitel").Value = "" then
		'		CUPage.Containers("settings").Fields("Seitentitel").Value = CUPage.Caption
		'	end if
		if not CUPage.Containers("settings").Fields("Seitentitel").Value = "" Then
			seitentitel.Text = "<div class='part part-h1'><h1>" & CUPage.Containers("settings").Fields("Seitentitel").Value & "</h1></div>"
		End if
		'end if
	End Sub
</script>
<asp:Literal id="seitentitel" runat="server" />