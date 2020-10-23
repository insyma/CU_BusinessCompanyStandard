<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: part zur einbindung des entsprechenden Kategorieincludes
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim include as String
	Dim tempPage as new ContentUpdate.Page
	Dim kategorie as new ContentUpdate.Field
	dim page as string = "kategorieinclude"
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

		if container.fields("dezen_newsarchive").value = "1" then
			'' Soll vielleicht das Archiv angezeigt werden?
			page = "kategoriearchiveinclude"
		end if
		if Container.Fields("dezen_newskategorie").properties("value").value <> "" then
			'' Wenn Kategorie hinterlegt: lade das entsprechende Include
			kategorie.Load(Container.Fields("dezen_newskategorie").properties("value").value) 
			tempPage.Load(kategorie.Parentid)
			tempPage.Load(tempPage.pages(page).id)
		else
			'' Wenn keineKategorie hinterlegt: lade das erste Include
			kategorie.Load(cint(Container.Fields("dezen_newskategorie").properties("options").value)) 
			tempPage.Load(kategorie.Containers(1).Pages(page).id)
		end if
		tempPage.Preview = CUPage.Preview
		tempPage.LanguageCode = CUPage.LanguageCode 
		if CUPage.preview = true then
			include = tempPage.Link
		else
			include = tempPage.properties("filename").value
		end if
	End Sub
</script>

<% If CUPage.Arrange = false then 
	  if include <> "" then
		if cuPage.Preview then
			Server.Execute(include)
		else 
			response.write("<" + "!--#include file=""" & include & """ -->")
		end if
	  end if
   End If %>