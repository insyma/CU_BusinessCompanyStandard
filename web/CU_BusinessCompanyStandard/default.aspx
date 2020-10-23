<%@ Page Language="VB" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Globalization" %>
<script runat="server">
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
	dim ci0 as string = CultureInfo.CurrentCulture.Name
	dim ci1 as string = Request.UserLanguages(0).ToString()
	if ci0.substring(0,2).toLower() = "fr" OR ci1.substring(0,2).toLower() = "fr" then
		Response.Redirect("fra/default.aspx")
	else
		Response.Redirect("deu/default.aspx")
	end if
End Sub
</script>