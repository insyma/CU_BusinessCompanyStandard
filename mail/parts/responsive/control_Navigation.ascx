<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Dim CUList as ContentUpdate.ObjectSet
    Dim CUMail As New ContentUpdate.Mail()
    Dim count As Integer = 1

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        CUList = New ContentUpdate.ObjectSet()
        CUList = Container.ObjectSets(1)
        CUMail.Load(CUPage.Id)
        ''Laden der Listen aus den Einstellungen
        NavigationList.ObjectSet = CUList
        NavigationList.DataBind()
        TextNavigationList.ObjectSet = CUList
        TextNavigationList.DataBind()
    End Sub

    Sub NavigationList_ItemDataBound(ByVal Sender As Object, ByVal e As RepeaterItemEventArgs)
        Dim i As Integer = e.Item.ItemIndex
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim entry As ContentUpdate.Container
            entry = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim link As HtmlAnchor
            link = CType(e.Item.FindControl("NavigationLink"), HtmlAnchor)

            Dim forwardbegin As Literal
            forwardbegin = CType(e.Item.FindControl("ForwardBegin"), Literal)
            forwardbegin.Text = "<CUForward>"

            Dim forwardend As Literal
            forwardend = CType(e.Item.FindControl("ForwardEnd"), Literal)
            forwardend.Text = "</CUForward>"
            ''Möglichkeiten in der NAvigationsliste
            Select Case entry.Fields("Type").Properties("Value").Value
                Case "0"
                    'selbst eingegebene URL
                    link.HRef = entry.Fields("URL").Plaintext
                    forwardbegin.Visible = False
                    forwardend.Visible = False
                Case "1"
                    ''Profilelink
                    link.HRef = CUMail.NLProfileLink.Replace("&","&amp;")
                Case "2"
                    ''Austragen
                    link.HRef = CUMail.NLUnsubscribeLink.Replace("&","&amp;")
                Case "3"
                    ''Weiterleiten
                    link.HRef = CUMail.NLRecommendationLink.Replace("&","&amp;")
            End Select
            link.Target = "_blank"
            link.InnerHtml = "~ " & entry.Fields("Labelling").Value & " ~"
			link.Attributes.Add("style","color: #66676c;text-decoration:none;")
			count = i+1
        End If
    End Sub
    
    Sub TextNavigationList_ItemDataBound(ByVal Sender As Object, ByVal e As RepeaterItemEventArgs)
        Dim i As Integer = e.Item.ItemIndex
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim entry As ContentUpdate.Container
            entry = CType(e.Item.DataItem, ContentUpdate.Container)
            
            Dim TextLabel As Literal
            Dim TextLink As Literal
            TextLabel = CType(e.Item.FindControl("TextNaviLabel"), Literal)
            TextLink = CType(e.Item.FindControl("TextNaviLink"), Literal)

            Select Case entry.Fields("Type").Properties("Value").Value
                Case "0"
                    TextLabel.Text = entry.Fields("Labelling").Plaintext
                    TextLink.Text = entry.Fields("URL").Plaintext
                Case "1"
                    TextLabel.Text = entry.Fields("Labelling").Plaintext
                    TextLink.Text = CUMail.NLProfileLink
                Case "2"
                    TextLabel.Text = entry.Fields("Labelling").Plaintext
                    TextLink.Text = CUMail.NLUnsubscribeLink
                Case "3"
                    TextLabel.Text = entry.Fields("Labelling").Plaintext
                    TextLink.Text = CUMail.NLRecommendationLink
            End Select
        End If
    End Sub

</script>
<% if templateview = "text" then %><%=vbcrlf%>----------------------------------------------------------------------
<CU:CUObjectSet ID="TextNavigationList" runat="server" OnItemDataBound="TextNavigationList_ItemDataBound">
<ItemTemplate>
<asp:Literal ID="TextNaviLabel" runat="server"></asp:Literal>
<asp:Literal ID="TextNaviLink" runat="server"></asp:Literal>
</ItemTemplate></CU:CUObjectSet><% else %>
<CU:CUObjectSet ID="NavigationList" runat="server" OnItemDataBound="NavigationList_ItemDataBound">
    <HeaderTemplate>
<table class="part_navigation" width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffff" style="background: #ffffff;">
    <tr>
        <td width="19" bgcolor="#ffffff" style="background: #ffffff;"></td>
        <td width="562" bgcolor="#ffffff" style="background: #ffffff; font-size: 11px; line-height: 11px;font-family: Arial, Verdana, sans-serif;">
        <table width="562" style="background:#ffffff;border-top: solid 1px #fb2701;" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td align="left" width="562" valign="top" height="2" style="background: #ffffff; line-height: 0; font-size: 1px;">
                    <img src="http://www.contentupdate.net<%=p%>img/layout/breaker.gif" width="19" height="8" alt="*" />
                </td>
            </tr>
        </table>
        <table width="562" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffff" style="background: #ffffff;">
            <tr>
        </HeaderTemplate>
        <ItemTemplate>
            <asp:Literal ID="ForwardBegin" runat="server"></asp:Literal>
            <td valign="middle" align="center"  bgcolor="#ffffff" style="background: #ffffff; font-size: 11px; line-height: 11px; font-family: Arial, Verdana, sans-serif;">
                <a href="" id="NavigationLink" runat="server" target="_blank"></a>
            </td>
            <asp:Literal ID="ForwardEnd" runat="server"></asp:Literal>
        </ItemTemplate>
        <FooterTemplate>
            </tr>
            <tr>
                <td colspan="<%=count%>" width="562"  bgcolor="#ffffff" style="background: #ffffff;line-height: 0; font-size: 1px; "><img src="http://www.contentupdate.net<%=p%>img/layout/breaker.gif" width="5" height="8" alt="*" /></td>
            </tr>
        </table>
        </td>
        <td bgcolor="#ffffff" style="background: #ffffff;" width="19"></td>
    </tr>
</table>
    </FooterTemplate>
</CU:CUObjectSet >
<% end if %>