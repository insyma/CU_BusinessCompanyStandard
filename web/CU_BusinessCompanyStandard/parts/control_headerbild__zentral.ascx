<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	''  HINU: part zur Einbindung eines Includes für Headerbilder

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim topPage As New ContentUpdate.Page
	Dim include as String = ""

	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

		' ### Zentraler Headerbild Container definieren und laden
		Dim zenHeaderbilderContainer As New ContentUpdate.Container()
		'zenHeaderbilderContainer.LoadByName("Headerkategorien")
		zenHeaderbilderContainer.Load(CUPage.Web.Rubrics("Web").Rubrics("ZentraleInhalte").Pages("Headerbilder").Containers("Headerkategorien").id)
		zenHeaderbilderContainer.Preview = CUPage.Preview
		zenHeaderbilderContainer.LanguageCode = CUPage.LanguageCode
		Dim tempCon As New ContentUpdate.Page()
		' ### Include wählen wenn Kategorie auf Seite erfasst
		If CUPage.Containers("con_headerbild").Containers("con_headerbild__zentral").Fields("HeaderbildKategorie").Value <> "" Then
			Dim tempKategorie As String = CUPage.Containers("con_headerbild").Containers("con_headerbild__zentral").Fields("HeaderbildKategorie").Properties("Value").Value
			tempCon.Load(tempKategorie)
			tempCon.Load(tempCon.Parent.id)
			tempCon.Load(tempCon.ParentPages("inc_headerbildcategory").id)
			tempCon.LanguageCode = CUPage.LanguageCode
			tempCon.Preview = CUPage.Preview
			include = tempCon.Link
			If CUPage.Id = 27566 Then
				include = ".." & tempCon.properties("path").value & tempCon.properties("filename").value
			End If

			' ### Include wählen wenn keine Kategorie auf Seite erfasst
		Else
			' Wenn Parent Pages vorhanden
			If (CUPage.GetParentObjects(3).Count > 0) Then
				topPage.Load(CUPage.Id)
				Do While topPage.Parent.ClassId = 3
					topPage.Load(topPage.ParentId)
				Loop

				' Wenn ein ParentObjekt eine Seite ist, abfragen ob eine Headerkategorie erfasst ist
				If (topPage.Containers("con_headerbild").Containers("con_headerbild__zentral").Fields("HeaderbildKategorie").Value <> "") Then
					Dim tempKategorie As String = topPage.Containers("con_headerbild").Containers("con_headerbild__zentral").Fields("HeaderbildKategorie").Properties("Value").Value
					tempCon.Load(tempKategorie)
					tempCon.Load(tempCon.Parent.id)
					tempCon.Load(tempCon.ParentPages("inc_headerbildcategory").id)
					tempCon.LanguageCode = CUPage.LanguageCode
					tempCon.Preview = CUPage.Preview
					tempCon.Parent.Preview = CUPage.Preview
					include = tempCon.Link
					If CUPage.Id = 27566 Then
						include = ".." & tempCon.properties("path").value & tempCon.properties("filename").value
					End If
					' Wenn in Partent Seite keine Kategorie gewählt wurde
				Else
					tempCon.load(zenHeaderbilderContainer.ObjectSets("Headerkategorien").Containers(1).ParentPages("inc_headerbildcategory").id)
					include = tempCon.Link
					if CUPage.Id = 27566 then
						include = ".." & zenHeaderbilderContainer.ObjectSets("Headerkategorien").Containers(1).ParentPages("inc_headerbildcategory").properties("path").value & zenHeaderbilderContainer.ObjectSets("Headerkategorien").Containers(1).ParentPages("inc_headerbildcategory").properties("filename").value
					end if
				End If
				' Wenn keine Parent Seite vorhanden ist
			else
				if zenHeaderbilderContainer.ObjectSets("Headerkategorien").Containers.Count > 0 then
					tempCon.load(zenHeaderbilderContainer.ObjectSets("Headerkategorien").Containers(1).ParentPages("inc_headerbildcategory").id)
					include = tempCon.Link
					if CUPage.Id = 27566 then
						include = ".." & zenHeaderbilderContainer.ObjectSets("Headerkategorien").Containers(1).ParentPages("inc_headerbildcategory").properties("path").value & zenHeaderbilderContainer.ObjectSets("Headerkategorien").Containers(1).ParentPages("inc_headerbildcategory").properties("filename").value
					end if
				end if
			End If
		End If
	End Sub
</script>

<% If CUPage.Arrange = false then 
	if cuPage.Preview then
		Server.Execute(include)
	else 
		response.write("<" + "!--#include virtual=""" & include &""" -->")
	end if
End If %>