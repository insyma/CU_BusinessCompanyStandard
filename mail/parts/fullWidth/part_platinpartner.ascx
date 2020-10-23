<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		Container.LanguageCode = CUPage.LanguageCode
		Container.Preview = CUPage.Preview
		If Not Container.Links("link1").Properties("Value").Value = "" Then
			if CUPage.Preview then
				Bildlink1.Text = "<a target=""_blank"" href="""& Container.Links("link1").Properties("Value").Value & """><img border=""0"" src=""" & Container.Images("logo1").src & """ alt=""" & Container.Images("logo1").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:18px; color:#FFFFFF;"" /></a>"
			else
				Bildlink1.Text = "<a target=""_blank"" href="""& Container.Links("link1").Properties("Value").Value & """><img border=""0"" src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/logo/cuimgpath/" & Container.Images("logo1").ProcessedFileName & """ alt=""" & Container.Images("logo1").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
				End if
		End If
    End Sub
</script>
<%  If TemplateView = "text" Then%>
<%else %>
<table align="center" border="0" cellpadding="0" cellspacing="0">
                      <tbody>
                        <tr>
                          <td colspan="3" style="width:622px; max-width:622px;;" bgcolor="#E6E6E6" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1" /></td>
                        </tr>
                        <tr>
                          <td colspan="3" style="width:622px; max-width:622px;;" bgcolor="#FFFFFF" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1" /></td>
                        </tr>
                        <tr>
                          <td style="width:15px; max-width:15px;" bgcolor="#F7F7F7">&nbsp;</td>
                          <td style="width:592px; max-width:592px; font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#C10E1F;" align="left" bgcolor="#F7F7F7" height="47"><CU:CUField name="title" runat="server" /></td>
                          <td style="width:15px; max-width:15px;" bgcolor="#F7F7F7">&nbsp;</td>
                        </tr>
                        <tr>
                          <td style="width:15px; max-width:15px;" bgcolor="#F7F7F7">&nbsp;</td>
                          <td align="center" bgcolor="#F7F7F7"style="width:592px; max-width:592px;"><asp:Literal ID="Bildlink1" runat="server" /></td>
                          <td style="width:15px; max-width:15px;" bgcolor="#F7F7F7">&nbsp;</td>
                        </tr>
                        <tr>
                          <td style="width:15px; max-width:15px;" bgcolor="#F7F7F7">&nbsp;</td>
                          <td style="width:592px; font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#C10E1F;" align="left" bgcolor="#F7F7F7">&nbsp;</td>
                          <td style="width:15px; max-width:15px;" bgcolor="#F7F7F7">&nbsp;</td>
                        </tr>
                         <tr>
                          <td colspan="3" style="width:622px; max-width:622px;;" bgcolor="#E6E6E6" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1" /></td>
                        </tr>
                        <tr>
                          <td colspan="3" style="width:622px; max-width:622px;;" bgcolor="#FFFFFF" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1" /></td>
                        </tr>
                      </tbody>
                    </table>
                         
                         
<%end if %>