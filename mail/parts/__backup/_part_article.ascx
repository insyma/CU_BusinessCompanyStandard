<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>

<% ''Include der Helper FUNCTIONS %>
<!--#include file="../helper_functions.ascx" -->
<% ''Include Grundstyle -> Font/Colors %>
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    'Lokale Styles
    Dim borderColor As String = "#f2f2f2"
    
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        Dim RefObj As New ContentUpdate.Obj
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        RefObj.IsMail = CUPage.IsMail
    End Sub
    
    Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
      If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
        Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
        Dim table_imgright As Htmlcontrol = CType(e.Item.FindControl("table_imgright"), Htmlcontrol)
        Dim table_imgleft As Htmlcontrol = CType(e.Item.FindControl("table_imgleft"), Htmlcontrol)
        Dim img_right As Literal = CType(e.Item.FindControl("img_right"), Literal)
        Dim img_left As Literal = CType(e.Item.FindControl("img_left"), Literal)
        Dim img_rightAlt As Literal = CType(e.Item.FindControl("img_rightAlt"), Literal)
        Dim img_leftAlt As Literal = CType(e.Item.FindControl("img_leftAlt"), Literal)

        Dim link As Literal = CType(e.Item.FindControl("link"), Literal)
        Dim dlink As Literal = CType(e.Item.FindControl("dlink"), Literal)
        Dim border As Literal = CType(e.Item.FindControl("border"), Literal)
        Dim txt As Literal = CType(e.Item.FindControl("txt"), Literal)

        Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
        con.LanguageCode = CUPage.LanguageCode
        con.Preview = CUPage.Preview

        Dim Counter = Container.ObjectSets("articlelist").Containers.count
        if e.item.itemindex = 0 then
            border.text = "border-bottom:1px solid #ccc;"
        else if e.item.itemindex > 0 AND e.item.itemindex < (Counter-1) then
            border.text = "border-bottom:1px solid #ccc; border-top:1px solid #fff;"
        else if e.item.itemindex = (Counter-1) then
            border.text = "border-top:1px solid #fff;"
        end if

        if Counter = 1 then
            border.text = ""
        end if

        'wenn kein Bild erfasst: Freigeben des Platzes für Content 
        table_imgright.visible = false
        table_imgleft.visible = false
        if con.images("article-img").filename <> "" then
            if con.fields("imgposition").properties("value").value = "0" then
                table_imgleft.visible = true
            else if con.fields("imgposition").properties("value").value = "1" then
                table_imgright.visible = true
            end if
        end if

        '' Sprungmarken setzen
        formlink.text = "<a name=""art" & e.item.itemindex & """ id=""art" & e.item.itemindex & """></a>"
        '' Bilderdaten setzen(Source und Alternativtexte)
        img_right.text = getImg(con.images("article-img"))
        img_left.text = getImg(con.images("article-img"))
        img_rightAlt.text = con.images("article-img").properties("Legend").value
        img_leftAlt.text = con.images("article-img").properties("Legend").value

        '' wenn Link erfasst: Ausgabe mit vorangestelltem Icon(für beide Varianten)
        if not con.links("article-link").properties("value").value = "" then
            link.text = "<br /><br />"
            link.text += "<a style='"& F_Link &" "& C_Link &"' href=""" & con.links("article-link").properties("value").value & """ title=""" & con.links("article-link").properties("Description").value & """>" & con.links("article-link").properties("Description").value & "</a>"
        end if
        if not con.files("article_doc").filename = "" then
            if con.files("article_doc").properties("filetype").value = "pdf" then
              dlink.text = "<img src='"& getPath("layout") &"new-pdf.png' style=""display:inline;float:left;margin-top:1px;"" alt='*' />&nbsp;"
            else if con.files("article_doc").properties("filetype").value = "doc" OR con.files("article_doc").properties("filetype").value = "docx" then
              dlink.text = "<img src='"& getPath("layout") &"new-word.png' style=""display:inline;float:left;margin-top:1px;"" alt='*' />&nbsp;"
            else
              dlink.text = "<img src='"& getPath("layout") &"new-download.png' style=""display:inline;float:left;margin-top:1px;"" alt='*' />&nbsp;"
            end if
            dlink.text += "<a style='"& F_Link &" "& C_Link &"' href='"& getPath() &"files/" & con.files("article_doc").filename & "' target='_blank' title='" & con.files("article_doc").properties("legend").value & "'>" & con.files("article_doc").properties("legend").value & "</a>"
        end if
        txt.text = getText(con.fields("article-text").value)
        if con.fields("article-title").value = "" then
            e.item.visible = false
        end if
      End If
    End Sub
    Protected Sub TBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
          Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
          Dim link As Literal = CType(e.Item.FindControl("link"), Literal)
          con.LanguageCode = CUPage.LanguageCode
          con.Preview = CUPage.Preview
          con.ismail = true
          if not con.links("article-link").properties("value").value = "" then
            link.text = con.links("article-link").properties("Description").value & " " & con.links("article-link").properties("value").value
          end if
        End If
    End Sub
</script>
<%  If TemplateView = "text" Then%>
<CU:CUObjectSet name="articlelist" runat="server" OnItemDataBound="TBindItem">
<ItemTemplate>
<CU:CUField name="article-title" runat="server" Plaintext="true" /><%=vbcrlf%><CU:CUField name="article-text" runat="server" Plaintext="true" /><%=vbcrlf%><asp:literal id="link" runat="server" /><CU:CUFile name="article_doc" runat="server" Plaintext="true" /><%=vbcrlf%>
-----------------------------------------------------------------
</ItemTemplate>
</CU:CUObjectSet>
<%else %>
<CU:CUObjectSet name="articlelist" runat="server" OnItemDataBound="BindItem">
    <ItemTemplate>
        <table align="center" bgColor="#fff" <%=T_Attr%> style='<asp:literal id="border" runat="server" />'>
            <tr>
                <td colspan="3" width="1" height="40" style="<%=S_Style%>"><%=spacer()%></td>
            </tr>
            <tr>
                <td width="20" height="1" style="<%=S_Style%>"><%=spacer()%></td>
                <td align="left" class="text" valign="top" style="<%=W_Wrap%>">
                    <asp:literal id="formlink" runat="server" />
                    <span style="<%=F_Title%>"><CU:CUField name="article-title" runat="server" /></span>
                    <br />
                    <br />
                    <!-- Image RIGHT -->
                    <table class="fullWidthArticleImage" id="table_imgright" runat="server" border="0" cellpadding="0" align="right"  cellspacing="0">
                        <tr> 
                            <td  class="fullWidthArticleImage" width="20"></td>
                            <td width="236"  class="fullWidthArticleImage">
                                <table  class="fullWidthArticleImage" width="236" bgcolor="<%=borderColor%>" style="border-radius: 4px;" <%=T_Attr %> >
                                    <tr>
                                        <td colspan="3" height="10" style="<%=S_Style%>"><%=spacer()%></td>
                                    </tr>
                                    <tr>
                                        <td width="10" bgcolor="<%=borderColor%>">&nbsp;</td>
                                        <td width="216">
                                            <img src='<asp:literal id="img_right" runat="server" />' width="216" alt='<asp:literal id="img_rightAlt" runat="server" />' style="<%=F_Text%> <%=C_Text%>" />
                                        </td>
                                        <td width="10" bgcolor="<%=borderColor%>">&nbsp;</td>
                                    </tr>
                                     <tr>
                                        <td colspan="3" height="10" style="<%=S_Style%>"><%=spacer()%></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="16" style="<%=S_Style%>"><%=spacer()%></td>
                        </tr>
                    </table>
                    <div style="<%=F_Text%>">
                        <!-- Image LEFT -->
                        <table class="fullWidthArticleImage" id="table_imgleft" runat="server" border="0" cellpadding="0" align="left"  cellspacing="0">
                            <tr> 
                                <td class="fullWidthArticleImage" width="236">
                                    <table class="fullWidthArticleImage" width="236" border="0" cellpadding="0" cellspacing="0" bgcolor="<%=borderColor%>" style="border-radius: 4px;">
                                        <tr>
                                            <td colspan="3" height="10" style="<%=S_Style%>"><%=spacer()%></td>
                                        </tr>
                                        <tr>
                                            <td width="10" bgcolor="<%=borderColor%>">&nbsp;</td>
                                            <td width="216">
                                                <img src='<asp:literal id="img_left" runat="server" />' width="216" alt='<asp:literal id="img_leftAlt" runat="server" />' style="<%=F_Text%> <%=C_Text%>" />
                                            </td>
                                            <td width="10" bgcolor="<%=borderColor%>">&nbsp;</td>
                                        </tr>
                                         <tr>
                                            <td colspan="3" height="10" style="<%=S_Style%>"><%=spacer()%></td>
                                        </tr>
                                    </table>
                                </td>
                                <td class="fullWidthArticleImage" width="20"></td>
                            </tr>
                            <tr>
                                <td colspan="2" height="16" style="<%=S_Style%>"><%=spacer()%></td>
                            </tr>
                        </table>
                        <asp:literal id="txt" runat="server" />
                        <asp:literal id="link" runat="server" />
                        <br /><br />
                        <asp:literal id="dlink" runat="server" />
                    </div>
                    
                </td>
                <td width="20" height="1" style="<%=S_Style%>"><%=spacer()%></td>
            </tr>
            <tr>
                <td colspan="3" width="1" height="40" style="<%=S_Style%>"><%=spacer()%></td>
            </tr>
        </table>
    </ItemTemplate>
</CU:CUObjectSet>
<%end if %>

