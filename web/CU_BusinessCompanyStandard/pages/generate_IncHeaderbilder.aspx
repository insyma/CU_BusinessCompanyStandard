<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">

	dim x as integer = 0
	dim y as integer = 0
	dim anzeigeModus as string = ""
	dim i as integer = 0
	dim counter as boolean = false
	dim vis as boolean = true
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
	
		' ### Id der Headerbilder Liste
		headerbilder.name = CUPage.Web.Rubrics("Web").Rubrics("ZentraleInhalte").Pages("Headerbilder").Containers("Headerbilder").ObjectSets("Headerbilder").Id
		
		' ### Auslesen ob Zufallsbild oder Slideshow
		Dim headerAnzeigeCon As New ContentUpdate.Container()
		'headerAnzeigeCon.LoadByName("HeaderAdmin")
		headerAnzeigeCon.Load(CUPage.Web.Rubrics("Web").Rubrics("ZentraleInhalte").Pages("Headerbilder").Containers("HeaderAdmin").id)
		anzeigeModus = headerAnzeigeCon.Fields("HeaderAnzeigeModus").Value

    End Sub
	
	Sub BindItem(sender as object, e as RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		
			Dim con as ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			con.LanguageCode = CUPage.LanguageCode
			con.Preview = CUPage.Preview
			
			' ### Alle Bilder ausblenden
			e.item.visible = false
			
			' ### Bilder die in der gewünschten Kategorie sind einblenden
			For each ccon As Contentupdate.Container in con.ObjectSets("Kategorien").Containers
				if (ccon.Fields("Kategorie").Value = CUPage.containers(1).Fields("Headerkategorie").Value) then
					e.item.visible = true
					i += 1
				end if
			next
		 
		End If
		If (e.Item.ItemType = ListItemType.Footer) Then
			if i = 0 then
				vis = false
			end if
		end If
	End Sub
	
</script>
<% if vis = true then %>
<CU:CUObjectSet name="" id="headerbilder" runat="server" OnItemDataBound="BindItem">
	<HeaderTemplate>
		<div data-mode="<%=anzeigeModus%>" class="part-headerbild con-flex flex-headerbild flexslider headerbild clearfix">
		<% if i < 2 %>
			<ul>
		<% else %>
        	<ul class="slides">
        <% end if %>
	</HeaderTemplate>
	<ItemTemplate>
		<li>
			<figure class="bgimg" style='background-image: url(<CU:CUImage name="Headerbild" runat="server" property="src" />)'>		
				<CU:CUImage name="Headerbild" runat="server" />
			</figure>
		</li>
	</ItemTemplate>
	<FooterTemplate>
    		</ul>
    	</div>
	</FooterTemplate>
</CU:CUObjectSet>
<% end if %>