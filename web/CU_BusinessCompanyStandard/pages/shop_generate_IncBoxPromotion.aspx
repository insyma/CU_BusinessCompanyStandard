<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<script runat="server">

dim cat as string = ""
dim b as new contentupdate.container()
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
	dim c as new Contentupdate.container()
	c.load(CUPage.parentid)
        cat = c.Fields("zen_shop_produkt_settings_promotion_entry_name").Id
	b.loadByName("zen_produkt_label_allg")
	b.preview = CUPage.preview
	b.LanguageCode = CUPage.LanguageCode
End Sub

Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
   	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
		
	End If
End Sub
</script>

<CU:CUObjectSet name="zen_shop_produkt_settings_promotion_list" runat="server" OnItemDataBound="BindItem">
<headertemplate><div class="box Promotion">Titel::<CU:CUField name="lbl_promo_sidebar" runat="server" tag="h3" tagclass="h3 item-title" /><ul></headertemplate>
<footertemplate></ul></div></footertemplate>
<ItemTemplate>
<li>
	<CU:CULink name="zen_shop_produkt_settings_promotion_entry_link" runat="server" />
</li>
</ItemTemplate>
</CU:CUObjectSet>
