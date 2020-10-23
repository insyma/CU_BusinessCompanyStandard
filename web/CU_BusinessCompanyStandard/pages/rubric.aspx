<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Register TagPrefix="Control" TagName="footer" Src="../parts/control_footer.ascx" %>
<%@ Register TagPrefix="Control" TagName="navigation" Src="../parts/control_navigation.ascx" %>
<%@ Register TagPrefix="Control" TagName="breadcrumb" Src="../parts/control_breadcrumb.ascx" %>
<%@ Register TagPrefix="Control" TagName="footernavi" Src="../parts/control_footernavi.ascx" %>
<script runat="server" > 
	Sub Page_Load(Src As Object, E As EventArgs)
	    breadcrumb.CUPage=CUPage
	    navigation.CUPage=CUPage
	    footer.CUPage=CUPage
	End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<%=CUPage.MetaTags(CUPage.Caption,false) %>
<link rel="stylesheet" href="../css/screen.css" type="text/css" media="screen" />
<link rel="stylesheet" href="./css/print.css" type="text/css" media="print" />
<link rel="stylesheet" href="../css/parts.css" type="text/css" media="screen,print" />
<script type="text/javascript" src="../js/InsymaUtilities.js"></script>
<script type="text/javascript" src="../js/scripts.js"></script>
</head>
<body>
<a name="top" id="top"></a>
<CU:CULibrary runat="server" id="CULibrary"/>

	<div id="content">
		<Control:navigation id="navigation" runat="server"/>
		<Control:breadcrumb id="breadcrumb" runat="server"/>
		<Control:footernavi id="footernavi" runat="server"/>
		<Control:footer id="footer" runat="server"/>
	</div>
</body>
</html>