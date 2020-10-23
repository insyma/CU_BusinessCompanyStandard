<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage"  %>
<%@ Register TagPrefix="Control" TagName="MailInfo" Src="../../parts/fullWidth/control_MailInfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="policy" Src="../../parts/fullWidth/control_Policy.ascx" %>
<%@ Register TagPrefix="Control" TagName="topnavigation" Src="../../parts/fullWidth/control_TopNavigation.ascx" %>
<%@ Register TagPrefix="Control" TagName="footer" Src="../../parts/fullWidth/control_Footer.ascx" %>

<script runat="server">
        '' Laden der ReferenzObjektID, welche auf dem NL-Objekt hinterlegt ist
        '' diese ID verweist auf die Seite mit den Einstellungen für diesen NL
    Dim RefObj As New ContentUpdate.Obj
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        '' Zuweisen der entsprechenden ContainerIDs(welche in der Eigenschafts-Seite angelegt sind)
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        policy.Container = RefObj.Containers("policy")
        MailInfo.Container = RefObj.Containers("MailInfo")
        footer.Container = RefObj.Containers("Footer")
		topnavigation.Container = RefObj.Containers("conlinkliste")
        policy.Container.LanguageCode = CUPage.LanguageCode
        MailInfo.Container.LanguageCode = CUPage.LanguageCode
        footer.Container.LanguageCode = CUPage.LanguageCode
		topnavigation.Container.LanguageCode = CUPage.LanguageCode
    End Sub
</script>
<Control:MailInfo ID="MailInfo" runat="server" TemplateView="text" /><CU:CUPLACEHOLDER id="header" runat="server" templateview="text" /><CU:CUPLACEHOLDER id="introduction" runat="server" templateview="text" /><CU:CUPLACEHOLDER id="content" runat="server" templateview="text" /><control:topnavigation id="topnavigation" runat="server" templateview="text" /><Control:policy id="policy" runat="server" TemplateView="text" /><Control:footer id="footer" runat="server" TemplateView="text" />