<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: Bilderliste-Part
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Dim i As Integer = 0
    ''Variable für die Entscheidung, ob part ausgegeben wird
    Dim part_visible As Boolean = False

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        '' weiter falls noch keine Inhalte gefunden wurden
        If part_visible = False Then
            '' Abfrage auf alle Bilder, welche in dem part vorhanden sind( ObjectClass 6 = Image)
            part_visible = _checkImages(Container.Id)
        End If
    End Sub
    Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
            if not con.images("part_BilderListe_Bild").Properties("filename").value = "" then
                formlink.Text = "<a style='background-image: url(" & con.images("part_BilderListe_Bild").src & ")' href='" & con.images("part_BilderListe_Bild").alternativeSrc & "' class='bgimg imagelink'>" & con.images("part_BilderListe_Bild").tag.replace("border=""0""","") & "</a>"
            end if
        End If
    End Sub
</script>
<% If part_visible = True Then%>
<div class="part part-bilder-liste ">
    <CU:CUField Name="part_BilderListe_titel" runat="server" Tag="h3" tagclass="h3 item-title" />
    <CU:CUObjectSet Name="part_BilderListe_Liste" runat="server" OnItemDataBound="BindItem">
        <HeaderTemplate>
			<div class="cols"><ul class="openInOverlay">
        </HeaderTemplate>
        <ItemTemplate>
            <li><asp:Literal id="formlink" runat="server" /></li>
        </ItemTemplate>
        <FooterTemplate></ul></div>
        </FooterTemplate>
    </CU:CUObjectSet>
</div>
<% End If%>