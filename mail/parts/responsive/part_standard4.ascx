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
		Dim bild_1 As Literal = CType(e.Item.FindControl("bild_1"), Literal)
		Dim bild_2 As Literal = CType(e.Item.FindControl("bild_2"), Literal)
		Dim bild_3 As Literal = CType(e.Item.FindControl("bild_3"), Literal)
		Dim bild_4 As Literal = CType(e.Item.FindControl("bild_4"), Literal)
		Dim Text1 As Literal = CType(e.Item.FindControl("Text1"), Literal)
		Dim Text2 As Literal = CType(e.Item.FindControl("Text2"), Literal)
		Dim Text3 As Literal = CType(e.Item.FindControl("Text3"), Literal)
		Dim Text4 As Literal = CType(e.Item.FindControl("Text4"), Literal)
		Dim link As Literal = CType(e.Item.FindControl("link"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
		bild_1.text="<img src='http://www.contentupdate.net" & p & "img/cuimgpath/" & con.Images("bild_1").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_1").properties("Legend").value & "' />"
		bild_2.text="<img src='http://www.contentupdate.net" & p & "img/cuimgpath/" & con.Images("bild_2").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_2").properties("Legend").value & "' />"
		bild_3.text="<img src='http://www.contentupdate.net" & p & "img/cuimgpath/" & con.Images("bild_3").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_3").properties("Legend").value & "' />"
		bild_4.text="<img src='http://www.contentupdate.net" & p & "img/cuimgpath/" & con.Images("bild_4").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_4").properties("Legend").value & "' />"
		Text1.Text = con.Fields("text_1").Value.Replace("<a","<a style='color: #CC0000; text-decoration: none;'").replace("<ul", "<ul style='margin:0;'")
		Text2.Text = con.Fields("text_2").Value.Replace("<a","<a style='color: #CC0000; text-decoration: none;'").replace("<ul", "<ul style='margin:0;'")
		Text3.Text = con.Fields("text_3").Value.Replace("<a","<a style='color: #CC0000; text-decoration: none;'").replace("<ul", "<ul style='margin:0;'")
		Text4.Text = con.Fields("text_4").Value.Replace("<a","<a style='color: #CC0000; text-decoration: none;'").replace("<ul", "<ul style='margin:0;'")

		'link.text="<a href='" & con.Links("link").properties("value").value & "' target='_blank' style='color:#CC0000; text-decoration:none;' >" & con.Links("link").properties("description").value & "</a>"
		End If
End Sub
</script>
<%  If TemplateView = "text" Then%>
----------------------------------------------------------------------
<%  If Not Container.Fields("title").Value = "" Then%><CU:CUField Name="title" runat="server" PlainText="true" />
----------------------------------------------------------------------<%=vbcrlf%><% end if %>
<%  For Each cuentry As ContentUpdate.Container In Container.ObjectSets("culist").Containers%>
<%dim i as integer = 1
for i=1 to 4%>
<%if not cuentry.Fields("text_" & i).Value = "" then %>
<%=vbcrlf%><%=vbcrlf%><%=cuentry.Fields("text_" & i).Plaintext %>
<%end if%>
<%next%>
<%next%><%else %>
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
                            <td height="1" colspan="<%=cols%>" bgcolor="#DF0402" style="width:622px; max-width:622px;"></td>
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
                        <tr>
                            <td height="10" colspan="<%=cols%>" bgcolor="#F7F7F7" style="width:622px; max-width:622px;"></td>
                        </tr>
                    
                </table>
                </td>
            </tr>
           
            <tr>
                <td align="center" valign="top" bgcolor="#FFFFFF" style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                <CU:CUObjectSet name="culist" runat="server" OnItemDataBound="BindItem">
                <ItemTemplate>
                  <table border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td bgcolor="#F7F7F7"><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="14" height="15" style="display:block;" alt="" /></td>
                    <td align="center" bgcolor="#F7F7F7" style="width:592px; max-width:592px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td style="width:592px; max-width:592px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
<table border="0" align="left" cellpadding="0" cellspacing="0">
                      <tr>
                        <td style="width:136px; max-width:136px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><asp:Literal ID="bild_1" runat="server"/></td>
                        <td bgcolor="#F7F7F7"><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="15" height="15" style="display:block;" alt="" /></td>
                        <td style="width:136px; max-width:136px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><asp:Literal ID="bild_2" runat="server"/></td>
                        <td bgcolor="#F7F7F7"><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="15" height="15" style="display:block;" alt="" /></td>
                      </tr>
                      <tr>
                        <td align="left" valign="top"  style="width:136px; max-width:136px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;"><br />
                        <asp:Literal id="Text1" runat="server" /></td>
                        <td bgcolor="#F7F7F7">&nbsp;</td>
                        <td align="left" valign="top"  style="width:136px; max-width:136px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;"><br />
                        <asp:Literal id="Text2" runat="server" /></td>
                        <td bgcolor="#F7F7F7">&nbsp;</td>
                      </tr>
                    </table>
                      <table align="left" width="287" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                          <td style="width:136px; max-width:136px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><asp:Literal ID="bild_3" runat="server"/></td>
                          <td bgcolor="#F7F7F7"><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="15" height="15" style="display:block;" alt="" /></td>
                          <td style="width:136px; max-width:136px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><asp:Literal ID="bild_4" runat="server"/></td>
                        </tr>
                        <tr>
                          <td align="left" valign="top"  style="width:136px; max-width:136px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;"><br />
                          <asp:Literal id="Text3" runat="server" /></td>
                          <td bgcolor="#F7F7F7">&nbsp;</td>
                          <td align="left" valign="top"  style="width:136px; max-width:136px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;"><br />
                          <asp:Literal id="Text4" runat="server" /></td>
                        </tr>
                    </table>
                    
                 </td>
                 </tr>
</table>
                    </td>
                    <td bgcolor="#F7F7F7"><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="15" height="15" style="display:block;" alt="" /></td>
                  </tr>
                  <tr>
                    <td bgcolor="#F7F7F7">&nbsp;</td>
                    <td align="center" bgcolor="#F7F7F7" style="width:592px; max-width:592px; mso-table-lspace:0pt; mso-table-rspace:0pt;">&nbsp;</td>
                    <td bgcolor="#F7F7F7">&nbsp;</td>
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
