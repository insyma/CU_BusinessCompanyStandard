<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Dim include as String = ""
	Dim tempPage as new ContentUpdate.Page
	dim path as string = ""
	dim page as string = "kategorieinclude"
	Dim kategorie as new ContentUpdate.Field
	dim titel as string = ""
	dim vis as boolean = true
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		''	HINU: part zur Anzeige einer Newsbox mit folgenden grundeinstellungen
		''	1. Überschrift an jeder genutzten Stelle individuell anpassbar
		''  2. Auswahl einer Newskategorie per Dropdown
		''	3. Checkbox zur Anzeige ALLER News unabhängig von vergebenen Kategorien
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

		''Wenn Überschrift ausgefüllt
		if not Container.fields("dezen_boxnews_title").value = "" then
			titel = "<h3>" & Container.fields("dezen_boxnews_title").value & "</h3>"
		end if
		''Wenn Checkbox "Alle News?" aktiv (Anzeige aller News JEDER Kategorie)
		if Container.fields("dezen_newsall").value = "1" then
			tempPage.LoadByName("NewsBoxInclude")
		else
		''Anzeige News auf Basis einer Kategorie
			if Container.Fields("dezen_newskategorie").properties("value").value <> "" then
				''Ist eine Kategorie gewählt? 
				''Durch Hineinziehen des Parts auf einer Seite, OHNE danach die Einstellungen des Parts zu "Speichern" kann der Value des Kategorie leer sein
				kategorie.Load(Container.Fields("dezen_newskategorie").properties("value").value) 
				tempPage.Load(kategorie.Parentid)
				tempPage.Load(tempPage.pages(page).id)
			else
				''wenn keine Kategorie gewählt
				''Laden der Property "Options" beim Dropdown == ListenID der Kategorien
				kategorie.Load(cint(Container.Fields("dezen_newskategorie").properties("options").value)) 
				'' Laden der Page des ersten Kategorie-Eintrages
				if kategorie.containers.count > 0 then
					tempPage.Load(kategorie.Containers(1).Pages(page).id)
				end if
			end if
		end if

		''Sicherstellen das die geladene Page weiss, ob Si in der Vorschau ist und in welcher Sprache es angezeigt werden soll
		tempPage.Preview = CUPage.Preview
		tempPage.LanguageCode = CUPage.LanguageCode 
		
		if tempPage.ID <> CUPage.ID then
			if CUPage.Preview then
				'' Wir sind in der Vorschau und benötigen für das Einbinden den Link des Includes
			    include = tempPage.Link
			else
				'' wir publizieren zum LiveServer und brauchen nur den Filename des Includes, da er in den jeweiligen Sprachordner publiziert wird
			    include = tempPage.properties("Filename").value
			end if
		end if

  		if CUPage.id = CUPage.Web.rubrics("Web").rubrics("ServiceNavigation").pages("HomeSite").id and CUPage.Languagecode = 0 then
  			'' Sonderfall
  			'' die Startseite eines Projektes wird in der Main-Language nicht in den Sprachordner, sondern ins Root publiziert
  			'' >> der Verweis auf das Include benötigt die Angabe dieses Ordners
      		path = "deu/"
    	end if
    	if tempPage.Id = 0 OR include = "" then
    		vis = false
    	end if

	End Sub
</script>
<% if vis = true then %>
<div class="part part-news">
<%=titel%>
<% If CUPage.Arrange = false then 
	'' Das Ganze wird nicht im Drag'N'Drop - Modus ausgeführt	
	  if include <> "" then
	  	'' Macht nur Sinn, wenn es ein Include gibt
		if cuPage.Preview then
			'' In Vorschau wird das Include vom Server generiert
			Server.Execute(include)
			
		else 
			'' Live wird es als SSI eingebunden
			response.write("<" + "!--#include file=""" & path & include & """ -->")
		end if
	  end if
   End If %>
</div>
<% end if %>