<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Dim i As Integer = 0

	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		if CUPage.Containers("con_headerbild").Containers("con_headerbild__local").id > 0 then
			headerbild_liste.name = CUPage.Containers("con_headerbild").Containers("con_headerbild__local").objectSets(1).id

			Dim HeaderbildContainer As New ContentUpdate.Container()
			If Not CUPage.Containers("con_headerbild").Containers("con_headerbild__local").Images("con_headerbild__local__image").properties("filename").value = "" Then
				Headerbild.Text = "<div class='part-headerbild con-flex flex-headerbild flexslider headerbild clearfix'><ul class='item'><li><figure class='bgimg' style='background-image: url(" & CUPage.Containers("con_headerbild").Containers("con_headerbild__local").Images("con_headerbild__local__image").src & ");'><img src ='" & CUPage.Containers("con_headerbild").Containers("con_headerbild__local").Images("con_headerbild__local__image").src & "' alt='" & HeaderbildContainer.files("con_headerbild__local__image").properties("legend").value & "' /></figure><</li></ul></div>"
			End If
		end if
	End Sub
	Sub BindItemList(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
			con.LanguageCode = CUPage.LanguageCode
			con.Preview = CUPage.Preview
			i += 1
		End If
	End Sub


</script>
<cu:cucontainer name="con_headerbild" runat="server">
	<cu:cucontainer name="con_headerbild__local" runat="server">

			<asp:Literal id="Headerbild" runat="server" />

			<cu:cuobjectset name="" id="headerbild_liste" runat="server" onitemdatabound="BindItemList">
				<HeaderTemplate>
					<div data-mode="" class="part-headerbild con-flex flex-headerbild flexslider headerbild clearfix">
					<% if i < 1 %>
        				<ul>
					<% else If i < 2 %>
						<ul class="item">
					<% else %>
        				<ul class="slides">
					<% end if %>
				</HeaderTemplate>
				<ItemTemplate>
					<li>
						<figure class="bgimg" style='background-image: url(<CU:CUImage name="con_headerbild__local__list_image" runat="server" property="src" />)'>
							<CU:CUImage name="con_headerbild__local__list_image" runat="server" />
						</figure>
					</li>
				</ItemTemplate>
				<FooterTemplate>
					</ul>
				</div>
				</FooterTemplate>
			</CU:CUObjectSet>
	</cu:cucontainer>
</cu:cucontainer>

