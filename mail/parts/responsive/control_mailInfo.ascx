<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
  Dim CUMail As New ContentUpdate.Mail()
  dim p as string = ""
  Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    CUMail.Load(CUPage.Id)  'zuweisen, dass wir uns in einer Mail(NL) befinden, nicht auf einer StandardPage'
		if Container.Fields("HTMLInfo2").value <> "" then
      ' Von den Einstellungen des NLs: wenn text abgefüllt, dann gib Text PLUS den personalisierten Archiv-Link der Mail aus'
			Link.Text = Container.Fields("HTMLInfo2").value
			Link2.Text = " " & CUmail.MailLink
		else
      '' Nur der Link
			Link.Text = " " & CUmail.MailLink
			Link2.visible = false
		end if
    '##### dynamischer Pfad like "/CU_BusinessCompanyStandard/mail/"
    p = CUPage.Web.TemplatePath
  End Sub
</script>
<%  If TemplateView = "text" Then%>
<CU:CUField name="TextInfo1" runat="server" PlainText="true" />
<CU:CUMailLink MailLinkType="MailLink" runat="server" /><% Else %>
<table align="center" border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;" bgcolor="#FFFFFF"><table border="0" cellpadding="0" cellspacing="0">
        <tbody>
          <tr>
            <td style="width:15px; max-width:15px;" bgcolor="#333333">&nbsp;</td>
            <td height="74" align="center" bgcolor="#333333" class="text" style="width:617px; max-width:617px; font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#B7B7B7;"><CUInfo>
              <CU:CUField name="HTMLInfo1" runat="server" />
              <CU:CUMailLink MailLinkType="MailLink" CssStyle="color: #B7B7B7;" Target="_blank" Link="true" runat="server">
                <asp:Literal id="Link" runat="server" />            
              </CU:CUMailLink>
              <CU:CUField name="HTMLInfo3" runat="server" />
              <asp:Literal id="Link2" runat="server" />            
              <% if not Container.Fields("SpamInfo").Value = "" %>
              <br  />
              <br />
              <%=Container.Fields("SpamInfo").Value %>
              <% End If %>
            </CUInfo></td>
            <td style="width:15px; max-width:15px;" bgcolor="#333333">&nbsp;</td>
          </tr>
        </tbody>
      </table></td>
    </tr>
  </tbody>
</table>
<% End If %>