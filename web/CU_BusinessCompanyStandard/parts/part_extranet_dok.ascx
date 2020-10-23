<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Data" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
Dim category As Dictionary(Of String, String)
Dim _tId As Integer = 0
dim _tstr as string = ""
Dim _tChecked As Boolean = False
Dim _tpageCats as string = ""
Dim DownloadLink As HtmlAnchor
Dim OutputLabel As HtmlAnchor
''Variable für die Entscheidung, ob part ausgegeben wird
dim part_visible as boolean = false
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        Dim tObjList As List(Of Dictionary(Of String, String))
        tObjList = CUPage.ObjCategories()
       	For Each dict As Dictionary(Of String, String) In tObjList
            For Each kvp As KeyValuePair(Of String, String) In dict
                If (kvp.Key.ToLower().Equals("id")) Then
                    _tId = kvp.Value
                End If
                If (kvp.Key.ToLower().Equals("checked") And kvp.Value.ToLower().Equals("true")) Then
                    _tChecked = True
                    _tpageCats += cstr(_tId)
                End If
            Next kvp
        Next
		'response.write("PCats: " & _tpageCats)
        '' Abfrage auf alle Textfelder, welche in dem part vorhanden sind( ObjectClass 5 = Textfeld)
        part_visible = _checkTextFields(container.id)
        
        '' weiter falls noch keine Inhalte gefunden wurden
        if part_visible = false then
            '' Abfrage auf alle Files, welche in dem part vorhanden sind( ObjectClass 9 = File)
            part_visible = _checkFiles(container.id)
        end if
    End Sub
	
	Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
            If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
                Dim doklink As Literal = CType(e.Item.FindControl("doklink"), Literal)
                Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
                Dim tObjList As List(Of Dictionary(Of String, String))
                tObjList = con.ObjCategories()
                _tId = 0
                _tstr = ""
                'response.write("<br /> CCats" & _tstr)
                For Each dict As Dictionary(Of String, String) In tObjList
                    For Each kvp As KeyValuePair(Of String, String) In dict
                        If (kvp.Key.ToLower().Equals("id")) Then
                            _tId = cint(kvp.Value)
                        End If
                        If (kvp.Key.ToLower().Equals("checked") And kvp.Value.ToLower().Equals("true")) Then
                            _tChecked = True
                            _tstr = _tId
                        End If
                    Next kvp
                Next
			'response.write("<br /> CCats" & _tstr)
			e.item.visible = false
			if instr(_tpageCats, _tstr) > 0 then
				e.item.visible = true
			end if
        End If
    End Sub
	
</script>
<% if part_visible = true then %>
<div class="part part-download">
    <CU:CUField name="titel" runat="server" tag="h3" tagclass="h3 item-title"  />
    <CU:CUField name="Einleitung" runat="server" />
    <CU:CUField name="Text" runat="server" tag="div" tagclass="liststyle"  />
    <CU:CUObjectSet name="extranet_zentrale_dokumente_culist" runat="server" OnItemDataBound="BindItem">
        <headertemplate><ul class="linklist"></headertemplate>
        <footertemplate></ul></footertemplate>
            <ItemTemplate>
                <li class="download"><CU:CUFile name="extranet_zentrale_dokumente_file" runat="server"  /></li>
            </ItemTemplate>
    </CU:CUObjectSet>
</div>
<% end if %>                                        