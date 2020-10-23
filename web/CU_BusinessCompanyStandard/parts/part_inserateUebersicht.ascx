<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ Import Namespace="Insyma"  %>
<script runat="server"> 
Dim tempCon as new ContentUpdate.Container
dim returnvalue as integer
dim angebote as string
dim gesuche as string
dim Art1 as string = ""
dim Art2 as string = ""
Sub Page_Load(Src As Object, E As EventArgs)
	dim con as new ContentUpdate.Container
	con.LoadByName("blackboard_beschriftung")
	con.LanguageCode = Container.LanguageCode
	angebote = con.fields("angebote").value
	gesuche = con.fields("gesuche").value
	
	con.loadByName("blackboard_arten")
	con.LanguageCode = Container.LanguageCode
	if con.objectsets("culist_blackboard_arten").containers.count > 1 then
		Art1 = con.objectsets("culist_blackboard_arten").containers(1).fields("blackboard_art_entry").id
		Art2 = con.objectsets("culist_blackboard_arten").containers(2).fields("blackboard_art_entry").id
	end if
End Sub

Function _getCount(aKategorie, aArt)
	returnvalue = 0
	'response.write("<br />--: " & aKategorie & " -- " & aArt)
	dim con as new ContentUpdate.Container
	con.LoadByName("Blackboard_OnlineEntries")
	con.LanguageCode = Container.LanguageCode
	for each ccon as Contentupdate.Container in con.ObjectSets("culist_OnlineEntries").Containers
		if aArt = ccon.Fields("blackboard_entry_art").properties("value").value AND aKategorie = ccon.Fields("blackboard_entry_kategorie").properties("value").value AND ccon.fields("blackboard_entry_aktiv").value = "1" then
			returnvalue += 1
		end if
	next
	Return returnvalue
End Function


Protected Sub AngBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		Dim con as ContentUPdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		Dim cat1 As Literal = CType(e.Item.FindControl("cat1"), Literal)
		dim tmp_int as integer = _getCount(con.fields("blackboard_entry_kategorie").id, Art1)
		con.ParentPages(1).Preview = CUPage.Preview
		if tmp_int > 0 then
			cat1.text = "<li class='contentActiv'><a href='" & con.ParentPages(1).link & "' title='" & con.fields("blackboard_entry_kategorie").value & "'>" & con.fields("blackboard_entry_kategorie").value & " (" & tmp_int & ")</a></li>"
		else
			cat1.text = "<li><span class='linkAbstand'>" & con.fields("blackboard_entry_kategorie").value & " (" & tmp_int & ")" & "</span></li>"
		end if
	end if
end sub

Protected Sub GesBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		Dim con as ContentUPdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		Dim cat2 As Literal = CType(e.Item.FindControl("cat2"), Literal)
		dim tmp_int as integer = _getCount(con.fields("blackboard_entry_kategorie").id, Art2)
		con.ParentPages(2).Preview = CUPage.Preview
		if tmp_int > 0 then
			cat2.text = "<li class='contentActiv'><a href='" & con.ParentPages(2).link & "' title='" & con.fields("blackboard_entry_kategorie").value & "'>" & con.fields("blackboard_entry_kategorie").value & " (" & tmp_int & ")</a></li>"
		else
			cat2.text = "<li><span class='linkAbstand'>" & con.fields("blackboard_entry_kategorie").value & " (" & tmp_int & ")" & "</span></li>"
		end if
	end if
end sub
</script>
<div class="part part-inserate">
    <h3 class="h3 item-title"><%=angebote %></h3>
    <CU:CUObjectSet name="culist_blackboard_kategorien" runat="server" OnItemDataBound="AngBindItem">
    <headertemplate><ul class="inserateuebersicht"></headertemplate>
    <ItemTemplate>
    <asp:Literal id="cat1" runat="server" />
    </ItemTemplate>
    <footertemplate></ul></footertemplate>
    </CU:CUObjectSet>
    <h3><%=gesuche %></h3>
    <CU:CUObjectSet name="culist_blackboard_kategorien" runat="server" OnItemDataBound="GesBindItem">
    <headertemplate><ul class="inserateuebersicht"></headertemplate>
    <ItemTemplate>
    <asp:Literal id="cat2" runat="server" />
    </ItemTemplate>
    <footertemplate></ul></footertemplate>
    </CU:CUObjectSet>
   
</div>