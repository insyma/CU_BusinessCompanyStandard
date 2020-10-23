<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
	Dim CUList as ContentUpdate.ObjectSet
    Dim CUMail As New ContentUpdate.Mail()
    Dim count As Integer = 1

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        CUList = New ContentUpdate.ObjectSet()
        CUList = Container.ObjectSets(1)
        CUMail.Load(CUPage.Id)
		dim c as new contentupdate.container()
		c.load(26596)
		c.LanguageCode = CUPage.LanguageCode
		c.Preview = CUPage.Preview
        addressText.Text = c.Fields("Adresse").Value.Replace("<a ", "<a style='text-decoration: none; color: #FFFFFF' ")

		dim c1 as new contentupdate.container()
		c1.load(11892)
		c1.LanguageCode = CUPage.LanguageCode
		c1.Preview = CUPage.Preview
        policyText.Text = c1.Fields("HTMLDisclaimerTitle").Value & "<br/>" & c1.Fields("HTMLDisclaimerText").Value.Replace("<a ", "<a style='text-decoration: none; color: #FFFFFF' ")

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
            
            Select Case entry.Fields("Type").Properties("Value").Value
                Case "0"
                    link.HRef = entry.Fields("URL").Plaintext
                    forwardbegin.Visible = False
                    forwardend.Visible = False
                Case "1"
                    link.HRef = CUMail.NLProfileLink.Replace("&","&amp;")
                Case "2"
                    link.HRef = CUMail.NLUnsubscribeLink.Replace("&","&amp;")
                Case "3"
                    link.HRef = CUMail.NLRecommendationLink.Replace("&","&amp;")
            End Select
            link.Target = "_blank"
            link.InnerHtml = entry.Fields("Labelling").Value
			link.Attributes.Add("style","color: #FFFFFF;text-decoration:none;")
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
</ItemTemplate></CU:CUObjectSet>
<% Else %>
    <table align="center" border="0" cellpadding="0" cellspacing="0">
                      <tbody><tr>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt; border-top:1px solid #C10E1F;" align="left" bgcolor="#333333" valign="top">&nbsp;</td>
                        <td style="width:592px; max-width:592px; mso-table-lspace:0pt; mso-table-rspace:0pt; border-top:1px solid #C10E1F;" align="left" bgcolor="#333333">&nbsp;</td>
                        <td style="width:15px; max-width:15px;mso-table-lspace:0pt; mso-table-rspace:0pt; border-top:1px solid #C10E1F;" align="left" bgcolor="#333333" valign="top">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#333333" valign="top">&nbsp;</td>
                        <td style="width:592px; max-width:592px; mso-table-lspace:0pt; mso-table-rspace:0pt; font-family:Tahoma, Geneva, sans-serif; font-size:13px; color:#FFFFFF;" align="left" bgcolor="#333333" height="74" valign="bottom">
                            		   <CU:CUObjectSet ID="NavigationList" runat="server" OnItemDataBound="NavigationList_ItemDataBound">
    <HeaderTemplate>
        </HeaderTemplate>
        <ItemTemplate>
            <asp:Literal ID="ForwardBegin" runat="server"></asp:Literal>
                <a href="" id="NavigationLink" runat="server" target="_blank"></a> &nbsp;&nbsp;
            <asp:Literal ID="ForwardEnd" runat="server"></asp:Literal>
        </ItemTemplate>
        <FooterTemplate>
    </FooterTemplate>
</CU:CUObjectSet ><br />
<br />
                                        <span style="font-size:11px;"><asp:Literal ID="addressText" runat="server" /><br /><br />
                            		    <asp:Literal ID="policyText" runat="server" /><br /><br /></span>
                                        
                                        
        
</td>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#333333" valign="top">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#333333" valign="top">&nbsp;</td>
                        <td style="width:592px; max-width:592px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#333333" valign="top">&nbsp;</td>
                        <td style="width:15px; max-width:15px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#333333" valign="top">&nbsp;</td>
                      </tr>
                    </tbody></table>
  
  
<% End If %>
