<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  MGUM: Medienliste-Part
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Dim i As Integer = 0
    ''Variable für die Entscheidung, ob part ausgegeben wird
    Dim part_visible As Boolean = False
    Dim position as integer
    Dim val_w As String = "400"
    Dim val_h As String = "250"
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

        '' weiter falls noch keine Inhalte gefunden wurden
        If part_visible = False Then
            '' Abfrage auf alle Bilder, welche in dem part vorhanden sind( ObjectClass 6 = Image)
            part_visible = _checkImages(Container.Id)
        End If
        position = getPositioninContent(Container.ParentID, Container.ID)
    End Sub

    Protected Sub Medienliste_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim holder As Literal = CType(e.Item.FindControl("holder"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            con.Preview = CUPage.Preview
            con.LanguageCode = CUPage.LanguageCode
            If Not con.fields("part_medienliste_movie_width").value = "" Then
                val_w = con.fields("part_medienliste_movie_width").value
            End If
            If Not con.fields("part_medienliste_movie_height").value = "" Then
                val_h = con.fields("part_medienliste_movie_height").value
            End If
            If (con.Fields("part_MedienListe_youtube_id").Value <> "") Then
                If (con.Images("part_MedienListe_Bild").FileName <> "") Then
                    holder.Text = "<a class='movielink bgimg'  data-movie-height='" & val_h & "' data-movie-width='" & val_w & "' data-movie-id='" & con.Fields("part_MedienListe_youtube_id").Value & "' href='javascript:void(0);' data-href='https://www.youtube-nocookie.com/embed/" & con.Fields("part_MedienListe_youtube_id").Value & "?enablejsapi=1&rel=0'>" & con.Images("part_MedienListe_Bild").Tag & "</a>"
                Else
                    holder.Text = "<a class='movielink bgimg' data-movie-height='" & val_h & "' data-movie-width='" & val_w & "' data-movie-id='" & con.Fields("part_MedienListe_youtube_id").Value & "' href='javascript:void(0);' data-href='https://www.youtube-nocookie.com/embed/" & con.Fields("part_MedienListe_youtube_id").Value & "?enablejsapi=1&rel=0'><img src='https://img.youtube.com/vi/" & con.Fields("part_MedienListe_youtube_id").Value & "/sddefault.jpg' /></a>"
                End If
            Else
                holder.Text = "<a class='imagelink bgimg' href='" & con.Images("part_MedienListe_Bild").AlternativeSrc & "'>" & con.Images("part_MedienListe_Bild").Tag & "</a>"
            End If

        End If
    End Sub
</script>
<% If part_visible = True Then%>
<div class="part part-medien-liste clearfix" data-id="con_<%=Container.Id %>">
    <CU:CUField Name="part_MedienListe_titel" runat="server" Tag="h3" tagclass="h3 item-title" />
    <CU:CUObjectSet Name="part_MedienListe_Liste" runat="server" OnItemDataBound="Medienliste_ItemDataBound">
        <HeaderTemplate>
            <ul class="imagelist horizontal openInOverlay clearfix">
        </HeaderTemplate>
        <ItemTemplate>
            <li>
                <asp:Literal runat="server" ID="holder"></asp:Literal>
            </li>
        </ItemTemplate>
        <FooterTemplate>
            </ul>
        </FooterTemplate>
    </CU:CUObjectSet>
    <script type="text/javascript">
        insymaFancyScripts._createGalleryWithExternalMovies(<%=position%>,"con_<%=Container.Id %>")
    </script>
</div>
<% End If%>