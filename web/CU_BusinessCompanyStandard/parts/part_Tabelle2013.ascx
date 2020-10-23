<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
dim content as string = ""
dim fr as boolean = false
Sub Page_Load(Src As Object, E As EventArgs)
	if container.fields("firstRowAsHeader").value = "1" Then
		fr = true
	end if
End Sub
Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
   	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
   		Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
		dim alt as string = ""
		if con.fields("row_highlight").value = "1" then
			alt = "class='altRow'"
		else
			alt = "class=''"
		end if
		if e.item.itemindex = 0 AND fr = true then
			formlink.text = "<tr " & alt & ">" & _getRows("th", con.id) & "</tr>" & vbcrlf
		else
			formlink.text = "<tr " & alt & ">" & _getRows("td", con.id) & "</tr>" & vbcrlf
		end if
	End If
End Sub    
Function _getRows(art as string, aId as integer)
	dim ret as string = ""
	dim c as integer = 1
	dim _c as integer = 1
	dim con as new contentupdate.container()
	con.load(aId)
	con.LanguageCode = CUPage.LanguageCode
	con.Preview = CUPage.Preview
	for c = 1 to 9
		if not con.fields("col_" & c.ToString()).value = "" AND c = _c then
			dim col as string = ""
			dim css as string = ""
			if not con.fields("ov_col_" & c.ToString()).value = "" then
				col = "colspan='" & con.fields("ov_col_" & c.ToString()).value & "'"
				_c += cint(con.fields("ov_col_" & c.ToString()).value)
			else
				_c += 1
			end if
			ret += "<" & art & " " & col & " class='" & con.fields("al_col_" & c.ToString()).properties("value").value & "'>" & con.fields("col_" & c.ToString()).value.replace("[leer]", "&nbsp;") & "</" & art & ">"
		end if
	next
	return ret
End Function
</script>
<div class="part part-tabelle clearfix">
	<CU:CUField name="part_Tabelle_variabel_Ueberschrift" runat="server" tag="h3"  tagclass="h3 item-title" />
    <div class="con-table">
        <CU:CUObjectSet name="Liste" runat="server" OnItemDataBound="BindItem">
            <headertemplate><table cellspacing="0" cellpadding="0" border="1"></headertemplate>
            <footertemplate></table></footertemplate>
            <itemtemplate>
                <asp:literal id="formlink" runat="server" />
            </itemtemplate>
        </CU:CUObjectSet>
        <CU:CUField name="part_Tabelle2013_text" runat="server" tag="div" tagclass="liststyle" />
    </div>
</div>
