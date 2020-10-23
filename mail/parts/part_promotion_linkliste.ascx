<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>

<% 'Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->


<script runat="server">
    Dim variantWidth = 300
    Dim conCount As Integer = 0
    Dim CC as Integer = 0
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        if Container.fields("title").value = "" then
            fullContent.visible = false
        end if        
        For Each con As ContentUpdate.Container In Container.parent.containers 
            if con.fields("title").value <> "" then
                CC = CC + 1
            end if
        next
        For Each con As ContentUpdate.Container In Container.ParentObjects(1).Containers
            if con.Fields(1).value <> "" then
                conCount += 1
                if lcase(con.objname).contains("download") then
                    ConCount -= 1
                end if
                If con.Id = Container.Id Then
                    Exit For
                End If
            end if
        Next
        ContentMenuAnchor.Text = "<a title=""news_" & conCount & """ name=""news_" & conCount & """  id=""news_" & conCount & """></a>"
    End Sub
    
    Sub BindItem(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim file As Literal = CType(e.Item.FindControl("file"), Literal)
            
            if con.files("part_promotion_linkliste_file").filename <> "" then
                if con.files("part_promotion_linkliste_file").properties("Legend").value <> "" then
                    file.text = "<a style='"& F_Link &" color:"& C_Promo_LinkList_Link &";' href=""" & getPath() & con.files("part_promotion_linkliste_file").Src & """ target='_blank' title=""" & con.files("part_promotion_linkliste_file").filename & """>" & con.files("part_promotion_linkliste_file").properties("Legend").value & "</a>"
                else
                    file.text = "<a style='"& F_Link &" color:"& C_Promo_LinkList_Link &";' href=""" & getPath() & con.files("part_promotion_linkliste_file").Src & """ target='_blank' title=""" & con.files("part_promotion_linkliste_file").filename & """>" & con.files("part_promotion_linkliste_file").filename & "</a>"
                end if
            end if
            
        End If
    End Sub
    Sub BindItemRechts(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            Dim file As Literal = CType(e.Item.FindControl("file"), Literal)
            
            if con.files("part_promotion_linkliste_r_file").filename <> "" then
                if con.files("part_promotion_linkliste_r_file").properties("Legend").value <> "" then
                    file.text = "<a style='"& F_Link &" color:"& C_Promo_LinkList_Link &";' href=""" & getPath() & con.files("part_promotion_linkliste_r_file").Src & """ target='_blank' title=""" & con.files("part_promotion_linkliste_r_file").filename & """>" & con.files("part_promotion_linkliste_r_file").properties("Legend").value & "</a>"
                else
                    file.text = "<a style='"& F_Link &" color:"& C_Promo_LinkList_Link &";' href=""" & getPath() & con.files("part_promotion_linkliste_r_file").Src & """ target='_blank' title=""" & con.files("part_promotion_linkliste_r_file").filename & """>" & con.files("part_promotion_linkliste_r_file").filename & "</a>"
                end if
            end if
            
        End If
    End Sub

</script>
<%  If TemplateView = "text" Then%><%=vbcrlf%>
-----------------------------------------------------------------
<CU:CUField Name="title" runat="server" PlainText="true" /><%=vbcrlf%>-----------------------------------------------------------------
<CU:CUObjectSet name="part_promotion_linkliste_culist" runat="server" ><ItemTemplate>
<CU:CUField name="part_promotion_linkliste_text" runat="server" PlainText="true"  />
<CU:CULink name="part_promotion_linkliste_link" runat="server" Property="value" PlainText="true"  />
<CU:CUFile name="part_promotion_linkliste_file" runat="server" PlainText="true"  /></ItemTemplate></CU:CUObjectSet><%=vbcrlf%>
-----------------------------------------------------------------
<CU:CUField Name="part_promotion_linkliste_right_title" runat="server" PlainText="true" /><%=vbcrlf%>-----------------------------------------------------------------
<CU:CUObjectSet name="part_promotion_linkliste_r_culist" runat="server" ><ItemTemplate>
<CU:CUField name="part_promotion_linkliste_r_text" runat="server" PlainText="true"  />
<CU:CULink name="part_promotion_linkliste_r_link" runat="server"  Property="value" PlainText="true"  />
<CU:CUFile name="part_promotion_linkliste_r_file" runat="server"  PlainText="true"  /></ItemTemplate></CU:CUObjectSet>
<%else %>

<asp:panel runat="server" id="fullContent">
<!-- TextBody -->
<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="<%=C_Promo_LinkList_BG%>" style="background-color: <%=C_Promo_LinkList_BG%>; border-bottom: 1px solid <%=C_Promo_LinkList_Border%>; width:100%;">
    <tr>
        <td>
            
            <!-- Holder -->
            <table align="center" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="640" style="width:640px; max-width:640px;">
                        <table border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                                <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                                <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                            </tr>
                            <tr>
                                <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                                <td width="600" style="width:600px; max-width:600px;">
                                    <table align="left" border="0" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                        <tr>
                                            <td valign="top" width="290" style=" max-width: 290px; width: 290px; <%=F_Text %> color:<%=C_Promo_LinkList_Text%>;">
                                                <!-- Title -->
                                                <table border="0" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                                    <tr>
                                                        <td style="<%=F_Title%> color:<%=C_Promo_LinkList_Title%>;">
                                                            <asp:Literal ID="ContentMenuAnchor" runat="server" />
                                                            <CU:CUField name="title" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                                    </tr>
                                                </table>
                                                <!-- Link -->
                                                <CU:CUObjectSet name="part_promotion_linkliste_culist" runat="server" OnItemDataBound="BindItem">
                                                    <headertemplate>
                                                        <table border="0" cellpadding="0" cellspacing="0"> 
                                                    </headertemplate>
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td width="20" style="<%=F_Link%> color:<%=C_Promo_LinkList_Link%>;">&gt;</td>
                                                            <td  style="<%=F_Link%> color:<%=C_Promo_LinkList_Link%>;">
                                                                <CU:CULink name="part_promotion_linkliste_link" runat="server" cssStyle="<%#FC_Promo_LinkList_Link%>" />
                                                                <asp:literal runat='server' id='file' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="20" style="<%=F_Link%> color:<%=C_Promo_LinkList_Link%>;"></td>
                                                            <td  style="<%=F_Text%> color:<%=C_Promo_LinkList_Text%>;">
                                                                <CU:CUField name="part_promotion_linkliste_text" runat="server" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" height="5" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                                                        </tr>
                                                   </ItemTemplate>
                                                   <footertemplate>
                                                        </table> 
                                                    </footertemplate>
                                               </CU:CUObjectSet> 
                                            </td>
                                            <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                                        </tr>
                                    </table>

                                    <table class="fullWidth" align="left" border="0" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                        <tr>
                                            <td class="hideMobile" width="20" style="line-height: 0; font-size: 1px;"><img width="20" height="1" src="<%=getPath("layout") %>breaker.gif" border="0"   alt="*" /></td>
                                            <td valign="top" style='<%=F_Text %>  max-width: 260px; width: 260px;'>
                                                <!-- Title -->
                                                <table border="0" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                                    <tr>
                                                        <td style="<%=F_Title%> color:<%=C_Promo_LinkList_Title%>;">
                                                            <CU:CUField name="part_promotion_linkliste_right_title" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
                                                    </tr>
                                                </table>
                                                <!-- Link -->
                                                <CU:CUObjectSet name="part_promotion_linkliste_r_culist" runat="server" OnItemDataBound="BindItemRechts">
                                                    <headertemplate>
                                                        <table border="0" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt; mso-table-rspace:0pt;"> 
                                                    </headertemplate>
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td width="20" style="<%=F_Link%> color:<%=C_Promo_LinkList_Link%>;">&gt;</td>
                                                            <td  style="<%=F_Link%> color:<%=C_Promo_LinkList_Link%>;">
                                                                <CU:CULink name="part_promotion_linkliste_r_link" runat="server" cssStyle="<%#FC_Promo_LinkList_Link%>" />
                                                                <asp:literal runat='server' id='file' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="20" style="<%=F_Link%> color:<%=C_Promo_LinkList_Link%>;"></td>
                                                            <td  style="<%=F_Text%> color:<%=C_Promo_LinkList_Text%>;">
                                                                <CU:CUField name="part_promotion_linkliste_r_text" runat="server" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" height="5" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
                                                        </tr>
                                                   </ItemTemplate>
                                                    <footertemplate>
                                                        </table> 
                                                    </footertemplate>
                                               </CU:CUObjectSet>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                            </tr>
                            <tr>
                                <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                                <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                                <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                            </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
                                
</asp:panel>
<%end if %>