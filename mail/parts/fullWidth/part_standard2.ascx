<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Dim conCount As Integer = 0
    
    Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
   	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then

		Dim bild1 As Literal = CType(e.Item.FindControl("bild1"), Literal)
		Dim bild2 As Literal = CType(e.Item.FindControl("bild2"), Literal)
		Dim linkleft As Literal = CType(e.Item.FindControl("linkleft"), Literal)
		Dim linkright As Literal = CType(e.Item.FindControl("linkright"), Literal)
		Dim TextLeft As Literal = CType(e.Item.FindControl("TextLeft"), Literal)
		Dim TextRight As Literal = CType(e.Item.FindControl("TextRight"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
		TextLeft.Text = con.Fields("text_links").Value.Replace("<a","<a style='color: #C20F1F; text-decoration: none;'")
		TextRight.Text = con.Fields("text_rechts").Value.Replace("<a","<a style='color: #C20F1F; text-decoration: none;'")
		bild1.text="<img style='font-family:Tahoma, Geneva, sans-serif; font-size:18px; color:#333333;' src='http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/cuimgpath/" & con.Images("bild_links").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_links").properties("Legend").value & "' />"
		bild2.text="<img style='font-family:Tahoma, Geneva, sans-serif; font-size:18px; color:#333333;' src='http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/cuimgpath/" & con.Images("bild_rechts").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_rechts").properties("Legend").value & "' />"
		linkleft.text="<a href='" & con.Links("link_links").properties("value").value & "' target='_blank' style='color:#C20F1F; text-decoration:none;' >" & con.Links("link_links").properties("description").value & "</a>"
		linkright.text="<a href='" & con.Links("link_rechts").properties("value").value & "' target='_blank' style='color:#C20F1F; text-decoration:none;' >" & con.Links("link_rechts").properties("description").value & "</a>"
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
<%next %><%=vbcrlf%>
<%else %>
<table border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td align="center" valign="top" bgcolor="#FFFFFF" style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><table class="contentable" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                        <td colspan="2" style="width:622px; max-width:622px;;" bgcolor="#B5B5B5" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1"></td>
                      </tr>
                      <tr>
                        <td colspan="2" style="width:622px; max-width:622px;;" bgcolor="#FFFFFF" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1"></td>
                      </tr>
                          <tr>
                            <td align="left" valign="top" bgcolor="#E8E8E8" style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" width="5" height="47" style="display:block;" alt="" /></td>
                            <td height="30" align="left" bgcolor="#E8E8E8" style="width:607px; max-width:607px; mso-table-lspace:0pt; mso-table-rspace:0pt; font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#C10E1F;"><CU:CUField name="title" runat="server" /></td>
                          </tr>
                          <tr>
                            <td colspan="2" align="center" valign="bottom" bgcolor="#E8E8E8" style="width:622px; max-width:622px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                                            <CU:CUObjectSet name="culist" runat="server" OnItemDataBound="BindItem">
								<ItemTemplate>
<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td style="width:622px; max-width:622px; mso-table-lspace:0pt; mso-table-rspace:0pt;">

<table border="0" align="left" cellpadding="0" cellspacing="0" style="display:inline">
                              <tr>
                                <td><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" width="22" height="5" style="display:block;" alt="" /></td>
                                <td class="resetWidth" style="width:280px; max-width:280px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" width="22" height="5" style="display:block;" alt="" /></td>
                              </tr>
                              <tr>
                                <td>&nbsp;</td>
                                <td style="width:280px; max-width:280px; border:1px solid #D3D3D3;"><table border="0" cellspacing="0" cellpadding="0">
                                  <tr>
                                    <td align="center" style="width:280px; max-width:280px; border:7px solid #FFFFFF; mso-table-lspace:0pt; mso-table-rspace:0pt;"><asp:Literal ID="bild1" runat="server"/></td>
                                  </tr>
                                </table></td>
                              </tr>
                              <tr>
                                <td>&nbsp;</td>
                                <td class="resetWidth" style="width:280px; max-width:280px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                              </tr>
                              <tr>
                                <td>&nbsp;</td>
                                <td align="left" valign="top" class="resetWidth" style="width:280px; max-width:280px; mso-table-lspace:0pt; mso-table-rspace:0pt; mso-table-tspace:0pt; mso-table-bspace:0; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%;"><strong style="color:#333333; line-height:100%;"><CU:CUField name="titel_links" runat="server" /></strong><br />
                                    <asp:Literal ID="TextLeft" runat="server"/><br />
                                    <br />
                                    <asp:Literal ID="linkleft" runat="server"/><br />
                                    <span style="color:#333333;"><CU:CUField name="beschreibung_links" runat="server" /></span></td>
                              </tr>
                            </table>
                              <table align="left" width="309" border="0" cellpadding="0" cellspacing="0" style="display:inline">
                                <tr>
                                  <td><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" width="14" height="5" style="display:block;" alt="" /></td>
                                  <td class="resetWidth" style="width:280px; max-width:280px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" width="22" height="5" style="display:block;" alt="" /></td>
                                  <td><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" width="15" height="5" style="display:block;" alt="" /></td>
                                </tr>
                                <tr>
                                  <td>&nbsp;</td>
                                  <td style="width:280px; max-width:280px; border:1px solid #D3D3D3;"><table border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center" style="width:280px; max-width:280px; border:7px solid #FFFFFF; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                      <asp:Literal ID="bild2" runat="server"/></td>
                                    </tr>
                                  </table></td>
                                  <td>&nbsp;</td>
                                </tr>
                                <tr>
                                  <td>&nbsp;</td>
                                  <td class="resetWidth" style="width:280px; max-width:280px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                                  <td>&nbsp;</td>
                                </tr>
                                <tr>
                                  <td>&nbsp;</td>
                                  <td align="left" valign="top" class="resetWidth" style="width:280px; max-width:280px; mso-table-lspace:0pt; mso-table-rspace:0pt; mso-table-tspace:0pt; mso-table-bspace:0; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%;"><strong style="color:#333333; line-height:100%;"><CU:CUField name="titel_rechts" runat="server" /></strong><br />
                                    <asp:Literal ID="TextRight" runat="server"/><br />
                                      <br />
                                    <asp:Literal ID="linkright" runat="server"/><br />
                                    <span style="color:#333333;"><CU:CUField name="beschreibung_rechts" runat="server" /></span></td>
                                  <td>&nbsp;</td>
                                </tr>
                            </table></td>
  </tr>
</table>
 </ItemTemplate>
								</CU:CUObjectSet>      
                            
                            </td>
                          </tr>
                          <tr>
                            <td colspan="2" style="width:622px; max-width:622px;;" bgcolor="#E8E8E8" height="1">&nbsp;</td>
                          </tr>
                          <tr>
                        <td colspan="2" style="width:622px; max-width:622px;;" bgcolor="#FFFFFF" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1"></td>
                      </tr>
                      <tr>
                        <td colspan="2" style="width:622px; max-width:622px;;" bgcolor="#B5B5B5" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1"></td>
                      </tr>
                        </table></td>
                      </tr>
                    </table>


<%end if %>