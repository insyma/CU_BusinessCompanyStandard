<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<script runat="server">

dim cat as string = ""
dim b as new contentupdate.container()
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
	dim c as new Contentupdate.container()
	c.load(CUPage.parentid)
	cat = c.fields("zen_produkt_promotions_name").id
	b.loadByName("zen_produkt_label_allg")
	b.preview = CUPage.preview
	b.LanguageCode = CUPage.LanguageCode
End Sub

Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
   	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		Dim Bild As Literal = CType(e.Item.FindControl("Bild"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
		if con.fields("zen_produkt_active").properties("value").value = "1" Then
			if con.objectsets("zen_produkt_culist_promo").containers.count > 0 then
				dim vis as boolean = false
				for each c as contentupdate.container in con.objectsets("zen_produkt_culist_promo").containers	
					if c.fields("zen_produkt_cuentry_promo_cat").properties("value").value = cat
						vis = true
						exit for
					end if
				next
				if vis = true then
					if con.objectsets("zen_produkt_culist_img").containers.count > 0 Then
						if not con.objectsets("zen_produkt_culist_img").containers(1).images("zen_produkt_cuentry_img_img").filename = "" then
							dim cc as new contentupdate.container()
							cc.load(con.objectsets("zen_produkt_culist_img").containers(1).id)
							cc.LanguageCode = CUPage.LanguageCode
							cc.Preview = CUPage.Preview
							Bild.text = cc.images("zen_produkt_cuentry_img_img").tag.replace("border=""1""","")
						end if
					end if
				else
					e.item.visible = false
				end if
			else
				e.item.visible = false
			end if
		else
			e.item.visible = false
		end if
	End If
End Sub
</script>
<CU:CUObjectSet name="zen_produkte_list" runat="server" OnItemDataBound="BindItem">
<headertemplate><div class="overview products"><ul></headertemplate>
<footertemplate></ul></div></footertemplate>
<ItemTemplate>
<li>
	<asp:literal id="Bild" runat="server" />
	<div class="textcon">
        <CU:CUField name="zen_produkt_name" runat="server" tag="h1" />
        <CU:CUPageLink name="produktdetail" ParentPage="true" runat="server">
            <%=b.fields("lbl_produktdetail").value%>
        </CU:CUPageLink>
	</div>
</li>
</ItemTemplate>
</CU:CUObjectSet>
