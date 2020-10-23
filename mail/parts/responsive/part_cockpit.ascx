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
[Particulars]
<CU:CUContainer Name="part_intro" runat="server">
<%  If Not Container.Containers("part_intro").Fields("Title").Value = "" Then%><%=vbcrlf%><CU:CUField Name="Title" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Containers("part_intro").Fields("Text").Value = "" Then%><CU:CUField name="Text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%=vbcrlf%></CU:CUContainer><%else %>
<table align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="64" bgcolor="#FFFFFF">&nbsp;</td>
    <td align="center" bgcolor="#FFFFFF" style="width:519px; max-width:519px; font-family:Tahoma, Geneva, sans-serif; font-size:17px; line-height:21px; color:#81BA25;">
    <!--Swiss CRM Forum is powered by <span style="color:#333333;">WEBSITE</span>, <span style="color:#333333;">NEWSLETTER</span> and <span style="color:#333333;">CRM</span> modules
      in ContentUpdate Management Cockpit<br />
      <br />-->
      <img src='http://www.contentupdate.net<%=p%>img/CUimgpath/<%=container.images("cockpit-image").processedfilename%>' alt="insyma Management Cockpit" width="100%" border="0" style="display:block; font-family:Arial, Helvetica, sans-serif; font-size:17px; text-align:center; line-height:21px;" /></td>
    <td width="64" bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td align="center" bgcolor="#FFFFFF" style="width:519px; max-width:519px; font-family:Tahoma, Geneva, sans-serif; font-size:17px; line-height:21px; color:#81BA25;">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
</table>
<%end if %>
