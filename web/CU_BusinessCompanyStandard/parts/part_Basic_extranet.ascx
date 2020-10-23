<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: Grundlagen-Part
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''Variable für die Entscheidung, ob part ausgegeben wird
    dim part_visible as boolean = false

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
    End Sub
    Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim dokument As Literal = CType(e.Item.FindControl("dokument"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)                
            '' diese beiden Aufrufe in einem Binditem immer machen, das sonst Sprache und Preview-Status vergessen werden kann
            con.preview = CUPage.preview
            con.languagecode = CUPage.languagecode
            
            '' Bauen des File-Links, weil bei leerer Legende sonst die Object-Caption benutzt wird. Hier alternativ der Filename
            
        End If
    End Sub
</script>
<% if part_visible = true then %>
<div class="part part-basic clearfix"><CU:CUField runat="server" Name="Titel" tag="h3" tagclass="h3 item-title" /><CU:CUField runat="server" Name="Einleitung" tag="div" tagclass="lead"/><CU:CUObjectSet name="basic_bilder_liste" runat="server">
        <HeaderTemplate>
        	<ul class="imglist-position imagelist vertical insymaNewThumbs openInOverlay">
    	</HeaderTemplate>
    	<ItemTemplate>
        	<li>
                <figure>
                    <CU:CUImage name="basic_bilder_bild" runat="server" LinkClass="imagelink" Popup="true" PopupMode="ScriptCompatibility" />
                    <CU:CUImage runat="server" Name="basic_bilder_bild" Property="Legend" tag="figcaption"/>
				</figure>
            </li>
        </ItemTemplate>
        <FooterTemplate>
            </ul>
        </FooterTemplate>
	</CU:CUObjectSet><CU:CUField runat="server" Name="Text" tag="div" tagclass="liststyle" /><CU:CUObjectSet name="liste" runat="server" OnItemDataBound="BindItem">
        <HeaderTemplate>
            <ul class="linklist">
        </HeaderTemplate>
        <ItemTemplate>
            <CU:CUFile name="Datei" runat="server" Tag="li" tagclass="link download" PDFBrowser="true" class="property.filetype" />
            <CU:CULink name="link" runat="server" Tag="li" class="icon" />
        </ItemTemplate>
        <FooterTemplate>
            </ul>
        </FooterTemplate>
    </CU:CUObjectSet></div>
<% end if %>