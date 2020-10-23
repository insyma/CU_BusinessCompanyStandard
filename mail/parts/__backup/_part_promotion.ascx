<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>

<% 'Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->


<script runat="server">
    Dim F_Text = "font-family:Arial, Helvetica sans-serif; font-size:12px; line-height:18px; color:#fff;"
    Dim F_Title = "font-family:Arial, Helvetica sans-serif; font-size:15px; font-weight:bold; line-height:18px; color:#e9d799;"
    Dim F_Lead = "font-family:Arial, Helvetica sans-serif; font-size:12px; line-height:18px; color:#fff;"
    Dim F_Button = "font-family:Arial, Helvetica sans-serif; font-size:14px; line-height:18px; color:#005F9C;"
    Dim styleSpecButton = "border-radius:7px; display:inline-block; font-family:Arial, Helvetica sans-serif; font-size:17px; line-height:34px; text-align:center; text-decoration:none !important; width:274px;"
    
    Dim styleLink = "color:#3c66aa; text-decoration:none;"
    Dim styleFontTextBullet = "font-family:Arial, Helvetica sans-serif; font-size:14px; line-height:18px; color:#333333;"
    
    Dim bgColor = "#1d4569"
    Dim bgColorBorder = "#143655"
    Dim variantWidth = 600
    
</script>
<script runat="server">
    Dim conCount As Integer = 0
    Dim CC as Integer = 0
    dim lang as String = ""

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
            For Each con As ContentUpdate.Container In Container.parent.containers 
                if con.fields("title").value <> "" then
                    CC = CC + 1
                end if
            next
            
            'Sprache definieren
            if CUPage.LanguageCode = 3 then
                lang = "_en"
            end if
            
            'Buttons
            if Container.Fields("button_color").Properties("value").value = "blue" then
                imgButton.text = "<img src='" & getPath("layout") & "button_blau_text"& Container.Fields("button_text").Properties("value").value &""& lang &".gif' border='0' style='display:inline; " & F_Text & "'  alt='"& Container.Fields("button_text").value &"' />"
                
                bgColor = "#ffffff"
                bgColorBorder = "#efefef"
                F_Text = "font-family:Arial, Helvetica sans-serif; font-size:12px; line-height:18px; color:#333333;"
                F_Lead = "font-family:Arial, Helvetica sans-serif; font-size:12px; line-height:18px; color:#333333;"
                F_Title = "font-family:Arial, Helvetica sans-serif; font-size:15px; font-weight:bold; line-height:18px; color:#1d4569;"
            else
                F_Text = "font-family:Arial, Helvetica sans-serif; font-size:12px; line-height:18px; color:#ffffff;"
                F_Lead = "font-family:Arial, Helvetica sans-serif; font-size:12px; line-height:18px; color:#ffffff;"
                styleLink = "color:#9D9D9F; text-decoration:none;"
                styleFontTextBullet = "font-family:Arial, Helvetica sans-serif; font-size:14px; line-height:18px; color:#ffffff;"

                imgButton.text = "<img src='" & getPath("layout") & "button_weiss_text"& Container.Fields("button_text").Properties("value").value &""& lang &".gif' border='0' style='display:inline; " & F_Text & "'  alt='"& Container.Fields("button_text").value &"' />"
            end if
            

            
            if Container.fields("imgposition").value = "links" then
                ImageAlign.text = "right"
            else
                ImageAlign.text = "right"
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
            
            if Container.images("bild").Filename <> "" then
                fullWidth.text = "width:270px; max-width:270px;"
                variantWidth = 270
            end if
             
            ContentMenuAnchor.Text = "<a title=""news_" & conCount & """ name=""news_" & conCount & """  id=""news_" & conCount & """></a>"
    End Sub
    
    Sub BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ListAnchor As Literal = CType(e.Item.FindControl("ListAnchor"), Literal)
            
            If Not con.Fields("desc").Properties("Value").Value = "" Then
                If Not con.Fields("url").Value = "" Then
                    ListAnchor.Text = "<a href=""" & con.Fields("url").Value & """ target='_blank' style='text-decoration:none;" & F_Button & "' title=""" & con.Fields("desc").Value.Replace("&ouml;","ö").Replace("&auml;","ä").Replace("&uuml;","ü").Replace("&Ouml;","Ö").Replace("&Auml;","Ä").Replace("&Uuml;","Ü") & """>" & con.Fields("desc").Value.Replace("&ouml;","ö").Replace("&auml;","ä").Replace("&uuml;","ü").Replace("&Ouml;","Ö").Replace("&Auml;","Ä").Replace("&Uuml;","Ü") & "</a>"
					'ListAnchor.Text = ListAnchor.Text.Replace("&","&amp;")
                End If
                If Not con.Files("file").FileName = "" Then
                    ListAnchor.Text = "<a href=""" & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Button & "' title=""" & con.Fields("desc").Value.Replace("&ouml;","ö").Replace("&auml;","ä").Replace("&uuml;","ü").Replace("&Ouml;","Ö").Replace("&Auml;","Ä").Replace("&Uuml;","Ü") & """>" & con.Fields("desc").Value.Replace("&ouml;","ö").Replace("&auml;","ä").Replace("&uuml;","ü").Replace("&Ouml;","Ö").Replace("&Auml;","Ä").Replace("&Uuml;","Ü") & " / " & con.Files("file").Properties("FileType").Value & " " & con.Files("file").Properties("size").Value & "KB</a>"
					'ListAnchor.Text = ListAnchor.Text.Replace("&","&amp;")
                End If
            Else
                If Not con.Files("file").FileName = "" Then
                    ListAnchor.Text = "<a href=""" & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Button & "' title=""" & con.Files("file").Properties("legend").Value.Replace("&ouml;","ö").Replace("&auml;","ä").Replace("&uuml;","ü").Replace("&Ouml;","Ö").Replace("&Auml;","Ä").Replace("&Uuml;","Ü") & """>" & con.Files("file").Properties("legend").Value.Replace("&ouml;","ö").Replace("&auml;","ä").Replace("&uuml;","ü").Replace("&Ouml;","Ö").Replace("&Auml;","Ä").Replace("&Uuml;","Ü") & " / " & con.Files("file").Properties("FileType").Value & " " & con.Files("file").Properties("size").Value & "KB</a>"
					'ListAnchor.Text = ListAnchor.Text.Replace("&","&amp;")
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
<% if not container.fields("button_link").Value = "" Then%><%=vbcrlf%><CU:CUField name="button_text" runat="server" /><%=vbcrlf%><CU:CUField name="button_link" runat="server" /><%=vbcrlf%><%end if%>
<% end if %>
<%else %>

<asp:panel runat="server" id="fullContent">
<!-- TextBody -->
<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="<%=bgColor%>" style="background-color: <%=bgColor%>; border-bottom: 1px solid <%=bgColorBorder%>; width:100%;">
    <tr>
        <td>
            <table border="0" align="center" cellpadding="0" cellspacing="0">
                <tbody>
                    <tr>
                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><img width="20" height="20" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                        <td height="40" style="line-height: 0; font-size: 1px;"><img width="1" height="20" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><img width="20" height="20" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                    </tr>
                    <tr>
                        <td width="20" height="20" style="line-height: 0; font-size: 1px;"><img width="20" height="20" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                        <td width="640" style="width:640px; max-width:640px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                            <table border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tbody>
                                        <tr>
                                            <td width="600" style="width:600px; max-width:600px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                                <% If Container.Images("bild").FileName <> "" Then %>
                                                <table class="fullWidthArticleImage"  align='<asp:literal runat="server" id="ImageAlign" />' border="0" cellpadding="0" cellspacing="0">
                                                    <tr> 
                                                        <td class="fullWidthArticleImage" width="310">
                                                            <table class="fullWidthArticleImage" align="right" width="290" border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td width="216">
                                                                        <a href='<%=Container.Fields("button_link").value%>' target="blank" style="">
                                                                            <img src="<%=getImg(Container.Images("bild"))%>" alt="Produkt Bild" border="0" />
                                                                        </a>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" height="16" style="line-height: 0; font-size: 1px;"><img width="1" height="16" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                                                    </tr>
                                                </table>
                                                <% end if %>
                                                
                                                <table border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td width="<%=variantWidth%>" style="width:<%=variantWidth%>px; max-width:<%=variantWidth%>px;">
                                                             <!-- Title -->
                                                            <table border="0" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                                                <tr>
                                                                    <td  style="mso-table-lspace:0pt; mso-table-rspace:0pt;  <%=F_Title%>">
                                                                        <asp:Literal ID="ContentMenuAnchor" runat="server" />
                                                                        <CU:CUField Name="title" runat="server" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td height="10" style="line-height: 0; font-size: 1px;"><img width="1" height="10" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                                                                </tr>
                                                            </table>
                                                            <% If Container.Fields("intro").Value <> "" Then %>
                                                                <span style='<%=F_Lead%>'><CU:CUField Name="intro" runat="server" /><br /><br /></span>
                                                            <% end if %>
                                                            <% If Container.Fields("text").Value <> "" Then %>
                                                            <table border="0" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                                                <tbody>
                                                                    <tr>
                                                                        <td  style="<asp:literal runat='server' id='fullWidth' /> mso-table-lspace:0pt; mso-table-rspace:0pt; <%=F_Text%>">
                                                                            <%=getCleanText(Container.Fields("text").value, styleLink, F_Text, styleFontTextBullet)%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td height="10" style="line-height: 0; font-size: 1px;"><img width="1" height="10" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                            <% end if %>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
                                                <a href='<%=Container.Fields("button_link").value%>' target="blank" style="">
                                                    <asp:literal id="imgButton" runat="server" />
                                                </a>
                                                <CU:CUField name='button_link' runat='server' visible='false' />
                                                <asp:literal runat='server' id='button_strokecolor' visible='false' />
                                                <asp:literal runat='server' id='button_img' visible='false' />
                                                <asp:literal runat='server' id='button_bgcolor' visible='false' />
                                                <asp:literal runat='server' id='button_fontcolor' visible='false' />
                                                <CU:CUField name="button_text" runat="server" visible='false' />
                                                <asp:literal runat='server' id='button_fontcolor_web' visible='false' />
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td width="20" height="20" style="line-height: 0; font-size: 1px;"><img width="20" height="20" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                            <td height="40" style="line-height: 0; font-size: 1px;"><img width="1" height="20" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                            <td width="20" height="20" style="line-height: 0; font-size: 1px;"><img width="20" height="20" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                        </tr>
                    </tbody>
                </table>
            </td>
        </tr>
    </table>
                                
</asp:panel>
<%end if %>