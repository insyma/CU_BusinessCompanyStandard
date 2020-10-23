<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
dim ci as string = "de-DE"
dim dtformat as string = ""
dim datetimeformat as string = "yyyy-MM-dd"
dim _c as string = ""
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

Dim counter as Integer = 36

Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
'' Filter der Kategorie, ansonsten gleich generateincNewsBox
	dim c as new contentupdate.container()
	c.load(CuPage.ParentId)
	c.languageCode = CUPage.LanguageCode
	_c = c.fields("zennews_catentry_category").value
	
	dim os as new contentupdate.objectset()
	os.load(CUPage.Web.Rubrics("Web").Rubrics("ZentraleInhalte").Pages("zenNews").Containers("zennews_archive_news").ObjectSets("zennews_archive_newslist").Id)
	os.LanguageCode = CUPage.LanguageCode
	newslist.name = os.id.toString()
	
	'newslist.filter = "news_newsentry_cat='" & _c & "'"

	if CUpage.LanguageCode = 0 then
		'''Datumsformat DEU
		dtformat = "dd.MM.yyyy"
	else
		'''Datumsformat ENG
		dtformat = "yyyy-MM-dd"
		ci = "en-US"
	end if
End Sub

Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
   	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
		Dim pagelink As Literal = CType(e.Item.FindControl("pagelink"), Literal)
		Dim datetime As Literal = CType(e.Item.FindControl("datetime"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
		if con.fields("news_newsentry_cat").value = _c then
			if not con.fields("news_newsentry_intro").value = "" then
				if CountWords(con.Fields("news_newsentry_intro").value) > counter then
					formlink.Text = SplitString(con.Fields("news_newsentry_intro").value, counter) & " ..."
					if formlink.Text.contains("<p>") then
						formlink.Text += "</p>"
					end if
				else
					formlink.Text = "<div>" & con.Fields("news_newsentry_intro").value & "</div>"
				end if
			end if
			if not con.datefields("news_newsentry_date").value = "" and not con.datefields("news_newsentry_date").value = "01.01.0001" then
				dim _time as string = Date.Parse(con.datefields("news_newsentry_date").value).toString(dtformat,New System.Globalization.CultureInfo(ci))
				dim _datetime as string = Date.Parse(con.datefields("news_newsentry_date").value).toString(datetimeformat,New System.Globalization.CultureInfo(ci))
				datetime.text = "<time datetime='" & _datetime & "'>" &_time & "</time>"
			end if
			pagelink.text = "<a href='" & con.parentpages("newsdetailpage").link & "' title='" & con.fields("news_newsentry_title").value & "'>"
			if con.parentpages("newsdetailpage").Publish(CUPage.LanguageCode) = false Then
				e.item.Visible = false
			end if
		else
			e.item.Visible = false
		end if
	End If
End Sub
Function SplitString(strInput, countWords)
	Dim strTemp as String
	Dim arrTemp as String()
	Dim counter as Integer = 0
	strTemp = Replace(strInput, vbTab, " ")
	strTemp = Replace(strTemp, vbCr, " ")
	strTemp = Replace(strTemp, vbLf, " ")
	strTemp = Trim(strTemp)
	
	arrTemp = strTemp.Split(" ")
	strTemp = ""
	
	For counter = 0 to countWords-1
		strTemp += arrTemp(counter) & " "
	next
	
	SplitString = trim(strTemp)
End Function
Public Function CountWords(ByVal value As String) As Integer
    Dim collection As MatchCollection = Regex.Matches(value, "\S+")
    Return collection.Count
End Function

</script>
<CU:CUObjectSet name="" runat="server" id="newslist" OnItemDataBound="BindItem">
<headertemplate><div class="part part-news"><ul></headertemplate>
<footertemplate></ul></div></footertemplate>
<ItemTemplate>
<li>
    
    <asp:literal id="pagelink" runat="server" />
        <dl>
            <dt>
                <asp:literal id="datetime" runat="server" />
            </dt>
            <dd>
                <CU:CUField name="news_newsentry_title" runat="server" tag="span" tagclass="strong" />
                <asp:literal id="formlink" runat="server" />
            </dd>
        </dl>
    </a>
</li>
</ItemTemplate>
</CU:CUObjectSet>