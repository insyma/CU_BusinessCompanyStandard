<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>

<% 'Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    Dim conCount As Integer = 0
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        'Hide if title is empty or checkbox is active
        if Container.fields("title").value = "" OR Container.fields("show_content").value = "1" then
            fullContent.visible = false
        end if
        
        'Anchor Position
        For Each con As ContentUpdate.Container In Container.ParentObjects(1).Containers
            if con.fields("title").value <> "" AND con.fields("show_content").value <> "1" then
                conCount += 1
                If con.Id = Container.Id Then
                    Exit For
                End If
            end if
        Next
        ContentMenuAnchor.Text = "<a title=""news_" & conCount & """ name=""news_" & conCount & """  id=""news_" & conCount & """></a>"
        
        'Image position stuff
        if Container.fields("imgposition").value = "links" then
            ImageAlign.text = "left"
        else
            ImageAlign.text = "right"
            ImageAlignRightMargin.visible = false
        end if
        if container.images("bild").Filename <> "" then
            if Container.fields("imgposition").value = "links" then
                fullWidth.text = "width:275px; max-width:275px;"
                fullWidth2.text = "275"
                ImageAlignRightMargin.Style.Add("mso-table-rspace", "5pt")
            Else
                fullWidth.Text = "width:288px; max-width:288px;"
                fullWidth2.Text = "288"
            End If
        end if

        'Button width replace with standard
        if Container.Fields("link_width").value = "" then
            width_button1.Text = StandardButtonWidth
            width_button2.Text = StandardButtonWidth
        Else
            width_button1.Text = Container.Fields("link_width").Properties("value").Value
            width_button2.Text = Container.Fields("link_width").Properties("value").Value
        End If
        
    End Sub
    
    Sub BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ListAnchor As Literal = CType(e.Item.FindControl("ListAnchor"), Literal)
                     
            If Not con.Fields("desc").Properties("Value").Value = "" Then
                If Not con.Fields("url").Value = "" Then
                    ListAnchor.Text = "<a href=""" & con.Fields("url").Value & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & "</a>"
                    if e.Item.ItemIndex = 0 then
                        imgLinkFromList_start.Text = "<a href=""" & con.Fields("url").Value & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Fields("desc").Value & """>"
                        imgLinkFromList_end.Text = "</a>"
                    end if 
                End If
                If Not con.Files("file").FileName = "" Then
                    ListAnchor.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & " / " & con.Files("file").Properties("FileType").Value & " " & con.Files("file").Properties("size").Value & "KB</a>"
                    if e.Item.ItemIndex = 0 then
                        imgLinkFromList_start.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Fields("desc").Value & """>"
                        imgLinkFromList_end.Text = "</a>"
                    end if 
                End If
            Else
                If Not con.Files("file").FileName = "" Then
                    ListAnchor.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Files("file").Properties("legend").Value & """>" & con.Files("file").Properties("legend").Value & " / " & con.Files("file").Properties("FileType").Value & " " & con.Files("file").Properties("size").Value & "KB</a>"
                    if e.Item.ItemIndex = 0 then
                        imgLinkFromList_start.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Fields("desc").Value & """>"
                        imgLinkFromList_end.Text = "</a>"
                    end if 
                End If
            End If
            
            
            
        End If
    End Sub
</script>
<asp:panel runat="server" id="fullContent">
<%  If TemplateView = "text" Then%>
<%  If Not Container.Fields("title").Value = "" Then%>
-----------------------------------------------------------------
<CU:CUField Name="title" runat="server" PlainText="true" /><%=vbcrlf%>-----------------------------------------------------------------
<%  If Not Container.Fields("intro").Value = "" Then%><%=vbcrlf%><CU:CUField name="intro" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("text").Value = "" Then%><%=vbcrlf%><CU:CUField Name="text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<% if not container.fields("link_url").Value = "" Then%><%=vbcrlf%><CU:CUField name="link_text" runat="server" /> [<CU:CUField name="link_url" runat="server" />]<%=vbcrlf%><%end if%>
<%=vbcrlf%><%  For Each cuentry As ContentUpdate.Container In Container.ObjectSets("culist").Containers%><%if not cuentry.Fields("desc").Value = "" then %>
<%=cuentry.Fields("desc").Plaintext %><%If Not cuentry.Fields("url").Value = "" Then%><%=vbcrlf%>[<%=cuentry.Fields("url").Plaintext %>]<%=vbcrlf%>-------------------------------<%=vbcrlf%><%end if %>
<%If Not cuentry.Files("file").Filename = "" Then%><%=vbcrlf%><%=cuentry.Files("file").Src%> [<%=cuentry.Files("file").Properties("FileType").Value%> | <%=cuentry.Files("file").Properties("Size").Value%>]<%=vbcrlf%>-------------------------------<%=vbcrlf%><%end if %><%else %><%If Not cuentry.Files("file").Filename = "" Then%>
<%=vbcrlf%><%=cuentry.Files("file").Properties("Legend").Value%> <%=vbcrlf%><%=cuentry.Files("file").Src%> [<%=cuentry.Files("file").Properties("FileType").Value%> | <%=cuentry.Files("file").Properties("Size").Value%>]<%=vbcrlf%>-------------------------------<%=vbcrlf%><%end if %><%end if %>
<%next %><% end if %><%else %>

<!-- Holder -->
<table align="center" border="0" cellpadding="0" cellspacing="0" bgcolor="<%=C_Standard_Background%>" style='<%=S_Standard_Border%>'>
    <tr>
        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
    </tr>
    <tr>
        <td width="640" style="width:640px; max-width:640px;">

            <table border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    <td width="600" style="width:600px; max-width:600px; <%=F_Standard_Text%> <%=C_Standard_Text%>">
                        <!-- Title -->
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="<%=F_Standard_Title%> <%=C_Standard_Title%>">
                                    <asp:Literal ID="ContentMenuAnchor" runat="server" />
                                    <CU:CUField Name="title" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,15)%></td>
                            </tr>
                        </table>

                        <% If Container.Fields("intro").Value <> "" Then %>
                            <span style='<%=F_Standard_Text%> <%=C_Standard_Text%>'><CU:CUField Name="intro" runat="server" /><br /><br /></span>
                        <% end if %>
                        <table class="mobileFullWidth" border="0" cellpadding="0" cellspacing="0">
                           <tr>
                               <td width="600" style="width:600px; max-width:600px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                <% If Container.Images("bild").FileName <> "" Then %>
                                    <table class="mobileFullWidth" align='<asp:literal runat="server" id="ImageAlign" />' cellpadding="0" cellspacing="0" style="border:1px solid <%=C_Standard_Background%>; mso-table-lspace:0pt; mso-table-rspace:5pt;">
                                        <tr>
                                            <td bgcolor="<%=C_Standard_Background%>" width="288" style="width:288px; max-width:288px; text-align: left; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                                <span style="mso-table-lspace:0pt; mso-table-rspace:0pt; margin: 0;">
                                                    <asp:literal runat="server" id="imgLinkFromList_start" />
                                                    <img class="moibleBlockImage" src="<%=getImg(Container.Images("bild"))%>" alt="*" border="0" style="display:inline; max-width:100%;" />
                                                    <asp:literal runat="server" id="imgLinkFromList_end" />
                                                </span>
                                            </td>
                                            <td runat="server" id="ImageAlignRightMargin" class="fullWidthArticleImage" width="20" style="line-height: 0; font-size: 1px; mso-table-lspace:0pt;"><%=spacer(20,1)%></td>
                                        </tr>
                                    </table>
                                    <table class="mobileOnlyNoPadding" cellpadding="0" cellspacing="0" style="border:1px solid <%=C_Standard_Background%>; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                        <tr>
                                            <td height="5" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                                        </tr>
                                    </table>
                                <% end if %>

                                <% If Container.Fields("text").Value <> "" Then %>
                                <table cellpadding="0" cellspacing="0" style="border:1px solid <%=C_Standard_Background%>; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                    <tbody>
                                        <tr>
                                            <td class="mobileFullWidth" bgcolor="<%=C_Standard_Background%>" width="<asp:literal runat='server' id='fullWidth2' />" style="<asp:literal runat='server' id='fullWidth' /> mso-table-lspace:0pt; mso-table-rspace:0pt; <%=F_Standard_Text%> <%=C_Standard_Text%>">
                                                <%=getText(Container.Fields("text").value, (F_Standard_Link & C_Standard_Link), (F_Standard_Text & C_Standard_Text))%>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <% end if %>
                                
                                
                                <%if Container.Fields("link_url").value <> "" AND Container.Fields("link_text").value <> "" then %>
                                <div>
                                    <table cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                                        </tr>
                                    </table>
                                    <!--[if mso]>
                                        <v:rect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href='<CU:CUField runat="server" name="link_url" />' style="height:45px;v-text-anchor:middle;width:<asp:literal id='width_button1' runat='server' />px;" stroke="f" fillcolor="<%=BG_Standard_Button%>">
                                          <w:anchorlock/>
                                          <center>
                                        <![endif]-->
                                            <a class="button" href="<CU:CUField runat='server' name='link_url' />" target='_blank' style="background-color: <%=BG_Standard_Button%>; <%=C_Standard_Button%> <%=F_Standard_Button%> display:inline-block;line-height:45px;text-align:center;width:<asp:literal id='width_button2' runat='server' />px;-webkit-text-size-adjust:none;"><CU:CUField runat="server" name="link_text" /></a>
                                        <!--[if mso]>
                                          </center>
                                        </v:rect>
                                    <![endif]-->
                                    <table cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                                        </tr>
                                    </table>
                                </div>
                                <% end if %>
                                
                                </td>
                            </tr>
                        </table>
                        <% 'Space only if image and text are empty                 
                            If Container.Images("bild").FileName = "" AND Container.Fields("text").Value = "" Then %>
                            <!-- Spacer -->
                            <table border="0" align="center" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,15)%></td>
                                </tr>
                            </table>
                        <% end if %>

                        <CU:CUObjectSet Name="culist" runat="server" OnItemDataBound="BindItem">
                            <ItemTemplate>
                                <table cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                                    </tr>
                                    <tr>
                                        <td width="600" style="width:600px; max-width:600px; mso-table-lspace:0pt; mso-table-rspace:0pt; <%=F_Standard_Link%> <%=C_Standard_Link%>"><asp:Literal ID="ListAnchor" runat="server" /> </td>
                                    </tr>
                                    <tr>
                                        <td height="10" style="<%=S_Standard_Link_Border%> line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </CU:CUObjectSet>
                    </td>
                    <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id='spacer2' runat='server'>
        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
    </tr>
</table>
<!-- Spacer -->
<table align="center" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="<%=space%>" style="line-height: 0; font-size: 1px;"><%=spacer(1,space)%></td>
    </tr>
</table>
<%end if %>
</asp:panel>