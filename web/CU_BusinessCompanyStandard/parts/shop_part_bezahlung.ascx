<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		response.write("<%@ Page Language=""VB"" %>")	
		response.write("<%@ Register TagPrefix=""Control"" TagName=""Bezahlung"" Src=""../deu/shop_bezahlung.ascx"" %>")
	End Sub
    
</script>
<%response.write("<Control:Bezahlung id=""Bezahlung"" ru" & "nat=""server"" />")%>