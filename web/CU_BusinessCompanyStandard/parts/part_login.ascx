<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ Register TagPrefix="Control" TagName="login" Src="../parts/login.ascx" %>
<script runat="server"> 
        Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
                
        End Sub
</script>
<div class="part part-log-in">
     <%
     	If (CUPage.Preview) Then
     %>
        	<Control:login id="login" runat="server" />
     <%
        Else
        	Response.Write("<Control:login id=""login"" runat=""server"" />")
        End If
     %>
</div>