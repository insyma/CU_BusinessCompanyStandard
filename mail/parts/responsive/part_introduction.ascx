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
<%  If Not Container.Fields("text").Value = "" Then%><%=vbcrlf%><CU:CUField Name="intro-text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<table align="center" border="0" cellpadding="0" cellspacing="0">
<tbody>
  <tr>
    <td bgcolor="#F7F7F7" style="width:15px; max-width:15px;">&nbsp;</td>
    <td height="30" align="left" valign="top" bgcolor="#F7F7F7" class="text" style="width:617px; max-width:617px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:21px; color:#333333;">&nbsp;</td>
    <td bgcolor="#F7F7F7" style="width:15px; max-width:15px;">&nbsp;</td>
  </tr>
  <tr>
    <td bgcolor="#F7F7F7" style="width:15px; max-width:15px;">&nbsp;</td>iuz
    <td align="left" valign="top" bgcolor="#F7F7F7" class="text" style="width:617px; max-width:617px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; line-height:130%; color:#595252;"><span style="font-size:17px; line-height:25px;">Was is Responsive design?</span><br /><CU:CUField name="intro-text" runat="server" /><br />
      <br />
      <div><!--[if mso]>
  <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="http://emailbtn.net/" style="height:34px;v-text-anchor:middle;width:274px;" arcsize="16%" strokecolor="#82BB25" fill="t">
    <v:fill type="tile" src="http://www.contentupdate.net<%=p%>img/layout/bg-button2.gif" color="#82BB25" />
    <w:anchorlock/>
    <center style="color:#ffffff;font-family:Tahoma, Geneva, sans-serif;font-size:19px;text-shadow:#435928 2px 0 0 ;"><CU:CUField name="button-text" rnat="server" /></center>
  </v:roundrect>
<![endif]--><![if !mso]><a href="http://emailbtn.net/"
style="background-color:#82BB25;background-image:url(http://www.contentupdate.net<%=p%>img/layout/bg-button2.gif);border:1px solid #609637;border-radius:7px;color:#ffffff;display:inline-block;font-family:Tahoma, Geneva, sans-serif;font-size:19px;line-height:34px;text-align:center;text-decoration:none;width:274px;-webkit-text-size-adjust:none;text-shadow:#435928 1px 1px 1px ;"><CU:CUField name="button-text" rnat="server" /></a><![endif]></div></td>
    <td bgcolor="#F7F7F7" style="width:15px; max-width:15px;">&nbsp;</td>
  </tr>
  <tr>
    <td bgcolor="#F7F7F7" style="width:15px; max-width:15px;">&nbsp;</td>
    <td align="left" valign="top" bgcolor="#F7F7F7" class="text" style="width:617px; max-width:617px;">&nbsp;</td>
    <td bgcolor="#F7F7F7" style="width:15px; max-width:15px;">&nbsp;</td>
  </tr>
</tbody>
</table>
<%end if %>
