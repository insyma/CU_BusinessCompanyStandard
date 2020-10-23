<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>

<% 'Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    Dim RefObj As New ContentUpdate.Obj
    Dim ShowContentMenu As Boolean = False
    Dim ConCount As Integer = 0
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        
        'Wenn min. Content-Title erfasst ist, Inhaltsverzeichnis anzeigen
        For Each field As ContentUpdate.Obj In CUPage.Containers("content").GetChildObjects(CUClass.Field)
            If field.ObjName = "title" Then
                If Not field.Properties("Value").Value = "" Then
                    ShowContentMenu = True
                    Exit For
                End If
            End If
        Next
        'Repeater f�r Inhaltsverzeichnis einbinden
        ContentMenu.DataSource = CUPage.Containers("content").Containers
        ContentMenu.DataBind()
        'Repeater f�r Gr�sse einbinden
        greetings.DataSource = Container.Containers("leftcol").ObjectSets("greeting_culist").Containers
        greetings.DataBind()
		
        'Wenn Gr�sse erfasst sind, einblenden
        If Container.Containers("leftcol").Fields("regards").Value = "" Then
            TextObj.Visible = False
        Else
            TextObj.InnerHtml = getText(Container.Containers("leftcol").Fields("regards").Value, F_Intro_Link, F_Intro_Text)
        End If
		
        If Not Container.Containers("rightcol").Fields("title-content").Value = "" And Not CUPage.Containers("content").Containers.Count = 0 And ShowContentMenu = True Then
        Else
            index.Visible = False
        End If
        If Container.Containers("leftcol").Fields("show_content").Value = "1" Then
            editorial.Visible = False
        End If
        If Container.Containers("rightcol").Fields("show_content").Value = "1" Then
            index.Visible = False
        End If
    End Sub
    'Inhaltsverzeichnis BIND
    Protected Sub BintItem_ContentMenu(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim Con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ContentMenuAnchor As Literal = CType(e.Item.FindControl("ContentMenuAnchor"), Literal)
            Dim conTitle As String
            Dim spaceHeight As integer = 3
            
                        
            If Not Con.Fields("show_content").Value = "1" Then
                ConCount += 1
                If Con.Fields(2).ObjName.Contains("title") Then
                    If Not Con.Fields(2).Value = "" Then
                        conTitle = Con.Fields(2).Value
                    End If
                End If
                ContentMenuAnchor.Text = "<tr><td valign=""top"">"
                ContentMenuAnchor.Text &= "<a href=""#news_" & ConCount.ToString & """ style='" & F_Index_Link & "" & C_Index_Link & "' title=""" & Con.Fields("title").Value & """>" & conTitle & "</a>"
                ContentMenuAnchor.Text &= "</td></tr>"
                
                '2 Box Part special
                If Con.Fields("box2_titel").Value <> "" then
                    conTitle = Con.Fields("box2_titel").Value
                    ContentMenuAnchor.Text &= "<tr><td colspan=""3"" height="""& spaceHeight &""" style=""line-height: 0; font-size: 1px;"">" & spacer(1,5) & "</td></tr>"
                    ContentMenuAnchor.Text &= "<tr><td valign=""top"">"
                    ContentMenuAnchor.Text &= "<a href=""#news_" & ConCount.ToString & """ style='" & F_Index_Link & "" & C_Index_Link & "' title=""" & Con.Fields("title").Value & """>" & conTitle & "</a>"
                    ContentMenuAnchor.Text &= "</td></tr>"
                end if
                        
            Else
                e.Item.Visible = False
            End If
            If CUPage.Containers("content").Containers.Count - 1 = e.Item.ItemIndex Then
            else
                ContentMenuAnchor.Text &= "<tr><td colspan=""3"" height="""& spaceHeight &""" style=""line-height: 0; font-size: 1px;"">" & spacer(1,5) & "</td></tr>"
            End If
            
        End If
    End Sub
    'Unterschriften BIND
    Sub BindItem_Greetings(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim greet_img As Literal = CType(e.Item.FindControl("greet_img"), Literal)
            Dim greet_text As Literal = CType(e.Item.FindControl("greet_text"), Literal)
            Dim align As Literal = CType(e.Item.FindControl("align"), Literal)
            Dim lastTD As HtmlTableCell = CType(e.Item.FindControl("lastTD"), HtmlTableCell)
            
            align.Text = "align='left' "
            If e.Item.ItemIndex > 1 Then
                Exit Sub
            End If
            If e.Item.ItemIndex = 1 Then
                lastTD.Visible = False
            End If
            If con.Images("greeting_culist_img").FileName <> "" Then
                greet_img.Text = "<img src='" & getImg(con.Images("greeting_culist_img")) & "' />"
            End If
            If con.Fields("greeting_culist_text").Value <> "" Then
                greet_text.Text = getText(con.Fields("greeting_culist_text").Value, "", F_Intro_Text)
            End If
        End If
    End Sub
    Sub BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ListAnchor As Literal = CType(e.Item.FindControl("ListAnchor"), Literal)
                     
            If Not con.Fields("desc").Properties("Value").Value = "" Then
                If Not con.Fields("url").Value = "" Then
                    ListAnchor.Text = "<a href=""" & con.Fields("url").Value & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & "</a>"
                    If e.Item.ItemIndex = 0 Then
                        imgLinkFromList_start.Text = "<a href=""" & con.Fields("url").Value & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Fields("desc").Value & """>"
                        imgLinkFromList_end.Text = "</a>"
                    End If
                End If
                If Not con.Files("file").FileName = "" Then
                    ListAnchor.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Fields("desc").Value & """>" & con.Fields("desc").Value & " / " & con.Files("file").Properties("FileType").Value & " " & con.Files("file").Properties("size").Value & "KB</a>"
                    If e.Item.ItemIndex = 0 Then
                        imgLinkFromList_start.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Fields("desc").Value & """>"
                        imgLinkFromList_end.Text = "</a>"
                    End If
                End If
            Else
                If Not con.Files("file").FileName = "" Then
                    ListAnchor.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Files("file").Properties("legend").Value & """>" & con.Files("file").Properties("legend").Value & " / " & con.Files("file").Properties("FileType").Value & " " & con.Files("file").Properties("size").Value & "KB</a>"
                    If e.Item.ItemIndex = 0 Then
                        imgLinkFromList_start.Text = "<a href=""" & getPath() & con.Files("file").Src & """ target='_blank' style='text-decoration:none;" & F_Standard_Link & "" & C_Standard_Link & "' title=""" & con.Fields("desc").Value & """>"
                        imgLinkFromList_end.Text = "</a>"
                    End If
                End If
            End If
            
            
            
        End If
    End Sub
</script>
<%  If TemplateView = "text" Then%>
[Particulars]

<CU:CUContainer Name="leftcol" runat="server">
<% If Not Container.Containers("leftcol").Fields("einleitung").Value = "" Then%><CU:CUField name="einleitung" runat="server" PlainText="true" /><%=vbcrlf%><% End If%>
<% If Not Container.Containers("leftcol").Fields("text").Value = "" Then%><%=vbcrlf%><CU:CUField Name="text" runat="server" PlainText="true" /><%=vbcrlf%><% End If%>
<% If Not Container.Containers("leftcol").Fields("regards").Value = "" Then%><%=vbcrlf%><CU:CUField Name="regards" runat="server" PlainText="true" /><%=vbcrlf%><% End If%></CU:CUContainer>
<% For Each cuentry As ContentUpdate.Container In Container.Containers("leftcol").ObjectSets("greeting_culist").Containers%>
    <%If Not cuentry.Fields("greeting_culist_text").Value = "" Then%>
        <%=cuentry.Fields("greeting_culist_text").Plaintext %>
    <%End If%>
<%Next%>
<%  For Each cuentry As ContentUpdate.Container In Container.Containers("leftcol").ObjectSets("intro_culist").Containers%><%If Not cuentry.Fields("desc").Value = "" Then%>
<%=vbcrlf%><%=cuentry.Fields("desc").Plaintext %><%If Not cuentry.Fields("url").Value = "" Then%><%=vbcrlf%><%=cuentry.Fields("url").Plaintext %><%End If%>
<%If Not cuentry.Files("file").FileName = "" Then%><%=vbcrlf%><%=getPath("file")%><%=cuentry.Files("file").Filename%> [<%=cuentry.Files("file").Properties("FileType").Value%> | <%=cuentry.Files("file").Properties("Size").Value%> KB]<%End If%><%Else%><%If Not cuentry.Files("file").FileName = "" Then%>
<%=vbcrlf%><%=cuentry.Files("file").Properties("Legend").Value%> <%=vbcrlf%><%=getPath("file")%><%=cuentry.Files("file").Filename%> [<%=cuentry.Files("file").Properties("FileType").Value%> | <%=cuentry.Files("file").Properties("Size").Value%> KB]<%=vbcrlf%><%End If%><%End If%>
<%Next%>
<%Else%>

<!-- Einleitung -->
<asp:panel id="editorial" runat="server">
    <table align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="<%=C_Intro_Background%>" style="<%=S_Intro_Border%>">
        <tr>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
            <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
        </tr>
        <tr>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
            <td valign="top" width="600" style=" max-width: 600px; width: 600px; <%=F_Intro_Text %> <%=C_Intro_Text %>">
                <CU:CUContainer Name="leftcol" runat="server" visible="false">
                    <span style="<%=F_Intro_Title %> <%=C_Intro_Title %>"><CU:CUField Name="titel" runat="server" /></span><br /><br />
                </CU:CUContainer>

                <span style="<%=F_Intro_Title %> <%=C_Intro_Title %> "><CUSalutation>[Particulars]</CUSalutation></span><br /><br />
                <% If Container.Containers("leftcol").Images("intro_bild").FileName <> "" Then%>
                    <table class="mobileFullWidth" align='right' cellpadding="0" cellspacing="0" style="border:1px solid <%=C_Intro_Background%>; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                        <tr>
                            <td runat="server" id="ImageAlignLeftMargin" class="hideMobile" width="15" style="line-height: 0; font-size: 1px;"><%=spacer(15,1)%></td>
                            <td bgcolor="<%=C_Intro_Background%>" width="172" style="width:172px; max-width:172px; text-align: left; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                <span style="mso-table-lspace:0pt; mso-table-rspace:0pt; margin: 0;">
                                    <asp:literal runat="server" id="imgLinkFromList_start" />
                                    <img class="moibleBlockImage" src="<%=getImg(Container.Containers("leftcol").Images("intro_bild"))%>" width="172" alt="*" border="0" style="display:inline;" />
                                    <asp:literal runat="server" id="imgLinkFromList_end" />
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,15)%></td>
                        </tr>
                    </table>
                <% End If%>
                <CU:CUContainer Name="leftcol" runat="server">
                    <% If Not Container.Containers("leftcol").Fields("einleitung").Value = "" Then%>
                        <%=getText(Container.Containers("leftcol").Fields("einleitung").Value, (F_Intro_Link & C_Intro_Link), (F_Intro_Text & C_Intro_Text)) %><br /><br/>
                    <%End If%>                                  
                  <span id="TextObj" runat="server"></span>
                <CU:CUObjectSet Name="" runat="server" id="greetings" OnItemDataBound="BindItem_Greetings">
                    <headertemplate>
                        <table border="0" cellpadding="0" cellspacing="0" >
                            <tr>
                                <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(15,1)%></td>
                            </tr>
                            <tr>
                                <td width="578" style="width:578px; max-width:578px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                    </headertemplate>
                    <ItemTemplate>
                        <table <asp:literal runat="server" id="align" /> border="0" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                            <tr>
                                <td style="<%=F_Intro_Text%> width:128px; max-width:128px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                    <asp:literal runat="server" id="greet_img" /><br/>
                                    <asp:literal runat="server" id="greet_text" />
                                </td>
                                <td width="20" id="lastTD" runat="server" style="line-height: 0; font-size: 1px; mso-table-lspace:0pt; mso-table-rspace:0pt;"><%=spacer(20,1)%></td>
                            </tr>
                        </table>
                    </ItemTemplate>
                    <footertemplate>
                                </td>
                            </tr>
                        </table>
                    </footertemplate>
                </CU:CUObjectSet>

                <CU:CUObjectSet Name="intro_culist" runat="server" OnItemDataBound="BindItem">
                    <headertemplate>
                        <table align="center" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                            </tr>
                        </table>
                    </headertemplate>
                    <ItemTemplate>
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                            </tr>
                            <tr>
                                <td width="600" style="width:600px; max-width:600px; mso-table-lspace:0pt; mso-table-rspace:0pt; <%=F_Standard_Link%> <%=C_Standard_Link%>"><asp:Literal ID="ListAnchor" runat="server" /> </td>
                            </tr>
                            <tr>
                                <td height="10" style="<%=S_Standard_Link_Border%> line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </CU:CUObjectSet>
                </CU:CUContainer>

            </td>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
        </tr>
        <tr>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
            <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
        </tr>
    </table>
    <!-- Spacer -->
    <table align="center" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td height="<%=space%>" style="line-height: 0; font-size: 1px;"><%=spacer(1,space)%></td>
        </tr>
    </table>
</asp:panel>  

<!-- Inhaltsverzeichnis -->
<asp:panel id="index" runat="server">
    <table align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="<%=C_Index_Background%>" style="<%=S_Index_Border%>">
        <tr>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
            <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
        </tr>
        <tr>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
            <td valign="top" width="598" style=" max-width: 598px; width: 598px; <%=F_Index_Title%>">
                <CU:CUContainer Name="rightcol" runat="server">
                    <span style="<%=F_Index_Title %> <%=C_Index_Title %>"><CU:CUField Name="title-content" runat="server" /></span><br /><br />
                </CU:CUContainer>
                <asp:Repeater ID="ContentMenu" runat="server" OnItemDataBound="BintItem_ContentMenu">
                    <HeaderTemplate>
                        <table border="0" cellspacing="0" cellpadding="0">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:Literal ID="ContentMenuAnchor" runat="server" />
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </td>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
        </tr>
        <tr>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
            <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
            <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
        </tr>
    </table>

    <!-- Spacer -->
    <table align="center" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(1,15)%></td>
        </tr>
    </table>
</asp:panel>
<%End If%>