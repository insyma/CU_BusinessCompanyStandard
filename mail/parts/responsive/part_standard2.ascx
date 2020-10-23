<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Dim conCount As Integer = 0
    dim cols as string = "2"
    dim p as string = ""
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    '##### dynamischer Pfad like "/CU_BusinessCompanyStandard/mail/"
    p = CUPage.Web.TemplatePath
End Sub
Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
   	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then

		Dim bild1 As Literal = CType(e.Item.FindControl("bild1"), Literal)
		Dim bild2 As Literal = CType(e.Item.FindControl("bild2"), Literal)
		Dim link As Literal = CType(e.Item.FindControl("link"), Literal)
		Dim TextLeft As Literal = CType(e.Item.FindControl("TextLeft"), Literal)
		Dim TextRight As Literal = CType(e.Item.FindControl("TextRight"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
		TextLeft.Text = con.Fields("text_links").Value.Replace("<a","<a style='color: #CC0000; text-decoration: none;'").replace("<ul", "<ul style='margin:0;'")
		TextRight.Text = con.Fields("text_rechts").Value.Replace("<a","<a style='color: #CC0000; text-decoration: none;'").replace("<ul", "<ul style='margin:0;'")
		bild1.text="<img src='http://www.contentupdate.net" & p & "img/cuimgpath/" & con.Images("bild_links").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_links").properties("Legend").value & "' />"
		bild2.text="<img src='http://www.contentupdate.net" & p & "img/cuimgpath/" & con.Images("bild_rechts").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_rechts").properties("Legend").value & "' />"
		'link.text="<a href='" & con.Links("link").properties("value").value & "' target='_blank' style='color:#CC0000; text-decoration:none;' >" & con.Links("link").properties("description").value & "</a>"
		End If
End Sub
</script>
<%  If TemplateView = "text" Then%>
----------------------------------------------------------------------
<%  If Not Container.Fields("title").Value = "" Then%><CU:CUField Name="title" runat="server" PlainText="true" />
----------------------------------------------------------------------<%=vbcrlf%><% end if %>
<%  For Each cuentry As ContentUpdate.Container In Container.ObjectSets("culist").Containers%>
<%if not cuentry.Fields("text_links").Value = "" then %><%=vbcrlf%><%=vbcrlf%><%=cuentry.Fields("text_links").Plaintext %><%end if%>
<%If Not cuentry.Fields("text_rechts").Value = "" Then%><%=vbcrlf%><%=cuentry.Fields("text_rechts").Plaintext %><%end if %><%next%><%else %>
<table border="0" align="center" cellpadding="0" cellspacing="0">
                         <% if not container.images("icon").properties("filename").value = "" then 
                            cols = 3
                         else 
                            cols = 2
                         end if %>
                    <tr>
                            <tr>
                              <td align="center" valign="top" bgcolor="#FFFFFF" style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                              <table border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td height="1" colspan="<%=cols%>" bgcolor="#DF0402" style="width:622px; max-width:622px;" ></td>
                                </tr>
                                <tr>
                                  <td bgcolor="#F7F7F7" style="width:15px; max-width:15px;">&nbsp;</td>
                                  <% if not container.images("icon").properties("filename").value = "" then %>
                                    <td bgcolor="#F7F7F7" style="width:40px; max-width:40px;"><img src='http://www.contentupdate.net<%=p%>img/icon/cuimgpath/<%=container.images("icon").processedfilename%>' width="28" height="40" style="display:block;" alt="" /></td>
                                    <td height="47" align="left" bgcolor="#F7F7F7" style="width:567px; max-width:567px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:15px; color:#393131;"><CU:CUField name="title" runat="server" /></td>
                                  <% else %>
                                    <td height="47"  align="left" bgcolor="#F7F7F7" style="width:607px; max-width:607px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:15px; color:#393131;"><CU:CUField name="title" runat="server" /></td>    
                                  <% end if %>
                                </tr>
                                <tr>
                                  <td height="1" colspan="<%=cols%>" bgcolor="#E6E6E6" style="width:622px; max-width:622px;"></td>
                                </tr>
                                <tr>
                                  <td height="1" colspan="<%=cols%>" bgcolor="#FFFFFF" style="width:622px; max-width:622px;"></td>
                                </tr>
                              </table></td>
                            </tr>                           

							<tr>
                                <td align="center" valign="top" bgcolor="#FFFFFF" style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                <CU:CUObjectSet name="culist" runat="server" OnItemDataBound="BindItem">
								<ItemTemplate>
								  <table border="0" align="center" cellpadding="0" cellspacing="0" class="resetWidth">
                                  <tr>
                                    <td align="center" valign="top" bgcolor="#F7F7F7" style="width:622px; max-width:622px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><table border="0" align="left" cellpadding="0" cellspacing="0" style="display:inline">
                                      <tr>
                                        <td><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="15" height="15" style="display:block;" alt="" /></td>
                                        <td class="resetWidth" style="width:280px; max-width:280px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
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
                                        <td bgcolor="#F7F7F7">&nbsp;</td>
                                        <td align="left" valign="top" bgcolor="#F7F7F7" class="resetWidth" style="width:280px; max-width:280px; mso-table-lspace:0pt; mso-table-rspace:0pt; mso-table-tspace:0pt; mso-table-bspace:0; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%;"><asp:Literal id="TextLeft" runat="server" /></td>
                                      </tr>
                                    </table>
                                      <table align="left" width="309" border="0" cellpadding="0" cellspacing="0" style="display:inline">
                                        <tr>
                                          <td><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="14" height="15" style="display:block;" alt="" /></td>
                                          <td class="resetWidth" style="width:280px; max-width:280px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                                          <td><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="15" height="15" style="display:block;" alt="" /></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td style="width:280px; max-width:280px; border:1px solid #D3D3D3;"><table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center" style="width:280px; max-width:280px; border:7px solid #FFFFFF; mso-table-lspace:0pt; mso-table-rspace:0pt;"><asp:Literal ID="bild2" runat="server"/></td>
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
                                          <td align="left" valign="top" class="resetWidth" style="width:280px; max-width:280px; mso-table-lspace:0pt; mso-table-rspace:0pt; mso-table-tspace:0pt; mso-table-bspace:0; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%;"><asp:Literal id="TextRight" runat="server" /></td>
                                          <td>&nbsp;</td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                  <tr>
                                    <td align="center" valign="top" bgcolor="#F7F7F7" style="width:622px; max-width:622px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td align="center" valign="top" bgcolor="#F7F7F7" style="width:622px; max-width:622px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                                  </tr>
                                  </table>
                                </ItemTemplate>
								</CU:CUObjectSet>
                                </td>
                            </tr>
							<tr>
							  <td align="center" valign="top" bgcolor="#FFFFFF" style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
  </tr>
                         </table>
<%end if %>