<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Dim conCount As Integer = 0
	
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        
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
		Dim link1 As Literal = CType(e.Item.FindControl("link1"), Literal)
		Dim link2 As Literal = CType(e.Item.FindControl("link2"), Literal)
		Dim link3 As Literal = CType(e.Item.FindControl("link3"), Literal)
		Dim link4 As Literal = CType(e.Item.FindControl("link4"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
		bild_1.text="<img style='font-family:Arial, Helvetica, sans-serif; font-size:18px; text-align:center; line-height:47px; color:#cccccc; display:block;' src='http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/cuimgpath/" & con.Images("bild_1").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_1").properties("Legend").value & "' />"
		bild_2.text="<img style='font-family:Arial, Helvetica, sans-serif; font-size:18px; text-align:center; line-height:47px; color:#cccccc; display:block;' src='http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/cuimgpath/" & con.Images("bild_2").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_2").properties("Legend").value & "' />"
		bild_3.text="<img style='font-family:Arial, Helvetica, sans-serif; font-size:18px; text-align:center; line-height:47px; color:#cccccc; display:block;' src='http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/cuimgpath/" & con.Images("bild_3").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_3").properties("Legend").value & "' />"
		bild_4.text="<img style='font-family:Arial, Helvetica, sans-serif; font-size:18px; text-align:center; line-height:47px; color:#cccccc; display:block;' src='http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/cuimgpath/" & con.Images("bild_4").processedfilename & "' width='100%' border='0' alt='" & con.Images("bild_4").properties("Legend").value & "' />"
		Text1.Text = con.Fields("text_1").Value.Replace("<a","<a style='color: #C20F1F; text-decoration: none;'")
		Text2.Text = con.Fields("text_2").Value.Replace("<a","<a style='color: #C20F1F; text-decoration: none;'")
		Text3.Text = con.Fields("text_3").Value.Replace("<a","<a style='color: #C20F1F; text-decoration: none;'")
		Text4.Text = con.Fields("text_4").Value.Replace("<a","<a style='color: #C20F1F; text-decoration: none;'")
		link1.text="<a href='" & con.Links("link_1").properties("value").value & "' target='_blank' style='color:#C20F1F; text-decoration:none;' >" & con.Links("link_1").properties("description").value & "</a>"
		link2.text="<a href='" & con.Links("link_2").properties("value").value & "' target='_blank' style='color:#C20F1F; text-decoration:none;' >" & con.Links("link_2").properties("description").value & "</a>"
		link3.text="<a href='" & con.Links("link_3").properties("value").value & "' target='_blank' style='color:#C20F1F; text-decoration:none;' >" & con.Links("link_3").properties("description").value & "</a>"
		link4.text="<a href='" & con.Links("link_4").properties("value").value & "' target='_blank' style='color:#C20F1F; text-decoration:none;' >" & con.Links("link_4").properties("description").value & "</a>"
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
    
    
    <table align="center" border="0" cellpadding="0" cellspacing="0">
                      <tbody><tr>
                        <td bgcolor="#F7F7F7"><span style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" width="5" height="47" style="display:block;" alt="" /></span></td>
                        <td height="47" align="left" bgcolor="#F7F7F7" style="width:592px; max-width:592px; mso-table-lspace:0pt; mso-table-rspace:0pt; font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#C10E1F;"><CU:CUField name="title" runat="server" /></td>
                        <td bgcolor="#F7F7F7">&nbsp;</td>
                      </tr>
                      <tr>
                        <td bgcolor="#F7F7F7"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="15" width="15"></td>
                        <td style="width:592px; max-width:592px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="center" bgcolor="#F7F7F7">
                                                            <CU:CUObjectSet name="culist" runat="server" OnItemDataBound="BindItem">
                                        <ItemTemplate>
<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td style="width:592px; max-width:592px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
<table align="left" border="0" cellpadding="0" cellspacing="0">
                          <tbody><tr>
                            <td style="width:126px; max-width:126px; mso-table-lspace:0pt; mso-table-rspace:0pt; border:1px solid #333333;">
                            <asp:Literal ID="bild_1" runat="server"/></td>
                            <td bgcolor="#F7F7F7"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="15" width="25"></td>
                            <td style="width:126px; max-width:126px; mso-table-lspace:0pt; mso-table-rspace:0pt; border:1px solid #333333;"><asp:Literal ID="bild_2" runat="server"/></td>
                            <td bgcolor="#F7F7F7"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="15" width="22"></td>
                          </tr>
                          <tr>
                            <td style="width:126px; max-width:126px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" valign="top"><span style="color:#333333;"><br>
                            <CU:CUField name="title_1" runat="server" /></span> <br>
                            <asp:Literal ID="text1" runat="server"/><br>
                            <asp:Literal ID="link1" runat="server"/><br /></td>
                            <td bgcolor="#F7F7F7">&nbsp;</td>
                            <td style="width:126px; max-width:126px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" valign="top"><span style="color:#333333;"><br>
                            <CU:CUField name="title_2" runat="server" /></span> <br>
                            <asp:Literal ID="text2" runat="server"/><br>
                            <asp:Literal ID="link2" runat="server"/><br /></td>
                            <td bgcolor="#F7F7F7">&nbsp;</td>
                          </tr>
                        </tbody></table>
<table align="left" border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="width:126px; max-width:126px; mso-table-lspace:0pt; mso-table-rspace:0pt; border:1px solid #333333;"><asp:Literal ID="bild_3" runat="server"/></td>
      <td bgcolor="#F7F7F7"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="15" width="25" /></td>
      <td style="width:126px; max-width:126px; mso-table-lspace:0pt; mso-table-rspace:0pt; border:1px solid #333333;"><asp:Literal ID="bild_4" runat="server"/></td>
      </tr>
    <tr>
      <td style="width:126px; max-width:126px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" valign="top"><span style="color:#333333;"><br />
        <CU:CUField name="title_3" runat="server" />
        </span> <br />
        <asp:Literal ID="text3" runat="server"/><br>
        <asp:Literal ID="link3" runat="server"/><br /></td>
      <td bgcolor="#F7F7F7">&nbsp;</td>
      <td style="width:126px; max-width:126px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; color:#656565; line-height:147%; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" valign="top"><span style="color:#333333;"><br />
        <CU:CUField name="title_4" runat="server" />
        </span> <br />
        <asp:Literal ID="text4" runat="server"/><br>
        <asp:Literal ID="link4" runat="server"/><br /></td>
      </tr>
  </tbody>
</table>
</td>
  </tr>
</table>
                                        </ItemTemplate></CU:CUObjectSet></td>
                        <td bgcolor="#F7F7F7"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="15" width="15"></td>
                      </tr>
                      <tr>
                        <td bgcolor="#F7F7F7">&nbsp;</td>
                        <td style="width:592px; max-width:592px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="center" bgcolor="#F7F7F7">&nbsp;</td>
                        <td bgcolor="#F7F7F7">&nbsp;</td>
                      </tr>
                    </tbody></table>
<%end if %>
