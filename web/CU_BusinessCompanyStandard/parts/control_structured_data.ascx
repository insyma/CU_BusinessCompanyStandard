<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
	Dim homePage as ContentUpdate.Page
    
    dim contentcount as integer = 1
    dim jsonpath as string = ""
    dim detail as integer = 0
    dim news as boolean = false
    Dim include as String = ""

    Sub Page_Load(Src As Object, E As EventArgs)
        ' Hier wird die Startseite ausgelesen und den Link dazu ins HTML geschrieben
    	homePage = new ContentUpdate.Page
    	'homePage.LoadByname("HomeSite")
        homepage.load(CUPage.Web.rubrics("Web").rubrics("ServiceNavigation").pages("HomeSite").id)
    	homePage.LanguageCode = CUPage.LanguageCode
        homePage.Preview = false
        'Da Breadcrumb von unten nach oben aufgebaut wird, aber die Position normal zaehlt wird Anzahl Eintraege ermittelt'
		Dim hPage as new ContentUpdate.Page()
        hPage.load(cint(Request.QueryString("page_id")))
        Counting(hPage, "")
       
		detail = contentcount + 1
        'Beginn breadcrump mit Home-Link'
        jsonpath += "{" & vbcrlf
        jsonpath += "    ""@type"": ""ListItem""," & vbcrlf
        jsonpath += "    ""position"": 1," & vbcrlf
        jsonpath += "    ""item"": {" & vbcrlf
        jsonpath += "        ""@id"": """ & CUPage.Web.LiveServer & homePage.Link & """," & vbcrlf
        jsonpath += "        ""name"": """ & homePage.Caption & """" & vbcrlf
        jsonpath += "    }" & vbcrlf
        jsonpath += "}," & vbcrlf
        dim _json as string = ""
        'aktuelle Seite ist letztes Item in Breadcrumb und Ausgangspunkt des Zusammenbaus'
        If (hPage.Navigable) Then
            dim temppage as new contentupdate.page()
            temppage.Load(hPage.Id)
            temppage.Preview = false
            _json += "{" & vbcrlf
            _json += "    ""@type"": ""ListItem""," & vbcrlf
            _json += "    ""position"": " & contentcount.toString() & "," & vbcrlf
            _json += "    ""item"": {" & vbcrlf
            _json += "        ""@id"": """ &  hPage.Web.LiveServer & temppage.Link & """," & vbcrlf
            _json += "        ""name"": """ & hPage.Caption & """" & vbcrlf
            _json += "    }" & vbcrlf
            _json += "}," & vbcrlf
            contentcount = contentcount-1
        End If
        'jetzt arbeiten wir uns in der Hierarchie nach oben'
        
        Do while hPage.Parent.ClassId = 3
            hPage.load(hPage.ParentID)
            hPage.Preview = false
            if hPage.navigable Then
                jsonpath += "{" & vbcrlf
                jsonpath += "    ""@type"": ""ListItem""," & vbcrlf
                jsonpath += "    ""position"": " & contentcount.toString() & "," & vbcrlf
                jsonpath += "    ""item"": {" & vbcrlf
                jsonpath += "        ""@id"": """ & CUPage.Web.LiveServer & hPage.Link & """," & vbcrlf
                jsonpath += "        ""name"": """ & hPage.Caption & """" & vbcrlf
                jsonpath += "    }" & vbcrlf
                jsonpath += "}," & vbcrlf
                contentcount = contentcount-1
            end if
        Loop
        jsonpath += _json

        'Wenn aktelle Seite Detailseite ist, wird nun dieser Eintrag als letzter Punkt gesetzt'
        if CUPage.Containers("detail").containers.count > 0 AND IsNumeric(Request.QueryString("detail")) Then
            homePage.load(cint(Request.QueryString("detail")))
            dim c as new contentupdate.container()
            c.load(homepage.id)
            dim _caption as string = homepage.fields(1).plaintext
            if homepage.ParentPages.Count > 0 then
                homepage.load(homepage.parentPages(1).id)
                jsonpath += "{" & vbcrlf
                jsonpath += "    ""@type"": ""ListItem""," & vbcrlf
                jsonpath += "    ""position"": " & detail.toString() & "," & vbcrlf
                jsonpath += "    ""item"": {" & vbcrlf
                jsonpath += "        ""@id"": """ & CUPage.Web.LiveServer & homePage.Link & """," & vbcrlf
                jsonpath += "        ""name"": """ & _caption & """" & vbcrlf
                jsonpath += "    }" & vbcrlf
                jsonpath += "}," & vbcrlf
            end if
            'wenn es sich um eine Newsdetailseite handelt werden hier die Inhalte für das News-JSON generiert'
            if CUPage.ID = CUPage.Web.rubrics("Web").rubrics("ServiceNavigation").pages("aktuelles").id then
            	news = true    ' Juhu, es ist eine News'
                'Titel'
            	titledata.text = c.fields("news_newsentry_title").plaintext
            	'Datum'
                dim _datetime as string = Date.Parse(c.datefields("news_newsentry_date").value).toString("yyyy-MM-dd",New System.Globalization.CultureInfo("en-US"))
	            datemeta.text = "" & _datetime & ""
            	'Einleitung'
                introdata.text = c.fields("news_newsentry_intro").plaintext
            	'Langtext(da WYSIWYG muss HTML beseitigt werden)'
                txtdata.text = System.Text.RegularExpressions.Regex.Replace(c.fields("news_newsentry_text").value, "<.*?>", "")
            	Dim HeaderLogoContainer As New ContentUpdate.Container()
            	'Bild'
                if c.objectsets("news_bilder_liste").containers.count = 0 then
                    'Leider keine Bilder bei Newseintrag - holen wir uns das Logo'
		            'HeaderLogoContainer.LoadByName("HeaderLogoContainer")
                    HeaderLogoContainer.Load(CUPage.Web.Rubrics("Web").Rubrics("Seiteneinstellungen").Pages("Beschriftungen").Containers("HeaderLogoContainer").id)
		            HeaderLogoContainer.Preview = false
		            HeaderLogoContainer.LanguageCode = CUPage.LanguageCode
		            imgJson.text = CUPage.Web.LiveServer & HeaderLogoContainer.Images("HeaderLogo").src
		        else 
                    'wir schnappen uns das erste Bild aus der Liste
		        	HeaderLogoContainer.Load(c.objectsets("news_bilder_liste").containers(1).id)
		        	imgJson.text = CUPage.Web.LiveServer & HeaderLogoContainer.images("news_bilder_bild").src
		        end if
            end if
        end if
        'Da Breadcrumb-Eintraege durch Komma getrennt werden(der letzte Eintrag aber kein abschliessendes Komma benoetigt) entfernen wir das letzte Komma'
        if jsonpath.length > 10 Then
            jsonpath = jsonpath.substring(0, jsonpath.lastIndexOf(","))
        end if
        ' Bisher waren die Daten alle Seitenspezifisch, also variabel'
        ' Nun integrieren wir die statischen Daten, wie z.B. Kontaktdaten, Social-Links, Logo'
        homepage.LoadByName("inc_structured_data")
        homepage.Preview = CUPage.Preview
        include = homepage.Link
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
<!--Breadcrumb JSON-->
<script type="application/ld+json">
	{
		"@context": "http://schema.org",
		"@type": "BreadcrumbList",
		"itemListElement": [
            <%=jsonpath%>
        ]
	}
</script>
<!--News-JSON-->
<% if news = true then 'wozu ausgeben, wenn es keine News ist...' %>
<script type="application/ld+json">
	{
		"@context": "http://schema.org",
		"@type": "NewsArticle",
		"headline": "<asp:literal id="titledata" runat="server" />",
		"image": [
		"<asp:literal id="imgJson" runat="server" />"
	],
		"datePublished": "<asp:literal id="datemeta" runat="server" />",
		"description": "<asp:literal id="introdata" runat="server" />",
		"articleBody": "<asp:literal id="txtdata" runat="server" />"
	}
</script>
<% end if
'LOS, klauen wir uns die statischen JSONs! '
If CUPage.Arrange = false AND not include = "" then 
    if cuPage.Preview then
        Server.Execute(include)
    else 
        response.write("<" + "!--#include virtual=""" & include &""" -->")
    end if
End If %>
