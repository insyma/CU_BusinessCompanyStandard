<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: part zur Integration der CSS-Files fürs Include(incl. Umgehung des Caching bei Publizierung des Includes)
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
dim path as string = "../"
dim caching as string = ""
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
	if cupage.Preview = false then
		path = CUPage.Web.LiveServer & CUPage.Web.Livepath
	end if
	caching = "?cache=" & DateTime.UtcNow.Subtract(New DateTime(1970, 1, 1)).TotalMilliseconds
End Sub
</script>
<% if CUPage.Preview then %>
<link rel="stylesheet" href="<%=path%>css/main.css<%=caching%>" type="text/css" />
<% else %>
<link rel="stylesheet" href="<%=path%>css/main.min.css<%=caching%>" type="text/css" media="all">
<% end if %>