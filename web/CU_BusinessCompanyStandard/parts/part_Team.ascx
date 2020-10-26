<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">

	''Variable für die Entscheidung, ob part ausgegeben wird
	dim part_visible as boolean = false

	dim content as string = ""

	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

		'' Abfrage auf alle Textfelder, welche in dem part vorhanden sind( ObjectClass 5 = Textfeld)
		part_visible = _checkTextFields(container.id)

		'' weiter falls noch keine Inhalte gefunden wurden
		if part_visible = false then
			'' Abfrage auf alle Bilder, welche in dem part vorhanden sind( ObjectClass 6 = Image)
			part_visible = _checkImages(container.id)
		end if

		'' weiter falls noch keine Inhalte gefunden wurden
		if part_visible = false then
			'' Abfrage auf alle Links, welche in dem part vorhanden sind( ObjectClass 12 = Link)
			part_visible = _checkLinks(container.id)
		end if
	End Sub
	Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			con.LanguageCode = CUPage.LanguageCode
			con.Preview = CUPage.Preview
			If Not con.fields("partteamSocialmediaCSSClass").properties("value").value = "" Then
				Dim c As New contentupdate.obj()
				c.load(CInt(con.fields("partteamSocialmediaCSSClass").properties("value").value))
				Dim a As String = "class='icon social " & c.properties("value").value & "'"
				If Not con.links("partteamSocialmediaLink").properties("description").value = "" Then
					formlink.Text = "<li>" & con.links("partteamSocialmediaLink").tag.replace("<a", "<a " & a).replace(con.links("partteamSocialmediaLink").Caption, "<span class='label'>" & con.links("partteamSocialmediaLink").properties("description").value & "</span>") & "</li>"
				Else
					formlink.Text = "<li>" & con.links("partteamSocialmediaLink").tag.replace("<a", "<a " & a).replace(con.links("partteamSocialmediaLink").Caption, "<span class='label'>" & con.fields("partteamSocialmediaCSSClass").value & "</span>") & "</li>"
				End If
			End If
		End If
	End Sub

	Protected Sub ContactBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim contactlink As Literal = CType(e.Item.FindControl("contactlink"), Literal)
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			con.LanguageCode = CUPage.LanguageCode
			con.Preview = CUPage.Preview
			If Not con.fields("partteamContactCSSClass").properties("value").value = "" Then
				Dim c As New contentupdate.obj()
				c.load(CInt(con.fields("partteamContactCSSClass").properties("value").value))
				Dim a As String = "class='icon contact " & c.properties("value").value & "'"
				If Not con.links("partteamContactLink").properties("description").value = "" Then
					contactlink.Text = "<li>" & con.links("partteamContactLink").tag.replace("<a", "<a " & a).replace(con.links("partteamContactLink").Caption, "<span class='label'>" & con.links("partteamContactLink").properties("description").value & "</span>") & "</li>"
				Else
					contactlink.Text = "<li>" & con.links("partteamContactLink").tag.replace("<a", "<a " & a).replace(con.links("partteamContactLink").Caption, "<span class='label'>" & con.links("partteamContactLink").properties("value").value & "</span>") & "</li>"
				End If
			End If
		End If
	End Sub


	Protected Sub EBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
			Dim imglink As Literal = CType(e.Item.FindControl("imglink"), Literal)
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			con.LanguageCode = CUPage.LanguageCode
			con.Preview = CUPage.Preview
			dim s as string = "<strong>"
			if not con.fields("partteamVorname").value = "" then
				s += con.fields("partteamVorname").value & " "
			end if
			if not con.fields("partteamName").value = "" then
				s += con.fields("partteamName").value
			end if
			s += "</strong>"
			if con.fields("partteamVorname").value = "" AND con.fields("partteamName").value = "" Then
				s = ""
			end if
			formlink.text = s
			if not con.images("partteamBild").Properties("filename").value = "" Then
				imglink.Text = "<a style='background-image: url(" & con.images("partteamBild").src & ")' href='" & con.images("partteamBild").alternativeSrc & "' class='bgimg imagelink'>" & con.images("partteamBild").tag.replace("border=""0""", "") & "</a>"
			End if
		End If
	End Sub
</script>
<% if part_visible = true then %>
<div class="part part-team insymaNewThumbs clearfix">
	<cu:cufield name="part_team_Ueberschrift" runat="server" tag="h3" tagclass="h3 item-title" />
	<cu:cuobjectset name="part_team_Liste" runat="server">
        <HeaderTemplate><ul></HeaderTemplate>
        <ItemTemplate>
        	<li>
            	<CU:CUField name="partteamBereichUeberschrift" runat="server" tag="h4" tagclass="h4" />
                <CU:CUField name="partteamBereichLead" runat="server" tag="div" tagclass="lead" />
				<div class="cards">
               		<input type="hidden" name="ihf_row" value='<CU:CUField name="partteamBereichSelectEntries" runat="server" property="value" />' />
					<CU:CUObjectSet name="partteamListEmployee" runat="server"  OnItemDataBound="EBindItem">
						<HeaderTemplate><div class="openInOverlay cards-con"></HeaderTemplate>
						<ItemTemplate>
							<div class="card">
								<div class="card-con">
									<div class="card-header">
										<figure>
											<asp:literal id="imglink" runat="server" />
										</figure>
									</div>

									<div class="card-body">
                            			<asp:literal id="formlink" runat="server" />
                            			<CU:CUField name="partteamFunktion" runat="server" tag="p" />
										<CU:CUField name="partteamStatement" runat="server" tag="div" tagclass="liststyle" />

										<CU:CUObjectSet name="partteamContactList" runat="server" OnItemDataBound="ContactBindItem">
											<HeaderTemplate><ul class="linklist"></HeaderTemplate>
											<ItemTemplate>
												<asp:literal id="contactlink" runat="server" />
											</ItemTemplate>
											<FooterTemplate></ul></FooterTemplate>
										</CU:CUObjectSet>

										<CU:CUObjectSet name="partteamSocialmediaList" runat="server" OnItemDataBound="BindItem">
											<HeaderTemplate><ul class="linklist"></HeaderTemplate>
											<ItemTemplate>
												<asp:literal id="formlink" runat="server" />
											</ItemTemplate>
											<FooterTemplate></ul></FooterTemplate>
										</CU:CUObjectSet>

									</div>

								</div>
							</div>
						</ItemTemplate>
						<FooterTemplate></div></FooterTemplate>
					</CU:CUObjectSet>
				</div>
        	</li>
        </ItemTemplate>
        <FooterTemplate>
			<script type="text/javascript">
				/* <![CDATA[ */
				$("input[name='ihf_row']").each(function () {
					var _val = "item-count-" + $(this).val();
					$(this).next("div").addClass(_val);
				})
            /* ]]> */
            </script>
        </ul>
		</FooterTemplate>
    </cu:cuobjectset>
</div>
<% end if %>