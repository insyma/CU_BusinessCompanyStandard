<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	''  HINU: Grundlagen-Part
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	''Variable für die Entscheidung, ob part ausgegeben wird
	Dim part_visible As Boolean = False

	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

		'' Abfrage auf alle Textfelder, welche in dem part vorhanden sind( ObjectClass 5 = Textfeld)
		part_visible = _checkTextFields(container.id)

		'' weiter falls noch keine Inhalte gefunden wurden
		If part_visible = False Then
			'' Abfrage auf alle Bilder, welche in dem part vorhanden sind( ObjectClass 6 = Image)
			part_visible = _checkImages(container.id)
		End If

		'' weiter falls noch keine Inhalte gefunden wurden
		If part_visible = False Then
			'' Abfrage auf alle Files, welche in dem part vorhanden sind( ObjectClass 9 = File)
			part_visible = _checkFiles(container.id)
		End If

		'' weiter falls noch keine Inhalte gefunden wurden
		If part_visible = False Then
			'' Abfrage auf alle Links, welche in dem part vorhanden sind( ObjectClass 12 = Link)
			part_visible = _checkLinks(container.id)
		End If
	End Sub
	Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
			Dim csslink As Literal = CType(e.Item.FindControl("csslink"), Literal)
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			con.LanguageCode = CUPage.LanguageCode
			con.Preview = CUPage.Preview
			if con.images("part_cards__entry__img").properties("filename").value = "" Then
				e.item.visible = false
			end if
			If Not con.links("part_cards__entry__link").Properties("Value").Value = "" Then
				csslink.Text = "card-linked"
			End If
		End If
	End Sub


</script>
<% If part_visible = True Then%>
<div class="part part-cards">
    <cu:cufield name="part_cards__title" runat="server" tag="h3" tagclass="h3 item-title" />

    <cu:cuobjectset name="part_cards__list" runat="server" OnItemDataBound="BindItem">
            <HeaderTemplate><div class="cards">
    <div class='cards-con <cu:cufield name="part_cards__display_in_a_row" property="value" runat="server" />'>
            </HeaderTemplate>
            <ItemTemplate>
                <div class='card <asp:literal id="csslink" runat="server" />' >
	                <CU:CULink name="part_cards__entry__link" runat="server" class="card-link" />
	                <div class="card-con">
                        <div class="card-header">
                            <figure class="card-image bg-img" style="background-image: url('<CU:CUImage name="part_cards__entry__img" runat="server" property="src" />') " >
                                <CU:CUImage name="part_cards__entry__img" runat="server"  />
                            </figure>
    	                
                        </div>
                        <div class="card-body">
	                        <CU:CUField name="part_cards__entry__title" runat="server" tag="h3" tagclass="h3 item-title card-title" />
	                        <CU:CUField name="part_cards__entry__lead" runat="server" tag="div" tagclass="lead card-lead" />
	                        <CU:CUField name="part_cards__entry__text" runat="server" tag="div" tagclass="liststyle card-text" />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate>
</div></div>
</FooterTemplate>
        </cu:cuobjectset>




</div>
<% End If%>