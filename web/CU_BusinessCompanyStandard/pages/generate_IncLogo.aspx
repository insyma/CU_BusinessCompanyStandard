<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: part zur Anzeige des Headers mit dem Logo und Link zur Startseite

    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Dim homePage As ContentUpdate.Page
    Dim topPage As New ContentUpdate.Page

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

        ' ### Header-Logo - Container laden
        Dim HeaderLogoContainer As New ContentUpdate.Container()
        'HeaderLogoContainer.LoadByName("HeaderLogoContainer")
        HeaderLogoContainer.Load(CUPage.Web.rubrics("Web").rubrics("Seiteneinstellungen").pages("beschriftungen").containers("HeaderLogoContainer").id)
        HeaderLogoContainer.Preview = CUPage.Preview
        HeaderLogoContainer.LanguageCode = CUPage.LanguageCode

        ' ### Startseite suchen und laden
        homePage = New ContentUpdate.Page
        'homePage.LoadByName("HomeSite")
        homePage.Load(CUPage.Web.rubrics("Web").rubrics("ServiceNavigation").pages("HomeSite").id)
        homePage.LanguageCode = CUPage.LanguageCode

        ' ### Metatag-Seite laden (warum auch immer das von Bedeutung ist)
        Dim MetaPage As New ContentUpdate.Page
        'MetaPage.LoadByName("MetaTags")
        MetaPage.Load(CUPage.Web.rubrics("Web").rubrics("Seiteneinstellungen").pages("MetaTags").id)
        MetaPage.LanguageCode = CUPage.LanguageCode


        Dim p As String = HeaderLogoContainer.files("headerlogo").properties("path").value
        If CUPage.Preview = True Then
            p = ".." & p
        Else
            p = CUPage.Web.Livepath & p
            p = p.replace("//", "/")
        End If

        '' Wenn die MetaPage-Seite keine Caption hat geht gar nichts(kommt meist in Sprache <> Mainlanguage vor)
        If Not MetaPage.Caption = "" Then
            '' ist ein Slogan hinterlegt?
            If HeaderLogoContainer.Fields("slogan").Value = "" Then
                '' wenn kein Slogan, nimm die Daten von den zentralen META-Tags
                con_logo.InnerHtml = "<a rel=""nofollow""  href=""" & homePage.Link & """ title=""" & MetaPage.Containers(1).Fields("websitetitle").Value & """><img src='" & p & HeaderLogoContainer.files("headerlogo").properties("filename").value & "' alt='" & HeaderLogoContainer.files("headerlogo").properties("legend").value & "' /><span>" & MetaPage.Containers(1).Fields("websitetitle").Value & CUPage.Caption & "</span></a>"
            Else
                '' wenn Slogan vorhanden, dann nimm ihn auch
                con_logo.InnerHtml = "<a rel=""nofollow"" href=""" & homePage.Link & """ title=""" & HeaderLogoContainer.Fields("slogan").Value & """><img src='" & p & HeaderLogoContainer.files("headerlogo").properties("filename").value & "' alt='" & HeaderLogoContainer.files("headerlogo").properties("legend").value & "' />" & "<em>" & HeaderLogoContainer.Fields("slogan").Value & "</em></a>"
            End If
        End If


    End Sub
</script>
<h4 class="control con-logo" id="con_logo" runat="server"></h4>
