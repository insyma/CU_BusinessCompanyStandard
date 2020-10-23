<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
dim counter as integer = 0
Dim HeaderCount As Integer = 0
dim c_alt as integer = 0

''Variable für die Entscheidung, ob part ausgegeben wird
dim part_visible as boolean = false

Sub Page_Load(Src As Object, E As EventArgs)
	'' Abfrage auf alle Textfelder, welche in dem part vorhanden sind( ObjectClass 5 = Textfeld)
    part_visible = _checkTextFields(container.id)
End Sub
    
    Protected Sub ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs)
		Dim cont As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		If e.Item.ItemType = ListItemType.Header Then
            Dim HeaderRowRepeater As Repeater = CType(e.Item.FindControl("HeaderRowRepeater"), Repeater)
            Dim con As ContentUpdate.Container = CType(E.Item.DataItem, ContentUpdate.Container)	
				
            If Container.Fields("part_Tabelle_firstRowAsHeader").Value = "1" Then
                Try
	                HeaderRowRepeater.DataSource = Container.ObjectSets("part_Tabelle_Liste").Containers(1).Fields
    	            HeaderRowRepeater.DataBind()
				Catch ex As Exception
					e.Item.Visible = False
				End Try   
            End If
        End If
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim RowRepeater As Repeater = CType(e.Item.FindControl("RowRepeater"), Repeater)
            Dim conRowRepeater As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			            
            If e.Item.ItemIndex = 0 And Container.Fields("part_Tabelle_firstRowAsHeader").Value = "1" Then
                e.Item.Visible = False
            End If
			           
            RowRepeater.DataSource = conRowRepeater.Fields
            RowRepeater.DataBind()
        End If
    End Sub
    Protected Sub HeaderRowRepeater_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim th As HtmlTableCell = CType(e.Item.FindControl("Th"), HtmlTableCell)
            Dim field As ContentUpdate.Field = CType(e.Item.DataItem, ContentUpdate.Field)
            th.InnerHtml = field.Value
            If field.Value = "" Then
                th.Visible = False
            Else
				if field.Value.contains("[LEER]") then
					th.InnerHtml = "&nbsp;"
					th.Attributes.Add("class","noStyle")
				elseif field.Value.contains("[-]") then
					th.visible = false
				elseif field.Value.contains("[+]")
					th.Attributes.Add("colspan","2")
					th.InnerHtml = trim(field.Value.Replace("[+]",""))
				end if
				if e.Item.ItemIndex > 0 then
					th.Attributes.Add("style", "text-align:center;")
				end if
                HeaderCount += 1
            End If						
        End If
    End Sub
	Protected Sub RowRepeater_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Header then
			Dim altrow As Literal = CType(e.Item.FindControl("altrow"), Literal)
			if c_alt Mod 2 = 0 then
				altrow.text = " class='altRow'"
			end if
			c_alt += 1
		End if
		
		If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim field As ContentUpdate.Field = CType(e.Item.DataItem, ContentUpdate.Field)
			Dim td as HTMLTableCell = CType(e.Item.FindControl("Td"), HTMLTableCell)
			if HeaderCount > 0 then
				if e.Item.ItemIndex <= HeaderCount-1 then
					if not field.Value = "" then
						if IsNumeric(field.Plaintext.Replace("<br/>","").Replace(" %","").Replace("%","").Replace(" - ","").Replace(",","").Replace(".","")) or IsNumeric(field.Value.Replace("&acute;",""))then
							if e.Item.ItemIndex mod 2 then
								td.Attributes.Add("class","int")
							else
								td.Attributes.Add("class","int altCol")
							end if
						end if
						td.InnerHtml = trim(field.Value).Replace("&acute;","'")
						
						if field.Value.contains("[LEER]") then
							td.InnerHtml = "&nbsp;"
							td.Attributes.Add("class","noStyle")
						end if
					else
						td.InnerHtml = "&nbsp;"
					end if
				else
					td.visible = false
				end if
			else
				if not field.Value = "" then
					if IsNumeric(field.Plaintext.Replace(" %","").Replace("%","").Replace(" - ","").Replace(",","").Replace(".","")) or IsNumeric(field.Value.Replace("&acute;","")) then
						if e.Item.ItemIndex mod 2 then
							td.Attributes.Add("class","int")
						else
							td.Attributes.Add("class","int altCol")
						end if
					end if
					td.InnerHtml = trim(field.Value).Replace("&acute;","'")
					
					if field.Value.contains("[LEER]") then
						td.InnerHtml = "&nbsp;"
						td.Attributes.Add("class","noStyle")
					end if
				else
					try 
						td.visible = false
						if not field.parentObjects(1).fields(e.Item.ItemIndex+2).value = "" then
							td.visible = true
							td.InnerHtml = "&nbsp;"
						end if
					catch ex as exception
						td.visible = false
					end try
				end if
			end if
        End If
    End Sub
</script>
<% if part_visible = true then %>
<div class="part part-tabelle clearfix">
<CU:CUField name="part_Tabelle_Ueberschrift" runat="server" tag="h3" tagclass="h3 item-title" />
<div class="con-table">
<CU:CUObjectSet name="part_Tabelle_Liste" runat="server" OnItemDataBound="ItemDataBound">
  <HeaderTemplate>
    <table>
      <CU:CUField name="Ueberschrift" runat="server" tag="caption" />    
      <asp:Repeater id="HeaderRowRepeater" runat="server" OnItemDataBound="HeaderRowRepeater_ItemDataBound">
        <HeaderTemplate><thead><tr></HeaderTemplate>
        <ItemTemplate>
          <th runat="server" id="Th"></th>
        </ItemTemplate>
        <FooterTemplate></tr></thead></FooterTemplate>
      </asp:Repeater>
  </HeaderTemplate>
  <ItemTemplate>
      <asp:Repeater id="RowRepeater" runat="server" OnItemDataBound="RowRepeater_ItemDataBound" >
        <HeaderTemplate><tr <asp:literal id="altrow" runat="server" />></HeaderTemplate>
        <ItemTemplate>
          <td runat="server" id="Td" class="altCol"></td>
        </ItemTemplate>
        <AlternatingItemTemplate>
          <td runat="server" id="Td"></td>
        </AlternatingItemTemplate>
        <FooterTemplate></tr></FooterTemplate>
      </asp:Repeater>
  </ItemTemplate>
  <FooterTemplate>
    </table>
</FooterTemplate>
</CU:CUObjectSet>
</div>
</div>
<% end if %>