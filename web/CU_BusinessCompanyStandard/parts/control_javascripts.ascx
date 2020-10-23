<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		''	HINU: part zur Integration der JS-Scripte als Include
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim include as String = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		' ### IncludePage Definieren und Laden
		Dim footerInfoIncPage As New ContentUpdate.Page()
		'footerInfoIncPage.LoadByName("inc_JS")
		footerInfoIncPage.Load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("PublishMetaIncludes").pages("inc_JS").id)
		footerInfoIncPage.Preview = CUPage.Preview
		include = footerInfoIncPage.Link
       '' response.write(include)
       if CUPage.Id = 27566 then
			include = ".." & footerInfoIncPage.properties("path").value & footerInfoIncPage.properties("filename").value
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
