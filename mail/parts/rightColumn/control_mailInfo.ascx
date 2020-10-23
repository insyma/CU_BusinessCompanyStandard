<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
    Dim CUMail As New ContentUpdate.Mail()
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        CUMail.Load(CUPage.Id)
		if Container.Fields("HTMLInfo2").value <> "" then
			Link.Text = Container.Fields("HTMLInfo2").value
			Link2.Text = " " & CUmail.MailLink
		else
			Link.Text = " " & CUmail.MailLink
			Link2.visible = false
		end if
    End Sub
</script>
<%  If TemplateView = "text" Then%>
<CU:CUField name="TextInfo1" runat="server" PlainText="true" />
<CU:CUMailLink MailLinkType="MailLink" runat="server" /><% Else %>
<CUInfo>
	<CU:CUField name="HTMLInfo1" runat="server" />
	<CU:CUMailLink MailLinkType="MailLink" CssStyle="color: #fb2701;" Target="_blank" Link="true" runat="server">
		<asp:Literal id="Link" runat="server" />
	</CU:CUMailLink> 
	<CU:CUField name="HTMLInfo3" runat="server" />   
    <asp:Literal id="Link2" runat="server" /> 
    <% if not Container.Fields("SpamInfo").Value = "" %>
    	<br  /><br /><%=Container.Fields("SpamInfo").Value %>
    <% End If %> 
</CUInfo>
<% End If %>