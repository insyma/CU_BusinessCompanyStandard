<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: Grundlagen-Part
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''Variable für die Entscheidung, ob part ausgegeben wird
    dim part_visible as boolean = false
    Dim position as integer
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

        '' Abfrage auf alle Textfelder, welche in dem part vorhanden sind( ObjectClass 5 = Textfeld)
        part_visible = _checkTextFields(container.id)

        '' weiter falls noch keine Inhalte gefunden wurden
        if part_visible = false then
            '' Abfrage auf alle Bilder, welche in dem part vorhanden sind( ObjectClass 6 = Image)
            part_visible = _checkImages(container.id)
        end if

        '' weiter falls noch keine Inhalte gefunden wurden
        if part_visible = false then
            '' Abfrage auf alle Files, welche in dem part vorhanden sind( ObjectClass 9 = File)
            part_visible = _checkFiles(container.id)
        end if

        '' weiter falls noch keine Inhalte gefunden wurden
        if part_visible = false then
            '' Abfrage auf alle Links, welche in dem part vorhanden sind( ObjectClass 12 = Link)
            part_visible = _checkLinks(container.id)
        end if
        position = getPositioninContent(Container.ParentID, Container.ID)
        dim txtfield as string = container.fields("part_Basic_Text").value
        if not txtfield = "" then
            txtfield = txtfield.replace("[[", "<a id=""ga-opt-out"" href=""javascript:void(0)"">")
            txtfield = txtfield.replace("]]", "</a>")
            txt.Text = "<div class='liststyle'>" & txtfield & "</div>"
        end if 
    End Sub

    Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim dokument As Literal = CType(e.Item.FindControl("dokument"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            '' diese beiden Aufrufe in einem Binditem immer machen, das sonst Sprache und Preview-Status vergessen werden kann
            con.preview = CUPage.preview
            con.languagecode = CUPage.languagecode

            '' Bauen des File-Links, weil bei leerer Legende sonst die Object-Caption benutzt wird. Hier alternativ der Filename
            if not con.files("part_Basic_Datei").Properties("Filename").Value = "" then
                If con.Files("part_Basic_Datei").Properties("Legend").Value <> "" then
                    dokument.text = "<li class='link download'><a class='icon " & con.Files("part_Basic_Datei").Properties("filetype").Value & "' href='" & con.Files("part_Basic_Datei").src & "' title='" & con.Files("part_Basic_Datei").Properties("Legend").Value & "' target='_blank'>" & con.Files("part_Basic_Datei").Properties("Legend").Value & "</a></li>"
                else
                    dokument.text = "<li class='link download'><a class='icon " & con.Files("part_Basic_Datei").Properties("filetype").Value & "' href='" & con.Files("part_Basic_Datei").src & "' title='" & con.Files("part_Basic_Datei").Properties("Filename").Value & "' target='_blank'>" & con.Files("part_Basic_Datei").Properties("Filename").Value & "</a></li>"
                end if
            end if
        End If
    End Sub
    Protected Sub BBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
            if not con.images("part_Basic_bilder_bild").Properties("filename").value = "" Then
                formlink.Text = "<a data-fancybox='gallery0" & position & "' data-caption='" & con.images("part_Basic_bilder_bild").properties("Legend").value & "' style='background-image: url(" & con.images("part_Basic_bilder_bild").src & ")' href='" & con.images("part_Basic_bilder_bild").alternativeSrc & "' class='bgimg imagelink'>" & con.images("part_Basic_bilder_bild").tag.replace("border=""0""", "") & "</a>"
            End if
        End If
    End Sub




</script>
<% If part_visible = True Then%>
<div class="part part-basic item-bild-text">
    <header class="part-header">
        <CU:CUField runat="server" Name="part_Basic_Titel" Tag="h3" tagclass="h3 item-title" />
        <CU:CUField runat="server" Name="part_Basic_Einleitung" Tag="div" TagClass="lead" />
    </header>
    <div class="part-image">
        <CU:CUObjectSet Name="part_Basic_bilder_liste" runat="server" OnItemDataBound="BBindItem">
            <HeaderTemplate>
                <ul class="image-list vertical openInOverlay">
            </HeaderTemplate>
            <ItemTemplate>
                <li>
                    <figure>
                    <asp:Literal id="formlink" runat="server" />
                    <CU:CUImage runat="server" Name="part_Basic_bilder_bild" Property="Legend" Tag="figcaption" />
                    </figure>
                </li>
            </ItemTemplate>
            <FooterTemplate>
                </ul>
            </FooterTemplate>
        </CU:CUObjectSet>
    </div>
    <div class="part-body">
        <asp:literal id = "txt" runat="server" />
        <CU:CUObjectSet Name="part_Basic_liste" runat="server" OnItemDataBound="BindItem">
            <HeaderTemplate>
                <ul class="linklist">
            </HeaderTemplate>
            <ItemTemplate>
                <asp:Literal ID="dokument" runat="server" />
                <CU:CULink Name="part_Basic_link" runat="server" Tag="li" class="icon" />
            </ItemTemplate>
            <FooterTemplate>
                </ul>
            </FooterTemplate>
        </CU:CUObjectSet>
    </div>
</div>
<% End If%>