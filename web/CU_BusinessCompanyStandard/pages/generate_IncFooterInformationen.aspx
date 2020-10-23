<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
	Dim what as string = ""
	dim acc as string = ""
	dim txt as string = ""
	Dim con As New contentupdate.container
	Dim con_links As New contentupdate.container
	Dim content As String = ""
	Dim tracking as boolean = false
	dim b as new contentupdate.container()
	dim labels as boolean = false
	Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
		'con.loadByName("FooterInfoCon")
		con.load(CUPage.containers("FooterInfoCon").containers("FooterAddressCon").id)
		con.languageCode = CUpage.LanguageCode
		con.Preview = CUPage.Preview
		content0.name = con.id
		' link container
		con_links.load(CUPage.containers("FooterInfoCon").containers("footer_con_links").id)
		con_links.languageCode = CUpage.LanguageCode
		con_links.Preview = CUPage.Preview
		content_links.name = con_links.id

		Dim f As New contentupdate.field()
		'f.loadByName("analyticsclicktracking")
		f.load(CUPage.Web.rubrics("Web").rubrics("Seiteneinstellungen").pages("google").containers("GoogleanalyticsContainer").fields("analyticsclicktracking").id)
		if f.value = "1" AND CUPage.Preview = false AND CUPage.Web.Liveserver.Contains("test.") = false then
			tracking = true
		end if
		'b.loadByName("FooterLabelCon")
		b.load(CUPage.containers("FooterInfoCon").containers("FooterLabelCon").id)
		b.LanguageCode = CUpage.LanguageCode
		if not b.fields("FooterLabel_ContactShowHide").value = "" then
			labels = true
		end if

	End Sub
	function mailadresse(aStr as string)
		dim ret as string = ""
		'response.write("<!--" & aStr & "-->")
		ret = StrReverse(aStr)
		'response.write("<!--" & ret & "-->")
		ret = "L_" & ret.replace("@", "--").replace(".","__")
		'response.write("<!--" & ret & "-->")
		return ret
	end function
	'' Footernavigation
	Private Sub BindItem(Sender As Object, e As RepeaterItemEventArgs)

		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim pageLink as Literal = CType(e.Item.FindControl("pageLink"), Literal)
			Dim navPage as ContentUpdate.Obj = CType(e.Item.DataItem, ContentUpdate.Obj)
			navPage.Preview=CUPage.Preview
			navPage.LanguageCode = CUPage.LanguageCode
			'if navart = "servicenavigation" then
			'if sender.id <> "Navigation" then
			'e.item.visible = false
			'end if
			'end if
			if not navPage.navigable then
				e.Item.visible = false
			end if

			pageLink.Text = "<a href='" & navPage.Link & "' title='" & navPage.Caption & "'>" & navPage.Caption.replace("®","<sup>®</sup>").replace("&reg;", "<sup>&reg;</sup>") & "</a>"
			if navPage.id = 25334 then
				pageLink.Text = "<a class='speciallink shop' href='" & navPage.Link & "' title='" & navPage.Caption & "'><span class='icon shoplink'></span>" & navPage.Caption.replace("®","<sup>®</sup>").replace("&reg;", "<sup>&reg;</sup>") & "</a>"
			end if

			If navPage.Pages.NaviPages.Count() > 0 Then
				if(navPage.Containers("Inhalt").Containers.Count = 0) then
					pageLink.Text = "<a href='" & navPage.Pages.NaviPages(0).Link & "' title='" & navPage.Caption & "'>" & navPage.Caption.replace("®","<sup>®</sup>").replace("&reg;", "<sup>&reg;</sup>") & "</a>"
				end if
			else
				'Abfrage auf den Redirect-Part
				for each _tcon as contentupdate.container in navPage.Containers("Inhalt").Containers
					if _tcon.objname = "part_redirect" then
						if _tcon.links("zielurl").properties("value").value <> "" then
							if _tcon.links("zielurl").properties("Intern").value = "True" then
								dim _tpage as new contentupdate.page
								_tpage.load(cint(_tcon.links("zielurl").properties("value").value))
								_tpage.preview = cupage.preview
								_tpage.LanguageCode = cupage.Languagecode
								pageLink.Text = "<a href='" & _tpage.link & "'>" & navPage.Caption & "</a>"
							else
								pageLink.Text = "<a title='" & navPage.Caption & "' target='_blank' href='" & _tcon.links("zielurl").properties("value").value & "'>" & navPage.Caption & "</a>"
							end if
						end if
						exit for
					end if
				next
			End If
			for each _tcon as contentupdate.container in navPage.Containers("Inhalt").Containers
				if _tcon.objname = "part_tooltipp" then
					if not  _tcon.fields("tooltipp_text").value = "" then
						pageLink.Text = pageLink.Text & "<span class='nav_tooltipp hide'>" & _tcon.fields("tooltipp_text").value & "</span>"
					end if
					exit for
				end if
			next
		End If

	End Sub
	Protected Sub CBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim content As Literal = CType(e.Item.FindControl("content"), Literal)
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			con.LanguageCode = CUPage.LanguageCode
			con.Preview = CUPage.Preview
			dim str1 as string = ""
			dim klick as string = ""
			'''phone#Telefon;fax#Fax;mail#E-Mail;web#Web-Adresse
			''''Link gefüllt?
			if not con.links("FooterInfoCon_Address_ContactLink").properties("value").value = "" then
				if tracking = true then
					if con.fields("FooterInfoCon_Address_ContactType").properties("value").value = "iconphone" then
						klick = "onclick='_gaq.push([""_trackEvent"",""Phone"",""Click"",""" & con.links("FooterInfoCon_Address_ContactLink").properties("value").value & """])'"
					else if con.fields("FooterInfoCon_Address_ContactType").properties("value").value = "iconmail" then
						klick = "onclick='_gaq.push([""_trackEvent"",""EMail"",""Click"",""" & con.links("FooterInfoCon_Address_ContactLink").properties("value").value & """])'"
					end if
				end if
				str1 = "<li><dl><dt class='icon contacticon " & con.fields("FooterInfoCon_Address_ContactType").properties("value").value & "'>"
				if labels = true Then
					str1 = "<li><span class='label'>"
					str1 += "<span>" & con.fields("FooterInfoCon_Address_ContactType").value & "</span>"
				End If
				str1 += "</span><span class='value'>"
				''andere Caption?
				If not con.fields("FooterInfoCon_Address_ContactText").value = "" then
					str1 += con.links("FooterInfoCon_Address_ContactLink").tag.replace(con.links("FooterInfoCon_Address_ContactLink").caption, con.fields("FooterInfoCon_Address_ContactText").value)
				else if not con.links("FooterInfoCon_Address_ContactLink").properties("Description").value = "" then
					str1 += con.links("FooterInfoCon_Address_ContactLink").tag.replace(con.links("FooterInfoCon_Address_ContactLink").caption, con.links("FooterInfoCon_Address_ContactLink").properties("Description").value)
				else
					str1 += con.links("FooterInfoCon_Address_ContactLink").tag
				end if
				str1 = str1.replace("<a", "<a " & klick) & "</span>"
			else if not con.fields("FooterInfoCon_Address_ContactText").value = "" then

				if labels = true Then
					str1 += "<li><span class='label'>"
					str1 += "<span>" & con.fields("FooterInfoCon_Address_ContactType").value & "</span>"
				Else
					str1 += "<li><span class='icon contacticon " & con.fields("FooterInfoCon_Address_ContactType").properties("value").value & "'>"
				End If
				str1 += "</span>" & "<span class='value'>" & con.fields("FooterInfoCon_Address_ContactText").value & "</span>"
			End If

			str1 += "</li>"
			content.text = str1

		End If
	End Sub
	Protected Sub AddressBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			Dim streetLi As HtmlControl = CType(e.Item.FindControl("street"), HtmlControl)
			Dim cityLi As HtmlControl = CType(e.Item.FindControl("city"), HtmlControl)
			Dim countryLi As HtmlControl = CType(e.Item.FindControl("country"), HtmlControl)
			con.LanguageCode = CUPage.LanguageCode
			con.Preview = CUPage.Preview

			if con.Fields("FooterInfoCon_Address_Street").value = "" AND con.Fields("FooterInfoCon_Address_StreetNumber").value = ""  then
				streetLi.visible = false
			end if
			if con.Fields("FooterInfoCon_Address_City").value = "" AND con.Fields("FooterInfoCon_Address_ZIP").value = "" then
				cityLi.visible = false
			end if
			if con.Fields("FooterInfoCon_Address_Country").value = "" AND con.Fields("FooterInfoCon_Address_CountryCode").value = "" then
				countryLi.visible = false
			end if

		End If
	End Sub
</script>

<CU:CUContainer name="" id="content0" runat="server">
	<div class="con-footer-address">
		<ul>
			<li>
				<CU:CUField name="footer_title" runat="server" tag="h4" tagclass="h4 item-title" />
				<CU:CUObjectSet name="FooterInfoCon_AddressList" runat="server" onitemdatabound="AddressBindItem">
					<ItemTemplate>
						<div class="con-address">
							<CU:CUField name="FooterInfoCon_Address_Name" runat="server"  />
							<ul class="list">
								<CU:CUField name="FooterInfoCon_Address_NameAdditional" runat="server" tag="li" />
								<li runat="server" id="street"><CU:CUField name="FooterInfoCon_Address_Street" runat="server" /> <CU:CUField name="FooterInfoCon_Address_StreetNumber" runat="server" /></li>
								<CU:CUField name="FooterInfoCon_Address_StreetAdditional" runat="server" tag="li" />
								<li runat="server" id="city"><CU:CUField name="FooterInfoCon_Address_ZIP" runat="server" /> <CU:CUField name="FooterInfoCon_Address_City" runat="server" /></li>
								<li runat="server" id="country"><CU:CUField name="FooterInfoCon_Address_CountryCode" runat="server" /> <CU:CUField name="FooterInfoCon_Address_Country" runat="server" /></li>
								<CU:CUObjectSet name="FooterInfoCon_Address_ContactList" runat="server" OnItemDataBound="CBindItem">
									<headertemplate><li><ul class="con-address-contact-options"></headertemplate>
									<ItemTemplate>
										<asp:literal id="content" runat="server" />
									</ItemTemplate>
									<footertemplate></ul></li></footertemplate>
								</CU:CUObjectSet>
							</ul>
						</div>
					</ItemTemplate>
				</CU:CUObjectSet>
				<CU:CUField name="FooterInfo" runat="server" tag="div" tagclass="hide" />
			</li>
		</ul>
	</div>
</CU:CUContainer>         

<CU:CUContainer name="" id="content_links" runat="server">
	<div class="con-footer-links">
		<CU:CUField name="footer_con_links__title" runat="server" tag="span" tagclass="h4 item-title" />
		<CU:CUObjectSet name="footer_con_links__list" runat="server" >
			<headertemplate><ul class="list list-level-1"></headertemplate>
			<footertemplate></ul></footertemplate>
			<ItemTemplate>
				<li class="item">
					<CU:CUField name="footer_con_links__list_entry__title" runat="server" tag="span" tagclass="item-title" />
					<CU:CUObjectSet name="footer_con_links__list_entry__list" runat="server" >
						<headertemplate><ul class="list list-level-2"></headertemplate>
						<footertemplate></ul></footertemplate>
						<ItemTemplate>
							<li class="item">
								<CU:CULink name="footer_con_links__list_entry__list_entry__link" runat="server" tag="h4"  tagclass="item-link" />
								<CU:CUField name="footer_con_links__list_entry__list_entry__text" runat="server" />
							</li>
						</ItemTemplate>
					</CU:CUObjectSet>
				</li>
			</ItemTemplate>
		</CU:CUObjectSet>


	</div>
</CU:CUContainer>          
