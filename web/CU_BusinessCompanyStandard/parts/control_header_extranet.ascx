<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ''  HINU: part zur Anzeige des Headers mit dem Logo und Link zur Startseite
       
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Dim homePage As ContentUpdate.Page
    Dim topPage As New ContentUpdate.Page
	dim pfad as string = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

		' ### Header-Logo - Container laden
		Dim HeaderLogoContainer As New ContentUpdate.Container()
        HeaderLogoContainer.LoadByName("HeaderLogoContainer")
        HeaderLogoContainer.Preview = CUPage.Preview
		HeaderLogoContainer.LanguageCode = CUPage.LanguageCode

        ' ### Startseite suchen und laden
        homePage = New ContentUpdate.Page
        homePage.Load(39977)
        homePage.LanguageCode = CUPage.LanguageCode
        
        ' ### Metatag-Seite laden (warum auch immer das von Bedeutung ist)
        Dim MetaPage As New ContentUpdate.Page
        MetaPage.LoadByName("MetaTags")
        MetaPage.LanguageCode = CUPage.LanguageCode
        if CUPage.preview = true then
            pfad = "cuimgpath/"
        end if
        '' Wenn die MetaPage-Seite keine Caption hat geht gar nichts(kommt meist in Sprache <> Mainlanguage vor)
        If Not MetaPage.Caption = "" Then
            '' ist ein Slogan hinterlegt?
            If HeaderLogoContainer.Fields("slogan").Value = "" Then
                '' wenn kein Slogan, nimm die Daten von den zentralen META-Tags
                h1Tag.InnerHtml = "<a rel=""nofollow""  href=""" & homePage.Link & """ title=""" & MetaPage.Containers(1).Fields("websitetitle").Value & """><img src='../img/" & pfad & HeaderLogoContainer.Images("HeaderLogo").processedfilename & "' alt=''/><span>" & MetaPage.Containers(1).Fields("websitetitle").Value & CUPage.Caption & "</span></a>"
            Else
                '' wenn Slogan vorhanden, dann nimm ihn auch
                h1Tag.InnerHtml = "<a rel=""nofollow"" href=""" & homePage.Link & """ title=""" & HeaderLogoContainer.Fields("slogan").Value & """><img src='../img/" & pfad & HeaderLogoContainer.Images("HeaderLogo").processedfilename & "' alt=''/><em>" & HeaderLogoContainer.Fields("slogan").Value & "</em></a>"
            End If
        End If
                
        Dim PageNow As New ContentUpdate.Page
        ''' Abfragen ob Aktuelle Seite eine Newsdetailseite ist
        ''' für mögliche Sachen, die auf Detailseiten anders sein sollen
		for each container as ContentUpdate.Container in CUPage.Containers("inhalt").containers
			if container.ObjName ="part_news" then
	            PageNow.Load(CUPage.Containers("inhalt").Containers(1).ParentPages(1).Id)
    	    Else
        	    PageNow.Load(CUPage.Id)
	        End If
		next
    End Sub
</script>
<h4 id="h1Tag" runat="server"></h4>

