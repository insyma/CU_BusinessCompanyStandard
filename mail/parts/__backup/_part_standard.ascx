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
		Dim bild As Literal = CType(e.Item.FindControl("bild"), Literal)
		Dim link As Literal = CType(e.Item.FindControl("link"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
        dim txt as Literal = CType(e.Item.FindControl("txt"), Literal)
        
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
        if not con.Images("bild").properties("filename").value = "" then
            bild.text = "<td align=""left"" valign=""top"" bgcolor=""#F7F7F7"" style=""width:140px; max-width:140px; mso-table-lspace:0pt; mso-table-rspace:0pt;"">"
            bild.text += "<img src='http://www.contentupdate.net<%=p%>img/cuimgpath/" & con.Images("bild").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild").properties("Legend").value & "' />"
            bild.text += "</td>"
            bild.text += "<td align=""left"" valign=""top"" bgcolor=""#F7F7F7"" style=""width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;"">&nbsp;</td>"
            bild.text += "<td class=""text"" align=""left"" valign=""top"" bgcolor=""#F7F7F7"" style=""width:437px; max-width:437px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;"">"
		else
            bild.text += "<td class=""text"" colspan=""3"" align=""left"" valign=""top"" bgcolor=""#F7F7F7"" style=""width:592px; max-width:592px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;"">"
        end if
        txt.text = con.fields("text").value.replace("<a", "<a style='color: #CC0000; text-decoration: none;'").replace("<ul", "<ul style='margin:0;'")
		if not con.Links("link").properties("value").value = "" then
            dim  _l as string = con.Links("link").properties("description").value
            if _l = "" then
                _l = con.Links("link").properties("value").value
            end if
            link.text="| <a href='" & con.Links("link").properties("value").value & "' target='_blank' style='color:#CC0000; text-decoration:none;' >" & _l & "</a>"
		end if
    End If
End Sub
</script>
<%  If TemplateView = "text" Then%>
----------------------------------------------------------------------
<%  If Not Container.Fields("title").Value = "" Then%><CU:CUField Name="title" runat="server" PlainText="true" />
----------------------------------------------------------------------<%=vbcrlf%><% end if %>
<%  For Each cuentry As ContentUpdate.Container In Container.ObjectSets("culist").Containers%>
<%if not cuentry.Fields("intro").Value = "" then %><%=vbcrlf%><%=vbcrlf%><%=cuentry.Fields("intro").Plaintext %><%end if%>
<%If Not cuentry.Fields("text").Value = "" Then%><%=vbcrlf%><%=cuentry.Fields("text").Plaintext %><%end if %>
<%If Not cuentry.links("link").properties("value").value = "" Then%><% if not cuentry.links("link").properties("legend").value = "" then%><%=vbcrlf & cuentry.links("link").properties("legend").value%><%end if%><%=vbcrlf & cuentry.links("link").properties("value").value%><%end if%>
<%next%><%else %>

            <table border="0" cellspacing="0" cellpadding="0" align="center">
                    <% if not container.images("icon").properties("filename").value = "" then 
                            cols = 3
                         else 
                            cols = 2
                         end if %>
                    <tr>
                        <td height="1" colspan="<%=cols%>" bgcolor="#DF0402"></td>
                    </tr>
                    <tr>

                        <td bgcolor="#F7F7F7" style="width:15px; max-width:15px;">&nbsp;</td>
                        <% if not container.images("icon").properties("filename").value = "" then %>
                        <td bgcolor="#F7F7F7" style="width:40px; max-width:40px;"><img src='http://www.contentupdate.net<%=p%>img/icon/cuimgpath/<%=container.images("icon").processedfilename%>' width="28" height="40" style="display:block;" alt="" /></td>
                        <td height="47" align="left" bgcolor="#F7F7F7" style="width:567px; max-width:567px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:15px; color:#393131;"><CU:CUField name="title" runat="server" /></td>
                        <% else %>
                        <td height="47" align="left" bgcolor="#F7F7F7" style="width:607px; max-width:607px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:15px; color:#393131;"><CU:CUField name="title" runat="server" /></td>    
                        <% end if %>
                    </tr>
                    <tr>
                        <td height="1" colspan="<%=cols%>" bgcolor="#E6E6E6" style="width:622px; max-width:622px;"></td>
                    </tr>
                    <tr>
                        <td height="1" colspan="<%=cols%>" bgcolor="#FFFFFF" style="width:622px; max-width:622px;"></td>
                    </tr>
                    <tr>
                        <td height="10" colspan="<%=cols%>" bgcolor="#F7F7F7" style="width:622px; max-width:622px;"></td>
                    </tr>
                
            </table>
        
            <CU:CUObjectSet name="culist" runat="server" OnItemDataBound="BindItem">
			<ItemTemplate>
                <table border="0" cellspacing="0" cellpadding="0" align="center">
                     <tr>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:140px; max-width:140px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:437px; max-width:437px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:15px; max-width:15px;mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                        <asp:Literal ID="bild" runat="server"/>
                        <strong style="color:#333333; line-height:100%;"><CU:CUField name="intro" runat="server" /></strong><br />
                        <asp:Literal ID="txt" runat="server"/><br />
                        <asp:Literal ID="link" runat="server"/></td>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:140px; max-width:140px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                        <td class="text" align="left" valign="top" bgcolor="#F7F7F7" style="width:437px; max-width:437px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                        <td align="left" valign="top" bgcolor="#F7F7F7" style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                    </tr>
                </table>
                </ItemTemplate>
			</CU:CUObjectSet>
              <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="5" style="width:622px; max-width:622px;" bgcolor="#FFFFFF">&nbsp;</td>
                    </tr>
                </table>

<%end if %>
