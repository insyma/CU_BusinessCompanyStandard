<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
    dim content as string = ""
    dim culist as integer = 0
    dim overlay as boolean = false

    ''Variable für die Entscheidung, ob part ausgegeben wird
    dim part_visible as boolean = false


    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        culist = Container.objectsets("anw_culist").id

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
            Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
            if not con.fields("anw_eintragkat_name").value = "" then
                dim os as new Contentupdate.objectset()
                os.load(culist)
                os.LanguageCode = CUPage.LanguageCode
                os.Preview = CUPage.Preview
                os.filter = "anw_entry_cat='" & con.fields("anw_eintragkat_name").plaintext.Replace("'", "''") & "'"
                'if os.containers.count > 0 then
                for each c as contentupdate.container in os.containers
                    content += "<div class='part part-tab' style='display: none;'>"
                    c.LanguageCode = CUPage.LanguageCode
                    c.Preview = CUPage.Preview
                    if c.fields("anw_img_overlay").value = "1" then
                        overlay = true
                    else
                        overlay = false
                    end If
                    content += "<div id='" & c.fields("anw_ueberschrift").plaintext.replace(" ", "") & "'>"

                    Dim _large as string = ""
                    dim _thumbs as string = ""
                    dim j as integer = 0
                    if c.objectsets("anw_img_list").containers.count > 0 or c.objectsets("anw_mov_list").containers.count > 0 Then
                        _large = "<div class='imagewrap'><ul class='img_large img-large insymaNewThumbs openInOverlay'>"
                        _thumbs = "<div class='part-bilder-liste clearfix'><div class='cols'><ul class='img_thumbs thumbnails'>"

                        For each _i as contentupdate.container in c.objectsets("anw_mov_list").containers
                            _i.LanguageCode = CUPage.LanguageCode
                            _i.Preview = CUPage.Preview
                            if j = 0 then
                                _large += "<li id='img_l_" & _i.id & "_" & j & "'>"
                                _thumbs += "<li id='img_t_" & _i.id & "_" & j & "' class='active'>"
                            else
                                _large += "<li id='img_l_" & _i.id & "_" & j & "' style='display:none;'>"
                                _thumbs += "<li id='img_t_" & _i.id & "_" & j & "' class=''>"
                            end If
                            _large += "<a data-movie-type='youtube' data-movie-height='768' data-movie-width='1024' data-movie-id='" & _i.fields("anw_mov_id").value & "' class='bgimg imagelink movielink' style='background-image: url(http://img.youtube.com/vi/" & _i.fields("anw_mov_id").value & "/hqdefault.jpg);'><img src='http://img.youtube.com/vi/" & _i.fields("anw_mov_id").value & "/hqdefault.jpg' alt='*'>"
                            _thumbs += "<figure class='bgimg imagelink' style='background-image: url(http://img.youtube.com/vi/" & _i.fields("anw_mov_id").value & "/default.jpg);'><img src='http://img.youtube.com/vi/" & _i.fields("anw_mov_id").value & "/default.jpg' alt='*' /></figure>"
                            _large += "</a>"
                            _large += "</li>"
                            _thumbs += "</li>"
                            j += 1
                        next
                        for each _i as contentupdate.container in c.objectsets("anw_img_list").containers
                            _i.LanguageCode = CUPage.LanguageCode
                            _i.Preview = CUPage.Preview
                            if j = 0 then
                                _large += "<li id='img_l_" & _i.id & "_" & j & "'>"
                                _thumbs += "<li id='img_t_" & _i.id & "_" & j & "' class='active'>"
                            else
                                _large += "<li id='img_l_" & _i.id & "_" & j & "' style='display:none;'>"
                                _thumbs += "<li id='img_t_" & _i.id & "_" & j & "' class=''>"
                            end If
                            ' large
                            _large += "<a class='bgimg imagelink' style='background-image: url(" & _i.images("anw_entry_img").processedsrc & ");' href='" & _i.images("anw_entry_img").alternativeSrc & "'>"
                            _large += _i.images("anw_entry_img").tag.replace("border=""0""", "")
                            _large += "</a>"
                            _large += "</li>"
                            ' thumbs
                            _thumbs += "<figure class='bgimg imagelink' style='background-image: url(" & _i.images("anw_entry_img").processedsrc & ");'>"
                            _thumbs += _i.images("anw_entry_img").tag.replace("border=""0""", "")
                            _thumbs += "</figure></li>"
                            j += 1
                        Next

                        _large += "</ul>"
                        _thumbs += "</ul></div></div></div>"
                    End if
                    if j < 2 Then
                        _large += "</div>"
                        _thumbs = ""
                    End If


                    content += "<div class='part part-basic item-bild-text'>"
                    content += "<header class='part-header'><h3 class='h3 item-title'>" & c.fields("anw_ueberschrift").value & "</h3></header>"
                    content += "<div class='part-image'><div class='img-position'>" & _large & _thumbs & "</div></div>"
                    content += "<div class='part-body'>"
                    content += "<div class='liststyle'>"
                    content += c.fields("anw_entry_desc").value
                    content += "</div>"
                    Dim _link As String = ""
                    If not c.links("anw_link").properties("value").value = "" then
                        if not c.links("anw_link").properties("description").value = "" Then
                            _link = c.links("anw_link").tag.replace(c.links("anw_link").caption, c.links("anw_link").properties("description").value).replace("<a", "<a class='icon iconweblink'")
                        Else
                            _link = c.links("anw_link").tag.replace("<a", "<a class='icon iconweblink '")
                        End if
                    end If
                    content += "<ul class='linklist'><li>"
                    content += _link
                    content += "</li></ul>"
                    content += "</div>"
                    content += "</div>"
                    content += "</div>"
                    content += "</div>"
                Next
                'end if
            End if
        End If
    End Sub
</script>

<% if part_visible = true then %>

<!---->
<div class="part part-tabbing-nav">
	<CU:CUObjectSet name="anw_ListeKat" runat="server" OnItemDataBound="BindItem">
    <HeaderTemplate><div class="tabbing"><ul></HeaderTemplate>
        <ItemTemplate>
            <CU:CUField name="anw_eintragkat_name" runat="server" tag="li" tagclass="tabbing-item" />
        </ItemTemplate>
    <FooterTemplate></ul></div></FooterTemplate>    
    </CU:CUObjectSet>
    
</div>

<%=content%>

<% if CUPage.Arrange = false %>
<script type="text/javascript">
    /* <![CDATA[ */
        //insymaScripts._setAnwendg();
        //_setAnwendg: function()
        //{
            var tab = $("div.part-tabbing-nav li");
            var div = $("div.part-tab");
            tab.each(function(i){
                if(i == 0)
                    $(this).addClass("active");
                $(this).attr("id", "li_tab_" + i);
            });
            div.each(function(i){
                if(i == 0)
                    $(this).show();
                $(this).attr("id", "div_tab_" + i);
            });
            tab.each(function(i){
                if($("#div_tab_" + i).find("li").length == 0)
                {
                    $(this).hide();
                }
            });
            tab.click(function(){
                if($(this).hasClass("active") == false)
                {
                    var _id = $(this).attr("id").replace("li", "div");
                    tab.removeClass("active");
                    div.hide();
                    $(this).addClass("active").show();
                    //$("#" + _id + " li").tsort('',{order:'asc',attr:'id'});
                    
                    $("#" + _id).show();
                }
            });
            var lis = $("ul.img_thumbs > li");
            var largelis = $("ul.img_large > li");
            lis.click(function(){
                lis.removeClass("active");
                $(this).addClass("active");
                var _id = $(this).attr("id");
                largelis.hide();
                $("#" + _id.replace("_t_", "_l_")).show();
            });
       // }
    /* ]]> */  
</script>
<% end if %>
<% end if %>

