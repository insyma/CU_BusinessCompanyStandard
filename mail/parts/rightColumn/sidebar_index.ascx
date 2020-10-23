<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
	Dim RefObj As New ContentUpdate.Obj
    Dim ConCount As Integer = 0
    Dim ShowContentMenu As Boolean = False
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))        
		For Each field As ContentUpdate.Obj In CUPage.Containers("content").GetChildObjects(CUClass.Field)
			If field.ObjName = "title" Then
				If Not field.Properties("Value").Value = "" Then
					ShowContentMenu = True
					Exit For
				End If
			End If
		Next
        
        ContentMenu.DataSource = CUPage.Containers("content").Containers
        ContentMenu.DataBind()
	End Sub
	
	Protected Sub BintItem_ContentMenu(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim Con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ContentMenuAnchor As Literal = CType(e.Item.FindControl("ContentMenuAnchor"), Literal)
			Dim showCounter As Literal = CType(e.Item.FindControl("showCounter"), Literal)
			
            If Not Con.Fields("title").Value = "" Then
                ConCount += 1
                ContentMenuAnchor.Text = "<a href=""#news_" & ConCount.ToString+1 & """ style='color: #66676c; text-decoration: none;' title=""" & Con.Fields("title").Value & """>" & Con.Fields("title").Value & "</a>"
				if ConCount < 10 then
					showCounter.Text = "0" & ConCount.ToString
				else
					showCounter.Text = ConCount.ToString
				end if
            Else
                e.Item.Visible = False
            End If
        End If
    End Sub
</script>
<% If TemplateView = "text" Then%>
<% else %>
<table class="sidebar_index" width="172" border="0" cellspacing="0" cellpadding="0" align="center" style="background:#ffffff;clear:both;" bgcolor="#ffffff">
    <tr>
        <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="60" /></td>
    </tr>
    <tr>
        <td align="left" width="172" style="background:#ffffff; color: #66676c; font-size: 14px; font-family: Arial, Verdana, sans-serif;line-height: 16px;">
            <CU:CUField Name="title-content" runat="server" />
        </td>
    </tr>
    <tr>
        <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="5" /></td>
    </tr>
    <tr>
        <td align="left" width="172" style="background: #ffffff;">
            <asp:Repeater ID="ContentMenu" runat="server" OnItemDataBound="BintItem_ContentMenu">
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
                    	<asp:Literal ID="ContentMenuAnchor" runat="server" />
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
            </asp:Repeater>
        </td>
    </tr>
</table>
<% end if %>