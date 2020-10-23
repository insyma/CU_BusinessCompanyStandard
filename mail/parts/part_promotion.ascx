<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>

<% 'Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    Dim conCount As Integer = 0
    Dim CC as Integer = 0
    dim lang as String = ""
    Dim variantWidth = 600
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        if Container.fields("title").value = "" then
            fullContent.visible = false
        end if        
        For Each con As ContentUpdate.Container In Container.parent.containers 
            if con.fields("title").value <> "" then
                CC = CC + 1
            end if
        next
        For Each con As ContentUpdate.Container In Container.ParentObjects(1).Containers
            if con.Fields(1).value <> "" then
                conCount += 1
                if lcase(con.objname).contains("download") then
                    ConCount -= 1
                end if
                If con.Id = Container.Id Then
                    Exit For
                End If
            end if
        Next
        ContentMenuAnchor.Text = "<a title=""news_" & conCount & """ name=""news_" & conCount & """  id=""news_" & conCount & """></a>"
        
        if Container.images("bild_promotion").Filename <> "" then
            fullWidth.text = "width:270px; max-width:270px;"
            variantWidth = 270
        end if
    End Sub
    
    Sub Buttons_BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim button_bg_color As Literal = CType(e.Item.FindControl("button_bg_color"), Literal)
            Dim button_border_color As Literal = CType(e.Item.FindControl("button_border_color"), Literal)
            Dim button_font_color As Literal = CType(e.Item.FindControl("button_font_color"), Literal)
            Dim button_bg_color_OL As Literal = CType(e.Item.FindControl("button_bg_color_OL"), Literal)
            Dim button_border_color_OL As Literal = CType(e.Item.FindControl("button_border_color_OL"), Literal)
            Dim button_font_color_OL As Literal = CType(e.Item.FindControl("button_font_color_OL"), Literal)
            
            'Buttons
            if con.Fields("buttons_list_color").Properties("value").value = "1" then
                button_bg_color.text = "#efefef"
                button_border_color.text = "#aaaaaa"
                button_font_color.text = "#333333"
                button_bg_color_OL.text = button_bg_color.text
                button_border_color_OL.text = button_border_color.text
                button_font_color_OL.text = button_font_color.text
            end if
            if con.Fields("buttons_list_color").Properties("value").value = "2" then
                button_bg_color.text = "#99c739"
                button_border_color.text = "#1e3650"
                button_font_color.text = "#ffffff"
                button_bg_color_OL.text = button_bg_color.text
                button_border_color_OL.text = button_border_color.text
                button_font_color_OL.text = button_font_color.text
            end if
            
        End If
    End Sub
</script>
<%  If TemplateView = "text" Then%>
<%  If Not Container.Fields("title").Value = "" Then%>
-----------------------------------------------------------------
<CU:CUField Name="title" runat="server" PlainText="true" /><%=vbcrlf%>-----------------------------------------------------------------
<%  If Not Container.Fields("intro").Value = "" Then%><%=vbcrlf%><CU:CUField name="intro" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("text").Value = "" Then%><%=vbcrlf%><CU:CUField Name="text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<% if not container.fields("button_link").Value = "" Then%><%=vbcrlf%><CU:CUField name="button_text" runat="server" /><%=vbcrlf%><CU:CUField name="button_link" runat="server" /><%=vbcrlf%><%end if%>
<% end if %>
<%else %>

<asp:panel runat="server" id="fullContent">
<!-- Full Width Table -->
    <table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="<%=C_Promotion_BG%>" style="background-color: <%=C_Promotion_BG%>; border-bottom: 1px solid <%=C_Promotion_Border%>; width:100%;">
        <tr>
            <td>
                
                <!-- Holder -->                
                <table align="center" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    </tr>
                    <tr>
                        <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                        <td width="600" style="width:600px; max-width:600px;">
                            
                            <% If Container.Images("bild_promotion").FileName <> "" Then %>
                            <table class="fullWidthArticleImage" align="right" border="0" cellpadding="0" cellspacing="0">
                                <tr> 
                                    <td class="fullWidthArticleImage" width="310">
                                        <table class="fullWidthArticleImage" align="right" width="290" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="216">
                                                    <img src="<%=getImg(Container.Images("bild_promotion"))%>" alt="" border="0" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" height="16" style="line-height: 0; font-size: 1px;"><%=spacer(1,16)%></td>
                                </tr>
                            </table>
                            <% end if %>
                            
                            
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="<%=variantWidth%>" style="width:<%=variantWidth%>px; max-width:<%=variantWidth%>px;">
                                        <!-- Title -->
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="<%=F_Title%> color:<%=C_Promotion_Title%>;">
                                                    <asp:Literal ID="ContentMenuAnchor" runat="server" />
                                                    <CU:CUField Name="title" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,15)%></td>
                                            </tr>
                                        </table>

                                        <% If Container.Fields("intro").Value <> "" Then %>
                                            <span style='<%=F_LeadText%> color:<%=C_Promotion_Text%>;'><CU:CUField Name="intro" runat="server" /><br /><br /></span>
                                        <% end if %>
                                        <% If Container.Fields("text").Value <> "" Then %>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tbody>
                                                    <tr>
                                                        <td style="<asp:literal runat='server' id='fullWidth' /> <%=F_Text%> color:<%=C_Promotion_Text%>;">
                                                            <%=getText(Container.Fields("text").value, F_Link &" color:"& C_Promotion_Link &";", F_Text &" color:"& C_Promotion_Text &";", F_Text &" color:"& C_Promotion_Text &";" )%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        <% end if %>
                                        <% 'Space only if image and text are empty                 
                                            If Container.Images("bild_promotion_gross").FileName = "" AND Container.Fields("text").Value = "" Then %>
                                            <!-- Spacer -->
                                            <table align="center" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,15)%></td>
                                                </tr>
                                            </table>
                                        <% end if %>
                                    </td>
                                </tr>
                            </table>

                            <CU:CUObjectSet name="buttons_list" runat="server" OnItemDataBound="Buttons_BindItem">
                                <headertemplate>
                                </headertemplate>
                                <ItemTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                        </tr>
                                    </table>   
                                    <div>
                                        <!--[if mso]>
                                            <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href='<CU:CUField name="buttons_list_link" runat="server" />' style='height:<CU:CUField name="buttons_list_height" runat="server" />px;v-text-anchor:middle;width:<CU:CUField name="buttons_list_width" runat="server" />px;' arcsize="13%" strokecolor="<asp:literal id='button_border_color_OL' runat='server' />" fillcolor="<asp:literal id='button_bg_color_OL' runat='server' />">
                                                <w:anchorlock/>
                                                <center style="color:<asp:literal id='button_font_color_OL' runat='server' />;font-family:sans-serif;font-size:13px;font-weight:bold;"><CU:CUField name="buttons_list_text" runat="server" /></center>
                                            </v:roundrect>
                                        <![endif]-->
                                        <a href='<CU:CUField name="buttons_list_link" runat="server" />' target="_blank" style='background-color:<asp:literal id="button_bg_color" runat="server" />;border:1px solid <asp:literal id="button_border_color" runat="server" />;border-radius:4px;color:<asp:literal id="button_font_color" runat="server" />;display:inline-block;font-family:sans-serif;font-size:13px;font-weight:bold;line-height:<CU:CUField name="buttons_list_height" runat="server" />px;text-align:center;text-decoration:none;width:<CU:CUField name="buttons_list_width" runat="server" />px;-webkit-text-size-adjust:none;mso-hide:all;'><CU:CUField name="buttons_list_text" runat="server" /></a>
                                    </div>
                                </ItemTemplate>
                            </CU:CUObjectSet>
                        </td>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    </tr>
                    <tr>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

</asp:panel>
<%end if %>