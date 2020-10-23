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
      <td align="center" bgcolor="#3A601E" style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><a href="http://www.insyma.ch"><img src='http://www.contentupdate.net<%=p%>img/headerbilder/cuimgpath/<%=container.images("img-stage").processedfilename%>' width="100%" border="0" style="font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:21px; color:#FFFFFF;" />
</a></td>
    </tr>
  </tbody>
</table>
<%end if %>