<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
dim p as string = ""
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    Dim RefObj As New ContentUpdate.Obj
    RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
    RefObj.IsMail = CUPage.IsMail
    '##### dynamischer Pfad like "/CU_BusinessCompanyStandard/mail/"
    p = CUPage.Web.TemplatePath
End Sub
Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
  If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
    Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
    Dim formlink0 As Literal = CType(e.Item.FindControl("formlink0"), Literal)
    Dim img As Literal = CType(e.Item.FindControl("img"), Literal)
    Dim imgalt As Literal = CType(e.Item.FindControl("imgalt"), Literal)
    Dim img0 As Literal = CType(e.Item.FindControl("img0"), Literal)
    Dim imgalt0 As Literal = CType(e.Item.FindControl("imgalt0"), Literal)
    Dim link As Literal = CType(e.Item.FindControl("link"), Literal)
    Dim dlink As Literal = CType(e.Item.FindControl("dlink"), Literal)
    Dim link0 As Literal = CType(e.Item.FindControl("link0"), Literal)
    Dim dlink0 As Literal = CType(e.Item.FindControl("dlink0"), Literal)
    Dim txt As Literal = CType(e.Item.FindControl("txt"), Literal)
    Dim txt0 As Literal = CType(e.Item.FindControl("txt0"), Literal)
    Dim table1 As Htmlcontrol = CType(e.Item.FindControl("lefttable"), Htmlcontrol)
    Dim table2 As Htmlcontrol = CType(e.Item.FindControl("righttable"), Htmlcontrol)
    Dim table3 As Htmlcontrol = CType(e.Item.FindControl("imgright"), Htmlcontrol)
    Dim table4 As Htmlcontrol = CType(e.Item.FindControl("imgleft"), Htmlcontrol)

    ' 2 Tabellen; je eine für eine Bildausrichtung
    table1.visible = false
    table2.visible = false
    Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
    con.LanguageCode = CUPage.LanguageCode
    con.Preview = CUPage.Preview
    ' Dropdown für Bildposition >> entsprechende Tabelle wird eingeblendet'
    if con.fields("imgposition").properties("value").value = "0" then
        table1.visible = true
    else if con.fields("imgposition").properties("value").value = "1" then
        table2.visible = true
    end if
    '' wenn kein Bild erfasst: Freigeben des Platzes für Content  
	  if con.images("article-img").filename="" then
	   	  table3.visible = false
		    table4.visible = false
	  end if

    '' Sprungmarken setzen(für beide Varianten)
    formlink.text = "<a name=""art" & e.item.itemindex & """ id=""art" & e.item.itemindex & """></a>"
    formlink0.text = "<a name=""art" & e.item.itemindex & """ id=""art" & e.item.itemindex & """></a>"
    '' Bilderdaten setzen(Source und Alternativtexte)
    img.text = con.images("article-img").processedfilename
    imgalt.text = con.images("article-img").properties("Legend").value
    img0.text = con.images("article-img").processedfilename
    imgalt0.text = con.images("article-img").properties("Legend").value

    '' wenn Link erfasst: Ausgabe mit vorangestelltem Icon(für beide Varianten)
    if not con.links("article-link").properties("value").value = "" then
        link.text = "<br /><br />"
		    link.text += "<a href=""" & con.links("article-link").properties("value").value & """ title=""" & con.links("article-link").properties("Description").value & """ style='color:#435928; text-decoration:none;'>" & con.links("article-link").properties("Description").value & "</a>"
        link.text += "<img src=""http://www.contentupdate.net" & p & "img/layout/arr-green-on-white.gif"" width=""10"" height=""8"" style=""display:inline;"" />"
        link0.text = "<a href=""" & con.links("article-link").properties("value").value & """ title=""" & con.links("article-link").properties("Description").value & """ style='color:#435928; text-decoration:none;'>" & con.links("article-link").properties("Description").value & "</a>"
        link0.text += "<img src=""http://www.contentupdate.net" & p & "img/layout/arr-green-on-white.gif"" width=""10"" height=""8"" style=""display:inline;"" />"
    end if
    if not con.files("article_doc").filename = "" then
        if con.files("article_doc").properties("filetype").value = "pdf" then
          dlink.text = "<img style=""display:inline;"" src='http://www.contentupdate.net" & p & "img/layout/ico-pdf.gif' alt='*' />&nbsp;"
          dlink0.text = "<img style=""display:inline;"" src='http://www.contentupdate.net" & p & "img/layout/ico-pdf.gif' alt='*' />&nbsp;"
        else if con.files("article_doc").properties("filetype").value = "doc" OR con.files("article_doc").properties("filetype").value = "docx" then
          dlink.text = "<img style=""display:inline;"" src='http://www.contentupdate.net" & p & "img/layout/ico-word.gif' alt='*' />&nbsp;"
          dlink0.text = "<img style=""display:inline;"" src='http://www.contentupdate.net" & p & "mail/img/layout/ico-word.gif' alt='*' />&nbsp;"
        else
          dlink.text = "<img style=""display:inline;"" src='http://www.contentupdate.net" & p & "img/layout/icon-file.gif' alt='*' />&nbsp;"
          dlink0.text = "<img style=""display:inline;"" src='http://www.contentupdate.net" & p & "img/layout/icon-file.gif' alt='*' />&nbsp;"
        end if
        dlink.text += "<a href='http://www.contentupdate.net" & p & "files/" & con.files("article_doc").filename & "' target='_blank' style='color: #000001; text-decoration: none; font-weight: bold;' title='" & con.files("article_doc").properties("legend").value & "'>" & con.files("article_doc").properties("legend").value & "</a>"
        dlink0.text += "<a href='http://www.contentupdate.net" & p & "files/" & con.files("article_doc").filename & "' target='_blank' style='color: #000001; text-decoration: none; font-weight: bold;' title='" & con.files("article_doc").properties("legend").value & "'>" & con.files("article_doc").properties("legend").value & "</a>"
    end if
    txt.text = con.fields("article-text").value.replace("<ul", "<ul style='list-style-position: inside;'").replace("<ol", "<ol style='list-style-position: inside;'")
    txt0.text = txt.text
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
<table border="0" align="center" cellpadding="0" cellspacing="0" id="righttable" runat="server">
  <tr>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#435928;"><asp:literal id="formlink" runat="server" /></td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <tr>
    <td width="15" bgcolor="#FFFFFF">&nbsp;</td>
    <td align="left" class="text" valign="top" bgcolor="#FFFFFF" style="width:617px; max-width:617px; font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#333333;"><span style="font-size:17px; color:#81BA25;"><CU:CUField name="article-title" runat="server" /></span><br />
      <br />
     
      <table id="imgright" runat="server" width="247" border="0" align="right" cellpadding="0" cellspacing="0" >
        <tr>
          <td width="10">&nbsp;</td>
          <td width="232"><table width="232" border="0" align="left" cellpadding="0" cellspacing="0" style="border:1px solid #CCCCCC;">
            <tr>
              <td><table width="216" border="0" cellspacing="0" cellpadding="0" class="left">
                <tr>
                  <td width="216" style="border:7px solid #FFFFFF;">
                  	<img src='http://www.contentupdate.net<%=p%>img/cuimgpath/<asp:literal id="img" runat="server" />' width="216" alt='<asp:literal id="imgalt" runat="server" />' style="display:block; font-family:Tahoma, Geneva, sans-serif; font-size:15px; color:#435928;" /></td>
                </tr>
              </table></td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td width="10">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
    </table>
    <asp:literal id="txt" runat="server" />
      <asp:literal id="link" runat="server" />
      <br /><br />
      <asp:literal id="dlink" runat="server" />
      </td>
    <td width="15" bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#000007;">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3" height="1" bgcolor="#CCCCCC" style="font-size: 1px; line-height: 1%; mso-line-height-rule: exactly;">&nbsp;</td>
  </tr>
</table>

<!-- links-->
<table border="0" align="center" cellpadding="0" cellspacing="0" id="lefttable" runat="server">
  <tr>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#435928;"><asp:literal id="formlink0" runat="server" /></td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <tr>
    <td width="15" bgcolor="#FFFFFF">&nbsp;</td>
    <td class="text" valign="top" bgcolor="#FFFFFF" style="width:617px; max-width:617px; font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#435928;"><span style="font-size:17px; color:#81BA25;"><CU:CUField name="article-title" runat="server" /></span><br />
      <br />
     
      <table id="imgleft" runat="server" width="247" border="0" align="left" cellpadding="0" cellspacing="0" class="left">
          <tr>
            <td width="232"><table width="232" border="0" align="left" cellpadding="0" cellspacing="0" style="border:1px solid #CCCCCC;">
              <tr>
                <td>
                <table width="216" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="216" style="border:7px solid #FFFFFF;">
                      <img src='http://www.contentupdate.net<%=p%>img/cuimgpath/<asp:literal id="img0" runat="server" />' width="216" alt='<asp:literal id="imgalt0" runat="server" />' style="display:block; font-family:Tahoma, Geneva, sans-serif; font-size:15px; color:#435928;" />
                    </td>
                  </tr>
                </table></td>
              </tr>
            </table></td>
            <td width="10">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
    <asp:literal id="txt0" runat="server" /><br />&nbsp;
      <br />
      <asp:literal id="link0" runat="server" />
      <br /><br />
      <asp:literal id="dlink0" runat="server" />
      </td>
    <td width="15" bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#000007;">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3" height="1" bgcolor="#CCCCCC" style="font-size: 1px; line-height: 1%; mso-line-height-rule: exactly;">&nbsp;</td>
  </tr>
</table>

</ItemTemplate>
			</CU:CUObjectSet>
<%end if %>

