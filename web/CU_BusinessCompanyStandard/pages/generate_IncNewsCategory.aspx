<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
    Dim ci As String = "de-DE"
    Dim dtformat As String = ""
    Dim datetimeformat As String = "yyyy-MM-dd"

    ''''''''''''''''Formate'''''''''''''''''''''''''''''''''''''''''''
    ''	d 		Tage 1-31
    ''	dd 		Tage 01-31
    ''  ddd     Wochentage kurz (Mo)
    ''	dddd	Wochentage lang(Montag)
    ''	M 		Monat von 1-12
    ''	MM 		Monat von 01-12
    '' 	MMM 	Monat kurz(Jun)
    ''	MMMM	Monat lang(Juni)
    '' 	y 		Jahr 0-99
    '' 	yy 		Jahr von 00-99
    ''  yyy 	Jahr mit minimum von 3 Ziffern
    ''	yyyy 	Jahr 4stellig
    ''  alle Textwerte sind abhängig der Definition in Variable "ci"
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    Dim counter As Integer = 10
    Dim nonews As Boolean = False
    Dim _c As String = ""
    Dim css0 As String = ""
    Dim css1 As String = ""
    Dim css2 As String = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

        '' Filter der Kategorie, ansonsten gleich generateincNewsBox
        Dim c As New contentupdate.container()
        c.load(CuPage.ParentId)
        c.languageCode = CUPage.LanguageCode
        _c = c.fields("zennews_catentry_category").value

        Dim os As New contentupdate.objectset()
        'os.loadByName("zennews_newslist")
        os.load(CUPage.Web.Rubrics("Web").Rubrics("ZentraleInhalte").Pages("zenNews").Containers("zennews_news").ObjectSets("zennews_newslist").Id)
        os.LanguageCode = CUPage.LanguageCode
        newslist.name = os.id.toString()

        'newslist.filter = "news_newsentry_cat='" & _c & "'"
        If os.containers.count = 0 Then
            nonews = True
        End If

        If CUpage.LanguageCode = 0 Then
            '''Datumsformat DEU
            dtformat = "dd.MM.yyyy"
        Else
            '''Datumsformat ENG
            dtformat = "yyyy-MM-dd"
            ci = "en-US"
        End If
        If Not c.fields("part_cards__content__width").value = "" Then
            css0 = "content-width-" & c.fields("part_cards__content__width").properties("value").value
        End If
        If Not c.fields("part_cards__bg__colour").value = "" Then
            css1 += "content-bg-" & c.fields("part_cards__bg__colour").properties("value").value
        End If
        If Not c.fields("part_cards__line").value = "" Then
            css2 += "content-line-bottom"
        End If
    End Sub

    Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
            Dim pagelink As Literal = CType(e.Item.FindControl("pagelink"), Literal)
            Dim datetime As Literal = CType(e.Item.FindControl("datetime"), Literal)
            Dim headerimg As Literal = CType(e.Item.FindControl("headerimg"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
            If con.fields("news_newsentry_cat").value = _c Then
                If Not con.fields("news_newsentry_intro").value = "" Then
                    If CountWords(con.Fields("news_newsentry_intro").value) > counter Then
                        formlink.Text = "<div class='lead card-lead'>" & SplitString(con.Fields("news_newsentry_intro").value, counter) & " ..."
                        If formlink.Text.Contains("<p>") Then
                            formlink.Text += "</p>"
                        End If
                        formlink.Text += "</div>"
                    Else
                        formlink.Text = "<div class='lead card-lead'>" & con.Fields("news_newsentry_intro").value & "</div>"
                    End If
                End If
                If Not con.datefields("news_newsentry_date").value = "" And Not con.datefields("news_newsentry_date").value = "01.01.0001" Then
                    Dim _time As String = Date.Parse(con.datefields("news_newsentry_date").value).ToString(dtformat, New System.Globalization.CultureInfo(ci))
                    Dim _datetime As String = Date.Parse(con.datefields("news_newsentry_date").value).ToString(datetimeformat, New System.Globalization.CultureInfo(ci))
                    datetime.Text = "<time datetime='" & _datetime & "'>" & _time & "</time>"
                End If
                Dim p As New ContentUpdate.Page()
                p.load(con.parentpages("newsdetailpage").id)
                p.Preview = CUpage.Preview
                p.LanguageCode = CUpage.LanguageCode
                pagelink.Text = "<a class='card-link-footer' href='" & p.link & "' title='" & con.fields("news_newsentry_title").value & "'>"
                If con.parentpages("newsdetailpage").Publish(CUPage.LanguageCode) = False Then
                    e.Item.Visible = False
                End If
                If con.objectsets("news_bilder_liste").Containers.count > 0 Then
                    headerimg.Text = getImage(con.objectsets("news_bilder_liste"))
                End If


            Else
                e.Item.Visible = False
            End If
        End If
    End Sub
    Function getImage(aOs)
        Dim ret As String = ""
        For Each c As contentupdate.container In aOs.Containers
            If Not c.images("news_bilder_bild").properties("filename").value = "" Then
                ret = "<div class='card-header'>"
                ret += "<figure class='card-image bg-img' style='background-image: url(" & c.images("news_bilder_bild").src & ")'>"
                ret += c.images("news_bilder_bild").tag.replace("border=""0""", "")
                ret += "</figure></div>"
                Exit For
            End If
        Next
        Return ret
    End Function
    Function SplitString(strInput, countWords)
        Dim strTemp As String
        Dim arrTemp As String()
        Dim counter As Integer = 0
        strTemp = Replace(strInput, vbTab, " ")
        strTemp = Replace(strTemp, vbCr, " ")
        strTemp = Replace(strTemp, vbLf, " ")
        strTemp = Trim(strTemp)

        arrTemp = strTemp.Split(" ")
        strTemp = ""

        For counter = 0 To countWords - 1
            strTemp += arrTemp(counter) & " "
        Next

        SplitString = Trim(strTemp)
    End Function
    Public Function CountWords(ByVal value As String) As Integer
        Dim collection As MatchCollection = Regex.Matches(value, "\S+")
        Return collection.Count
    End Function

</script>
<div class="part part-cards part-news part-news-overview ">
    <CU:CUObjectSet name="" runat="server" id="newslist" OnItemDataBound="BindItem">
    	<HeaderTemplate>
            <div class="cards">
        		<div class='cards-con <cu:cufield name="part_cards__display_in_a_row" property="value" runat="server" />'>
        </HeaderTemplate>
        <ItemTemplate>
            <div class='card card-linked <asp:literal id="csslink" runat="server" />' >
                <div class="card-con">
                	<asp:literal id="headerimg" runat="server" />
                    <div class="card-body">
                    	<CU:CUField name="news_newsentry_title" runat="server" tag="h3" tagclass="h3 item-title card-title" />
                    	<asp:literal id="datetime" runat="server" />
                    	<asp:literal id="formlink" runat="server" />
                    </div>
                    <div class="card-footer">
                    	<asp:literal id="pagelink" runat="server" /><CU:CUField name="zennews_news_morelabel" runat="server" /></a>
                    </div>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
        		</div>
    		</div>
    	</FooterTemplate>	
    </cu:cuobjectset>
</div>
