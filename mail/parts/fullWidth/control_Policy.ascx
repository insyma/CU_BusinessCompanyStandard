<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        DisclaimerLink.HRef = Container.Fields("HTMLDisclaimerURL").Value
        ReplacePlaceholder.ReplaceText = Container.Fields("TextProfileDisclaimer").Plaintext
        if Container.Fields("HTMLDisclaimerURL").Value = "" then
        	DisclaimerLink.Visible = false
        end if
    End Sub
</script>
<% if templateview = "text" then %><%=vbcr%>
----------------------------------------------------------------------
<CU:CUMailLink ID="ReplacePlaceholder" MailLinkType="ReplacePlaceholder" runat="server" />
<%=vbcr%>
<% else %>
<table class="control_policy" width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffff">
    <tr>        
        <td align="left" bgcolor="#ffffff" width="19" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="19" height="5" /></td>
        <td align="left" width="562" style="background:#ffffff" bgcolor="#ffffff">
            <table width="562" style="background:#ffffff;border-top: solid 1px #fb2701;" border="0">
            	<tr>
                    <td align="left" width="562" valign="top" height="2" style="background: #ffffff; line-height: 0; font-size: 1px;">
                    	<img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" width="19" height="1" alt="*" />
                    </td>
				</tr>
			</table>
        </td>
		<td bgcolor="#ffffff" align="left" width="19" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="19" height="5" /></td> 
	</tr>
</table>
<table width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffff">
    <tr>
        <td align="left" width="19" bgcolor="#ffffff" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="19" /></td>
        <td align="left" width="562" bgcolor="#ffffff" style="background:#ffffff;font-size: 10px; font-family: Arial, Verdana, sans-serif; color: #66676c; line-height: 16px;"> 
			<img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" height="20" /><br />
            <CU:CUField name="HTMLDisclaimerTitle" runat="server" Tag="strong" /><br />
            <CU:CUField name="HTMLDisclaimerText" runat="server" />
            <a id="DisclaimerLink" runat="server" href="#" target="_blank" style="color: #fb2701;">
                <CU:CUField name="HTMLDisclaimerLinkLabel" runat="server" />
            </a><br />&nbsp;<br />
            <CUForward>
            <CU:CUField name="HTMLProfileTitle" runat="server" Tag="strong" /><br />
            <CU:CUField name="HTMLProfileText" runat="server" />
                <CU:CUMailLink MailLinkType="NLProfileLink" Link="true" Target="_blank" CssStyle="color: #fb2701;" runat="server" >
                    <CU:CUField name="HTMLProfileLinkLabel" runat="server" />
                </CU:CUMailLink>
            </CUForward>
            <br /><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="20" />
        </td>
        <td align="left" width="19" bgcolor="#ffffff" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="19" /></td>
    </tr>
</table>
<% End If %>