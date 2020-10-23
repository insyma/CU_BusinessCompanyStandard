<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
    dim zurKasseButton as string
    dim currenc as string = ""
    dim art as string = ""

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        dim beschrWk as new contentupdate.container
		beschrWk.loadbyname("zen_shop_produkt_label_allg")
		beschrWk.LanguageCode = CUPage.LanguageCode
		beschrWk.Preview = CUPage.Preview
		
        zurKasseButton = beschrWk.links("link_shop_zurkasse").tag.replace(beschrWk.links("link_shop_zurkasse").caption, beschrWk.links("link_shop_zurkasse").properties("Description").value)
		emptybasket.text = beschrWk.fields("lbl_shop_warenkorbleer").value
		subtotal.text = beschrWk.fields("lbl_shop_subtotal").value
		title.text = beschrWk.fields("lbl_shop_warenkorbtitle").value
	End Sub
</script>
<%-- Begin Warenkorb--%>
    <div id="warenkorb" class="part part-warenkorb clearfix" style="display:block;">
        <div id="wk_header">
            <h2><asp:Literal id="title" runat="server" /></h2>
        </div>
        <div id="wk_body">
        </div>
        <div id="wk_emptybasket">
            <asp:Literal id="emptybasket" runat="server" />
        </div>
        <div id="wk_footer">
            <div class="wrap_total"><span class="wk_sub_total_label"><asp:Literal id="subtotal" runat="server" /></span> <span class="wk_sub_total" /></div>
            <%=zurKasseButton%>
        </div>
    </div>
<%-- Ende Warenkorb--%>