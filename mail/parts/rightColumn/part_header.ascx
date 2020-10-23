<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<%  If TemplateView = "text" Then%>
<%=vbcrlf%>
----------------------------------------------------------------------
<%=CUPage.Properties("subject").Value%>
----------------------------------------------------------------------
<CU:CUField Name="title" runat="server" PlainText="true" />
<CU:CUField Name="ausgabe" runat="server" PlainText="true" /><%else %>

<table class="part_header" width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="background: #ffffff;">
    <tr>
        <td align="left" width="20" valign="top" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" width="19" height="19" alt="*" /></td>
        <td align="left" width="280" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" height="19" width="5" alt="*" /></td>
        <td align="left" width="280" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" height="19" width="5" alt="*" /></td>
        <td align="right" valign="top" width="20" bgcolor="#ffffff"><img src="http://www.cu3.ch/CU_BCS/mail/img/layout/corner.gif" alt="*" width="20" height="20" border="0" align="right" style="margin-left:1px;" /></td>
    </tr>
    <tr>
        <td align="left" width="20" valign="top" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" width="19" height="19" alt="*" /></td>
        <td align="left" width="280" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" height="19" width="5" alt="*" /></td>
        <td align="right" width="280" style="background: #ffffff; line-height: 0; font-size: 1px;width:260px;"><a href="<%=Container.Fields("url").Value %>" target="_blank" title="" style="background: #ffffff; line-height: 0; font-size: 1px;width:260px;"><img src="http://www.cu3.ch/CU_BCS/mail/img/logo/cuimgpath/<%=Container.Images("logo-img").ProcessedFileName%>" border="0" alt="<%=Container.Images("logo-img").legend %>" width="<%=Container.Images("logo-img").Properties("width").value %>" align="right" /></a></td>        
         <td align="left" width="20" height="20" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" height="20" width="20" alt="*" /></td>
    </tr>
</table>
<table width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffff">
    <tr>
		<td align="left" width="19" valign="top" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" width="19" height="19" alt="*" /></td>
        <td align="left" width="562" style="font-family: Arial, Verdana, sans-serif;; background: #ffffff; line-height: 20px; font-size: 14px;color:#66676c; text-transform:uppercase;width:562px;"><span style="color: #66676c; font-size: 20px; font-family: Georgia, Times New Roman, serif;; line-height: 20px; text-transform:uppercase;"><CU:CUField name="title" runat="server" /></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CU:CUField name="ausgabe" runat="server" /></td>
        <td align="left" width="19" height="19" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" height="19" width="19" alt="*" /></td>
     </tr>
</table>
<table width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffff">
    <tr>
		<td align="left" width="600" valign="top" height="19" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" width="19" height="19" alt="*" /></td>
     </tr>
</table>
<table bgcolor="#ffffff" width="600" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>  
        <td width="600" valign="middle" style="background: #ffffff; line-height: 0; font-size: 1px;">
        	<img src="http://www.cu3.ch/CU_BCS/mail/img/headerbilder/cuimgpath/<%=Container.Images("emotion").ProcessedFileName %>" width="600" alt="<%=Container.Images("emotion").Legend %>" /></td>
    </tr>
    <tr>  
        <td width="600" valign="middle" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" height="10" width="19" alt="*" /></td>
    </tr>
</table>
<%End If%>