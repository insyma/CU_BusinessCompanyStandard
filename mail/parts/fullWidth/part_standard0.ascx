<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Dim conCount As Integer = 0
	
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        
    End Sub
	Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
   	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		Dim bild As Literal = CType(e.Item.FindControl("bild"), Literal)
		Dim link As Literal = CType(e.Item.FindControl("link"), Literal)
		Dim Text As Literal = CType(e.Item.FindControl("Text"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
		bild.text="<img style='font-family:Arial, Helvetica, sans-serif; font-size:18px; text-align:center; line-height:47px; color:#cccccc; display:block;' src='http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/cuimgpath/" & con.Images("bild").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild").properties("Legend").value & "' />"
		link.text="<a href='" & con.Links("link").properties("value").value & "' target='_blank' style='color:#C20F1F; text-decoration:none;' >&raquo; " & con.Links("link").properties("description").value & "</a>"
		Text.Text = con.Fields("text").Value.Replace("<a","<a style='color: #C20F1F; text-decoration: none;'")

		End If
End Sub
</script>
<%  If TemplateView = "text" Then%>
----------------------------------------------------------------------
<%  If Not Container.Fields("title").Value = "" Then%><CU:CUField Name="title" runat="server" PlainText="true" />
----------------------------------------------------------------------<%=vbcrlf%><% end if %>
<%  If Not Container.Fields("intro").Value = "" Then%><%=vbcrlf%><CU:CUField name="intro" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("text").Value = "" Then%><%=vbcrlf%><CU:CUField Name="text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("text2").Value = "" Then%><%=vbcrlf%><CU:CUField Name="text2" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>

<%  For Each cuentry As ContentUpdate.Container In Container.ObjectSets("culist").Containers%><%if not cuentry.Fields("desc").Value = "" then %>
<%=vbcrlf%><%=vbcrlf%><%=cuentry.Fields("desc").Plaintext %><%If Not cuentry.Fields("url").Value = "" Then%>
<%=vbcrlf%><%=cuentry.Fields("url").Plaintext %><%end if %><%If Not cuentry.Files("file").Filename = "" Then%>
<%=vbcrlf%>http://www.cu3.ch/CU_BCS/mail/<%=cuentry.Files("file").Src%> [<%=cuentry.Files("file").Properties("FileType").Value%> | <%=cuentry.Files("file").Properties("Size").Value%>]<%end if %><%else %><%If Not cuentry.Files("file").Filename = "" Then%>
<%=vbcrlf%><%=cuentry.Files("file").Properties("Legend").Value%> <%=vbcrlf%>http://www.cu3.ch/CU_BCS/mail/<%=cuentry.Files("file").Src%> [<%=cuentry.Files("file").Properties("FileType").Value%> | <%=cuentry.Files("file").Properties("Size").Value%>]<%end if %><%end if %>
<%next %><%=vbcrlf%><%else %>
<CU:CUObjectSet name="culist" runat="server" OnItemDataBound="BindItem">
<ItemTemplate>
            <table align="center" border="0" cellpadding="0" cellspacing="0">
                      <tbody><tr>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                        <td style="width:157px; max-width:157px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                        <td style="width:420px; max-width:420px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                        <td style="width:15px; max-width:15px;mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                        <td style="width:157px; max-width:157px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">
                        <asp:Literal ID="bild" runat="server"/></td>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                        <td class="text" style="width:420px; max-width:420px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#595252; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top"><strong style="color:#C20F1F; line-height:100%;"><CU:CUField name="title" runat="server" /></strong><br>
                        <asp:Literal ID="text" runat="server"/><br /><asp:Literal ID="link" runat="server"/></td>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                        <td style="width:157px; max-width:157px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                        <td class="text" style="width:420px; max-width:420px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                      </tr>
                    </tbody></table>
            </ItemTemplate>
			</CU:CUObjectSet>
<%end if %>
