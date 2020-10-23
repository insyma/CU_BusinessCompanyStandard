<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Dim count as Integer = 1
    dim p as string = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        ''Speichern der Anzahl der erfassten Links(Einstellungen NL)
        count = Container.ObjectSets(1).Containers.Count
        '##### dynamischer Pfad like "/CU_BusinessCompanyStandard/mail/"
        p = CUPage.Web.TemplatePath
	End Sub
	
	Sub BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ListAnchor As Literal = CType(e.Item.FindControl("ListAnchor"), Literal)
            If Not con.Fields("desc").Properties("Value").Value = "" Then
                '' Nur wenn Beschreibung des Links erfasst
                If count > e.item.itemindex+1 then
                    ' solange es nicht der letzte Link ist(für Abstand zwischen den Links)'
			        ListAnchor.Text = "<a style='color: #393131; text-decoration: none;' href=""" & con.Fields("url").Value & """ target='_blank' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & "</a>&nbsp;&nbsp;" 
				else 
				    ' ansonsten ohne abschliessenden Abstand'
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
    <table align="center" border="0" cellspacing="0" cellpadding="0" class="TopNavigation">
        <tr>
            <td height="30" align="center" valign="top" bgcolor="#FFFFFF" style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                <table border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="">
                    <tr>
                        <td height="47" align="center" bgcolor="#F7F7F7" class="text" style="width:622px; max-width:622px; text-align:center; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:14px; color:#393131;">
    </HeaderTemplate>
    <ItemTemplate>
        <asp:Literal ID="ListAnchor" runat="server" />
    </ItemTemplate>
    <FooterTemplate>
                        </td>
                    </tr>
                    <tr>
                        <td height="1" align="center" bgcolor="#E6E6E6" class="text" style="width:647px; max-width:647px; text-align:center;font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:14px; color:#393131;"></td>
                    </tr>
                    <tr>
                        <td height="1" align="center" bgcolor="#FFFFFF" class="text" style="width:647px; max-width:647px; text-align:center;font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:14px; color:#393131;"></td>
                    </tr>
                    <tr>
                        <td align="center" bgcolor="#F7F7F7" class="text" style="width:647px; max-width:647px; text-align:center;font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:14px; color:#393131;">&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
    </td>
</tr>
</table>
    </FooterTemplate>
</CU:CUObjectSet >
<% end if %>