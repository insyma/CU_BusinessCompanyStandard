<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
dim p as string = ""
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    Dim RefObj As New ContentUpdate.Obj
    RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
    RefObj.IsMail = CUPage.IsMail
    Nav.name = RefObj.Containers("conlinkliste").id
    '##### dynamischer Pfad like "<%=p%>"
    p = CUPage.Web.TemplatePath
End Sub
</script>
<%  If TemplateView = "text" Then%>
<%=vbcrlf%>
----------------------------------------------------------------------
<%=CUPage.Properties("subject").Value%>
----------------------------------------------------------------------
<CU:CUField Name="title" runat="server" PlainText="true" />
<CU:CUField Name="ausgabe" runat="server" PlainText="true" />
<%else %>
<table align="center" border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="width:647px; max-width:647px; mso-table-lspace:0pt; mso-table-rspace:0pt;" align="left" bgcolor="#FFFFFF" valign="top"><table border="0" cellpadding="0" cellspacing="0">
        <tbody>
        </tbody>
      </table></td>
    </tr>
  </tbody>
</table>
<table border="0" align="center" cellpadding="0" cellspacing="0">
      
        <tr>
          <td style="width:15px; max-width:15px;" bgcolor="#161E15">&nbsp;</td>
          <td class="text" align="left" style="width:308px; max-width:308px; font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#82BB25;" bgcolor="#161E15" height="29"><CU:CUField name="Thema" runat="server" /></td>
          <td height="29" bgcolor="#161E15" class="text" style="width:309px; max-width:309px; font-family:Tahoma, Geneva, sans-serif; font-size:10px; color:#82BB25; text-align:right;"><table border="0" align="right" cellpadding="0" cellspacing="0">
            <tr>
              <td class="text" align="right" style="font-family:Tahoma, Geneva, sans-serif; font-size:11px; color:#82BB25; width:147px;"><img src="http://www.contentupdate.net<%=p%>img/layout/resize.gif" width="14" height="10" style="display:inline;" /> <CU:CUMailLink MailLinkType="MailLink" CssStyle="color: #82BB25; text-decoration: none;" Target="_blank" Link="true" runat="server"><CU:CUField name="open-in-browser" runat="server" CSSStyle="font-family:Tahoma, Arial, Helvetica, sans-serif; color:#82BB25; text-decoration:none;" class="text" /></CU:CUMailLink></td>
            </tr>
          </table></td>
          <td style="width:15px; max-width:15px;" bgcolor="#161E15">&nbsp;</td>
        </tr>
      
    </table>
    <table align="center" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="91" valign="top" background="http://www.contentupdate.net<%=p%>img/headerbilder/cuimgpath/<%=container.images("header-image").processedfilename%>" bgcolor="#333333" style="width:647px; max-width:647px; font-family:Tahoma, Geneva, sans-serif; font-size:17px; color:#FFFFFF;">
<!--[if gte mso 9]>
<v:image xmlns:v="urn:schemas-microsoft-com:vml" id="image" style="behavior: url(#default#VML); display:inline-block; position:absolute; height:91px; width:647px; top:0; left:0; border:0; z-index:1;" src="http://www.contentupdate.net<%=p%>img/layout/top-banner.gif" />
<v:shape xmlns:v="urn:schemas-microsoft-com:vml" id="text" style="behavior: url(#default#VML); display:inline-block; position:absolute; height:91px; width:647px; top:0; left:0; border:0; z-index:2;">
<![endif]-->
<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
    <td style="width:632px; max-width:632px; font-family:Tahoma, Geneva, sans-serif; font-size:19px; color:#FFFFFF;">&nbsp;</td>
  </tr>
  <tr>
    <td width="15">&nbsp;</td>
    <td align="left" style="width:632px; max-width:632px; font-family:Tahoma, Geneva, sans-serif; font-size:19px; color:#FFFFFF; line-height:21px;">
                        
                            <CU:CULink name="header-title" runat="server" CSSStyle="color:#FFFFFF; text-decoration:none;" /><br />
							<span style="font-size:15px;"><CU:CULink name="header-subtitle" runat="server" CSSStyle="font-size:15px; color:#FFFFFF; text-decoration:none;" /></span>
                       
    </td>
  </tr>
</table>
<!--[if gte mso 9]>
</v:shape>
<![endif]-->
</td>
      </tr>
    </table>
    <table border="0" align="center" cellpadding="0" cellspacing="0">
      
        <tr>
          <td style="width:15px; max-width:15px;" bgcolor="#82BB25">&nbsp;</td>
          <td height="29" align="left" bgcolor="#82BB25" class="text" style="width:617px; max-width:617px; font-family:Tahoma, Geneva, sans-serif; font-size:13px; color:#FFFFFF;"><CU:CUField name="ausgabe" runat="server" /></td>
          <td style="width:15px; max-width:15px;" bgcolor="#82BB25">&nbsp;</td>
        </tr>
    </table>
    <table border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="29" align="center" bgcolor="#FFFFFF" style="width:647px; max-width:647px; min-height:47px; font-family:Tahoma, Geneva, sans-serif; font-size:13px; color:#82BB25; border-bottom:1px solid #CCCCCC;">
<CU:CUContainer name="" id="nav" runat="server">
    <CU:CUObjectset name="culist" runat="server">
        <itemtemplate>
        <a href="<CU:CUField name='url' runat='server' />" title="<CU:CUField name='desc' runat='server' />" class="emailmobbutton" style="font-family:Tahoma, Geneva, sans-serif; font-size:13px; text-decoration:none; color:#82BB25;"><CU:CUField name="desc" runat="server" /></a> <span class="emailnomob">&nbsp;&nbsp;|&nbsp;&nbsp;</span>
        </itemtemplate>
    </CU:CUObjectset>
</CU:CUContainer>
    </td>
  </tr>
</table>
<table align="center" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td bgcolor="#FFFFFF" style="width:647px; max-width:647px; border-bottom:1px solid #CCCCCC;"><table border="0" align="left" cellpadding="0" cellspacing="0">
          <tr>
            <td width="15" bgcolor="#FFFFFF">&nbsp;</td>
            <td width="308"><span style="mso-table-lspace:0;mso-table-rspace:0;"><a href="<%=container.links("logo-link").properties("value").value%>" title="<%=container.links("logo-link").properties("Description").value%>" target='_blank'><img src='http://www.contentupdate.net<%=p%>img/logo/cuimgpath/<%=container.images("logo-img").processedfilename%>' alt="insyma" width="308" height="66" border="0" style="display:block; font-family:Arial, Helvetica, sans-serif; font-size:17px; text-align:center; line-height:21px; height:auto;" /></a></span></td>
          </tr>
        </table>
          <table border="0" align="left" cellpadding="0" cellspacing="0" width="320">
            <tr>
              <td height="94" class="left" style="mso-table-lspace:0pt; mso-table-rspace:0pt; border:none; font-family:Arial, Helvetica, sans-serif; font-size:17px; color:#82BB25; text-align:left; word-break:break-all; width:310px; max-width:310px;"><span style="mso-table-lspace:0;mso-table-rspace:0;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Particulars]</span></td>
            </tr>
          </table></td>
      </tr>
    </table>
    <%End If%>