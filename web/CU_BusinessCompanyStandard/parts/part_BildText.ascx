<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
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

            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim Bild As CUImage = CType(e.Item.FindControl("part_BildText_Bild"), CUImage)
            Dim showImage As HtmlControl = CType(e.Item.FindControl("showImage"), HtmlControl)
            Dim bildlink0 As Literal = CType(e.Item.FindControl("bildlink0"), Literal)
            Dim bildlink1 As Literal = CType(e.Item.FindControl("bildlink1"), Literal)
            Dim insymaImageThumbClass As Literal = CType(e.Item.FindControl("insymaImageThumbClass"), Literal)

            ' ### Wenn ein Bild erfasst
            If con.Images("part_BildText_Bild").FileName = "" Then
                showImage.Visible = False
            Else
                'showimage.Attributes.Add("style", "background-image:url(" & con.Images("part_BildText_Bild").processedsrc & ")")
            End If

            If con.Images("part_BildText_Bild").FileName <> "" Then
                ' Bei Bildausrichtung Links Klasse vergeben
                If con.Fields("part_BildText_imageposition").Properties("Value").Value = "links" Then
                    CType(e.Item.FindControl("leftClass"), Literal).Text = "img-posleft "
                End If
                ' Wenn Bildlink erfasst ist, Bild mit Link ausgeben
                If con.Links("part_BildText_BildLink").Properties("Value").Value <> "" Then
                    '					bildlink.Text = "<a class='imagewrap' href='" & con.Links("part_BildText_BildLink").Properties("Value").Value & "' target='" & con.Links("part_BildText_BildLink").Properties("Target").Value & "'>" & con.Images("part_BildText_Bild").Tag & "</a>"
                    bildlink0.Text = "<a data-fancybox style='background-image: url(" & con.images("part_BildText_Bild").src & ")' class='bgimg imagewrap' href='" & con.Links("part_BildText_BildLink").Url & "' target='" & con.Links("part_BildText_BildLink").Properties("Target").Value & "'>" & con.Images("part_BildText_Bild").Tag & "</a>"
                    ' ### Wenn Bildlink NICHT erfasst ist, Bild mit Overlay ausgeben
                Else
                    insymaImageThumbClass.Text = " insymaNewThumbs openInOverlay"
                    bildlink1.Text = "<a data-fancybox style='background-image: url(" & con.images("part_BildText_Bild").src & ")' href='" & con.images("part_BildText_Bild").alternativeSrc & "' class='bgimg imagelink'>" & con.images("part_BildText_Bild").tag.replace("border=""0""", "") & "</a>"
                End If
            End If
        End If
    End Sub

    Protected Sub BindItem2(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim dokument As Literal = CType(e.Item.FindControl("dokument"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            '' diese beiden Aufrufe in einem Binditem immer machen, das sonst Sprache und Preview-Status vergessen werden kann
            con.preview = CUPage.preview
            con.languagecode = CUPage.languagecode

            '' Bauen des File-Links, weil bei leerer Legende sonst die Object-Caption benutzt wird. Hier alternativ der Filename
            If Not con.files("part_BildText_Datei").Properties("Filename").Value = "" Then
                If con.Files("part_BildText_Datei").Properties("Legend").Value <> "" Then
                    dokument.Text = "<li class='link download'><a class='icon " & con.Files("part_BildText_Datei").Properties("filetype").Value & "' href='" & con.Files("part_BildText_Datei").src & "' title='" & con.Files("part_BildText_Datei").Properties("Legend").Value & "' target='_blank'>" & con.Files("part_BildText_Datei").Properties("Legend").Value & "</a></li>"
                Else
                    dokument.Text = "<li class='link download'><a class='icon " & con.Files("part_BildText_Datei").Properties("filetype").Value & "' href='" & con.Files("part_BildText_Datei").src & "' title='" & con.Files("part_BildText_Datei").Properties("Filename").Value & "' target='_blank'>" & con.Files("part_BildText_Datei").Properties("Filename").Value & "</a></li>"
                End If
            End If
        End If
    End Sub

</script>
<% if part_visible = true then %>
<cu:cuobjectset name="part_BildText_CUList" runat="server" onitemdatabound="BindItem">
<ItemTemplate>
<div class="part part-bild-text item-bild-text clearfix <asp:literal id='leftClass' runat='server' /><asp:literal id='insymaImageThumbClass' runat='server' />">
    <header class="part-header">
    	<CU:CUField name="part_BildText_Titel" runat="server" tag="h3" tagclass="h3 item-title" />
    </header>
    <div class="part-image">
        <figure id="showimage" runat="server" class="img-position">
            <asp:literal id="bildlink0" runat="server" />
            <asp:literal id="bildlink1" runat="server" />
            <CU:CUImage Name="part_BildText_Bild" Property="Legend" runat="server" Tag="figcaption" />
	    </figure>
    </div>
    <div class="part-body">
	    <CU:CUField runat="server" Name="part_BildText_Text" tag="div" tagclass="liststyle" />
	    <CU:CUObjectSet name="part_BildText_liste" runat="server" OnItemDataBound="BindItem2">
            <HeaderTemplate>
                <ul class="linklist">
            </HeaderTemplate>
            <ItemTemplate>
                <asp:literal id="dokument" runat="server" />
                <CU:CULink name="part_BildText_Link" runat="server" Tag="li" class="icon" />
            </ItemTemplate>
            <FooterTemplate>
                </ul>
            </FooterTemplate>
	    </CU:CUObjectSet>
    </div>
</div>
</ItemTemplate>
</cu:cuobjectset>
<% end if %>