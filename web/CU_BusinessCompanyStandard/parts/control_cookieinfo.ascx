<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
    Dim include as String
    Dim tempPage as new ContentUpdate.Page
    dim path as string = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    '' Laden der Include-Page
      tempPage.Load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("zen_cookieinfo").id)
      tempPage.Preview = CUPage.Preview
      tempPage.LanguageCode = CUPage.LanguageCode 
      '' bei Preview wird kompletter Pfad gebraucht, live nur der Dateiname, da im selben Ordner 
      if CUPage.ID <> tempPage.ID then
        include = tempPage.Link
      end if
      '' bedingt durch DEU-Startseite im Root muss der Verweis des Includes auf den Ordner zeigen
      if CUPage.id = CUPage.Web.rubrics("Web").rubrics("MainNavigation").pages("HomeSite").id and CUPage.Languagecode = 0 then
         '' path = "deu/"
        end if
    End Sub
</script>

<% If CUPage.Arrange = false then 
  if include <> "" then
    if cuPage.Preview then
      Server.Execute(include)
    else 
      response.write("<" + "!--#include virtual=""" & path & include & """ -->")
    end if
  end if
 End If %>
