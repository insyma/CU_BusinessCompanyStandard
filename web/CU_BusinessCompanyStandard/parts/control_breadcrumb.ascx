<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: Control zur Darstellung der Breadcrumb - zumeist in den MAsterpages eingebunden

    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Dim homePage As ContentUpdate.Page
    Dim contentcount As Integer = 1
    Dim naviPath As String = ""

    Dim detailitem As String = ""
    Sub Page_Load(Src As Object, E As EventArgs)

        ' Hier wird die Startseite ausgelesen und den Link dazu ins HTML geschrieben
        homePage = New ContentUpdate.Page
        'homePage.LoadByname("HomeSite")
        homePage.Load(CUPage.Web.rubrics("Web").rubrics("ServiceNavigation").pages("HomeSite").id)
        homePage.LanguageCode = CUPage.LanguageCode
        HomeLink.HRef = homePage.Link

        '' scheinbar ein Relikt, da nicht genutzt
        Dim Beschriftungen As New ContentUpdate.Container()
        'Beschriftungen.LoadByName("HeaderLogoContainer")
        Beschriftungen.Load(CUPage.Web.rubrics("Web").rubrics("Seiteneinstellungen").pages("beschriftungen").containers("HeaderLogoContainer").id)
        Beschriftungen.LanguageCode = CUPage.LanguageCode
        Me.Container = Beschriftungen

        '@Uwe:
        '--->>>homePage = CUPage
        'Was hat das für einen Sinn? 
        'Weiter unten im Code werden neue ID's gesetzt somit hat auch die CUPage die neuen ID's... ;)
        'Es ist keine kopie von CUPage sondern eine kopie der Referenz vo CUPage und hat einfluss auf weitere aufruafe von CUPage (Page und Controls die unter der Breadcrumb sind)


        homePage.load(CInt(Request.QueryString("page_id")))
        Counting(homePage, "")
        If (homePage.Navigable) Then
            '' Erweitere derzeitige Bradcrumb um aktuelle Seite    
            naviPath = "<li>" & vbCrLf
            naviPath += "<a class='activePage icon iconbefore' href=""" & homePage.Link & """>" & vbCrLf
            naviPath += "<span>" & homePage.Caption & "</span></a>" & vbCrLf
            naviPath += "</li>" & vbCrLf
        End If
        Do While homePage.Parent.ClassId = 3
            homePage.load(homePage.ParentID)
            If homePage.navigable Then
                Dim _path As String = ""
                If (homePage.Containers("Inhalt").Containers.Count = 0) And homePage.Pages.NaviPages.Count > 0 Then
                    _path = "<li>" & vbCrLf
                    _path += "<a href=""" & homePage.Pages.NaviPages(0).Link & """>" & vbCrLf
                    _path += "<span>" & homePage.Caption & "</span></a>" & vbCrLf
                    _path += "</li>" & vbCrLf
                Else
                    _path = "<li>" & vbCrLf
                    _path += "<a href=""" & homePage.Link & """>" & vbCrLf
                    _path += "<span>" & homePage.Caption & "</span></a>" & vbCrLf
                    _path += "</li>" & vbCrLf
                End If
                naviPath = _path & naviPath
                contentcount = contentcount - 1
            End If
        Loop
        If CUPage.Containers("detail").containers.count > 0 And IsNumeric(Request.QueryString("detail")) Then
            homePage.load(CInt(Request.QueryString("detail")))
            Dim _caption As String = homePage.fields(1).value
            If homePage.ParentPages.Count > 0 Then
                homePage.load(homePage.parentPages(1).id)
                detailitem = "<li>" & vbCrLf
                detailitem += "<a href=""" & homePage.Link & """>" & vbCrLf
                detailitem += "<span>" & _caption & "</span></a>" & vbCrLf
                detailitem += "</li>" & vbCrLf
            End If
        End If

    End Sub

    Function Counting(naviPage as ContentUpdate.Page, navPath as string) as String
        If (naviPage.Navigable) Then
            contentcount += 1
        End If
        '' Sollte Page aus aktuellem Durchlauf noch eine Elternseite haben...
        If naviPage.ParentPages.count > 0 Then
            Counting(naviPage.ParentPages(1), "")
        End If
    end function
</script>
<div class="part part-breadcrumbs">
    <ol>
        <li>
            <a class="icon iconbefore iconhome" id="HomeLink" runat="server">
                <cu:cufield name="header_logo_home" runat="server" tag="span" />
            </a>
        </li>
        <%=naviPath%>
        <%=detailitem%>
    </ol>
</div>

