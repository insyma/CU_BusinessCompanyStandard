<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Dim conCount As Integer = 0
	
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        If Container.Fields("title").Value = "" Then
            EntryTable.Visible = False
			showBorder.visible = false
        Else			
            For Each con As ContentUpdate.Container In Container.ParentObjects(1).Containers
               	conCount += 1
                If con.Id = Container.Id Then
                    Exit For
                End If
            Next
			ContentMenuAnchor.Text = "<a title=""news_" & conCount & """ name=""news_" & conCount & """  id=""news_" & conCount & """></a>"
			if conCount = 2 then
				showTop.visible = false
			end if
			if Container.ParentObjects(1).Containers.count = conCount then
				showBorder.visible = false
			elseif Container.ParentObjects(1).Containers(conCount+1).id = 0 then
				showBorder.visible = false
			elseif Container.ParentObjects(1).Containers(conCount+1).Fields("title").value = "" then
				showBorder.visible = false
			end if
        End If
        If Container.Fields("text").Value = "" Then
            TextObj.Visible = False
			TextObjL.Visible = False
		else
			TextObj.InnerHtml = Container.Fields("text").Value.Replace("<ol>","<ol style='padding:0;margin:0;list-style-position:inside;'>").Replace("<ul>","<ul style='list-style:none;list-style-position:inside;padding:0;margin:0;'>").Replace("<a","<a style='color:#FB2701;'")
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
			TextObjL.InnerHtml = TextObj.InnerHtml
			TextObjT.InnerHtml = TextObj.InnerHtml
			TextObjB.InnerHtml = TextObj.InnerHtml & "<br />"
		End If
			
		If Container.Fields("text2").Value = "" Then
            TextObj2.Visible = False
		else
			TextObj2.InnerHtml = "<br />" & Container.Fields("text2").Value.Replace("<ol>","<ol style='padding:0;margin:0;list-style-position:inside;'>").Replace("<ul>","<ul style='list-style:none;list-style-position:inside;padding:0;margin:0;'>").Replace("<a","<a style='color:#FB2701;'") & "<br />"
			if not (InStrRev(TextObj2.InnerHtml,"<ul")) = 0 then
				If Instr(Right(TextObj2.InnerHtml,Len(TextObj2.InnerHtml) - InStrRev(TextObj2.InnerHtml,"<ul")),">") Then	
					Dim liTag as string = ""
					liTag = Right(TextObj.InnerHtml,Len(TextObj2.InnerHtml) - InStrRev(TextObj2.InnerHtml,"<ul"))
					if not (InStrRev(TextObj.InnerHtml,"<ol")) = 0 then
						liTag = Left(liTag,Len(Right(TextObj.InnerHtml,Len(TextObj.InnerHtml) - InStrRev(TextObj.InnerHtml,"</ul"))))
					end if
					liTag = Right(liTag,Len(liTag) - InStr(liTag,">"))
					TextObj2.InnerHtml = TextObj2.InnerHtml.Replace(liTag, liTag.Replace("<li>","<li style='list-style:none;'><img src=""http://www.cu3.ch/CU_BCS/mail/img/layout/list-style.gif"" alt=""*"" width=""9"" height=""10"" />&nbsp;"))
				End IF		
			end if
        End If
        If Container.Fields("intro").Value = "" Then
            intro.Visible = False
        End If
		If Container.Fields("imgposition").Value = "links"
			ImageRight.visible = false
			ImageTop.visible = false
			TextObjB.visible = false
			BildAnsichtB.visible = false
		else if Container.Fields("imgposition").Value = "oben"
			ImageRight.visible = false
			ImageLeft.visible = false
			TextObjB.visible = false
			BildAnsichtB.visible = false
		else if Container.Fields("imgposition").Value = "unten"
			ImageRight.visible = false
			ImageTop.visible = false
			ImageLeft.visible = false
		else
			ImageLeft.visible = false
			ImageTop.visible = false
			TextObjB.visible = false
			BildAnsichtB.visible = false
		end if
        If Not Container.Images("bild").FileName = "" Then         
			BildAnsichtL.Text = "<img src=""" & Container.Images("bild").src & """ alt=""" & Container.Images("bild").legend & """ width=""" & Container.Images("bild").properties("width").value & """ align=""left"" vspace=""5"" border=""0"" style=""padding:0;margin:0;"" /></td><td align=""left"" valign=""top"" width=""210"" style=""background: #ffffff; color: #66676c; font-size: 12px; font-family: Arial, Verdana, sans-serif; line-height: 16px;width:210px;"">"
			getStylesL.Attributes.Add("style","background: #ffffff; font-size: 1px;line-height: 0;width:161px;")
			getStylesL.width = "161"
			
			BildAnsicht.Text = "</td><td align=""left"" valign=""top"" width=""161"" style=""background: #ffffff; font-size: 1px;line-height: 0;width:161px;""><img src=""" & Container.Images("bild").src & """ alt=""" & Container.Images("bild").legend & """ width=""" & Container.Images("bild").properties("width").value & """ align=""right"" vspace=""5"" border=""0"" style=""padding:0;margin:0;"" />"
			getStyles.Attributes.Add("style","background: #ffffff; color: #66676c; font-size: 12px; font-family: Arial, Verdana, sans-serif; line-height: 16px; width:210px;")
			getStyles.width = "210"
			
			BildAnsichtT.Text = "<img src=""" & Container.Images("bild").alternativesrc & """ alt=""" & Container.Images("bild").legend & """ width=""" & Container.Images("bild").properties("L-width").value & """ align=""right"" vspace=""5"" border=""0"" style=""padding:0;margin:0;"" /><br />&nbsp;<br />"
			getStylesT.Attributes.Add("style","background: #ffffff; color: #66676c; font-size: 12px; font-family: Arial, Verdana, sans-serif; line-height: 16px;width:371px;")
			getStylesT.width = "371"
			
			BildAnsichtB.Text = "<img src=""" & Container.Images("bild").alternativesrc & """ alt=""" & Container.Images("bild").legend & """ width=""" & Container.Images("bild").properties("L-width").value & """ align=""top"" vspace=""5"" border=""0"" style=""padding:0;margin:0;clear:both;"" /><br />&nbsp;<br />"
			
		Else
			BildAnsicht.Visible = False
			getStyles.Attributes.Add("style","background: #ffffff; color: #66676c; font-size: 12px; font-family: Arial, Verdana, sans-serif; line-height: 16px;")
			getStyles.width = "371" 
			ImageLeft.visible = false
			ImageTop.visible = false
			TextObjB.visible = false
			BildAnsichtB.visible = false
		End If
    End Sub
    
    Sub BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ListAnchor As Literal = CType(e.Item.FindControl("ListAnchor"), Literal)
            
            If Not con.Fields("desc").Properties("Value").Value = "" Then
                If Not con.Fields("url").Value = "" Then
                    ListAnchor.Text = "<a href=""" & con.Fields("url").Value.Replace("&","&amp;") & """ target='_blank' style='color: #fb2701; text-decoration: underline;' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & "</a>"
					ListAnchor.Text = ListAnchor.Text
                End If
                If Not con.Files("file").FileName = "" Then
                    ListAnchor.Text = "<a href=""" & con.Files("file").Src & """ target='_blank' style='color: #fb2701; text-decoration: underline;' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & " [" & con.Files("file").Properties("FileType").Value & " | " & con.Files("file").Properties("size").Value & " KB]</a>"
					ListAnchor.Text = ListAnchor.Text
                End If
            Else
                If Not con.Files("file").FileName = "" Then
                    ListAnchor.Text = "<a href=""" & con.Files("file").Src & """ target='_blank' style='color: #fb2701; text-decoration: underline;' title=""" & con.Files("file").Properties("legend").Value & """>" & con.Files("file").Properties("legend").Value & " [" & con.Files("file").Properties("FileType").Value & " | " & con.Files("file").Properties("size").Value & " KB]</a>"
					ListAnchor.Text = ListAnchor.Text
                End If
            End If
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
<%next %><%=vbcrlf%><%else %>

<table class="part_standard" runat="server" id="EntryTable" width="371" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td align="left" width="371" valign="middle" style="background: #ffffff; color: #66676c; font-size: 12px; font-family: Arial, Verdana, sans-serif; line-height: 16px;">
            <span id="showTop" runat="server"><a href="#top" title="top"><img src="http://www.cu3.ch/CU_BCS/mail/img/layout/arrow-up.gif" alt="*" width="10" height="10" border="0" align="right" /></a>  <br />
            <img src="http://www.cu3.ch/CU_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="19" /></span>
            <asp:Literal ID="ContentMenuAnchor" runat="server" /><br />                        
            <span style="color: #fb2701; font-size: 20px; font-family: Georgia,Times New Roman,serif; line-height: 24px; background: #ffffff;"><CU:CUField Name="title" runat="server" /></span>
            <br /><img src="http://www.cu3.ch/CU_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="8" /><br />
            <strong id="intro" runat="server"><CU:CUField Name="intro" runat="server" /><br />&nbsp;<br /></strong>
            <span id="TextObjB" runat="server" style="clear:both;page-break-before: always;"></span>
            <table width="371" border="0" cellspacing="0" cellpadding="0" align="center" id="ImageLeft" runat="server" style="clear:both;"><tr>
                <td align="left" valign="top" id="getStylesL" runat="server"> 
                    <asp:Literal id="BildAnsichtL" runat="server" />
                    <span id="TextObjL" runat="server"></span>
                </td>
            </tr></table>
            <table width="371" border="0" cellspacing="0" cellpadding="0" align="center" id="ImageRight" runat="server" style="clear:both;"><tr>
                <td align="left" valign="top" id="getStyles" runat="server"> 
                    <span id="TextObj" runat="server"></span>
                    <asp:Literal id="BildAnsicht" runat="server" />                                
                </td>
            </tr></table>
            <table width="371" border="0" cellspacing="0" cellpadding="0" align="center" id="ImageTop" runat="server" style="clear:both;"><tr>
                <td align="left" valign="top" id="getStylesT" runat="server"> 
                    <asp:Literal id="BildAnsichtT" runat="server" />                                
                    <span id="TextObjT" runat="server" style="clear:both;"></span>
                </td>
            </tr></table>
            <span id="TextObj2" runat="server" style="clear:both;"></span>            
            <CU:CUObjectSet Name="culist" runat="server" OnItemDataBound="BindItem">
            <HeaderTemplate><span style="clear:both;"></HeaderTemplate>
            <ItemTemplate>
            <img src="http://www.cu3.ch/CU_BCS/mail/img/layout/list-style.gif" alt="*" width="9" height="10" />&nbsp;<asp:Literal ID="ListAnchor" runat="server" />
            <br />
            </ItemTemplate>
            <FooterTemplate>&nbsp;<br /></span></FooterTemplate>
            </CU:CUObjectSet>
            <asp:Literal id="BildAnsichtB" runat="server" />
        </td>
    </tr>
</table>
<table id="showBorder" runat="server" width="371" style="background:#ffffff;border-top: solid 1px #fb2701;" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td align="left" width="371" valign="top" height="2" style="background: #ffffff; line-height: 0; font-size: 1px;">
            <img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" width="19" height="1" alt="*" />
        </td>
    </tr>
</table>
<%end if %>