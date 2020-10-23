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
<CU:CUMailLink MailLinkType="MailLink" runat="server" />
<% Else %>

                            
                            
<table align="center" border="0" cellpadding="0" cellspacing="0">
                        
                            <tbody><tr>
                                <td style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;" bgcolor="#333333">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    
                                        <tbody><tr>
                                            <td style="width:15px; max-width:15px;" bgcolor="#333333">&nbsp;</td>
                                          <td class="text" style="width:607px; max-width:607px; font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#B7B7B7;" bgcolor="#333333" height="74">
                                                                                      <CUInfo>
	<CU:CUField name="HTMLInfo1" runat="server" />
	<CU:CUMailLink MailLinkType="MailLink" CssStyle="color: #B7B7B7;" Target="_blank" Link="true" runat="server">
		<asp:Literal id="Link" runat="server" />
	</CU:CUMailLink>&nbsp;<CU:CUField name="HTMLInfo3" runat="server" />   
    <asp:Literal id="Link2" runat="server" /> 
    <% if not Container.Fields("SpamInfo").Value = "" %>
    	<br  /><br /><%=Container.Fields("SpamInfo").Value %>
    <% End If %> 
</CUInfo></td>
                                            <td style="width:15px; max-width:15px;" bgcolor="#333333">&nbsp;</td>
                                  </tr>
                                    
                                </tbody></table>
                              </td>
                            </tr>
                        
                    </tbody></table>                            
<% End If %>