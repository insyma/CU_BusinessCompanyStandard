<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
dim h as string = ""
dim urli as string = ""
dim w as string = ""
''Variable für die Entscheidung, ob part ausgegeben wird
dim part_visible as boolean = false

Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
	h = container.fields("part_iframe_nl_h").value
	urli = container.fields("part_iframe_nl_url").value
	w = container.fields("part_iframe_nl_w").value
	if urli <> "" then
		part_visible = true
	end if
        If cupage.Preview = False Then
            path = CUPage.Web.LiveServer & CUPage.Web.Livepath
        End If
        Caching = "?cache=" & DateTime.UtcNow.Subtract(New DateTime(1970, 1, 1)).TotalMilliseconds
    End Sub
</script>
<% if part_visible = true then %>
<div class="part part-iframe">
    <iframe frameborder="0" height='<%=h%>' width='<%=w%>' scrolling='auto' src='<%=urli%>'><%=caching%></iframe>
</div>
<% end if %>