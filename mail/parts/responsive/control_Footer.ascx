<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
Dim CUMail As New ContentUpdate.Mail()
Dim count As Integer = 1
dim p as string = ""
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
  Dim RefObj As New ContentUpdate.Obj
    '' Laden der ReferenzObjektID, welche auf dem NL-Objekt hinterlegt ist
    '' diese ID verweist auf die Seite mit den Einstellungen für diesen NL
    RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
    RefObj.IsMail = CUPage.IsMail
    '' Holen der ListenID für die Navighationslinks
    navilist.name = RefObj.Containers("Navigation").objectsets("CUList").id
    content0.name = RefObj.Containers("Footer").id
    content1.name = RefObj.Containers("Footer-old").id
    '##### dynamischer Pfad like "/CU_BusinessCompanyStandard/mail/"
    p = CUPage.Web.TemplatePath
    
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
                    ''selbst eingegebene URL
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
            link.InnerHtml = entry.Fields("Labelling").Value
            link.Attributes.Add("style","color: #FFFFFF;text-decoration:none;")
            count = i+1
        End If
    End Sub
Sub TextNavigationList_ItemDataBound(ByVal Sender As Object, ByVal e As RepeaterItemEventArgs)
        ''selbes wie NavigationList_ItemDataBound nur für Textversion

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
Sub SBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
    If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
    Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
    Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
    con.LanguageCode = CUPage.LanguageCode
    con.Preview = CUPage.Preview
    dim l as string = "<a href='" & con.links("social-link").properties("value").value & "' target='_blank'>" _
                & "<img src='http://www.contentupdate.net" & p & "img/layout/cuimgpath/" & con.images("social-logo").processedfilename & "' alt='' width=""30"" height=""30"" border=""0"" style=""display:inline;"" />" _
                & "</a>&nbsp;&nbsp;"
    formlink.text = l

  End If
End Sub
 
</script>
<% if templateview = "text" then %>
----------------------------------------------------------------------------------------------------
<CU:CUField name="TextFooter" runat="server" PlainText="true" /><%=vbcrlf%>
<CU:CUField name="TextFooter2" runat="server" PlainText="true" /><%=vbcrlf%>
------------------------------------------------------------------

<CU:CUObjectSet name="11875" runat="server" OnItemDataBound="TextNavigationList_ItemDataBound">
<ItemTemplate>
<asp:Literal ID="TextNaviLabel" runat="server"></asp:Literal>
<asp:Literal ID="TextNaviLink" runat="server"></asp:Literal>
</ItemTemplate></CU:CUObjectSet>
<% Else %>
<CU:CUContainer name="" id="content0" runat="server">
<table align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="3" bgcolor="#7AAB2D"><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="1" height="25" style="display:block;" alt="" /></td>
  </tr>
  <tr>
    <td width="15" bgcolor="#2D2D2D">&nbsp;</td>
    <td align="left" valign="top" bgcolor="#2D2D2D" style="width:617px; max-width:617px;"><table class="emailnomob" width="157" border="0" align="left" cellpadding="0" cellspacing="0" style="border-left:1px solid #2D2D2D; border-right:1px solid #2D2D2D;">
      <tr>
        <td><span style="mso-table-lspace:0;mso-table-rspace:0;"><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="1" height="20" style="display:block;" alt="" /></span></td>
        </tr>
      <tr>
        <td class="text" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; color:#CCCCCC; width:147px; max-width:147px;"><span style="font-size:17px; line-height:21px; color:#7AAB2D;">
            <CU:CUFIeld name="footeraddresstitle" runat="server" />
            </span><br />
            <CU:CUFIeld name="footeraddress" runat="server" />
            </span></td>
        </tr>
      <tr>
        <td style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; color:#CCCCCC;">&nbsp;</td>
        </tr>
    </table>
      <table class="emailnomob" border="0" align="right" cellpadding="0" cellspacing="0">
        <tr>
          <td class="emailnomob" align="left" style="width:147px; max-width:147px; font-family:Tahoma, Geneva, sans-serif; font-size:17px; color:#CCCCCC;">&nbsp;</td>
        </tr>
        <tr>
          <td style="width:147px; max-width:147px; font-family:Tahoma, Geneva, sans-serif; font-size:15px; color:#CCCCCC;" class="center">Folgen Sie uns:</td>
        </tr>
        <tr>
          <td style="width:147px; max-width:147px;">&nbsp;</td>
        </tr>
        <tr>
          <td class="center" style="width:147px; max-width:147px;">
            <CU:CUObjectSet name="social-logos" runat="server" OnItemDataBound="SBindItem">
            <ItemTemplate>
              <asp:literal id="formlink" runat="server" />
            </ItemTemplate>
            </CU:CUObjectSet>
          </td>
        </tr>
      </table>
      <table class="emailnomob" border="0" align="right" cellpadding="0" cellspacing="0" style="border-left:1px solid #2D2D2D; border-right:1px solid #2D2D2D;">
        <tr>
          <td style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; color:#CCCCCC;"><span style="mso-table-lspace:0;mso-table-rspace:0;"><img src="http://www.contentupdate.net<%=p%>img/layout/1px.gif" width="1" height="11" class="hide_647" style="display:block;" alt="" /></span></td>
        </tr>
        <tr>
          <td width="447" align="center" style="font-family:Tahoma, Geneva, sans-serif; font-size:12px; color:#CCCCCC;"><span style="mso-table-lspace:0;mso-table-rspace:0;">
          <CU:CUObjectSet id="navilist" name="" runat="server" OnItemDataBound="NavigationList_ItemDataBound">
                    <ItemTemplate>
                        <asp:Literal ID="ForwardBegin" runat="server"></asp:Literal>
                            <span class="emailnomob"><img src="http://www.contentupdate.net<%=p%>img/layout/arr-green.gif" width="8" height="9" border="0" style="display:inline;" class="emailnomob" alt="" />&nbsp;</span><a href="" id="NavigationLink" runat="server" target="_blank" style="color:#FFFFFF; text-decoration:none;" class="emailmobbutton"></a><span class="emailnomob">&nbsp;&nbsp;&nbsp;</span>
                        <asp:Literal ID="ForwardEnd" runat="server"></asp:Literal>
                    </ItemTemplate>
                    <FooterTemplate>
                </FooterTemplate>
            </CU:CUObjectSet ></span></td>
        </tr>
        <tr>
          <td style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; color:#CCCCCC;">&nbsp;</td>
        </tr>
    </table></td>
    <td width="15" bgcolor="#2D2D2D">&nbsp;</td>
  </tr>
  </CU:CUContainer>
  <CU:CUContainer name="" id="content1" runat="server">
  <tr>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF" style="font-family:Arial, Helvetica, sans-serif; font-size:11px; color:#444444; line-height:13px;"><br />
    <CU:CUField name="HTMLFooter" runat="server" />
    </td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  </CU:CUContainer>
</table>
<br />
<br />
<br />

<% End If %>
