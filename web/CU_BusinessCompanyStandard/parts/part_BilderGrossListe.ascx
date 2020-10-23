<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: Bilderliste Gross -Part
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    dim css as string = ""
    dim css2 as string = ""

    ''Variable für die Entscheidung, ob part ausgegeben wird
    dim part_visible as boolean = false
    Dim position as integer
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

        ' ### Wenn mehr als ein Bild erfasst ist wurde früher das JavaScript insymaImageAddition eingefügt für das Blättern zwischen den Bildern (nächstes, vorheriges)
        if Container.ObjectSets("part_BilderGrossListe_Liste").Containers.Count > 1 then
            'showscript.Text = "<script type=""text/javascript"" src=""../js/insymaImageAddition.js""></sc" & "ript>"
            css = "slides"
            css2= "flex-bildergrossliste flexLoading"
        end if

        '' weiter falls noch keine Inhalte gefunden wurden
        if part_visible = false then
            '' Abfrage auf alle Bilder, welche in dem part vorhanden sind( ObjectClass 6 = Image)
            part_visible = _checkImages(container.id)
        end if
        position = getPositioninContent(Container.ParentID, Container.ID)
    End Sub

    Protected Sub BindImage(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Header) Then

        End If

        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            'Dim bildlegende As CUImage = CType(e.Item.FindControl("bildlegende"), CUImage)
            Dim bild As CUImage = CType(e.Item.FindControl("part_BilderGrossListe_Bild"), CUImage)
            Dim bildlink As Literal =  CType(e.Item.FindControl("bildlink"), Literal)
            Dim bildchen As String = ""

            'Skip entry if there is no image
            If con.images("part_BilderGrossListe_Bild").properties("Filename").value = "" Then
                e.Item.Visible = False
            End If

            ' ### Wenn eine Beschreibung erfasst ist wird die Bildlegende ausgeblendet, ansonsten wird die Bildlegende angezeigt.
            If con.Fields("part_BilderGrossListe_Beschreibung").Value <> "" then
                'bildlegende.visible = false
            end if

            ' Wenn Bildlink erfasst ist, Bild mit Link ausgeben
            If con.Links("part_BilderGrossListe_BildLink").Properties("Value").Value <> "" Then
                bildchen = "<a style='background-image: url(" & con.images("part_BilderGrossListe_Bild").src & ")' class='bgimg imagelink imagelinkexternal icon' target='"& con.Links("part_BilderGrossListe_BildLink").Properties("Target").Value &"' title='" & con.Images("part_BilderGrossListe_Bild").AlternativeSrc.replace("border=""0""","") & "' data-overlay-img='" & con.Images("part_BilderGrossListe_Bild").AlternativeSrc & "' href='" & con.Links("part_BilderGrossListe_BildLink").Properties("Value").Value & "'>" & con.Images("part_BilderGrossListe_Bild").Tag.replace("border=""0""","") & "</a>"
                'part_BilderGrossListe_Bildlink.Text = "<a class='imagelink' href='" & con.Images("part_BilderGrossListe_Bild").AlternativeSrc & "'>" & con.Images("part_BilderGrossListe_Bild").Tag & "</a>"
                ' ### Wenn Bildlink NICHT erfasst ist, Bild mit Overlay ausgeben
            Else
                'insymaImageThumbClass.Text = " insymaImgThumbs"
                If con.images("part_BilderGrossListe_Bild").properties("Filename").value <> "" Then
                    bildchen = "<a data-fancybox='gallery0" & position & "' data-caption style='background-image: url(" & con.images("part_BilderGrossListe_Bild").src & ")' class='bgimg imagelink icon' href='" & con.Images("part_BilderGrossListe_Bild").AlternativeSrc.replace("border=""0""", "") & "'>" & con.Images("part_BilderGrossListe_Bild").Tag.replace("border=""0""", "") & "</a>"
                End If
                'bild.Popup = "true"
            End If
            if not con.images("part_BilderGrossListe_Bild").properties("Legend").value = "" then
                bildchen = bildchen.replace("alt=""""", "alt='" & con.images("part_BilderGrossListe_Bild").properties("Legend").value & "'")
                bildchen = bildchen.replace("data-caption", "data-caption='" & con.images("part_BilderGrossListe_Bild").properties("Legend").value & "'")
            else if not con.fields("part_BilderGrossListe_Beschreibung").value = "" then
                bildchen = bildchen.replace("alt=""""", "alt='" & con.fields("part_BilderGrossListe_Beschreibung").value & "'")
                bildchen = bildchen.replace("data-caption", "data-caption='" & con.fields("part_BilderGrossListe_Beschreibung").value & "'")
            end if
            bildlink.text = bildchen
        End If
    End Sub
</script>
<% if part_visible = true then %>
<asp:Literal id="showscript" runat="server" />
<CU:CUObjectSet name="part_BilderGrossListe_Liste" runat="server" onItemDataBound="BindImage">
    <HeaderTemplate>
    	<div class="part part-bilder-liste-gross openInOverlay">
        	<CU:CUField name="part_BilderGrossListe_Titel" runat="server" tag="h3" tagclass="h3 item-title" />
            <div class="con-flex <%=css2%>">
                <ul class="<%=css%>">
	</HeaderTemplate>
    <ItemTemplate>
        <li>
			<figure>
	            <asp:literal id="bildlink" runat="server" />
				<CU:CUField name="part_BilderGrossListe_Beschreibung" runat="server" tag="figcaption" />
			</figure>
        </li>
    </ItemTemplate>
    <FooterTemplate>
    		</ul>
        </div>
	</div>
    </FooterTemplate>
</CU:CUObjectSet>
<% end if %>