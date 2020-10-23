<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<script runat="server">
    Dim settings As New ContentUpdate.Container()
    dim conid as string = ""
    dim cat as string = ""
    dim b as new contentupdate.container()
    dim i as integer = 0
    dim specVer as string = ""

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        dim c as new Contentupdate.container()
        c.load(CUPage.parentid)
            cat = c.Fields("zen_shop_produkt_categories_entry_cat").Id
        b.loadByName("zen_shop_produkt_label_allg")
        b.preview = CUPage.preview
        b.LanguageCode = CUPage.LanguageCode

        settings.LoadByName("zen_shop_produkt_settings")
        settings.Preview = CUPage.Preview
        settings.LanguageCode = CUPage.LanguageCode
    End Sub

    Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim Link As Literal = CType(e.Item.FindControl("DetailLink"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
            
            If con.Fields("zen_shop_produkte_entry_category").Properties("value").Value = cat And con.Fields("zen_shop_produkte_entry_active").Value = "1" Then
                Link.Text = "<a href='" & con.ParentPages("produktdetail").Link & "' title='" & b.Fields("lbl_detailpage").Value & "'>" & b.Fields("lbl_detailpage").Value & "det</a>"
                If Not con.Fields("zen_shop_produkte_entry_category").Value = "" Then
                    ''Ist Kategorie vergeben?
                    Dim _con As New ContentUpdate.Container()
                    _con.Load(CInt(con.Fields("zen_shop_produkte_entry_category").Properties("value").Value))
                    ''Laden des Eintrages in der Kategorienliste(Id des Kategorienamens-Feldes)
                    _con.Load(_con.ParentId)
                    ''Laden des Elternobjektes(um den wirklichen Eintrag zu haben)
                    specVer = "0"
                    '' kein spezieller(Gutschein-)Versand
                    If _con.Fields("zen_shop_produkt_categories_entry_special").Value = "1" Then
                        ''Ist es spezieller Versand(z.B. ein Gutschein)?
                        specVer = "1"
                    End If
                End If
            Else
                e.Item.Visible = False
            End If
        End If
    End Sub
    'Promotion Bild
    Protected Sub PromotionBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim Bild As Literal = CType(e.Item.FindControl("Bild"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
            If Not con.Fields("zen_shop_produkte_entry_list_promotion_entry_cat").Value = "" Then
                Dim _c As New ContentUpdate.Container()
                _c.Load(CInt(con.Fields("zen_shop_produkte_entry_list_promotion_entry_cat").Properties("value").Value))
                _c.Load(_c.ParentId)
                _c.Preview = CUPage.Preview
                _c.LanguageCode = CUPage.LanguageCode
                Bild.Text = _c.Images("zen_shop_produkt_settings_promotion_entry_icon").Tag.Replace("border=""0""", "class='new-img'")
            End If
        End If
    End Sub
    Protected Sub ProductImageBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim image As Literal = CType(e.Item.FindControl("ProdImage"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim prod_img As ContentUpdate.Image = con.Images("zen_shop_produkte_entry_list_img_entry_img")
            Dim big_img As String = prod_img.Path & prod_img.AlternativeFileName
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
            image.Text = "<a href='" & big_img & "' class='imagelink'><img src='" & prod_img.Src & "' alt='" & prod_img.Caption & "' /></a>"
        End If
    End Sub
    Protected Sub ProductsBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim Bild As Literal = CType(e.Item.FindControl("Bild"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim con_DropDownNumber As New ContentUpdate.Container()  
            Dim wkInput As Literal = CType(e.Item.FindControl("wkInput"), Literal)
            Dim wkButton As PlaceHolder = CType(e.Item.FindControl("wkButton"), PlaceHolder)
            Dim wkStatus As PlaceHolder = CType(e.Item.FindControl("wkStatus"), PlaceHolder)
            Dim parent_id As Literal = CType(e.Item.FindControl("parent_id"), Literal)
            Dim prod_id As Literal = CType(e.Item.FindControl("prod_id"), Literal)
            Dim error_value As Literal = CType(e.Item.FindControl("error_value"), Literal)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
            
            wkInput.Text = "<input type='input' class='shop_menge' vlaue='' id='shop_menge_" & con.Id & "' />"
            error_value.Text = "<span id='error_value_" & con.Id & "' class='hide validation'>"& b.fields("lbl_shop_keineanzahl").value &"</span>"
            parent_id.text = con.parent.parent.id
            prod_id.Text = con.Id
            
            'Show articel only if its active
            e.Item.Visible = False
            If con.Fields("zen_shop_produkte_entry_list_entry_active").Value = "1" Then
                e.Item.Visible = True
            End If
            
            'Get the Status Number instead the Name of Stautslist
            con_DropDownNumber.Load(CInt(con.Fields("zen_shop_produkte_entry_list_entry_status").Properties("value").Value))
            con_DropDownNumber.Load(con_DropDownNumber.ParentId)
            
            'Show only if Status is not 0
            wkStatus.Visible = False
            wkButton.Visible = False
            If CInt(con_DropDownNumber.Fields("zen_shop_produkt_settings_status_entry_number").Value) > 0 Then
                wkButton.Visible = True
            Else
                wkStatus.Visible = True
                wkInput.Text = "<input type='input' class='shop_menge' disabled='disabled' />"
            End If
        End If
    End Sub
</script>


<CU:CUObjectSet name="zen_shop_produkte_list" runat="server" OnItemDataBound="BindItem">
<headertemplate><div class="overview products"><ul></headertemplate>
<footertemplate></ul></div></footertemplate>
<ItemTemplate>
<li>
	<dl>
    	<dt>
            <!-- Product Image -->    
            <div class="part part-bild-text insymaNewThumbs detail">
                <CU:CUObjectSet ID="CUObjectSet1" name="zen_shop_produkte_entry_list_img" runat="server" OnItemDataBound="ProductImageBindItem">
                    <HeaderTemplate></HeaderTemplate>
                    <FooterTemplate></FooterTemplate>
                    <ItemTemplate>
                        <asp:Literal runat="server" id="ProdImage"></asp:Literal>
                    </ItemTemplate>
                </CU:CUObjectSet>
            </div>
            <!-- Promotion Image -->    
            <CU:CUObjectSet name="zen_shop_produkte_entry_list_promotion" runat="server" OnItemDataBound="PromotionBindItem">
                <ItemTemplate>
                    <asp:literal id="Bild" runat="server"  />
                </ItemTemplate>
            </CU:CUObjectSet>
        </dt>
        <dd>
            <h1><CU:CUField name="zen_shop_produkte_entry_name" runat="server" /></h1>
            

            
            <CU:CUObjectSet name="zen_shop_produkte_entry_list_detail" runat="server" OnItemDataBound="ProductsBindItem">
               <HeaderTemplate>
                    <ul class="shop-title" style="display:none;">
                        <li class="menge"><%= b.Fields("lbl_shop_menge").Value%></li>
                        <li class="anzahl"><%= b.Fields("lbl_shop_anzahl").Value%></li>
                        <li class="preis"><%= b.Fields("lbl_shop_preis").Value%></li>
                    </ul>
                </HeaderTemplate>
                <ItemTemplate>
                    <ul class="shop-produkt-detail">
                        <li class="menge">
                            <span class="title"><%= b.Fields("lbl_shop_menge").Value%></span>
                            <CU:CUField name="zen_shop_produkte_entry_list_entry_menge" runat="server" id="size"  />
                            <!-- Lable Error, no Input -->   
                            <asp:literal runat="server" ID="error_value" /> 
                        </li>
                        <li class="anzahl">
                            <span class="title"><%= b.Fields("lbl_shop_anzahl").Value%></span>
                            <asp:literal runat="server" ID="wkInput" /> x 
                        </li>
                        <li class="preis">
                            <span class="title"><%= b.Fields("lbl_shop_preis").Value%></span>
                            <CU:CUField name="zen_shop_produkte_entry_list_entry_price" runat="server"  /> <%=b.fields("lbl_shop_waehrung").value%>
                        </li>
                        <li class="action">
                            <asp:PlaceHolder runat="server" id="wkButton">
                                
                                <button class="wkButton" onclick="insymaShop.addToBasket(<asp:literal runat='server' ID='parent_id' />,<asp:literal runat='server' ID='prod_id' />)"><%=b.fields("lbl_shop_warenkorb").value%></button>
                            </asp:PlaceHolder>
                            <asp:PlaceHolder runat="server" id="wkStatus">
                                <span class="wkStauts"><CU:CUField name="zen_shop_produkte_entry_list_entry_status" runat="server" id="status"  /></span>
                            </asp:PlaceHolder>
                        </li>
                    </ul>
                    <% i+= 1 %>
                </ItemTemplate>
            </CU:CUObjectSet>

            <asp:literal id="DetailLink" runat="server" />
		</dd>
	</dl>
</li>
</ItemTemplate>
</CU:CUObjectSet>