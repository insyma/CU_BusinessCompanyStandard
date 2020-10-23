<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">    
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        If Container.Fields("titel").Value = "" Then
            EntryTable.Visible = False
        End If
	End Sub 
    Sub BindItem(sender as object, e as RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			Dim setLink as HtmlAnchor = CType(e.Item.FindControl("setLink"), HtmlAnchor)
            Dim closeTag As Literal = CType(e.Item.FindControl("closeTag"), Literal)
			
			setLink.InnerHTML = con.Images("bild").Tag.Replace("<img","<img width='" & con.Images("bild").Properties("width").value &  "'")
			setLink.href = con.Fields("url").value
			setLink.title = con.Images("bild").legend
			
            If e.Item.ItemIndex mod 2 then
				if not e.Item.ItemIndex = con.Parent.Containers.count-1 Then
    	            closeTag.Text = "</tr><tr>"
	                closeTag.Visible = True
				else
					closeTag.visible = false
				end if
            Else
                closeTag.Visible = False
            End If
        End If
    End Sub
</script>
<% If TemplateView = "text" Then%>
----------------------------------------------------------------------
<CU:CUField Name="titel" runat="server" plaintext="true" />
----------------------------------------------------------------------
<CU:CUObjectSet name="rubrikenliste" runat="server" >
<ItemTemplate>
<CU:CUField name="rubrik" runat="server" plaintext="true" /><CU:CUObjectSet name="bilderliste" runat="server"><ItemTemplate>
- <CU:CUField name="url" runat="server" plaintext="true" /></ItemTemplate></CU:CUObjectSet>
</ItemTemplate></CU:CUObjectSet>

<% else %>
<table class="sidebar_bilder" id="EntryTable" runat="server" width="172" border="0" cellspacing="0" cellpadding="0" align="center" style="background:#ffffff;clear:both;border-top: solid 1px #fb2701;" bgcolor="#ffffff">
    <tr>
        <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="20" /></td>
    </tr>
</table>
<table width="172" border="0" cellspacing="0" cellpadding="0" align="center" style="background:#ffffff;clear:both;" bgcolor="#ffffff">
    <tr>
        <td align="left" width="172" style="background:#ffffff; color: #66676c; font-size: 14px; font-family: Arial, Verdana, sans-serif;line-height: 16px;">
            <CU:CUField Name="titel" runat="server" />
        </td>
    </tr>
    <tr>
        <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="10" /></td>
    </tr>
    <CU:CUObjectSet name="rubrikenliste" runat="server">
    <ItemTemplate>
    <tr>
        <td width="172" style="background: #ffffff; font-family: Arial, Verdana, sans serif; font-size: 11px;">
            <CU:CUField name="rubrik" runat="server" tag="strong" />
        </td>
	</tr>
    <tr>
        <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="5" /></td>
    </tr>
	<tr>
        <td width="172" style="background: #ffffff; font-family: Arial, Verdana, sans serif; font-size: 11px;">
            <table width="172" border="0" align="center" cellpadding="0" cellspacing="0">
            <CU:CUObjectSet name="bilderliste" runat="server" OnItemDataBound="BindItem">
            <HeaderTemplate>
            	<tr>
            </HeaderTemplate>
            <ItemTemplate>                
                    <td width="73" align="left" valign="top" style="background: #ffffff; line-height: 0;">
	                    <a id="setLink" runat="server" href="" target="_blank" title="<CU:CUImage name='bild' runat='server' property='legend' />" style="border:0;">
	                        <CU:CUImage name="bild" runat="server" />
                        </a>
                    </td>                          
                    <asp:Literal ID="closeTag" runat="server"></asp:Literal>
            </ItemTemplate>
            <FooterTemplate>
            	</tr>
            </FooterTemplate>
            </CU:CUObjectSet>
            </table>
        </td>
    </tr>
    <tr>
        <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="10" /></td>
    </tr>
    </ItemTemplate>
    <FooterTemplate>
    <tr>
        <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="10" /></td>
    </tr>
    </FooterTemplate>
    </CU:CUObjectSet>
</table>
<% end if %>
