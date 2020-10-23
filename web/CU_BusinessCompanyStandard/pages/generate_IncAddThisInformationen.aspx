<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
dim what as string = ""
dim acc as string = ""
dim txt as string = ""
dim vis as boolean = false
   Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
   		dim con as new contentupdate.container
		'con.loadByName("addthisinfocon")
		con.load(CUPage.containers("addthisinfocon").id)
       '' Wenn AddThis gewünscht
		if con.fields("AddThisActive").value = "1" then
			what = con.fields("addthisstyle").value
			acc = con.fields("AddThisID").value
			txt = con.fields("AddThisText").value
		else
			AddThisButton.visible = false
		end if
   End Sub
</script>
<div class="ConAddThis" id="AddThisButton" runat="server">
	<% if what = "Toolbox" then %>
        <div class="addthis_sharing_toolbox"></div>
    <% end if %>
</div>