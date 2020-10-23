<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Dim conCount As Integer = 0
    Dim HeaderCount As Integer = 0
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
			if conCount = 1 then
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
        If Container.Fields("intro").Value = "" Then
            intro.Visible = False
        End If
    End Sub
    
    ' **** Alles f�r die Tabelle ****'
    
    Dim count As Integer = 0
    Dim tdCount As Integer = 0
    Dim thCount As Integer = 0
    Dim HeaderArr(5) As ContentUpdate.Field
    
    Protected Sub culist_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs)
        If E.Item.ItemType = ListItemType.Header Then
            Dim HeaderRepeater As Repeater = CType(e.Item.FindControl("HeaderRepeater"), Repeater)
            Dim tablehead As HtmlTableCell = CType(e.Item.FindControl("tablehead"), HtmlTableCell)
			Dim newRow As Literal = CType(e.Item.FindControl("newRow"), Literal)
            Dim i As Int32
            For i = 0 To 5
                Dim fNr As Integer = i + 1
                HeaderArr(i) = Container.Fields("titlecol" + fNr.ToString)
                If Not HeaderArr(i).Value = "" Then
                    count += 1
                End If
            Next
			if count = 0 then
			  if Container.ObjectSets(1).Containers.count > 0
				for each con as ContentUpdate.Field in Container.ObjectSets(1).Containers(1).Fields					
					if con.value <> "" then
						count += 1
					end if
				next
			  end if
			else
				if Container.Fields("tableheader").value <> "" then
					newRow.Text = "</tr><tr>"
				end if
			end if
            tablehead.ColSpan = count
			
            HeaderRepeater.DataSource = HeaderArr
            HeaderRepeater.DataBind()
        End If
        If E.Item.ItemType = ListItemType.Item Or E.Item.ItemType = ListItemType.AlternatingItem Then
            Dim RowRepeater As Repeater = CType(E.Item.FindControl("RowRepeater"), Repeater)
            Dim cont As ContentUpdate.Container = CType(E.Item.DataItem, ContentUpdate.Container)
            RowRepeater.DataSource = cont.Fields
            RowRepeater.DataBind()
        End If
        If e.Item.ItemType = ListItemType.Footer Then
        End If
    End Sub
    
    Protected Sub HeaderRepeater_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs)
        If E.Item.ItemType = ListItemType.Item Or E.Item.ItemType = ListItemType.AlternatingItem Then
            Dim th As HtmlTableCell = CType(e.Item.FindControl("headerTd"), HtmlTableCell)
            Dim field As ContentUpdate.Field
            field = CType(e.Item.DataItem, ContentUpdate.Field)
            If Not field.Value = "" Then
                th.Attributes.Add("style", "border-right: solid 1px #ffffff;padding: 5px 10px; color: #66676c; font-size: 10px; font-weight: bold; font-family : Verdana,sans-serif; line-height: 14px;")
                if field.value = "-" then
					th.InnerHtml = " "   
				else
					th.InnerHtml = field.Value    
				end if
            Else
                th.Visible = False
            End If
        End If
    End Sub
    
    Protected Sub RowRepeater_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs)
        If E.Item.ItemType = ListItemType.Item Or E.Item.ItemType = ListItemType.AlternatingItem Then
            Dim td As HtmlTableCell = CType(E.Item.FindControl("Td"), HtmlTableCell)
            Dim field As ContentUpdate.Field
            field = CType(e.Item.DataItem, ContentUpdate.Field)
            If field.Value = "" Then
				if e.Item.ItemIndex >= count then
					td.visible = false
				end if
            Else
				
				if field.value = "-" then
					td.InnerHtml = " "   
				else
					td.InnerHtml = field.Value    
				end if
				
				td.Attributes.Add("style", "border-right: solid 1px #ffffff;padding: 5px 10px; font-size: 10px; font-family : Verdana,sans-serif; color: #66676c; line-height: 14px; font-weight: bold; ")
				
                if IsNumeric(field.Plaintext.Replace(" %","").Replace("%","").Replace(" - ","").Replace(",","").Replace(".","").Replace("'","")) or IsNumeric(field.Value.Replace("&acute;","")) then              		
					td.Align = "right"					
				end if
				
				if e.Item.ItemIndex >= count then
					td.visible = false
				end if
            End If
        End If
    End Sub
</script>
<%  If TemplateView = "text" Then%>
----------------------------------------------------------------------
<%  If Not Container.Fields("title").Value = "" Then%><CU:CUField Name="title" runat="server" PlainText="true" />
----------------------------------------------------------------------<%=vbcrlf%><% end if %>
<%  If Not Container.Fields("intro").Value = "" Then%><%=vbcrlf%><CU:CUField name="intro" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("tableheader").Value = "" Then%><%=vbcrlf%><CU:CUField name="tableheader" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%=vbcrlf%>
<% count = 0 %>
<%  For Each cuentry As ContentUpdate.Container In Container.ObjectSets("culist").Containers%><%For Each cufield As ContentUpdate.Field In cuentry.Fields
            If Not cufield.Value = "" Then
                count = count + 1
                Dim HeaderField as ContentUpdate.Field = Container.Fields("titlecol" + count.toString)
				
                If HeaderField.Value <> "" and HeaderField.Value <> "-" Then %>
               
<% if HeaderField.Value.contains(":") then %><%=HeaderField.Plaintext.Replace(":","")%><%else%><%=HeaderField.Plaintext%><%end if %>: <%end if %><%=cufield.Plaintext %><%=vbcrlf%><%end if %><%  Next%>
<%count = 0 %><%=vbcrlf%><%  Next%>
<%else %>
<table class="part_table" runat="server" id="EntryTable" width="371" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td align="left" width="371" valign="middle" style="background: #ffffff; color: #66676c; font-size: 12px; font-family: Arial, Verdana, sans-serif; line-height: 20px;">                       
            <span id="showTop" runat="server"><a href="#top" title="top"><img src="http://www.cu3.ch/CU_BCS/mail/img/layout/arrow-up.gif" alt="*" width="10" height="10" border="0" align="right" /></a>  <br />
            <img src="http://www.cu3.ch/CU_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="19" /></span>
            <asp:Literal ID="ContentMenuAnchor" runat="server" /><br />
            <span style="color: #fb2701; font-size: 20px; font-family: Georgia,Times New Roman,serif; line-height: 24px; background: #ffffff;"><CU:CUField Name="title" runat="server" /></span>
            <br /><img src="http://www.cu3.ch/CU_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="8" /><br />
            <strong id="intro" runat="server"><CU:CUField Name="intro" runat="server" /><br /></strong>                        
            <CU:CUObjectSet name="culist" runat="server" OnItemDataBound="culist_ItemDataBound">
                <headertemplate>
                    <br />
                    <table width="371" border="0" cellspacing="0" cellpadding="5" align="left" style="clear:both;">
                        <tr>
                            <th runat="server" id="tablehead" bgcolor="#66676c" align="left" valign="middle" style="padding: 5px 10px; color: #ffffff; font-size: 11px; font-weight: bold; font-family : Verdana,sans-serif; line-height: 14px;"><CU:CUField name="tableheader" runat="server" /></th>
                        <asp:Literal id="newRow" runat="server" />
                        <asp:Repeater id="HeaderRepeater" runat="server" OnItemDataBound="HeaderRepeater_ItemDataBound">
                            <ItemTemplate>
                                <th runat="server" id="headerTd" bgcolor="#ffffff" align="left" valign="middle"></th>
                            </ItemTemplate>
                        </asp:Repeater>
                        </tr>
                </headertemplate>
                <itemtemplate>
                    <tr>
                        <asp:Repeater id="RowRepeater" runat="server" OnItemDataBound="RowRepeater_ItemDataBound" >
                            <ItemTemplate>
                                <td runat="server" valign="middle" bgcolor="#c1c1c1" align="left" id="Td"></td>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tr>
                </itemtemplate>
                <alternatingitemtemplate>
                    <tr>
                        <asp:Repeater id="RowRepeater" runat="server" OnItemDataBound="RowRepeater_ItemDataBound" >
                            <ItemTemplate>
                                <td runat="server" valign="middle" bgcolor="#ececec" align="left" id="Td"></td>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tr>
                </alternatingitemtemplate>
                <footertemplate>
                    </table>
                    <br style="clear:both;" />&nbsp;<br style="clear:both;" />
                </footertemplate>
            </CU:CUObjectSet>                        
            <img src="http://www.cu3.ch/CU_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="5" />
        </td>
    </tr>
</table>
<table id="showBorder" runat="server" width="371" style="background:#ffffff;border-top: solid 1px #fb2701;" border="0">
    <tr>
        <td align="left" width="371" valign="top" height="2" style="background: #ffffff; line-height: 0; font-size: 1px;">
            <img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" width="19" height="1" alt="*" />
        </td>
    </tr>
</table>
<%end if %>