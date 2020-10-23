<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: Grundlagen-part mit Movie
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
dim intro as string = ""
dim txt as string = ""
dim overlay as string = ""
    Dim val_w As String = "854"
    Dim val_h As String = "480"
dim swfobj as string = ""
dim noflash as string = ""
dim moviesrc as string = ""
dim imagesrc as string = ""
dim autoplay as string = ""
''Variable für die Entscheidung, ob part ausgegeben wird
dim part_visible as boolean = false
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        if not container.fields("part_Basic_Movie_Einleitung").value = "" then
            intro = "<div class='lead'>" & container.fields("part_Basic_Movie_Einleitung").value & "</div>"
        end if
        if not container.fields("part_Basic_Movie_Text").value = "" then
            txt = container.fields("part_Basic_Movie_Text").value
        end if
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
            if not con.files("part_Basic_Movie_datei").Properties("Filename").Value = "" then
                If con.Files("part_Basic_Movie_datei").Properties("Legend").Value <> "" then
                    dokument.text = "<li class='link download'><a class='icon " & con.Files("part_Basic_Movie_datei").Properties("filetype").Value & "' href='" & con.Files("part_Basic_Movie_datei").src & "' title='" & con.Files("part_Basic_Movie_datei").Properties("Legend").Value & "' target='_blank'>" & con.Files("part_Basic_Movie_datei").Properties("Legend").Value & "</a></li>"
                else
                    dokument.text = "<li class='link download'><a class='icon " & con.Files("part_Basic_Movie_datei").Properties("filetype").Value & "' href='" & con.Files("part_Basic_Movie_datei").src & "' title='" & con.Files("part_Basic_Movie_datei").Properties("Filename").Value & "' target='_blank'>" & con.Files("part_Basic_Movie_datei").Properties("Filename").Value & "</a></li>"
                end if
            end if
        End If
    End Sub
    Protected Sub MBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim embvideo As Literal = CType(e.Item.FindControl("embvideo"), Literal)
            Dim overlayvideo As Literal = CType(e.Item.FindControl("overlayvideo"), Literal)
            Dim conEntrybasicMovie as HTMLControl = CType(e.Item.FindControl("conEntrybasicMovie"), HTMLControl)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)                
            con.preview = CUPage.preview
            con.languagecode = CUPage.languagecode
            dim mov_con as new contentupdate.container()
            mov_con.load(con.id)
            mov_con.languagecode = cupage.languagecode
            mov_con.preview = cupage.preview
            dim emb as string = ""
            dim ov_v as string = ""
            if not mov_con.fields("basic_movie_id").value = "" then
                'Overlay********************************
                emb = "<a href='javascript:void(0);' class='movielink' data-movie-autoplay='false' data-movie-type='youtube' data-movie-height='" & val_h & "' data-movie-width='" & val_w & "' data-movie-id='" & mov_con.Fields("basic_movie_id").Value & "' data-content-id='" & Container.Id & "'>"
                'emb = "<a href='javascript:void(0);' class='movielink' id='movielink_" & container.id & "' data-movie='" & mov_con.fields("basic_movie_id").value & "' data-content-id='" & container.id & "'>"
                emb += "<img src='http://img.youtube.com/vi/" & mov_con.fields("basic_movie_id").value & "/hqdefault.jpg' alt='' />"
                emb += "</a>"
                'ov_v = "<div class='movie-holder'><iframe id='iframe_movie_youtube_"& container.id &"' class='youtube' title='YouTube' width='" & val_w & "' height='" & val_h & "' src='http://www.youtube.com/embed/" & mov_con.fields("basic_movie_id").value & "?enablejsapi=1' frameborder='0' allowfullscreen></iframe><div class='ratio' style='padding-top:" & (val_h/val_w)*100 & "%'></div></div>"
            
                if mov_con.fields("basic_movie_placeholder").value = "" then
                    embvideo.text = emb
                    'overlayvideo.text = ov_v
                else
                    conEntrybasicMovie.visible = false
                    dim ph as string = "[" & con.fields("basic_movie_placeholder").value & "]"
                    dim src as string = "<div class='part_movie' id='movie_" & con.id & "'>" & emb & "</div>"
                    'overlay += "<div id='overlayMovie_" & con.id & "' class='overlayMovie hide'>" & ov_v & "</div>"
                    intro = intro.replace(ph, src)
                    txt = txt.replace(ph, src)
                end if
            end if
        End If
    End Sub
</script>
<% if part_visible = true then %>
<div class="part part-basic clearfix">
    <CU:CUField runat="server" Name="part_Basic_Movie_Titel" tag="h3" tagclass="h3 item-title" />
    <%=intro%>
    <CU:CUObjectSet name="basic_bilder_liste" runat="server">
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
	</CU:CUObjectSet>
    <%=txt%>
    <CU:CUObjectSet name="part_Basic_Movie_liste" runat="server" OnItemDataBound="BindItem">
        <HeaderTemplate>
            <ul class="linklist">
        </HeaderTemplate>
        <ItemTemplate>
            <asp:literal id="dokument" runat="server" />
            <CU:CULink name="part_Basic_Movie_link" runat="server" Tag="li" class="icon" />
        </ItemTemplate>
        <FooterTemplate>
            </ul>
        </FooterTemplate>
    </CU:CUObjectSet>
    <CU:CUObjectSet name="basic_movie_liste" runat="server" OnItemDataBound="MBindItem">
    <ItemTemplate>
        <div id="conEntrybasicMovie" runat="server">
            <div class="part-movie" id="movie_<%# CType(Container.DataItem,ContentUpdate.Container).ID %>">
                <asp:literal id="embvideo" runat="server" />
            </div>
        </div>
    </ItemTemplate>
    </CU:CUObjectSet>
</div>
<%=overlay%>
<% end if %>