<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Dim RefObj As New ContentUpdate.Obj
    Dim ConCount As Integer = 0
    dim p as string = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))    
    		Container.LanguageCode = CUPage.LanguageCode
    		Container.Preview = CUPage.Preview
        '##### dynamischer Pfad like "/CU_BusinessCompanyStandard/mail/"
        p = CUPage.Web.TemplatePath

    End Sub
</script>
<%  If TemplateView = "text" Then%>
<%  If Not Container.Fields("title").Value = "" Then%><%=vbcrlf%><CU:CUField Name="title" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("intro").Value = "" Then%><CU:CUField Name="intro" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("title-left").Value = "" Then%><%=vbcrlf%><CU:CUField Name="title-left" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Links("link-left").Properties("value").value = "" Then%><CU:CULink Name="link-left" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("features-title-left").Value = "" Then%><CU:CUField Name="features-title-left" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("features-left").Value = "" Then%><CU:CUField Name="features-left" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("title-right").Value = "" Then%><%=vbcrlf%><CU:CUField Name="title-right" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Links("link-right").Properties("value").value = "" Then%><CU:CULink Name="link-right" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("features-title-right").Value = "" Then%><CU:CUField Name="features-title-right" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("features-right").Value = "" Then%><CU:CUField Name="features-right" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%=vbcrlf%><%else %>
<table align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF" style="width:617px; max-width:617px; width:617px; max-width:617px; font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#333333;">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <tr>
    <td width="15" bgcolor="#FFFFFF">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF" style="width:617px; max-width:617px; width:617px; max-width:617px; font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#333333;"><span style="mso-table-lspace:0;mso-table-rspace:0;"><span style="font-size:17px; color:#81BA25;"><CU:CUField name="title" runat="server" /><br /><br />
</span><CU:CUField name="intro" runat="server" /><br />
&nbsp;<br />
      </span>
      <table border="0" align="left" cellpadding="0" cellspacing="0">
        <tr>
          <td width="15" bgcolor="#F4F4F4" style="border-left:1px solid #CCCCCC; border-top:1px solid #CCCCCC;">&nbsp;</td>
          <td width="269" align="center" valign="top" bgcolor="#F4F4F4" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#333333; border-top:1px solid #CCCCCC;"><span style="mso-table-lspace:0;mso-table-rspace:0;"><br />
            <strong><CU:CUField name="title-left" runat="server" /></strong><br />
            <CU:CULink name="url"><img src='http://www.contentupdate.net<%=p%>img/CUimgpath/<%=container.images("image-left").processedfilename%>' alt="insyma" width="234" border="0" style="display:block; font-family:Arial, Helvetica, sans-serif; font-size:17px; text-align:center; line-height:21px;" /></CU:CULink><br />
            <img src="http://www.contentupdate.net<%=p%>img/layout/arr-green-on-white.gif" width="7" height="7" style="display:inline;" alt="" />&nbsp;<CU:CULink name="link-left" runat="server" CSSStyle="color:#81BA25;" /></span></td>
          <td width="15" bgcolor="#F4F4F4" style="border-right:1px solid #CCCCCC; border-top:1px solid #CCCCCC;">&nbsp;</td>
          <td class="hide_647" width="14" bgcolor="#FFFFFF" style="border-right:1px solid #FFFFFF;">&nbsp;</td>
        </tr>
        <tr>
          <td bgcolor="#F4F4F4" style="border-left:1px solid #CCCCCC;">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#F4F4F4" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#333333;">&nbsp;</td>
          <td bgcolor="#F4F4F4" style="border-right:1px solid #CCCCCC;">&nbsp;</td>
          <td bgcolor="#FFFFFF" style="border-right:1px solid #FFFFFF;">&nbsp;</td>
        </tr>
        <tr>
          <td width="15" bgcolor="#FFFFFF" style="border-left:1px solid #CCCCCC; border-bottom:1px solid #CCCCCC;">&nbsp;</td>
          <td width="269" align="left" valign="top" bgcolor="#FFFFFF" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:15px; color:#333333; border-bottom:1px solid #CCCCCC;"><span style="mso-table-lspace:0;mso-table-rspace:0;"><span style="font-size:15px; color:#81BA25;"><br />
            <strong><CU:CUField name="features-title-left" runat="server" /></strong></span><br />
            <br />
            <CU:CUField name="features-left" runat="server" /><br />
&nbsp;<br />
          </span></td>
          <td width="15" bgcolor="#FFFFFF" style="border-right:1px solid #CCCCCC; border-bottom:1px solid #CCCCCC;">&nbsp;</td>
          <td width="14" bgcolor="#FFFFFF" style="border-right:1px solid #FFFFFF; border-bottom:1px solid #FFFFFF;">&nbsp;</td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF">&nbsp;</td>
          <td bgcolor="#FFFFFF">&nbsp;</td>
          <td bgcolor="#FFFFFF">&nbsp;</td>
          <td bgcolor="#FFFFFF">&nbsp;</td>
        </tr>
      </table>
      <table border="0" align="left" cellpadding="0" cellspacing="0">
        <tr>
          <td width="15" bgcolor="#F4F4F4" style="border-left:1px solid #CCCCCC; border-top:1px solid #CCCCCC;">&nbsp;</td>
          <td width="269" align="center" valign="top" bgcolor="#F4F4F4" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#333333; border-top:1px solid #CCCCCC;"><span style="mso-table-lspace:0;mso-table-rspace:0;"><br />
            <strong><CU:CUField name="title-right" runat="server" /></strong><br />
            <img src='http://www.contentupdate.net<%=p%>img/CUimgpath/<%=container.images("image-right").processedfilename%>' alt="insyma" width="234" border="0" style="display:block; font-family:Arial, Helvetica, sans-serif; font-size:17px; text-align:center; line-height:21px;" /><br />
            <img src="http://www.contentupdate.net<%=p%>img/layout/arr-green-on-white.gif" width="7" height="7" style="display:inline;" alt="" />&nbsp;<CU:CULink name="link-right" runat="server" CSSStyle="color:#81BA25;" /></span></td>
          <td width="15" bgcolor="#F4F4F4" style="border-right:1px solid #CCCCCC; border-top:1px solid #CCCCCC;">&nbsp;</td>
        </tr>
        <tr>
          <td bgcolor="#F4F4F4" style="border-left:1px solid #CCCCCC;">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#F4F4F4" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#333333;">&nbsp;</td>
          <td bgcolor="#F4F4F4" style="border-right:1px solid #CCCCCC;">&nbsp;</td>
        </tr>
        <tr>
          <td width="15" bgcolor="#FFFFFF" style="border-left:1px solid #CCCCCC; border-bottom:1px solid #CCCCCC;">&nbsp;</td>
          <td width="269" align="left" valign="top" bgcolor="#FFFFFF" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:15px; color:#333333; border-bottom:1px solid #CCCCCC;"><span style="mso-table-lspace:0;mso-table-rspace:0;"><span style="font-size:15px; color:#81BA25;"><br />
            <strong><CU:CUField name="features-title-right" runat="server" /></strong></span><br />
            <br />
            <CU:CUField name="features-right" runat="server" /><br />
&nbsp;<br />

          </span></td>
          <td width="15" bgcolor="#FFFFFF" style="border-right:1px solid #CCCCCC; border-bottom:1px solid #CCCCCC;">&nbsp;</td>
        </tr>
      </table>
      <span style="mso-table-lspace:0;mso-table-rspace:0;"> </span></td>
    <td width="15" bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF" style="width:617px; max-width:617px; width:617px; max-width:617px; font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#333333;">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
</table>
<%end if %>
