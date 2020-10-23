<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<script runat="server">


Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
	

End Sub

Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
   	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		Dim Bild As Literal = CType(e.Item.FindControl("Bild"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
            If Not con.Fields("zen_shop_produkt_categories_entry_cat").Value = "" Then
                Dim os As New ContentUpdate.ObjectSet()
                os.LoadByName("zen_shop_produkte_list")
                For Each c As ContentUpdate.Container In os.Containers

                    If c.Fields("zen_shop_produkte_entry_category").Properties("value").Value = con.Fields("zen_shop_produkt_categories_entry_cat").Id And c.Fields("zen_shop_produkte_entry_active").Value = "1" Then
                        If c.ObjectSets("zen_produkt_culist_img").Containers.Count > 0 Then
                            If Not c.ObjectSets("zen_shop_produkte_entry_list_img").Containers(1).Images("zen_shop_produkte_entry_list_img_entry_img").FileName = "" Then
                                Dim cc As New ContentUpdate.Container()
                                cc.Load(c.ObjectSets("zen_shop_produkte_entry_list_img").Containers(1).Id)
                                cc.LanguageCode = CUPage.LanguageCode
                                cc.Preview = CUPage.Preview
                                Bild.Text = cc.Images("zen_shop_produkte_entry_list_img_entry_img").Tag.Replace("border=""1""", "")
                                Exit For
                            End If
                        End If
                    End If
                Next
            Else
                e.Item.Visible = False
            End If
	End If
End Sub
</script>
<CU:CUObjectSet name="zen_shop_produkt_categories_list" runat="server" OnItemDataBound="BindItem">
<headertemplate><div class="overview category"><ul></headertemplate>
<footertemplate></ul></div></footertemplate>
<ItemTemplate>
<li>
	<dl>
    	<dt>
        	<asp:literal id="Bild" runat="server" />
		</dt>
        <dd>
            <h1><CU:CUField name="zen_shop_produkt_categories_entry_cat" runat="server" /></h1>
            <CU:CULink name="zen_shop_produkt_categories_entry_link" runat="server" />
        </dd>
    </dl>
</li>
</ItemTemplate>
</CU:CUObjectSet>
