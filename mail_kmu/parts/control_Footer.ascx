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
        RefObj.LanguageCode = CUPage.LanguageCode
        
        'Holen der ListenID der Navighationslinks
        navilist.name = RefObj.Containers("Navigation").objectsets("CUList").id
        content0.name = RefObj.Containers("Footer").id
    End Sub
    Sub NavigationList_ItemDataBound(ByVal Sender As Object, ByVal e As RepeaterItemEventArgs)
            Dim i As Integer = e.Item.ItemIndex
            If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
                Dim entry As ContentUpdate.Container
                entry = CType(e.Item.DataItem, ContentUpdate.Container)
                entry.LanguageCode = Cupage.LanguageCode
                Dim link As HtmlAnchor
                link = CType(e.Item.FindControl("NavigationLink"), HtmlAnchor)

                link.Style.Add("color", C_SubFooter_Link)
                link.Style.Add("text-decoration", "none")
                
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
                        & "<img src='"& getImg(con.images("social-logo")) & "' alt='' border=""0"" style=""display:inline;"" />" _
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
                formlink.text = "<a style='" & F_Footer_Link & " " & C_Footer_Link & "' href='" & con.Fields("footeraddress_infos_link").value & "' target='_blank'>" _
                                & con.Fields("footeraddress_infos_value").value _
                                & "</a>"
            else
                if con.Fields("footeraddress_infos_link").value <> "" then
                    formlink.text = "<a style='" & F_Footer_Link & " " & C_Footer_Link & "' href='" & con.Fields("footeraddress_infos_link").value & "' target='_blank'>" _
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
------------------------------------------------------------------
------------------------------------------------------------------
<CU:CUField name="social-title" runat="server" Plaintext="true" />
<CU:CUObjectSet name="social-logos" runat="server" >
<ItemTemplate>
- <CU:CULink name="social-link" runat="server" Plaintext="true" />
</ItemTemplate>
</CU:CUObjectSet>

<CU:CUField name="footeraddresstitle" runat="server" Plaintext="true" />
<CU:CUField name="footeraddress" runat="server" Plaintext="true" />
<%  For Each cuentry As ContentUpdate.Container In Container.ObjectSets("footeraddress_infos").Containers%>
    <%if not cuentry.Fields("footeraddress_infos_label").Value = "" then %><%=vbcrlf%><%=cuentry.Fields("footeraddress_infos_label").Plaintext %> : <%end if %>
    <%if not cuentry.Fields("footeraddress_infos_value").Value = "" then %><%=cuentry.Fields("footeraddress_infos_value").Plaintext %><%end if %>
    <%If Not cuentry.Fields("footeraddress_infos_link").Value = "" Then%><%=vbcrlf%><%=cuentry.Fields("footeraddress_infos_link").Plaintext %><%end if %>
<%next %>
<%=vbcrlf%><%=vbcrlf%>
<CU:CUObjectSet name="32773" runat="server" OnItemDataBound="TextNavigationList_ItemDataBound">
<ItemTemplate>
<asp:Literal ID="TextNaviLabel" runat="server"></asp:Literal>
<asp:Literal ID="TextNaviLink" runat="server"></asp:Literal>
</ItemTemplate></CU:CUObjectSet>

<% Else %>
<CU:CUContainer name="" id="content0" runat="server">
    <table class="footer" align="center" border="0" bgcolor="<%=C_Footer_Background%>" cellpadding="0" cellspacing="0">
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
                <table class="mobileFullWidth" align="left" width="298" style="border:1px solid <%=C_Footer_Background%>" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td bgcolor="<%=C_Footer_Background%>" style="<%=F_Footer_Text%> <%=C_Footer_Text%>">
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
                        <td bgcolor="<%=C_Footer_Background%>" height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                    <tr>
                </table>
            </td>
            <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
        </tr>
    </table> 
    <!-- Spacer -->
    <table align="center" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td height="6" style="line-height: 0; font-size: 1px;"><%=spacer(1,6)%></td>
        </tr>
    </table>
    <table align="center" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
            <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
            <td height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
        </tr>
        <tr>
            <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
            <td width="600" style="width:600px; max-width:600px; <%=F_SubFooter_Text%> <%=C_SubFooter_Text%>">    
                <!-- Title -->
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="<%=F_SubFooter_Title%> <%=C_SubFooter_Title%>">
                            <%= RefObj.Containers("Policy").Fields("HTMLDisclaimerTitle").value %>
                        </td>
                    </tr>
                    <tr>
                        <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                    </tr>
                </table>
                
                <%= RefObj.Containers("Policy").Fields("HTMLDisclaimerText").value %>
                
                <% if RefObj.Containers("Policy").Fields("HTMLDisclaimerURL").value <> "" then %>
                    <a style="<%=F_SubFooter_Link%>" href='<%= RefObj.Containers("Policy").Fields("HTMLDisclaimerURL").value %><CU:CUField name="HTMLDisclaimerURL" runat="server" />' target="_blank"><%= RefObj.Containers("Policy").Fields("HTMLDisclaimerLinkLabel").value %></a>
                <% end if %>
                
                <!-- Spacer -->
                <table align="center" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td height="6" style="line-height: 0; font-size: 1px;"><%=spacer(1,6)%></td>
                    </tr>
                </table>
                
                <CU:CUObjectSet id="navilist" name="" runat="server" OnItemDataBound="NavigationList_ItemDataBound">
                    <ItemTemplate>
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                            </tr>
                            <tr>
                                <td width="600" style="width:600px; max-width:600px; mso-table-lspace:0pt; mso-table-rspace:0pt; <%=F_Standard_Link%> <%=C_Standard_Link%>">
                                    <asp:Literal ID="ForwardBegin" runat="server"></asp:Literal>
                                        <a href="" id="NavigationLink" runat="server" target="_blank" class="mobileButton"></a>
                                    <asp:Literal ID="ForwardEnd" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td height="10" style="<%=S_Standard_Link_Border%> line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                            </tr>
                        </table>
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
</CU:CUContainer>
<% End If %>
