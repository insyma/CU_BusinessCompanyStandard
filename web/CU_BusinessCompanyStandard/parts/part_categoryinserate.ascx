<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Dim FilterTyp As String
	Dim DasObjekt as CUObjectSet
	Dim Kategorie as String
	Dim kontakt as string
	Dim tel as String
	Dim fax as String
	Dim preis as string
	Dim Counter as integer = 0
	Dim gesamtanzahl as string
	Dim seiten as string
	dim inseratecount as integer
	dim _trubrik as string = ""
	Dim wID as String
	dim imgpath as string = ""
	dim angebote as string
	dim gesuche as string
	dim zurueck as string
	dim Art1 as string = ""
	dim Art2 as string = ""
	dim MasterArt1 as integer = 0
	dim MasterArt2 as integer = 0
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
		wID = Request.Querystring("WebId")
		Kategorie = Container.Fields("blackboard_entry_kategorie").value
		Container.LoadByName("Blackboard_OnlineEntries")
		dim con as new ContentUpdate.Container
		con.loadByName("blackboard_arten")
		con.LanguageCode = Container.LanguageCode
		if con.objectsets("culist_blackboard_arten").containers.count > 1 then
			Art1 = con.objectsets("culist_blackboard_arten").containers(1).fields("blackboard_art_entry").id
			Art2 = con.objectsets("culist_blackboard_arten").containers(2).fields("blackboard_art_entry").id
		end if
		dim _tpage as new contentupdate.Page
		_tPage.LoadByName("masterpageArt1")
		MasterArt1 = _tPage.Id
		_tPage.LoadByName("masterpageArt2")
		MasterArt2 = _tPage.Id
		dim conBeschr as new ContentUpdate.Container
		conBeschr.Load(916)
		conBeschr.LanguageCode = CUPage.LanguageCode 
		zurueck = conBeschr.fields("Zurueck").value
		if CUPage.Preview = true then
			imgpath =  "cuimgpath/"
		end if
		Dim objset as new ContentUpdate.ObjectSet
		objset.Load(Container.ObjectSets("culist_OnlineEntries").Id)
		objset.Filter = "Kategorie='" & Kategorie & "'"
		
		if CUPage.Id = MasterArt1 then
			_trubrik = Art1
			if CuPage.LanguageCode = 1 then
				_trubrik = Art1
			end if
		else if  CUPage.Id = MasterArt2 then
			_trubrik = Art2
			if CuPage.LanguageCode = 1 then
				_trubrik = Art2
			end if
		end if		

		If (Container.ObjectSets("culist_OnlineEntries").Containers.Count = 0) Then
            If (CUPage.LanguageCode = 1) Then
                linkText.Text = "Il n'y a pas d'entr�e"
            Else
                linkText.Text = "Leider sind momenten keine Eintr�ge vorhanden"
            End If
        Else
            linkText.Visible = False
        End If
		dim cont as new ContentUpdate.Container
		cont.loadByName("blackboard_beschriftung")
		cont.LanguageCode = Container.LanguageCode
		kontakt = cont.fields("kontaktdaten").value
		preis = cont.fields("preis").value
		gesamtanzahl = cont.fields("gesamtanzahl").value 
		seiten = cont.fields("seiten").value 
		inseratecount = CInt(cont.fields("inseratecount").value)
		tel = cont.fields("tel").value
		fax = cont.fields("fax").value
	End Sub

    Dim MailLink As HtmlAnchor

	Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Header) Then
			Dim inserateArt As Literal = CType(e.Item.FindControl("inserateArt"), Literal)
			if _trubrik = Art1 then
				inserateArt.text = angebote
			else
				inserateArt.text = gesuche
			end if
		End If
		
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			con.LanguageCode = Container.LanguageCode
			Dim image1 As Literal = CType(e.Item.FindControl("image1"), Literal)
			Dim image2 As Literal = CType(e.Item.FindControl("image2"), Literal)
			Dim image3 As Literal = CType(e.Item.FindControl("image3"), Literal)
			Dim image4 As Literal = CType(e.Item.FindControl("image4"), Literal)
			Dim counting As Literal = CType(e.Item.FindControl("counting"), Literal)
			
			con.Preview = CUPage.Preview
			'response.write("<br /> -- " & con.fields("Kategorie").value & " = " & Kategorie & " && " & con.fields("aktiv").value & "= 1 && " & _trubrik & " = " & con.fields("art").properties("value").value)
			if con.fields("blackboard_entry_kategorie").value = Kategorie AND con.fields("blackboard_entry_aktiv").value = "1" AND _trubrik =  con.fields("blackboard_entry_art").properties("value").value then
				' ## Hier wird die E-Mail Adresse mit einem mailto: versehen
				If con.Fields("blackboard_entry_email").Value <> "" Then
					MailLink = CType(e.Item.FindControl("MailLink"), HtmlAnchor)
					MailLink.InnerHtml = con.Fields("blackboard_entry_email").Value
				End If
				
				Dim imageLink1 As HtmlAnchor = CType(e.Item.FindControl("imageLink1"), HtmlAnchor)
				Dim imageLink2 As HtmlAnchor = CType(e.Item.FindControl("imageLink2"), HtmlAnchor)
				Dim imageLink3 As HtmlAnchor = CType(e.Item.FindControl("imageLink3"), HtmlAnchor)
				Dim imageLink4 As HtmlAnchor = CType(e.Item.FindControl("imageLink4"), HtmlAnchor)
				If con.Images("blackboard_entry_bild1").Filename = "" Then
					imageLink1.Visible = False
				Else
						imageLink1.HRef = "../img/blackboard/" & imgpath & con.Images("blackboard_entry_bild1").AlternativeProcessedFilename
						image1.text = "<img src='../img/blackboard/" & imgpath & con.Images("blackboard_entry_bild1").ProcessedFilename & "' alt='" & con.Images("blackboard_entry_bild1").legend & "' />"
				End If
				If con.Images("blackboard_entry_bild2").Filename = "" Then
					imageLink2.Visible = False
				Else
						imageLink2.HRef = "../img/blackboard/" & imgpath & con.Images("blackboard_entry_bild2").AlternativeProcessedFilename
						image2.text = "<img src='../img/blackboard/" & imgpath & con.Images("blackboard_entry_bild2").ProcessedFilename & "' alt='" & con.Images("blackboard_entry_bild2").legend & "' />"
				End If
				If con.Images("blackboard_entry_bild3").Filename = "" Then
					imageLink3.Visible = False
				Else
						imageLink3.HRef = "../img/blackboard/" & imgpath & con.Images("blackboard_entry_bild3").AlternativeProcessedFilename
						image3.text = "<img src='../img/blackboard/" & imgpath & con.Images("blackboard_entry_bild3").ProcessedFilename & "' alt='" & con.Images("blackboard_entry_bild3").legend & "' />"
				End If
				If con.Images("blackboard_entry_bild4").Filename = "" Then
					imageLink4.Visible = False
				Else
						imageLink4.HRef = "../img/blackboard/" & imgpath & con.Images("blackboard_entry_bild4").AlternativeProcessedFilename
						image4.text = "<img src='../img/blackboard/" & imgpath & con.Images("blackboard_entry_bild4").ProcessedFilename & "' alt='" & con.Images("blackboard_entry_bild4").legend & "' />"
				End If
				Counter += 1
				if counter <= inseratecount then
				counting.Text = " xid = '" & counter & "' style='display:block;'"
			else
				counting.Text = " xid = '" & counter & "' style='display:none;'"
			end if
			else
				e.item.visible = false
			end if
        End If
		If (e.Item.ItemType = ListItemType.Footer) Then
			Dim itemcount As Literal = CType(e.Item.FindControl("itemcount"), Literal)
			Dim itemcount2 As Literal = CType(e.Item.FindControl("itemcount2"), Literal)
			Dim pageID As Literal = CType(e.Item.FindControl("pageID"), Literal)
			pageID.text = CUPage.ID
			if Counter > inseratecount
				itemcount.Text = "<span class='gesamtseiten'>" & gesamtanzahl & " <strong>" & Counter & "</strong>" & "</span><span class='seiten'>" & seiten & _getPaging(Counter) & "</span>"
			else
				itemcount.Text = gesamtanzahl & " <strong>" & Counter & "</strong>"
			end if
			itemcount2.Text = Counter
		End if
    End Sub
Function _getPaging(aValue)
	dim i as integer
	dim x as integer = 1
	dim returnvalue as string = ""
		for i = 0 to aValue
			'response.write("<br />--" & inseratecount & "  " & i mod inseratecount)
			if i mod inseratecount = 1 AND i > 0 then
				if x = 1 then
					returnvalue += " <a href=""#"" id=""a_bottom_" & x & """ onclick=""javascript: _showPages(" & x & ", " & inseratecount & ")"" class='active'>" & x & "</a>"
				else
					returnvalue += " <a href=""#"" id=""a_bottom_" & x & """ onclick=""javascript: _showPages(" & x & ", " & inseratecount & ")"" class='inactive'>" & x & "</a>"
				end if
			   x += 1
			end if
		next
		
	return returnvalue
End Function


</script>

<div class="part part-blackboard-out">

<CU:CUObjectSet Name="culist_OnlineEntries" ID="CUList" runat="server" onItemDataBound="BindItem">
<HeaderTemplate><h1><asp:Literal id="inserateArt" runat="server" /> <%=Kategorie %></h1><p id="paging_top" class="bb_paging"></p><ul class="inserate"></HeaderTemplate>
<ItemTemplate>
<li <asp:literal id="counting" runat="server" /> class="Li_xid" id='li__<%# CType(Container.DataItem,ContentUpdate.Container).ID %>'>
<div class="insymaImgThumbs">
	<ul>
		<li class="left">
			<CU:CUDate Name="blackboard_entry_datum" runat="server" tag="em" DateFormat="d" DateCulture="de-CH" />
			<CU:CUField ID="titel" Name="blackboard_entry_titel" runat="server" tag="h4"/>
            
                <p><CU:CUField Name="blackboard_entry_description" runat="server" /></p>
         </li>
         <li class="images">
			<a id="imageLink1" runat="server" title="">
				<asp:Literal id="image1" runat="server" />
			</a>
			<a id="imageLink2" runat="server" title="">
				<asp:Literal id="image2" runat="server" />
			</a>
			<a id="imageLink3" runat="server" title="">
				<asp:Literal id="image3" runat="server" />
			</a>
			<a id="imageLink4" runat="server" title="">
				<asp:Literal id="image4" runat="server" />
			</a>
		</li>
        <li class="kontaktdaten">
            <p><em><%=kontakt %>:</em></p>
            <p><a href="" ID="MailLink" runat="server" /></p>
            <table>
                <tr>
                    <td><CU:CUField  Name="blackboard_entry_vorname" runat="server" /> <CU:CUField  Name="blackboard_entry_name" runat="server" /> </td>
                </tr>
              <tr>
                <td><CU:CUField  Name="blackboard_entry_strasse" runat="server" /></td>
              </tr>
              <tr>
                <td><CU:CUField  Name="blackboard_entry_plz" runat="server" /> <CU:CUField  Name="blackboard_entry_ort" runat="server" /></td>
              </tr>
            </table>
            <table>
              <tr>
                <td><%=tel %></td>
                <td><CU:CUField Name="blackboard_entry_telefon" runat="server" /></td>
              </tr>
              <tr>
                <td><%=fax %></td>
                <td><CU:CUField Name="blackboard_entry_fax" runat="server" /></td>
              </tr>
            </table>		
		</li>
		
	</ul>
</div>
</li>
</ItemTemplate>
<FooterTemplate>
	<li class="bb_paging" id="paging_bottom">
    	<asp:Literal id="itemcount" runat="server" />
        <script type="text/javascript">
			var counter = '<asp:Literal id="itemcount2" runat="server" />'
			var pageID = '<asp:Literal id="pageID" runat="server" />'
        	if (parseInt(counter) > 0){
				__HandleObjectInnerHTML("paging_bottom","paging_top");
			}
    	</script>
	</li>
</ul></FooterTemplate>
</CU:CUObjectSet>
<asp:Literal id="linkText" runat="server" />
<p class="clearBorderBottom"><a href="javascript:history.back();"><%  If CUPage.Preview Then %><img src="../img/layout/pfeil_zurueck.gif" alt="zur�ck" /><% Else %><img src="/img/layout/pfeil_zurueck.gif" alt="zur�ck" /><% End If %>&nbsp; <%= zurueck %></a></p>
</div>

