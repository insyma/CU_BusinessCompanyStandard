<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
''Variable für die Entscheidung, ob part ausgegeben wird
dim part_visible as boolean = false

Dim LinkDownloadName As String
Dim LinksSortieren As String
	
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

	' ### Checkbox für Sortierung vom CU auslesen
	LinksSortieren = container.Containers("part_Links_Admin").Fields("part_Links_AdminLinksSortieren").Value	
	
	'' Abfrage auf alle Textfelder, welche in dem part vorhanden sind( ObjectClass 5 = Textfeld)
    part_visible = _checkTextFields(container.containers("part_Links_Container").id)
    
    '' weiter falls noch keine Inhalte gefunden wurden
    if part_visible = false then
        '' Abfrage auf alle Files, welche in dem part vorhanden sind( ObjectClass 9 = File)
        part_visible = _checkFiles(container.containers("part_Links_Container").id)
    end if

    '' weiter falls noch keine Inhalte gefunden wurden
    if part_visible = false then
        '' Abfrage auf alle Links, welche in dem part vorhanden sind( ObjectClass 12 = Link)
        part_visible = _checkLinks(container.containers("part_Links_Container").id)
    end if
End Sub

Protected Sub BindRubrik(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		Dim objectSet As CUObjectSet = CType(e.Item.FindControl("Sortierung"), CUObjectSet)
		con.preview = cupage.preview
		con.languagecode = cupage.languageCode
		' ### Sortierung ausführen wenn im CU angekreuzt
		if LinksSortieren <> "" then
			objectSet.sort="LinkDownloadName ASC"
		end if
		
	End If
End Sub

Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		Dim cssclass As Literal = CType(e.Item.FindControl("cssclass"), Literal)
		Dim dokument As Literal = CType(e.Item.FindControl("dokument"), Literal)
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)				
		con.preview = CUPage.preview
		con.languagecode = CUPage.languagecode
		Dim datei As CUFile = CType(e.Item.FindControl("part_Links_Subeintrag_Datei"), CUFile)
		
		' ### Datei ausblenden wenn Link vorhanden
		if con.Links("part_Links_Subeintrag_Link").Properties("Value").Value <> "" then
			dokument.visible = false
		else
			cssclass.Text = " class='link download'"
		End if
		
		' ### Link- od. Dateibezeichnung in verstecktes CU Textfeld schreiben für Sortierung
		if LinksSortieren <> "" then
			if con.Links("part_Links_Subeintrag_Link").Properties("Value").Value <> "" then
				If con.Links("part_Links_Subeintrag_Link").Properties("Description").Value <> "" then
					LinkDownloadName = con.Links("part_Links_Subeintrag_Link").Properties("Description").Value
				else
					LinkDownloadName = con.Links("part_Links_Subeintrag_Link").Properties("Value").Value.Replace("http://", "").Replace("https://", "")
				End if 
			else
				If con.Files("part_Links_Subeintrag_Datei").Properties("Legend").Value <> "" then
					LinkDownloadName = con.Files("part_Links_Subeintrag_Datei").Properties("Legend").Value
				else
					LinkDownloadName = con.Files("part_Links_Subeintrag_Datei").Properties("Filename").Value
				End if
			end if
			con.Fields("part_Links_Subeintrag_LinkDownloadName").Value = LinkDownloadName
		end if
		if not con.files("part_Links_Subeintrag_Datei").Properties("Filename").Value = "" then
			If con.Files("part_Links_Subeintrag_Datei").Properties("Legend").Value <> "" then
				dokument.text = "<a class='icon " & con.Files("part_Links_Subeintrag_Datei").Properties("filetype").Value & "' href='" & con.Files("part_Links_Subeintrag_Datei").src & "' title='" & con.Files("part_Links_Subeintrag_Datei").Properties("Legend").Value & "' target='_blank'>" & con.Files("part_Links_Subeintrag_Datei").Properties("Legend").Value & "</a>"
			else
				dokument.text = "<a class='icon " & con.Files("part_Links_Subeintrag_Datei").Properties("filetype").Value & "' href='" & con.Files("part_Links_Subeintrag_Datei").src & "' title='" & con.Files("part_Links_Subeintrag_Datei").Properties("Filename").Value & "' target='_blank'>" & con.Files("part_Links_Subeintrag_Datei").Properties("Filename").Value & "</a>"
			end if
		end if


	End If
End Sub
</script>
<% if part_visible = true then %>
<div class="part part-links clearfix">
<CU:CUContainer name="part_Links_Container" runat="server">
	<CU:CUField name="part_Links_Titel" runat="server" tag="h3" tagclass="h3 item-title" />
	<CU:CUObjectSet name="part_Links_Liste" runat="server" OnItemDataBound="BindRubrik" >
	<HeaderTemplate>
	<ul>
	</HeaderTemplate>
	<ItemTemplate>
		<li>
			<CU:CUField name="part_Links_Subtitel" tag="h4" tagclass="h4 item-title" runat="server" />
            <CU:CUObjectSet name="part_Links_Subliste" runat="server" OnItemDataBound="BindItem" id="Sortierung">
			<HeaderTemplate><ul class="linklist"></HeaderTemplate>
			<ItemTemplate>
				<li <asp:literal id="cssclass" runat="server" />>
                    <CU:CULink name="part_Links_Subeintrag_Link" runat="server" class="icon" />
                    <asp:literal id="dokument" runat="server" />
                    <CU:CUField name="part_Links_Subeintrag_Beschreibung" runat="server" tag="p" />
				</li>
			</ItemTemplate>
			<FooterTemplate></ul></FooterTemplate>
			</CU:CUObjectSet>
		</li>
	</ItemTemplate>
	<FooterTemplate>
	</ul>
	</FooterTemplate>
	</CU:CUObjectSet>
</CU:CUContainer>
</div>
<% end if %>