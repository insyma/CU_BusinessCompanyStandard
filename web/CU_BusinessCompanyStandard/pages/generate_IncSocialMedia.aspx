<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
	dim con as new contentupdate.container
	dim content as string = ""
	Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
		'con.loadByName("SocialMediaCon")
		con.load(CUpage.containers("SocialMediaCon").id)
		con.languageCode = CUpage.LanguageCode
		con.Preview = CUPage.Preview
		content0.name = con.id
	End Sub
	Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			con.LanguageCode = CUPage.LanguageCode
			con.Preview = CUPage.Preview
			if not con.fields("ConSocialMediaCSSClass").properties("value").value = "" then
				dim c as new contentupdate.obj()
				c.load(cint(con.fields("ConSocialMediaCSSClass").properties("value").value))
				Dim a As String = "<i class='icon social " & c.properties("value").value & "'></i>"
				formlink.Text = "<li>" & con.links("ConSocialMediaLink").tag.replace("<a", "<a ").replace(con.links("ConSocialMediaLink").Caption, "<i class='icon social " & c.properties("value").value & "'></i><span class='label hide'>" & con.fields("ConSocialMediaCSSClass").value & "</span>") & "</li>"
			End if
		End If
	End Sub
</script>
<CU:CUContainer name="" id="content0" runat="server">
    <CU:CUObjectSet name="ConSocialMediaList" runat="server" OnItemDataBound="BindItem">
		<headertemplate><ul class="control con-socialmedia"></headertemplate>
        <ItemTemplate>
            <asp:literal id="formlink" runat="server" />
        </ItemTemplate>
		<footertemplate></ul></footertemplate>
    </CU:CUObjectSet>
</CU:CUContainer>          
