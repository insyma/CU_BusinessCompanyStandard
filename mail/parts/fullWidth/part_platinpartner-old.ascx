<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		Container.LanguageCode = CUPage.LanguageCode
		Container.Preview = CUPage.Preview
		If Not Container.Links("link1").Properties("Value").Value = "" Then
			if CUPage.Preview then
				Bildlink1.Text = "<a target=""_blank"" href="""& Container.Links("link1").Properties("Value").Value & """><img border=""0"" src=""" & Container.Images("logo1").src & """ alt=""" & Container.Images("logo1").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
			else
				Bildlink1.Text = "<a target=""_blank"" href="""& Container.Links("link1").Properties("Value").Value & """><img border=""0"" src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/logo/cuimgpath/" & Container.Images("logo1").ProcessedFileName & """ alt=""" & Container.Images("logo1").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
			End if
		End If
		If Not Container.Links("link2").Properties("Value").Value = "" Then
			if CUPage.Preview then
				Bildlink2.Text = "<a target=""_blank"" href="""& Container.Links("link2").Properties("Value").Value & """><img border=""0"" src=""" & Container.Images("logo2").src & """ alt=""" & Container.Images("logo2").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
			else
				Bildlink2.Text = "<a target=""_blank"" href="""& Container.Links("link2").Properties("Value").Value & """><img border=""0"" src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/logo/cuimgpath/" & Container.Images("logo2").ProcessedFileName & """ alt=""" & Container.Images("logo2").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
			End if
		End If
		If Not Container.Links("link3").Properties("Value").Value = "" Then
			if CUPage.Preview then
				Bildlink3.Text = "<a target=""_blank"" href="""& Container.Links("link3").Properties("Value").Value & """><img border=""0"" src=""" & Container.Images("logo3").src & """ alt=""" & Container.Images("logo3").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
			else
				Bildlink3.Text = "<a target=""_blank"" href="""& Container.Links("link3").Properties("Value").Value & """><img border=""0"" src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/logo/cuimgpath/" & Container.Images("logo3").ProcessedFileName & """ alt=""" & Container.Images("logo3").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
			End if
		End If
		If Not Container.Links("link4").Properties("Value").Value = "" Then
			if CUPage.Preview then
				Bildlink4.Text = "<a target=""_blank"" href="""& Container.Links("link4").Properties("Value").Value & """><img border=""0"" src=""" & Container.Images("logo4").src & """ alt=""" & Container.Images("logo4").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
			else
				Bildlink4.Text = "<a target=""_blank"" href="""& Container.Links("link4").Properties("Value").Value & """><img border=""0"" src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/logo/cuimgpath/" & Container.Images("logo4").ProcessedFileName & """ alt=""" & Container.Images("logo4").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
			End if
		End If
		If Not Container.Links("link5").Properties("Value").Value = "" Then
			if CUPage.Preview then
				Bildlink5.Text = "<a target=""_blank"" href="""& Container.Links("link5").Properties("Value").Value & """><img border=""0"" src=""" & Container.Images("logo5").src & """ alt=""" & Container.Images("logo5").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
			else
				Bildlink5.Text = "<a target=""_blank"" href="""& Container.Links("link5").Properties("Value").Value & """><img border=""0"" src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/logo/cuimgpath/" & Container.Images("logo5").ProcessedFileName & """ alt=""" & Container.Images("logo5").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#FFFFFF;"" /></a>"
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
                          <td style="width:592px; font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#C10E1F;" align="left" bgcolor="#F7F7F7" height="47"><CU:CUField name="title" runat="server" /></td>
                          <td style="width:15px; max-width:15px;" bgcolor="#F7F7F7">&nbsp;</td>
                        </tr>
                        <tr>
                          <td style="width:15px; max-width:15px;" bgcolor="#F7F7F7">&nbsp;</td>
                          <td align="center" bgcolor="#F7F7F7"><table border="0" align="left" cellpadding="0" cellspacing="0">
                            <tr>
                              <td align="left" style="width:120px; max-width:120px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><span style="width:102px; max-width:102px; float:left;"><asp:Literal ID="Bildlink1" runat="server" /></span></td>
                              <td align="left" style="width:120px; max-width:120px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><span style="width:102px; max-width:102px; float:left;"><asp:Literal ID="Bildlink2" runat="server" /></span></td>
                            </tr>
                          </table>
                            <table border="0" align="left" cellpadding="0" cellspacing="0">
                              <tr>
                                <td align="left" style="width:120px; max-width:120px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><span style="width:102px; max-width:102px; float:left;"><asp:Literal ID="Bildlink3" runat="server" /></span></td>
                                <td align="left" style="width:120px; max-width:120px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><span style="width:102px; max-width:102px; float:left;"><asp:Literal ID="Bildlink4" runat="server" /></span></td>
                              </tr>
                            </table>
                            <table border="0" align="left" cellpadding="0" cellspacing="0">
                              <tr>
                                <td align="center" style="width:102px; max-width:102px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><span style="width:102px; max-width:102px; float:left;"><asp:Literal ID="Bildlink5" runat="server" /></span></td>
                              </tr>
                          </table></td>
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