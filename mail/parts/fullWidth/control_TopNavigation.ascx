<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Dim count as Integer = 1
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    count = Container.ObjectSets(1).Containers.Count
	End Sub
	
	Sub BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ListAnchor As Literal = CType(e.Item.FindControl("ListAnchor"), Literal)
            
            If Not con.Fields("desc").Properties("Value").Value = "" Then
                If count > e.item.itemindex+1 then
			         ListAnchor.Text = "<a style='color: #393131; text-decoration: none;' href=""" & con.Fields("url").Value & """ target='_blank' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & "</a>&nbsp;&nbsp;" 
				else 
				    ListAnchor.Text = "<a style='color: #393131; text-decoration: none;' href=""" & con.Fields("url").Value & """ target='_blank' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & "</a>" 
				End If
            End If
        End If
    End Sub
</script>
<% if templateview = "text" then %><%=vbcrlf%>
----------------------------------------------------------------------
<CU:CUField name="title" runat="server" />
----------------------------------------------------------------------<CU:CUObjectSet Name="culist" runat="server"><ItemTemplate>
<CU:CUField name="desc" runat="server" PlainText="true" />:
<CU:CUField name="url" runat="server" PlainText="true" />
</ItemTemplate></CU:CUObjectSet><% else %>
<CU:CUObjectSet name="culist" runat="server" OnItemDataBound="BindItem">
    <HeaderTemplate>
    
    
    <table align="center" border="0" cellpadding="0" cellspacing="0">
                      <tbody><tr>
                        <td style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="center" bgcolor="#F7F7F7" height="30" valign="top"><table align="center" bgcolor="" border="0" cellpadding="0" cellspacing="0">
                          <tbody><tr>
                            <td class="text" style="width:622px; max-width:622px; text-align:center; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:14px; color:#393131;" align="center" bgcolor="#F7F7F7" height="47">
                                </HeaderTemplate>
    <ItemTemplate>
                <asp:Literal ID="ListAnchor" runat="server" />
    </ItemTemplate>
    <FooterTemplate>
</td>
                          </tr>
                          <tr>
                            <td class="text" style="width:622px; max-width:622px; text-align:center;font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:14px; color:#393131;" align="center" bgcolor="#E6E6E6" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1" /></td>
                          </tr>
                          <tr>
                            <td class="text" style="width:622px; max-width:622px; text-align:center;font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:14px; color:#393131;" align="center" bgcolor="#FFFFFF" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1" /></td>
                          </tr>
                          <tr>
                            <td class="text" style="width:622px; max-width:622px; text-align:center;font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:14px; color:#393131;" align="center" bgcolor="#F7F7F7">&nbsp;</td>
                          </tr>
                        </tbody></table></td>
                      </tr>
                    </tbody></table>
                    
    </FooterTemplate>
                    
</CU:CUObjectSet >
<% end if %>