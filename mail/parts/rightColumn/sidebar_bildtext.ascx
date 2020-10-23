<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ Import Namespace="Insyma"  %>
<script runat="server"> 
	Sub BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			Dim TextObj as HTMLGenericControl = CType(e.Item.FindControl("TextObj"), HTMLGenericControl)
			Dim EntryTable as HTMLTable = CType(e.Item.FindControl("EntryTable"), HTMLTable)
			Dim ListAnchor As Literal = CType(e.Item.FindControl("ListAnchor"), Literal)
			If con.Fields("titel").Value = "" Then
				EntryTable.Visible = False
			End If
			If con.Fields("text").Value = "" Then
				TextObj.Visible = False
			else
				TextObj.InnerHtml = con.Fields("text").Value.Replace("<ol>","<ol style='padding:0;margin:0;list-style-position:inside;'>").Replace("<ul>","<ul style='list-style:none;list-style-position:inside;padding:0;margin:0;'>").Replace("<a","<a style='color:#FB2701;'")
				if not (InStrRev(TextObj.InnerHtml,"<ul")) = 0 then
					If Instr(Right(TextObj.InnerHtml,Len(TextObj.InnerHtml) - InStrRev(TextObj.InnerHtml,"<ul")),">") Then
						Dim liTag as string = ""
						liTag = Right(TextObj.InnerHtml,Len(TextObj.InnerHtml) - InStrRev(TextObj.InnerHtml,"<ul"))
						if not (InStrRev(TextObj.InnerHtml,"<ol")) = 0 then
							liTag = Left(liTag,Len(Right(TextObj.InnerHtml,Len(TextObj.InnerHtml) - InStrRev(TextObj.InnerHtml,"</ul"))))
						end if
						liTag = Right(liTag,Len(liTag) - InStr(liTag,">"))
						TextObj.InnerHtml = TextObj.InnerHtml.Replace(liTag, liTag.Replace("<li>","<li style='list-style:none;'><img src=""http://www.cu3.ch/CU_BCS/mail/img/layout/list-style.gif"" alt=""*"" width=""9"" height=""10"" />&nbsp;"))
					End IF		
				end if
			End If
			If Not con.Fields("label").Properties("Value").Value = "" Then
                If Not con.Fields("url").Value = "" Then
                    ListAnchor.Text = "<br /><a href=""" & con.Fields("url").Value.Replace("&","&amp;") & """ target='_blank' style='color: #fb2701; text-decoration: underline;' title=""" & con.Fields("label").Value & """>" & con.Fields("label").Value & "</a>"
                End If
			else
				If Not con.Fields("url").Value = "" Then
                    ListAnchor.Text = "<br /><a href=""" & con.Fields("url").Value.Replace("&","&amp;") & """ target='_blank' style='color: #fb2701; text-decoration: underline;' title=""" & con.Fields("url").Value & """>" & con.Fields("url").Value & "</a>"
                End If
			end if
		End if
	End Sub
</script>
<% If TemplateView = "text" Then%>
<%=vbcrlf%>
<CU:CUObjectSet name="bildtextliste" runat="server" >
<ItemTemplate>
----------------------------------------------------------------------
<CU:CUField name="titel" runat="server" plaintext="true" />
----------------------------------------------------------------------
<CU:CUField name="text" runat="server" plaintext="true" />
</ItemTemplate>
</CU:CUObjectSet>
<% else %>
<CU:CUObjectSet name="bildtextliste" runat="server" OnItemDataBound="BindItem">
	<ItemTemplate>
        <table class="sidebar_bildtext" id="EntryTable" runat="server" width="172" border="0" cellspacing="0" cellpadding="0" align="center" style="background:#ffffff;clear:both;border-top: solid 1px #fb2701;" bgcolor="#ffffff">
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
                <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="5" /></td>
            </tr>
            <tr>
                <td align="left" width="172" style="background: #ffffff;">
                    <CU:CUImage name="bild" runat="server" />            
                </td>
            </tr>
            <tr>
                <td align="left" width="172" style="background: #ffffff; color: #66676c; font-size: 11px; font-family: Arial, Verdana, sans-serif; line-height: 16px;">
                    <span id="TextObj" runat="server"></span>
                    <asp:Literal ID="ListAnchor" runat="server" />     
                </td>
            </tr>
            <tr>
                <td align="left" width="172" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="20" /></td>
            </tr>
        </table>
	</ItemTemplate>
</CU:CUObjectSet>
<% end if %>