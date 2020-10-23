<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Dim RefObj As New ContentUpdate.Obj

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        RefObj.IsMail = CUPage.IsMail
		Me.Container = RefObj.Containers("conlinkliste")
		Me.Container.LanguageCode = CUPage.LanguageCode
		If Container.Fields("title").Value = "" Then
            EntryTable.Visible = False
        End If
	End Sub
	
	Sub BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ListAnchor As Literal = CType(e.Item.FindControl("ListAnchor"), Literal)
			Dim showCounter As Literal = CType(e.Item.FindControl("showCounter"), Literal)
            
            If Not con.Fields("desc").Properties("Value").Value = "" Then
                ListAnchor.Text = "<a href=""" & con.Fields("url").Value & """ target='_blank' style='color: #66676c; text-decoration: none;' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & "</a>"
				if e.Item.ItemIndex < 9 then
					showCounter.Text = "0" & e.Item.ItemIndex+1
				else
					showCounter.Text = e.Item.ItemIndex+1
				end if
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
<table class="sidebar_linkliste" id="EntryTable" runat="server" width="172" border="0" cellspacing="0" cellpadding="0" align="center" style="background:#ffffff;clear:both;border-top: solid 1px #fb2701;" bgcolor="#ffffff">
    <tr>
        <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="20" /></td>
    </tr>
</table>
<table width="172" border="0" cellspacing="0" cellpadding="0" align="center" style="background:#ffffff;clear:both;" bgcolor="#ffffff">
    <tr>
        <td align="left" width="172" style="background:#ffffff; color: #66676c; font-size: 14px; font-family: Arial, Verdana, sans-serif;line-height: 16px;">
            <CU:CUField Name="title" runat="server" />
        </td>
    </tr>
    <tr>
        <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="5" /></td>
    </tr>
    <tr>
        <td align="left" width="172" style="background: #ffffff;">
        <CU:CUObjectSet name="culist" runat="server" OnItemDataBound="BindItem">
        <HeaderTemplate>
			<table width="172" border="0" cellspacing="0" cellpadding="0" align="left" style="background:#ffffff;" bgcolor="#ffffff">
        </HeaderTemplate>
        <ItemTemplate>
            	<tr>
                    <td align="left" width="25" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width='7' height='10' /></td>
                    <td align="left" width="6" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width='6' height='10' /></td>
                    <td align="left" width="141" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width='7' height='10' /></td>
                </tr>
                <tr>
                    <td valign="bottom" align="left" width="25" style="font-size: 20px; font-family: Arial, Verdana, sans-serif;color: #66676c; line-height: 1;background:#ffffff;text-transform:uppercase;width:25px;"><asp:Literal id="showCounter" runat="server" /></td>
                    <td align="left" width="6" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width='6' height='20' /></td>
                    <td valign="bottom" width="141" style="font-size: 12px; font-family: Arial, Verdana, sans-serif;color: #66676c; line-height: 14px;background:#ffffff;">
                    <span style="width:141px;display:block;font-size: 12px; font-family: Arial, Verdana, sans-serif;color: #66676c; line-height: 14px;"><asp:Literal ID="ListAnchor" runat="server" /></span>
                    </td>
                </tr>
        </ItemTemplate>
        <FooterTemplate>     
        		<tr>
                    <td height="20" align="left" width="25" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width='7' height='20' /></td>
                    <td height="20" align="left" width="6" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width='6' height='20' /></td>
                    <td height="20" align="left" width="141" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width='7' height='20' /></td>
                </tr>  
			</table><br /><br />
        </FooterTemplate>
        </CU:CUObjectSet>
        </td>
    </tr>
</table>
<% end if %>