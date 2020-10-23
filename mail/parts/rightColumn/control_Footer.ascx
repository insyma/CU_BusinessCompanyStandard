<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<% if templateview = "text" then %>
----------------------------------------------------------------------------------------------------
<CU:CUField name="TextFooter" runat="server" PlainText="true" />
----------------------------------------------------------------------------------------------------
<% Else %>
<table class="control_footer" width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#efefef">
    <tr>
        <td align="left" width="19" bgcolor="#efefef" style="background: #efefef; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="19" /></td>
        <td align="left" width="562" bgcolor="#efefef" style="background:#efefef;font-size: 10px; font-family: Arial, Verdana, sans-serif; color: #aeaeae; line-height: 16px;"> 
			<img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" height="10" /><br />
			<%=Container.Fields("HTMLFooter").Value.Replace("<a ","<a style='color:#aeaeae;text-decoration:none;'").Replace(" insyma", " <span style='color: #fb2701;'>insyma</span>")%>
            <br /><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="13" />
		</td>
        <td align="left" width="19" bgcolor="#efefef" style="background: #efefef; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="19" /></td>
    </tr>
</table>
<% End If %>