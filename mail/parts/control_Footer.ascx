<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>

<% 'Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    Dim CUMail As New ContentUpdate.Mail()
    Dim count As Integer = 1
    Dim RefObj As New ContentUpdate.Obj
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        'Laden der ReferenzObjektID, welche auf dem NL-Objekt hinterlegt ist, ID verweist auf die Seite mit den Einstellungen
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        RefObj.IsMail = CUPage.IsMail
        
        'Holen der ListenID der Navighationslinks
        navilist.name = RefObj.Containers("Navigation").objectsets("CUList").id
        content0.name = RefObj.Containers("Footer").id
        content1.name = RefObj.Containers("Footer-old").id
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
    Sub SocialMediaBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
            
            formlink.text = "<a href='" & con.links("social-link").properties("value").value & "' target='_blank'>" _
                        & "<img src='"& getImg(con.images("social-logo")) & "' alt='' width=""30"" height=""30"" border=""0"" style=""display:inline;"" />" _
                        & "</a>&nbsp;"
      End If
    End Sub
    Sub AddressLinksBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
            
            if con.Fields("footeraddress_infos_value").value <> "" AND con.Fields("footeraddress_infos_link").value <> "" then
                formlink.text = "<a style='" & F_Footer_Link & "' href='" & con.Fields("footeraddress_infos_link").value & "' target='_blank'>" _
                                & con.Fields("footeraddress_infos_value").value _
                                & "</a>"
            else
                if con.Fields("footeraddress_infos_link").value <> "" then
                    formlink.text = "<a style='" & F_Footer_Link & "' href='" & con.Fields("footeraddress_infos_link").value & "' target='_blank'>" _
                                    & con.Fields("footeraddress_infos_link").value _
                                    & "</a>"
                end if
                if con.Fields("footeraddress_infos_value").value <> "" then
                    formlink.text = con.Fields("footeraddress_infos_value").value
                end if
            end if
            
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
    <table width="100%" bgcolor="<%=C_Footer_BG%>" style="background-color: <%=C_Footer_BG%>; border-top: 1px solid #000000; width:100%;" border="0" cellpadding="0" cellspacing="0" >
        <tr>
            <td>
                <table align="center" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
                        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                        <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
                    </tr>
                    <tr>
                        <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                        <td width="600" style="width:600px; max-width:600px; <%=F_Footer_Text%> <%=C_Footer_Text%>">
                            <!-- Title -->
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="<%=F_Footer_Title%> <%=C_Footer_Title%>">
                                        <CU:CUFIeld name="social-title" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                </tr>
                            </table>

                            <CU:CUFIeld name="social-text" runat="server" />

                            <CU:CUObjectSet name="social-logos" runat="server" OnItemDataBound="SocialMediaBindItem">
                                <headertemplate>
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td colspan="2" height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                        </tr>
                                        <tr>
                                            <td>
                                </headertemplate>
                                <ItemTemplate>
                                    <asp:literal id="formlink" runat="server" />
                                </ItemTemplate>
                                <footertemplate>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                        <tr>
                                    </table>
                                </footertemplate>
                            </CU:CUObjectSet>

                            <!-- Kontakt Table -->
                            <table class="mobileFullWidth" align="left" width="298" style="border:1px solid <%=C_Footer_BG%>" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td bgcolor="<%=C_Footer_BG%>" style="<%=F_Footer_Text%> <%=C_Footer_Text%>">
                                        <span style="mso-table-lspace:0;mso-table-rspace:0;">
                                            <!-- Title -->
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="<%=F_Footer_Title%> <%=C_Footer_Title%>">
                                                        <CU:CUFIeld name="footeraddresstitle" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                                </tr>
                                            </table>

                                            <CU:CUFIeld name="footeraddress" runat="server" />

                                            <CU:CUObjectSet name="footeraddress_infos" runat="server" OnItemDataBound="AddressLinksBindItem">
                                                <headertemplate>
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td colspan="2" height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                                        </tr>
                                                </headertemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td style="<%=F_Footer_Text%> <%=C_Footer_Text%>">
                                                            <CU:CUField name="footeraddress_infos_label" runat="server" />&nbsp;&nbsp;&nbsp;
                                                        </td>
                                                        <td style="<%=F_Footer_Text%> <%=C_Footer_Text%>">
                                                            <asp:literal id="formlink" runat="server" />
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <footertemplate>
                                                    </table>
                                                </footertemplate>
                                            </CU:CUObjectSet>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="<%=C_Footer_BG%>" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                                <tr>
                            </table>
                            <!-- Rechtliche Infos Table -->
                            <table class="mobileFullWidth" align="left" width="298" style="border:1px solid <%=C_Footer_BG%>" border="0" cellpadding="0" cellspacing="0" >
                                <tr>
                                    <td bgcolor="<%=C_Footer_BG%>" style="<%=F_Footer_Text%> <%=C_Footer_Text%>">
                                        <span style="mso-table-lspace:0;mso-table-rspace:0;">
                                            <!-- Title -->
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="<%=F_Footer_Title%> <%=C_Footer_Title%>">
                                                        <CU:CUField name="HTMLDisclaimerTitle" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                                </tr>
                                            </table>
                                            <CU:CUField name="HTMLDisclaimerText" runat="server" />
                                            <% if RefObj.Containers("Policy").Fields("HTMLDisclaimerURL").value <> "" then %>
                                                <a style="<%=F_Footer_Link%>" href='<CU:CUField name="HTMLDisclaimerURL" runat="server" />' target="_blank"><CU:CUField name="HTMLDisclaimerLinkLabel" runat="server" /></a>
                                           <% end if %>
                                           <br />
                                           <br />
                                           <CUForward>
                                               <CU:CUField name="HTMLProfileTitle" runat="server" Tag="strong" /><br />
                                               <CU:CUField name="HTMLProfileText" runat="server" /><br />
                                               <CU:CUMailLink cssStyle="text-decoration:none;" MailLinkType="NLProfileLink" Link="true" Target="_blank" runat="server" ><CU:CUField name="HTMLProfileLinkLabel" runat="server" /></CU:CUMailLink>
                                           </CUForward>  
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="<%=C_Footer_BG%>" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                                </tr>
                            </table>
                        </td>
                        <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    </tr>
                </table> 
            </td>
        </tr>
    </table> 
    <table width="100%" bgcolor="<%=C_Footer_Navig_BG%>" style="background-color: <%=C_Footer_Navig_BG%>; border-top: 1px solid #000000; width:100%;" border="0" cellpadding="0" cellspacing="0" >
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
                        <td width="600" style="width:600px; max-width:600px; <%=F_Footer_Text%> <%=C_Footer_Text%>">    
                            <CU:CUObjectSet id="navilist" name="" runat="server" OnItemDataBound="NavigationList_ItemDataBound">
                                <ItemTemplate>
                                    <asp:Literal ID="ForwardBegin" runat="server"></asp:Literal>
                                        <a href="" id="NavigationLink" runat="server" target="_blank" style="color:#FFFFFF; text-decoration:none;" class="mobileButton"></a><span class="emailnomob">&nbsp;&nbsp;&nbsp;</span>
                                    <asp:Literal ID="ForwardEnd" runat="server"></asp:Literal>
                                </ItemTemplate>
                            </CU:CUObjectSet >
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
</CU:CUContainer>

<%'INSYMA BRANDING if needed 
if INSYMA_BRANDING then
%>
<CU:CUContainer name="" id="content1" runat="server">
    <table width="100%" bgcolor="<%=C_Footer_INSYMA_BG%>" style="background-color: <%=C_Footer_INSYMA_BG%>; border-top: 1px solid #24380A; width:100%;" border="0" cellpadding="0" cellspacing="0" >
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
                        <td width="600" style="width:600px; max-width:600px; <%=F_Footer_Text%> <%=C_Footer_Text%>">
                            <CU:CUField name="HTMLFooter" runat="server" />
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
</CU:CUContainer>
<% End If %>

<% End If %>
