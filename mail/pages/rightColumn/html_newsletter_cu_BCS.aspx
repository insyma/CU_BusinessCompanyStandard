<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage"  %>
<%@ Register TagPrefix="Control" TagName="MailInfo" Src="../../parts/rightColumn/control_MailInfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="policy" Src="../../parts/rightColumn/control_Policy.ascx" %>
<%@ Register TagPrefix="Control" TagName="HiddenInfo" Src="../../parts/rightColumn/control_HiddenInfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="navigation" Src="../../parts/rightColumn/control_Navigation.ascx" %>
<%@ Register TagPrefix="Control" TagName="footer" Src="../../parts/rightColumn/control_Footer.ascx" %>
<script runat="server">
    Dim RefObj As New ContentUpdate.Obj

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        RefObj.IsMail = CUPage.IsMail
        HiddenInfo.Container = RefObj.Containers("HiddenInfo")
		navigation.Container = RefObj.Containers("Navigation")
        policy.Container = RefObj.Containers("policy")
        MailInfo.Container = RefObj.Containers("MailInfo")
        footer.Container = RefObj.Containers("Footer")
        HiddenInfo.Container.LanguageCode = CUPage.LanguageCode
        navigation.Container.LanguageCode = CUPage.LanguageCode
        policy.Container.LanguageCode = CUPage.LanguageCode
        MailInfo.Container.LanguageCode = CUPage.LanguageCode
        footer.Container.LanguageCode = CUPage.LanguageCode
    End Sub
</script>

<Control:HiddenInfo ID="HiddenInfo" runat="server" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="de" xml:lang="de">
<head>
    <title><%=CUPage.Properties("subject").Value%></title>
    <Encoding />

    <style type="text/css">
        a {
            color: #fb2701;
            text-decoration: none;
        }
        a:hover {
			color: #fb2701;
            text-decoration: none;
        }
		ul {
			list-style:none;
		}		
		.inhalt a, p a, span a {
			text-decoration : underline;	
		}
		table td {
			border-collapse:collapse;
		}
    </style>
</head>
<body bgcolor="#efefef" style="background: #efefef;padding:0;margin:0;" link="#fb2701" alink="#fb2701" vlink="#fb2701" text="#66676c">
<CU:CULibrary runat="server" id="CULibrary" />
<table border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#efefef" style="background: #efefef;">
    <tr>
        <td width="600" bgcolor="#efefef" style="background: #efefef; width: 600px;">
            <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#efefef" style="background: #efefef;">
                <tr>
                    <td width="600" bgcolor="#efefef" style="background: #efefef;line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="15" /></td>
                </tr>
                <tr>
                    <td width="600" align="center" bgcolor="#efefef" style="background: #efefef; font-size: 9px; font-family: Arial, Verdana, sans-serif; line-height: 13px; color: #aeaeae;">            
                        <Control:MailInfo ID="MailInfo" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td width="600" bgcolor="#efefef" style="background: #efefef;line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="15" /><a name="top"></a>  </td>
                </tr>
            </table>
			<CU:CUPlaceholder ID="header" runat="server" />
            <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffff">
                <tr>        
                    <td align="left" bgcolor="#ffffff" width="19" style="background: #ffffff; line-height: 0; font-size: 1px;">
                        <img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="19" height="5" />
                    </td>
                    <td align="left" valign="top" width="371" style="background:#ffffff;" bgcolor="#ffffff">
                        <CU:CUPlaceholder ID="content" runat="server" style="background: #ffffff;" cssclass="inhalt" />
					</td>
                    <td align="left" bgcolor="#ffffff" width="19" style="background: #ffffff; line-height: 0; font-size: 1px;">
                        <img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="19" height="5" />
                    </td>
                    <td align="left" valign="top" width="172" style="background:#ffffff;" bgcolor="#ffffff">
                        <CU:CUPlaceholder ID="introduction" runat="server" style="background: #ffffff;" cssclass="inhalt"/>
                    </td>
                    <td align="left" bgcolor="#ffffff" width="19" style="background: #ffffff; line-height: 0; font-size: 1px;">
                        <img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="19" height="5" />
                    </td>
                </tr>
            </table>
            <control:navigation id="navigation" runat="server" />
            <Control:policy id="policy" runat="server" />
           	<Control:footer id="footer" runat="server" />
		</td>
	</tr>
	<tr>
    	<td bgcolor="#efefef" align="left" style="background: #efefef; line-height: 0; font-size: 1px;">
			<CUForward><CU:CUMailLink ID="CUMailLink2" MailLinkType="LogImage" runat="server" Width="1" Height="1" /></CUForward>
        </td>
	</tr>
</table>
</body>
</html>