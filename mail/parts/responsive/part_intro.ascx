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
      	maintext.text = Container.fields("text").value.replace("<a", "<a style='color: #cc0000; text-decoration: none'")
        '##### dynamischer Pfad like "/CU_BusinessCompanyStandard/mail/"
        p = CUPage.Web.TemplatePath
    End Sub
</script>
<%  If TemplateView = "text" Then%>
[Particulars]
<CU:CUContainer Name="part_intro" runat="server">
<%  If Not Container.Containers("part_intro").Fields("Title").Value = "" Then%><%=vbcrlf%><CU:CUField Name="Title" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Containers("part_intro").Fields("Text").Value = "" Then%><CU:CUField name="Text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%=vbcrlf%></CU:CUContainer><%else %>
<table align="center" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td bgcolor="#F5F5F5">&nbsp;</td>
        <td align="left" valign="top" bgcolor="#F5F5F5" style="width:617px; max-width:617px; font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#FFFFFF;">&nbsp;</td>
        <td bgcolor="#F5F5F5">&nbsp;</td>
  </tr>
      <tr>
        <td width="15" bgcolor="#F5F5F5">&nbsp;</td>
        <td class="text" align="left" valign="top" bgcolor="#F5F5F5" style="width:617px; max-width:617px; font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#333333;"><span style="mso-table-lspace:0;mso-table-rspace:0;"><span style="font-size:17px; color:#444444;"><CU:CUField name="Title" runat="server" /></span>
        <br />
        <br />
        </span>
          <table class="left" align="left" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="width:293px; max-width:293px;"><span style="mso-table-lspace:0;mso-table-rspace:0;"><img src='http://www.contentupdate.net<%=p%>img/CUimgpath/<%=container.images("Image").processedfilename%>' alt="insyma" width="100%" border="0" style="display:block; font-family:Arial, Helvetica, sans-serif; font-size:17px; text-align:center; line-height:21px;" /></span></td>
              <td width="10">&nbsp;</td>
            </tr>
          </table>
          <span style="mso-table-lspace:0;mso-table-rspace:0;" class="text wide100"><asp:Literal ID="maintext" runat="server" /></span><br />
<br />
<div><!--[if mso]>
  <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="http://insyma.com" style="height:34px;v-text-anchor:middle;width:274px;" arcsize="16%" strokecolor="#82BB25" fill="t">
    <v:fill type="tile" src="http://www.contentupdate.net<%=p%>img/layout/bg-button2.gif" color="#82BB25" />
    <w:anchorlock/>
    <center style="color:#ffffff;font-family:Tahoma, Geneva, sans-serif;font-size:19px;text-shadow:#435928 2px 0 0 ;"><CU:CUField name="button-text" runat="server" /></center>
  </v:roundrect>
<![endif]--><![if !mso]><a href="http://insyma.com/" style="background-color:#82BB25;background-image:url(http://www.contentupdate.net<%=p%>img/layout/bg-button2.gif);border:1px solid #609637;border-radius:7px;color:#ffffff;display:inline-block;font-family:Tahoma, Geneva, sans-serif;font-size:19px;line-height:34px;text-align:center;text-decoration:none;width:274px;-webkit-text-size-adjust:none;text-shadow:#435928 1px 1px 1px ;"><CU:CUField name="button-text" runat="server" /></a><![endif]--></div></td>
        <td width="15" bgcolor="#F5F5F5">&nbsp;</td>
      </tr>
      <tr>
        <td bgcolor="#F5F5F5">&nbsp;</td>
        <td align="left" valign="top" bgcolor="#F5F5F5" style="width:617px; max-width:617px; font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; color:#FFFFFF;">&nbsp;</td>
        <td bgcolor="#F5F5F5">&nbsp;</td>
      </tr>
</table>
<%end if %>
