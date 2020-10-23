<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>

<% 'Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    Dim conCount As Integer = 0
    Dim CC as Integer = 0
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        For Each con As ContentUpdate.Container In Container.parent.containers 
            if con.fields("title").value <> "" then
                CC = CC + 1
            end if
        next

        if Container.fields("imgposition").value = "links" then
            ImageAlign.text = "left"
        else
            ImageAlign.text = "right"
            ImageAlignRightMargin.visible = false
        end if
        if Container.fields("title").value = "" then
            fullContent.visible = false
        end if
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

        if container.images("bild").Filename <> "" then
            fullWidth.text = "width:288px; max-width:288px;"
            fullWidth2.text = "288"
        end if

        if conCount <> CC then
            'spacer2.visible = false
        end if

        ContentMenuAnchor.Text = "<a title=""news_" & conCount & """ name=""news_" & conCount & """  id=""news_" & conCount & """></a>"
    End Sub
    
    Sub BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ListAnchor As Literal = CType(e.Item.FindControl("ListAnchor"), Literal)
            Dim ListImage As Literal = CType(e.Item.FindControl("ListImage"), Literal)
            
            Dim ImgDownload as String = "<img style='display:inline; vertical-align:text-bottom;' border='0' src='" & getPath("layout") & "download.gif' />"
            Dim ImgLink as String = "<img style='display:inline; vertical-align:text-bottom;' border='0' src='" & getPath("layout") & "link.gif' />"
            
            If Not con.Fields("desc").Properties("Value").Value = "" Then
                If Not con.Fields("url").Value = "" Then
                    ListAnchor.Text = "<a href=""" & con.Fields("url").Value & """ target='_blank' style='text-decoration:none;" & F_Button & "" & C_Button & "' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & "</a>"
                    ListImage.Text = ImgLink
                    if e.Item.ItemIndex = 0 then
                        imgLinkFromList_start.Text = "<a href=""" & con.Fields("url").Value & """ target='_blank' style='text-decoration:none;" & F_Button & "" & C_Button & "' title=""" & con.Fields("desc").Value & """>"
                        imgLinkFromList_end.Text = "</a>"
                    end if 
                End If
                If Not con.Files("file").FileName = "" Then
                    ListAnchor.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Button & "" & C_Button & "' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & " / " & con.Files("file").Properties("FileType").Value & " " & con.Files("file").Properties("size").Value & "KB</a>"
                    ListImage.Text = ImgDownload
                    if e.Item.ItemIndex = 0 then
                        imgLinkFromList_start.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Button & "" & C_Button & "' title=""" & con.Fields("desc").Value & """>"
                        imgLinkFromList_end.Text = "</a>"
                    end if 
                End If
            Else
                If Not con.Files("file").FileName = "" Then
                    ListAnchor.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Button & "" & C_Button & "' title=""" & con.Files("file").Properties("legend").Value & """>" & con.Files("file").Properties("legend").Value & " / " & con.Files("file").Properties("FileType").Value & " " & con.Files("file").Properties("size").Value & "KB</a>"
                    ListImage.Text = ImgDownload
                    if e.Item.ItemIndex = 0 then
                        imgLinkFromList_start.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Button & "" & C_Button & "' title=""" & con.Fields("desc").Value & """>"
                        imgLinkFromList_end.Text = "</a>"
                    end if 
                End If
            End If
            
            
            
        End If
    End Sub
</script>
<%  If TemplateView = "text" Then%>
<%  If Not Container.Fields("title").Value = "" Then%>
-----------------------------------------------------------------
<CU:CUField Name="title" runat="server" PlainText="true" /><%=vbcrlf%>-----------------------------------------------------------------
<%  If Not Container.Fields("intro").Value = "" Then%><%=vbcrlf%><CU:CUField name="intro" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("text").Value = "" Then%><%=vbcrlf%><CU:CUField Name="text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<% end if %><%=vbcrlf%><%  For Each cuentry As ContentUpdate.Container In Container.ObjectSets("culist").Containers%><%if not cuentry.Fields("desc").Value = "" then %>
<%=cuentry.Fields("desc").Plaintext %><%If Not cuentry.Fields("url").Value = "" Then%><%=vbcrlf%><%=cuentry.Fields("url").Plaintext %><%end if %>
<%If Not cuentry.Files("file").Filename = "" Then%><%=vbcrlf%>http://www.cu3.ch/swisssales/mail<%=cuentry.Files("file").Src%> [<%=cuentry.Files("file").Properties("FileType").Value%> | <%=cuentry.Files("file").Properties("Size").Value%>]<%end if %><%else %><%If Not cuentry.Files("file").Filename = "" Then%>
<%=vbcrlf%><%=cuentry.Files("file").Properties("Legend").Value%> <%=vbcrlf%>http://www.cu3.ch/swisssales/mail<%=cuentry.Files("file").Src%> [<%=cuentry.Files("file").Properties("FileType").Value%> | <%=cuentry.Files("file").Properties("Size").Value%>]<%end if %><%end if %>
<%next %><%else %>

<asp:panel runat="server" id="fullContent">
<!-- Full Width Table -->
<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="<%=C_Content_BG%>" style="background-color: <%=C_Content_BG%>; border-bottom: 1px solid <%=C_Content_Border%>; width:100%;">
        <tr>
            <td>

<!-- Holder -->
<table align="center" border="0" cellpadding="0" cellspacing="0" bgcolor="<%=C_Content_BG%>" style='<%=S_BoxShadow%>'>
    <tr>
        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
    </tr>
    <tr>
        <td width="640" style="width:640px; max-width:640px;">

            <table border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    <td width="600" style="width:600px; max-width:600px;">
                        <!-- Title -->
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="<%=F_Title%>">
                                    <asp:Literal ID="ContentMenuAnchor" runat="server" />
                                    <CU:CUField Name="title" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,15)%></td>
                            </tr>
                        </table>

                        <% If Container.Fields("intro").Value <> "" Then %>
                            <span style='<%=F_LeadText%>'><CU:CUField Name="intro" runat="server" /><br /><br /></span>
                        <% end if %>
                        <table class="mobileFullWidth" border="0" cellpadding="0" cellspacing="0">
                           <tr>
                               <td width="600" style="width:600px; max-width:600px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                <% If Container.Images("bild").FileName <> "" Then %>
                                    <table class="mobileFullWidth" align='<asp:literal runat="server" id="ImageAlign" />' cellpadding="0" cellspacing="0" style="border:1px solid <%=C_Content_BG%>; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                        <tr>
                                            <td bgcolor="<%=C_Content_BG%>" width="288" style="width:288px; max-width:288px; text-align: left; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                                <span style="mso-table-lspace:0pt; mso-table-rspace:0pt; margin: 0;">
                                                    <asp:literal runat="server" id="imgLinkFromList_start" />
                                                    <img class="moibleBlockImage" src="<%=getImg(Container.Images("bild"))%>" alt="*" border="0" style="display:inline; max-width:100%;" />
                                                    <asp:literal runat="server" id="imgLinkFromList_end" />
                                                </span>
                                            </td>
                                            <td runat="server" id="ImageAlignRightMargin" class="fullWidthArticleImage" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                                        </tr>
                                    </table>
                                <% end if %>

                                <% If Container.Fields("text").Value <> "" Then %>
                                <table cellpadding="0" cellspacing="0" style="border:1px solid <%=C_Content_BG%>; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                    <tbody>
                                        <tr>
                                            <td bgcolor="<%=C_Content_BG%>" width="<asp:literal runat='server' id='fullWidth2' />" style="<asp:literal runat='server' id='fullWidth' /> mso-table-lspace:0pt; mso-table-rspace:0pt; <%=F_Text%>">
                                                <%=getText(Container.Fields("text").value, "", F_Text)%>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
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
                                <!-- Spacer -->
                                <table border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td height="5" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                                    </tr>
                                </table>
                                <table class="mobileFullWidth" width="227" border="0" cellpadding="10" cellspacing="0">
                                    <tr>
                                        <td width="16" bgcolor="#ECEEE9" style=""><asp:Literal ID="ListImage" runat="server" /> </td>
                                        <td bgcolor="#f5f5f5" style="<%=F_Button%>"><asp:Literal ID="ListAnchor" runat="server" /> </td>
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
        <td height="6" style="line-height: 0; font-size: 1px;"><%=spacer(1,6)%></td>
    </tr>
</table>


            </td>
        </tr>
</table>
</asp:panel>
<%end if %>