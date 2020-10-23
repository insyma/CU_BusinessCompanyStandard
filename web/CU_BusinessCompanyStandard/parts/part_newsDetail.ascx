<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>

<script runat="server">
  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: part Newsdetail
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


dim ci as string = "de-DE"
dim dtformat as string = ""
dim datetimeformat as string = "yyyy-MM-dd"

''''''''''''''''Formate'''''''''''''''''''''''''''''''''''''''''''
''  d       Tage 1-31
''  dd      Tage 01-31
''  ddd     Wochentage kurz (Mo)
''  dddd    Wochentage lang(Montag)
''  M       Monat von 1-12
''  MM      Monat von 01-12
''  MMM     Monat kurz(Jun)
''  MMMM    Monat lang(Juni)
''  y       Jahr 0-99
''  yy      Jahr von 00-99
''  yyy     Jahr mit minimum von 3 Ziffern
''  yyyy    Jahr 4stellig
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''  alle Textwerte sind abhängig der Definition in Variable "ci"
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		Dim tempPage as new ContentUpdate.Page()
		Dim tempCon as new ContentUpdate.Container()
		
        'tempCon.LoadByName("part_newsUebersicht")
		
		
		'if tempCon.ParentObjects("inhalt").id <> 0 then
		''	if tempCon.ParentObjects("inhalt").ParentPages.count > 0 then
		''		tempPage.Load(tempCon.ParentObjects("inhalt").ParentPages(1).id)
		''		Container.ParentPages("newsDetail").Properties("MasterPageID").value = tempPage.ID & "&detail"
		''	end if
		'end if
        if not container.fields("news_newsentry_cat").properties("value").value = "" then
            dim c as new contentupdate.container()
            c.load(cint(container.fields("news_newsentry_cat").properties("value").value))
            c.load(c.ParentId)
            if not c.links("zennews_catentry_overview").properties("value").value = "" then
                dim p as new contentupdate.Page()
                p.load(cint(c.links("zennews_catentry_overview").properties("value").value))
                p.preview = CUpage.Preview
                p.LanguageCode = CUPage.LanguageCode
                getLink.Href = p.link
            else
                getLink.Href = "JavaScript: history.back()"
            end if
        else
            getLink.Href = "JavaScript: history.back()"
        end if
        if CUpage.LanguageCode = 0 then
            '''Datumsformat DEU
            dtformat = "dd.MM.yyyy"
        else
            '''Datumsformat ENG
            dtformat = "yyyy-MM-dd"
            ci = "en-US"
        end if
        
        if not container.datefields("news_newsentry_date").value = "" and not container.datefields("news_newsentry_date").value = "01.01.0001" then
            dim _time as string = Date.Parse(container.datefields("news_newsentry_date").value).toString(dtformat,New System.Globalization.CultureInfo(ci))
            dim _datetime as string = Date.Parse(container.datefields("news_newsentry_date").value).toString(datetimeformat,New System.Globalization.CultureInfo(ci))
            datetime.text = "<time datetime='" & _datetime & "'>" &_time & "</time>"
		end if
    End Sub	

    Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim dokument As Literal = CType(e.Item.FindControl("dokument"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)                
            '' diese beiden Aufrufe in einem Binditem immer machen, das sonst Sprache und Preview-Status vergessen werden kann
            con.preview = CUPage.preview
            con.languagecode = CUPage.languagecode
            
            '' Bauen des File-Links, weil bei leerer Legende sonst die Object-Caption benutzt wird. Hier alternativ der Filename
            if not con.files("news_datei_eintrag").Properties("Filename").Value = "" then
                If con.Files("news_datei_eintrag").Properties("Legend").Value <> "" then
                    dokument.text = "<li class='link download'><a class='icon " & con.Files("news_datei_eintrag").Properties("filetype").Value & "' href='" & con.Files("news_datei_eintrag").src & "' title='" & con.Files("news_datei_eintrag").Properties("Legend").Value & "' target='_blank'>" & con.Files("news_datei_eintrag").Properties("Legend").Value & "</a></li>"
                else
                    dokument.text = "<li class='link download'><a class='icon " & con.Files("news_datei_eintrag").Properties("filetype").Value & "' href='" & con.Files("news_datei_eintrag").src & "' title='" & con.Files("news_datei_eintrag").Properties("Filename").Value & "' target='_blank'>" & con.Files("news_datei_eintrag").Properties("Filename").Value & "</a></li>"
                end if
            end if
        End If
    End Sub
    Protected Sub IBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim img As Literal = CType(e.Item.FindControl("img"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)                
            '' diese beiden Aufrufe in einem Binditem immer machen, das sonst Sprache und Preview-Status vergessen werden kann
            con.preview = CUPage.preview
            con.languagecode = CUPage.languagecode
            if not con.images("news_bilder_bild").properties("filename").value = "" then
                dim _img as string = ""
                _img = "<a style='background-image: url(" & con.images("news_bilder_bild").src & ")' class='bgimg imagelink' href='" & con.images("news_bilder_bild").alternativesrc & "' title='" & con.images("news_bilder_bild").properties("legend").value & "' />"
                _img += "<img src='" & con.images("news_bilder_bild").src & "' alt='" & con.images("news_bilder_bild").properties("legend").value & "' /></a>"
                if not con.images("news_bilder_bild").properties("legend").value = "" then
                    _img += "<figcaption>" & con.images("news_bilder_bild").properties("legend").value & "</figcaption>"
                end if
                img.text = _img
            end if
        End If
    End Sub
</script>
<div class="part part-h1 part-news-detail">
    <% if not container.fields("news_newsentry_title").value = "" then %>
        <CU:CUField name="news_newsentry_title" runat="server" tag="h1" tagclass="h1 item-title"  />
    <% end if %>
    <asp:literal id="datetime" runat="server" />
    <% if not container.fields("news_newsentry_intro").value = "" then %>
        <CU:CUField name="news_newsentry_intro" runat="server" tag="div" tagclass="lead" />
    <% end if %>
</div>
<div class="part part-basic part-news-detail clearfix">
    <CU:CUObjectSet name="news_bilder_liste" runat="server" OnItemDataBound="IBindItem">
        <HeaderTemplate>
            <ul class="imglist-position imagelist vertical noliststyle insymaNewThumbs openInOverlay">
        </HeaderTemplate>
        <ItemTemplate>
            <li>
                <figure>
                    <asp:literal id="img" runat="server" />
				</figure>
            </li>
        </ItemTemplate>
        <FooterTemplate>
            </ul>
        </FooterTemplate>
    </CU:CUObjectSet>
    <CU:CUField name="news_newsentry_text" runat="server" tag="div" tagclass="liststyle" />
    <CU:CUObjectSet name="news_link_datei_liste" runat="server" OnItemDataBound="BindItem">
        <HeaderTemplate><ul class="linklist"></HeaderTemplate>
        <ItemTemplate>
            <asp:literal id="dokument" runat="server" />
            <CU:CULink name="news_link_eintrag" runat="server" tag="li" class="icon" />
        </ItemTemplate>
        <FooterTemplate>
            </ul>
        </FooterTemplate>
    </CU:CUObjectSet>
    <a href="" id="getLink" runat="server" class="icon iconbefore iconReturnTo link block"><CU:CUField Name="zennews_news_backto" runat="server" /></a>
</div>