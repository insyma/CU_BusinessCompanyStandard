<%@ Page ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" Language="VB"%>
<%@ Register TagPrefix="Control" TagName="footer" Src="../parts/control_footer.ascx" %>
<%@ Register TagPrefix="Control" TagName="header" Src="../parts/control_header.ascx" %>
<%@ Register TagPrefix="Control" TagName="navigation" Src="../parts/control_navigation.ascx" %>
<%@ Register TagPrefix="Control" TagName="breadcrumb" Src="../parts/control_breadcrumb.ascx" %>
<%@ Register TagPrefix="Control" TagName="footernavi" Src="../parts/control_footernavi.ascx" %>
<%@ Register TagPrefix="Control" TagName="googleanalytics" Src="../parts/control_googleanalytics.ascx" %>
<%@ Register TagPrefix="Control" TagName="googleanalyticsInc" Src="../parts/control_googleanalyticsInc.ascx" %>
<script runat="server"> 
    Dim imageConfigPage As New ContentUpdate.Page
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)                        
        breadcrumb.CUPage = CUPage
        navigation.CUPage = CUPage        
        header.CUPage = CUPage
        footer.CUPage = CUPage
        metaTags.Text = CUPage.MetaTags(CUPage.Caption, False)
        imageConfigPage.LoadByName("insymaImage-config")
        imageConfigPage.LanguageCode = CUPage.LanguageCode
        imageConfigPage.Preview = False
        ImageConfig.Text = ".." & imageConfigPage.Properties("path").Value & imageConfigPage.Properties("filename").Value
        If CUPage.Arrange = True Then
            Scripts.Visible = False
        End If
        If CUPage.ObjName = "404" Then
            Response.Write("<%@ Page Language=""VB"" %>" & vbCrLf)
            Response.Write("<scr" & "ipt runat=""server"">" & vbCrLf)
            Response.Write("Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)" & vbCrLf)
            Response.Write("Response.Status = ""404 Not found""" & vbCrLf)
            Response.Write("End Sub" & vbCrLf)
            Response.Write("</scr" & "ipt>" & vbCrLf)
        End If
    End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<asp:Literal id="metaTags" runat="server" />
<link rel="stylesheet" href="../css/screen.css" type="text/css" media="screen" />
<link rel="stylesheet" href="../css/parts.css" type="text/css" media="screen,print" />
<link rel="stylesheet" href="../css/print.css" type="text/css" media="print" />

<script type="text/javascript" src="../js/InsymaUtilities.js"></script>
<script type="text/javascript" src="../js/scripts.js"></script>


<CU:CUContainer Name="Scripts" ID="Scripts" runat="server">
<script type="text/javascript" src="../js/insymaBasic.packed.js"></script>

<script type="text/javascript" src="../js/insymaFormValidation.js"></script>
<script type="text/javascript" src="../js/insymaFormValidation.config.js"></script>

<script src="../js/lib/jquery-1.4.js" type="text/javascript">
</script> 

<script type="text/javascript">
  $.noConflict();
</script>
<script type="text/javascript" src="<asp:Literal id='ImageConfig' runat='server' />"></script>
</CU:CUContainer>

<link rel="stylesheet" href="../css/insymaImage.css" type="text/css" media="all" />

<link rel="shortcut icon" href="../favicon.ico" />
<Control:googleanalyticsInc id="googleanalyticsInc" runat="server"/>
</head>
<body class="page">
<a name="top" id="top"></a>
<CU:CULibrary runat="server" id="CULibrary"/>
<Control:header id="header" runat="server"/>
	<div id="content">
		<Control:navigation id="navigation" runat="server"/>
		<Control:breadcrumb id="breadcrumb" runat="server"/>
		<CU:CUPLACEHOLDER id="inhalt" runat="server" ></CU:CUPLACEHOLDER>
		<Control:footernavi id="footernavi" runat="server"/>
		<Control:footer id="footer" runat="server"/>
	</div>
	
	<Control:googleanalytics id="googleanalytics" runat="server"/>
</body>
</html>





