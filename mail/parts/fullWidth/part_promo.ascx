<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		Container.LanguageCode = CUPage.LanguageCode
		Container.Preview = CUPage.Preview
        If Not Container.Images("bild").Properties("Filename").Value = "" Then         
			If Not Container.Links("link").Properties("Value").Value = "" Then
				if CUPage.Preview then 
					Bildlink.Text = "<a target=""_blank"" href="""& Container.Links("link").Properties("Value").Value & """><img src=""" & Container.Images("bild").src & """ alt=""" & Container.Images("bild").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#FFFFFF;"" border=""0"" /></a>"
				else
					Bildlink.Text = "<a target=""_blank"" href="""& Container.Links("link").Properties("Value").Value & """><img src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/cuimgpath/" & Container.Images("bild").ProcessedFileName & """ alt=""" & Container.Images("bild").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#FFFFFF;"" border=""0"" /></a>"
				End If
			else
				if CUPage.Preview then 
					Bildlink.Text = "<img src=""" & Container.Images("bild").src & """ alt=""" & Container.Images("bild").legend & """ width=""100%"" border=""0"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#FFFFFF;"" />"
				else
					Bildlink.Text = "<img src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/cuimgpath/" & Container.Images("bild").ProcessedFileName & """ alt=""" & Container.Images("bild").legend & """ width=""100%"" border=""0"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#FFFFFF;"" />"
				End If
			End If
		End If
    End Sub
</script>
<%  If TemplateView = "text" Then%>
<%else %>
                         <table align="center" border="0" cellpadding="0" cellspacing="0">
                            <tbody>
                            <tr>
                              <td style="width:622px; max-width:622px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="center" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                      </tr>
                            <tr>
                                <td style="width:622px; max-width:622px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="center">
									<asp:Literal ID="Bildlink" runat="server" />
                                </td>
        </tr>
                            <tr>
                              <td style="width:622px; max-width:622px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="center" bgcolor="#F7F7F7" valign="top">&nbsp;</td>
                      </tr>
                       <tr>
                          <td style="width:622px; max-width:622px;;" bgcolor="#E6E6E6" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1" /></td>
                        </tr>
                        <tr>
                          <td style="width:622px; max-width:622px;;" bgcolor="#FFFFFF" height="1"><img src="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/1px.gif" style="display:block;" alt="" height="1" width="1" /></td>
                        </tr> 
                    </tbody></table>
                         
<%end if %>