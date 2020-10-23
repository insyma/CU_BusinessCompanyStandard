<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
  dim p as string = ""
  Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    '##### dynamischer Pfad like "/CU_BusinessCompanyStandard/mail/"
    p = CUPage.Web.TemplatePath
  End Sub
</script>
<%  If TemplateView = "text" Then%>
<%else %>
<table align="center" border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="center" bgcolor="#3A601E" valign="top"><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" style="display:block;" alt="" height="74" width="1" /></td>
      <td style="width:632px; max-width:632px; mso-table-lspace:0pt; mso-table-rspace:0pt; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:21px; color:#FFFFFF; line-height:31px;" align="left" bgcolor="#3A601E"><CU:CUField name="weiss" runat="server" /><br />
        <span style="color:#87C946; font-size:17px;"><CU:CUField name="gruen" runat="server" /></span></td>
    </tr>
  </tbody>
</table>
<%end if %>