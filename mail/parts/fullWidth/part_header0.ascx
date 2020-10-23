<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		Container.LanguageCode = CUPage.LanguageCode
		Container.Preview = CUPage.Preview
        If Not Container.Images("logo-img").Properties("Filename").Value = "" Then         
			If Not Container.Fields("url").Properties("Value").Value = "" Then
				if CUPage.Preview then 
					logo.Text = "<a target=""_blank"" href="""& Container.Fields("url").Properties("Value").Value & """><img src=""" & Container.Images("logo-img").src & """ alt=""" & Container.Images("logo-img").legend & """ border=""0"" width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:12px, color: #333333;"" /></a>"
				else
					logo.Text = "<a target=""_blank"" href="""& Container.Fields("url").Properties("Value").Value & """><img src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/logo/" & Container.Images("logo-img").filename & """ alt=""" & Container.Images("logo-img").legend & """ border=""0"" width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:12px, color: #333333;"" /></a>"
				end if
			else
				if CUPage.Preview then 
					logo.Text = "<img border=""0"" src=""" & Container.Images("logo-img").src & """ alt=""" & Container.Images("logo-img").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#FFFFFF;"" />"
				else
					logo.Text = "<img border=""0"" src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/logo/" & Container.Images("logo-img").src & """ alt=""" & Container.Images("logo-img").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#FFFFFF;"" />"
				end if
			End If
		End If
        If Not Container.Images("emotion").Properties("Filename").Value = "" Then         
			If Not Container.Fields("url_emotion").Properties("Value").Value = "" Then
				if CUPage.Preview then 
					emotion.Text = "<a target=""_blank"" href="""& Container.Fields("url_emotion").Properties("Value").Value & """><img src=""" & Container.Images("emotion").src & """ alt=""" & Container.Images("emotion").legend & """ border=""0"" width=""100%"" style=""Tahoma, Geneva, sans-serif; font-size:20px; color:#333333;"" /></a>"
				else
					emotion.Text = "<a target=""_blank"" href="""& Container.Fields("url_emotion").Properties("Value").Value & """><img src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/headerbilder/" & Container.Images("emotion").filename & """ alt=""" & Container.Images("emotion").legend & """ border=""0"" width=""100%"" style=""Tahoma, Geneva, sans-serif; font-size:20px; color:#333333;"" /></a>"
				End If
			else
				if CUPage.Preview then 
					emotion.Text = "<img border=""0"" src=""" & Container.Images("emotion").src & """ alt=""" & Container.Images("emotion").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#FFFFFF;"" />"
				else
					emotion.Text = "<img border=""0"" src=""http://www.contentupdate.net/SwissLeadershipForumAdmin/mail/img/headerbilder/" & Container.Images("emotion").filename & """ alt=""" & Container.Images("emotion").legend & """ width=""100%"" style=""font-family:Tahoma, Geneva, sans-serif; font-size:21px; color:#FFFFFF;"" />"
				End If
			End If
		End If
    End Sub
</script>

<%  If TemplateView = "text" Then%>
<%=vbcrlf%>
----------------------------------------------------------------------
<%=CUPage.Properties("subject").Value%>
----------------------------------------------------------------------
<CU:CUField Name="title" runat="server" PlainText="true" />
<CU:CUField Name="ausgabe" runat="server" PlainText="true" />
<%else %>


<table align="center" border="0" cellpadding="0" cellspacing="0">
                      <tbody><tr>
                        <td style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#FFFFFF" valign="top"><table border="0" cellpadding="0" cellspacing="0">
                          <tbody><tr>
                            <td style="width:271px; max-width:271px;">
                                <asp:Literal ID="logo" runat="server" />
                            </td>
                            <td style="width:376px; max-width:376px;">&nbsp;</td>
                          </tr>
                        </tbody></table></td>
                      </tr>
                      <tr>
                        <td style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;" bgcolor="#333333">
                                <asp:Literal ID="emotion" runat="server" />
                            </td>
                      </tr>
                    </tbody></table>
 
<%End If%>
