<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: Control für Einbindung Include der "normalen" Footerinhalte
    
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim include as String
Dim include0 as String
Dim tempPage as new ContentUpdate.Page
dim path as string = ""

Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    '' Laden der Seite, welches das Include generiert
    'tempPage.LoadByName("IncFooterNavigation")
    tempPage.Load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("navigationen").pages("IncFooterNavigation").id)

    '' Mitteilen für welche Sprache und ob Vorschau
    tempPage.Preview = CUPage.Preview
    tempPage.LanguageCode = CUPage.LanguageCode 

    if CUPage.Preview then
        '' wenn Preview, dann Link zur Direkterstellung des Includes
        include = tempPage.Link
    else
        '' ansonsten reicht der Dateiname, da im Sprachordner
        include = tempPage.properties("Filename").value
    end if

    if CUPage.id = CUPage.Web.rubrics("Web").rubrics("ServiceNavigation").pages("HomeSite").id and CUPage.Languagecode = 0 then
        '' Ausnahme: Startseite in Mainlanguage liegt im Root
        path = "deu/"
    end if
End Sub
</script>

<nav class="Nav NavFooter clearfix">
<% If CUPage.Arrange = false then 
  if include <> "" then
    if cuPage.Preview then
      Server.Execute(include)
    else 
      response.write("<" + "!--#include file=""" & path & include & """ -->")
    end if
  end if
 End If %>
 </nav>