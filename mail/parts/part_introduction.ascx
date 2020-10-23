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
        'Repeater für Inhaltsverzeichnis einbinden
        ContentMenu.DataSource = CUPage.Containers("content").Containers
        ContentMenu.DataBind()
        'Repeater für Grüsse einbinden
        greetings.DataSource = Container.Containers("leftcol").ObjectSets("greeting_culist").Containers
        greetings.DataBind()
		
        'Wenn Grüsse erfasst sind, einblenden
		If Container.Containers("leftcol").Fields("regards").Value = "" Then
            TextObj.Visible = False
		else
            TextObj.InnerHtml = getText(Container.Containers("leftcol").Fields("regards").Value, F_Link, F_Text)
        End If
		
        'Einleitung auf volle breite oder halbe breite, je nach Inhaltsverzeichnis status
		if Not Container.Containers("rightcol").Fields("title-content").Value = "" And Not CUPage.Containers("content").Containers.Count = 0 And ShowContentMenu = True Then
            RightWidth.text = "max-width: 270px; width: 270px; "
            RightWidth2.text = "270"
		else
			index.visible = false
            RightWidth.text = "max-width: 600px; width: 600px; "
            RightWidth2.text = "600"
		end if
    End Sub
    'Inhaltsverzeichnis BIND
    Protected Sub BintItem_ContentMenu(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim Con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim ContentMenuAnchor As Literal = CType(e.Item.FindControl("ContentMenuAnchor"), Literal)
			
            If Not Con.Fields("title").Value = "" Then
                ConCount += 1
                ContentMenuAnchor.Text = "<a href=""#news_" & ConCount.ToString & """ style='"& F_Link & ""& C_Link & "' title=""" & Con.Fields("title").Value & """>" & Con.Fields("title").Value & "</a>"
            Else
                e.Item.Visible = False
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
            Dim lastTD As HTMLTableCell = CType(e.Item.FindControl("lastTD"), HTMLTableCell)
            
            align.text = "align='left' "
            if e.item.itemindex > 1 then
                exit sub
            end if
            if e.item.itemindex = 1 then
                lastTD.visible = false
            end if
            If Con.Images("greeting_culist_img").Filename <> "" Then
                greet_img.text = "<img src='"&getImg(Con.Images("greeting_culist_img"))&"' />"
            end if
            If Con.Fields("greeting_culist_text").Value <> "" Then
                greet_text.text = getText(Con.Fields("greeting_culist_text").Value, "", F_Text)
            end if
        End If
    End Sub
</script>
<%  If TemplateView = "text" Then%>
[Particulars]<%=vbcrlf%>
<CU:CUContainer Name="leftcol" runat="server">
<%  If Not Container.Containers("leftcol").Fields("einleitung").Value = "" Then%><CU:CUField name="einleitung" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Containers("leftcol").Fields("regards").Value = "" Then%><%=vbcrlf%><CU:CUField Name="regards" runat="server" PlainText="true" /><%=vbcrlf%><% end if %></CU:CUContainer>
<%else %>

<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="<%=C_Intro_BG%>" style="background-color: <%=C_Intro_BG%>; border-bottom: 1px solid <%=C_Intro_Border%>; width:100%;">
        <tr>
            <td>

<!-- Spacer -->
<table align="center" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="6" style="line-height: 0; font-size: 1px;"><%=spacer(1,6)%></td>
    </tr>
</table>
<!-- Holder -->
<table align="center" bgcolor="<%=C_Intro_BG%>" border="0" cellpadding="0" cellspacing="0"  style='<%=S_BoxShadow%>'>
    <tr>
        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
    </tr>
    <tr>
        <td width="640" style="width:640px; max-width:640px;">
            <!-- Inhaltsverzeichnis -->
            <asp:panel id="index" runat="server">
                <table align="left" border="0" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                    <tr>
                        <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                        <td valign="top" width="270" style=" max-width: 270px; width: 270px; <%=F_Text %>">
                            <CU:CUContainer Name="rightcol" runat="server">
                                 <span style="<%=F_Title %>"><CU:CUField Name="title-content" runat="server" /></span><br /><br />
                            </CU:CUContainer>
                            <asp:Repeater ID="ContentMenu" runat="server" OnItemDataBound="BintItem_ContentMenu">
                                <HeaderTemplate>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td valign="top">
                                            <asp:Literal ID="ContentMenuAnchor" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table><br />
                                </FooterTemplate>
                            </asp:Repeater>
                        </td>
                        <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    </tr>
                    <tr>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                        <td style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    </tr>
                </table>
            </asp:panel>
            <!-- Einleitung -->
            <table align="left" class="mobileFullWidth" border="0" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                <tr>
                    <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    <td class="mobileFullWidth" valign="top" width='<asp:literal runat="server" id="RightWidth2" />' style='<asp:literal runat="server" id="RightWidth" /> <%=F_Text %>'>
                        <CU:CUContainer Name="leftcol" runat="server" visible="false">
                            <span style="<%=F_Title %>"><CU:CUField Name="titel" runat="server" /></span><br /><br />
                        </CU:CUContainer>
                        <span style="<%=F_Title %>"><CUSalutation>[Particulars]</CUSalutation></span><br /><br />
                        <CU:CUContainer Name="leftcol" runat="server">
                            <% If Not Container.Containers("leftcol").Fields("einleitung").Value = "" Then%>
                                <%=getText(Container.Containers("leftcol").Fields("einleitung").Value, "", F_Text) %><br /><br/>
                            <%end if%>                                  
                          <span id="TextObj" runat="server"></span>
                        </CU:CUContainer>


                        <CU:CUObjectSet Name="" runat="server" id="greetings" OnItemDataBound="BindItem_Greetings">
                            <headertemplate>
                                <table border="0" cellpadding="0" cellspacing="0" >
                                    <tr>
                                        <td height="15" style="line-height: 0; font-size: 1px;"><%=spacer(15,1)%></td>
                                    </tr>
                                    <tr>
                                        <td width="260" style="width:260px; max-width:260px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                            </headertemplate>
                            <ItemTemplate>
                                <table <asp:literal runat="server" id="align" /> border="0" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                    <tr>
                                        <td style="<%=F_Text%> width:105px; max-width:125px; mso-table-lspace:0pt; mso-table-rspace:0pt;">
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

                    </td>
                    <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                </tr>
                <tr>
                    <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    <td style="line-height: 0; font-size: 1px;"><%=spacer(1,1)%></td>
                    <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                </tr>
            </table>

        </td>
    </tr>
    <tr>
        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
    </tr>
</table>
<!-- Spacer -->
<table align="center" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="6" style="line-height: 0; font-size: 1px;"><%=spacer(1,6)%></td>
    </tr>
</table>

        </td>
    </tr>
</table>
<%end if %>