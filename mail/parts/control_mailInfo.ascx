<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>

<% 'Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    Dim CUMail As New ContentUpdate.Mail()
    Dim RefObj As New ContentUpdate.Obj
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        CUMail.Load(CUPage.Id)
        'Laden der ReferenzObjektID, welche auf dem NL-Objekt hinterlegt ist, ID verweist auf die Seite mit den Einstellungen
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        RefObj.IsMail = CUPage.IsMail
        
        if RefObj.Containers("MailInfo").Fields("SpamInfo").value <> "" then
            spamInfo.text = RefObj.Containers("MailInfo").Fields("SpamInfo").value  
        end if
        
    End Sub
</script>
<%  If TemplateView = "text" Then%>
<CU:CUField name="TextInfo1" runat="server" PlainText="true" />
<CU:CUMailLink MailLinkType="MailLink" runat="server" /><% Else %>
<table width="100%" style="width:100%;" border="0" cellpadding="0" cellspacing="0" >
    <tr>
        <td>
            <table align="center" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
                    <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                    <td height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
                </tr>
                <tr>
                    <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    <td width="600" style="text-align: center; width:600px; max-width:600px; <%=F_SpamInfo_Text%>">
                        <asp:literal runat="server" id="spamInfo" />
                    </td>
                    <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                </tr>
                <tr>
                    <td height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
                    <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                    <td height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
                </tr>
            </table> 
        </td>
    </tr>
</table> 



<% End If %>