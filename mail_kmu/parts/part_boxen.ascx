<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>

<% 'Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    Dim conCount As Integer = 0
    Dim bgcolor as String = "#ffffff"
    Dim bgcolor2 as String = "#ffffff"
    
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
        
        if Container.Fields("box1_link_width").value = "" then
            width_button1.Text = StandardButtonWidth
            width_button2.Text = StandardButtonWidth
        Else
            width_button1.Text = Container.Fields("box1_link_width").Properties("value").Value
            width_button2.Text = Container.Fields("box1_link_width").Properties("value").Value
        End If
        
        if Container.Fields("box2_link_width").value = "" then
            width_button3.Text = StandardButtonWidth
            width_button4.Text = StandardButtonWidth
        Else
            width_button3.Text = Container.Fields("box2_link_width").Properties("value").Value
            width_button4.Text = Container.Fields("box2_link_width").Properties("value").Value
        End If
        
    End Sub
</script>
<%  If TemplateView = "text" AND Container.fields("show_content").value <> "1" Then%>
<%  If Container.Fields("title").Value <> ""   Then%>
-----------------------------------------------------------------
<CU:CUField Name="title" runat="server" PlainText="true" /><%=vbcrlf%>-----------------------------------------------------------------
<%  If Not Container.Fields("box1_text").Value = "" Then%><%=vbcrlf%><CU:CUField name="box1_text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("box1_link_url").Value = "" Then%><%=vbcrlf%><CU:CUField Name="box1_link_text" runat="server" PlainText="true" /> [<CU:CUField Name="box1_link_url" runat="server" PlainText="true" />]<%=vbcrlf%><% end if %>
<% end if %>

<%  If Not Container.Fields("box2_titel").Value = "" Then%>
-----------------------------------------------------------------
<CU:CUField Name="box2_titel" runat="server" PlainText="true" /><%=vbcrlf%>-----------------------------------------------------------------
<%  If Not Container.Fields("box2_text").Value = "" Then%><%=vbcrlf%><CU:CUField name="box2_text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("box2_link_url").Value = "" Then%><%=vbcrlf%><CU:CUField Name="box2_link_text" runat="server" PlainText="true" /> [<CU:CUField Name="box2_link_url" runat="server" PlainText="true" />]<%=vbcrlf%><% end if %>
<% end if %>
<%else %>




<asp:panel runat="server" id="fullContent">
    <asp:Literal ID="ContentMenuAnchor" runat="server" />
    
    <table align="center" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td width="640" style="width:640px; max-width:640px;">
                
                
                <table class="mobileFullWidthTable" align="left" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td height='<CU:CUField name="boxen_height" runat="server" />' valign="top" class="mobileFullWidth" bgcolor="<%=bgcolor%>" width="313" style="width:313px; max-width:313px; <%=S_Boxen_Border%> mso-table-lspace:0pt; mso-table-rspace:0pt;">
                            <span style="mso-table-lspace:0;mso-table-rspace:0;">
                                <table class="mobileFullWidthTable" border="0" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                    <tr>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                        <td style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                    </tr>
                                    <tr>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                        <td class="mobileFullWidth" valign="top" width="268" style="max-width: 268px; width: 268px; <%=F_Boxen_Text %> <%=C_Boxen_Text %>">
                                            <!-- Title -->
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="<%=F_Boxen_Title%> <%=C_Boxen_Title%>">
                                                        <CU:CUField name="title" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,15)%></td>
                                                </tr>
                                            </table> 
                                            <% If Container.Images("box1_img").FileName <> "" Then %>
                                                <img class="moibleBlockImage" src="<%=getImg(Container.Images("box1_img"))%>" alt="*" border="0" style="display:block; max-width:100%;" />
                                            <% end if %>
                                            <!-- Text -->
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                                </tr>
                                                <tr>
                                                    <td style="<%=F_Boxen_Text%> <%=C_Boxen_Text%>">
                                                        <%=getText(Container.Fields("box1_text").value, (F_Boxen_Link & C_Boxen_Link), (F_Boxen_Text &" "& C_Boxen_Text))%>
                                                    </td>
                                                </tr>
                                            </table> 
                                            
                                            <%if Container.Fields("box1_link_url").value <> "" AND Container.Fields("box1_link_text").value <> "" then %>
                                            <div>
                                                <table cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                                                    </tr>
                                                </table>
                                                <!--[if mso]>
                                                    <v:rect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href='<CU:CUField runat="server" name="box1_link_url" />' style="height:45px;v-text-anchor:middle;width:<asp:literal id='width_button1' runat='server' />px;" stroke="f" fillcolor="<%=BG_Boxen_Button%>">
                                                      <w:anchorlock/>
                                                      <center>
                                                    <![endif]-->
                                                        <a class="button" href="<CU:CUField runat='server' name='box1_link_url' />" target='_blank' style="background-color: <%=BG_Boxen_Button%>; <%=C_Boxen_Button%> <%=F_Boxen_Button%> display:inline-block;line-height:45px;text-align:center;width:<asp:literal id='width_button2' runat='server' />px;-webkit-text-size-adjust:none;"><CU:CUField runat="server" name="box1_link_text" /></a>
                                                    <!--[if mso]>
                                                      </center>
                                                    </v:rect>
                                                <![endif]-->
                                            </div>
                                            <% end if %>
                                            
                                        </td>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                    </tr>
                                    <tr>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                        <td style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                    </tr>
                                </table>
                            </span>
                        </td>
                        <td class="hideMobile" width="10" style="line-height: 0; font-size: 1px;"><%=spacer(10,1)%></td>
                    </tr>
                    <tr>
                         <td colspan="2" height="<%=space%>" style="line-height: 0; font-size: 1px;"><%=spacer(1,space)%></td>
                    </tr>
                </table>
                <table class="mobileFullWidthTable" align="left" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td height='<CU:CUField name="boxen_height" runat="server" />' valign="top" class="mobileFullWidth" bgcolor="<%=bgcolor2%>" width="312" style="width:312px; max-width:312px; <%=S_Boxen_Border%> mso-table-lspace:0pt; mso-table-rspace:0pt;">
                            <span style="mso-table-lspace:0;mso-table-rspace:0;">
                                <table class="mobileFullWidthTable" border="0" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                    <tr>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                        <td style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                    </tr>
                                    <tr>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                        <td class="mobileFullWidth" valign="top" width="268" style="max-width: 268px; width: 268px; <%=F_Boxen_Text %> <%=C_Boxen_Text %>">
                                            <!-- Title -->
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="<%=F_Boxen_Title%> <%=C_Boxen_Title%>">
                                                        <CU:CUField name="box2_titel" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,15)%></td>
                                                </tr>
                                            </table> 
                                            <% If Container.Images("box2_img").FileName <> "" Then %>
                                                    <img class="moibleBlockImage" src="<%=getImg(Container.Images("box2_img"))%>" alt="*" border="0" style="display:block; max-width:100%;" />
                                            <% end if %>
                                            <!-- Text -->
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                                </tr>
                                                <tr>
                                                    <td style="<%=F_Boxen_Text%> <%=C_Boxen_Text%>">
                                                        <%=getText(Container.Fields("box2_text").value, (F_Boxen_Link & C_Boxen_Link), (F_Boxen_Text &" "& C_Boxen_Text))%>
                                                    </td>
                                                </tr>
                                            </table>
                                            
                                            <%if Container.Fields("box2_link_url").value <> "" AND Container.Fields("box2_link_text").value <> "" then %>
                                            <div>
                                                <table cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                                                    </tr>
                                                </table>
                                                <!--[if mso]>
                                                    <v:rect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href='<CU:CUField runat="server" name="box2_link_url" />' style="height:45px;v-text-anchor:middle;width:<asp:literal id='width_button3' runat='server' />px;" stroke="f" fillcolor="<%=BG_Boxen_Button%>">
                                                      <w:anchorlock/>
                                                      <center>
                                                    <![endif]-->
                                                        <a class="button" href="<CU:CUField runat='server' name='box2_link_url' />" target='_blank' style="background-color: <%=BG_Boxen_Button%>; <%=C_Boxen_Button%> <%=F_Boxen_Button%> display:inline-block;line-height:45px;text-align:center;width:<asp:literal id='width_button4' runat='server' />px;-webkit-text-size-adjust:none;"><CU:CUField runat="server" name="box2_link_text" /></a>
                                                    <!--[if mso]>
                                                      </center>
                                                    </v:rect>
                                                <![endif]-->
                                            </div>
                                            <% end if %>
                                        </td>
                                        <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                    </tr>
                                    <tr>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                        <td style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                                    </tr>
                                </table>
                            </span>
                        </td>
                    </tr>
                    <tr>
                         <td colspan="2" height="<%=space%>" style="line-height: 0; font-size: 1px;"><%=spacer(1,space)%></td>
                    </tr>
                </table>
                
                
            </td>
        </tr>
    </table>
</asp:panel>
<%end if %>