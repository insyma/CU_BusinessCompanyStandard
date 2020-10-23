<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage"  %>
<%@ Register TagPrefix="Control" TagName="MailInfo" Src="../../parts/fullWidth/control_MailInfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="HiddenInfo" Src="../../parts/fullWidth/control_HiddenInfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="navigation" Src="../../parts/fullWidth/control_Navigation.ascx" %>
<%@ Register TagPrefix="Control" TagName="topnavigation" Src="../../parts/fullWidth/control_TopNavigation.ascx" %>
<script runat="server">
    Dim RefObj As New ContentUpdate.Obj

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        RefObj.IsMail = CUPage.IsMail
        HiddenInfo.Container = RefObj.Containers("HiddenInfo")
		MailInfo.Container = RefObj.Containers("MailInfo")
        navigation.Container = RefObj.Containers("Navigation")
		topnavigation.Container = RefObj.Containers("conlinkliste")
        HiddenInfo.Container.LanguageCode = CUPage.LanguageCode
        MailInfo.Container.LanguageCode = CUPage.LanguageCode
        navigation.Container.LanguageCode = CUPage.LanguageCode
		topnavigation.Container.LanguageCode = CUPage.LanguageCode
    End Sub
</script>
<Control:HiddenInfo ID="HiddenInfo" runat="server" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<title><%=CUPage.Properties("subject").Value%></title>
    <Encoding />
<link rel="shortcut icon" href="http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/favicon.ico" type="image/x-icon" />
<style type="text/css">
body {
  width: 100% !important;
  margin: 0;
  padding: 0;
  background-color:#ffffff;
  border-collapse:collapse;
  -webkit-font-smoothing: antialiased;
  -webkit-text-size-adjust:none;
  -ms-text-size-adjust:none;
}
.ReadMsgBody {
  width: 100%;
}
.ExternalClass {
  width: 100%;
}

table td {
  border-collapse:collapse;
}
#wrapper {
  height: 100% !important;
  margin: 0;
  padding: 0;
  width: 100% !important;
}
a {
  color: #C10E1F;
}
a:link {
  color: #C10E1F;
}
a:visited {
  color: #C10E1F;
}
a:hover {
  color: #C10E1F;
  text-decoration:underline !important;
}

.grey a {
  color: #808285;
}
.grey a:link {
  color: #808285;
}
.grey a:visited {
  color: #808285;
}
.grey a:hover {
  color: #808285;
  text-decoration:underline !important;
}

.white a {
  color: #ffffff;
}
.white a:link {
  color: #ffffff;
}
.white a:visited {
  color: #ffffff;
}
.white a:hover {
  color: #ffffff;
  text-decoration:underline;
} 

img {
  display: block;
  line-height: 100%;
  outline: none;
  text-decoration: none;
}
/*
img[src$=".gif"], img[src$=".png"] {
  image-rendering: -moz-crisp-edges;
  -ms-interpolation-mode: nearest-neighbor;
  image-rendering: -o-crisp-edges;
  image-rendering:-webkit-optimize-contrast;
}

img[src$=".jpg"]{
  image-rendering:optimizeQuality;
  -ms-interpolation-mode:bicubic;
}*/

@media only screen and (max-width:620px) {
  [class=hide_500]{
    display:none !important;
  }
}
@media only screen and (max-width:400px) {
  [class=text]{
    font-size:14px !important;
    line-height:22px !important;
  }
  [class=soMeButton]{
    margin-left:7px;
    margin-bottom:7px;
    margin-top:7px;
  }
}
</style>
</head>
    <body style="padding:0; margin:0; -webkit-text-size-adjust:none;-ms-text-size-adjust:100%;">
	    <CU:CULibrary runat="server" id="CULibrary" />
        <table id="wrapper" summary="" bgcolor="#ffffff" border="0" cellpadding="0" cellspacing="0" width="100%">
            
                <tbody><tr>
                  <td align="left" valign="top">
<!--start email info-->                        
                         <Control:MailInfo ID="MailInfo" runat="server" />  
<!--end email info-->                            
<!-- start header-->                                    
                        <CU:CUPlaceholder ID="header" runat="server" />                
<!--end header-->                            
<!-- start navigation-->
						<control:topnavigation id="topnavigation" runat="server" />	
<!--end navigation-->                            
<!--start intro-->                           
						<CU:CUPlaceholder ID="introduction" runat="server" />
<!--end intro-->
                    
<!--start single column article-->                           
                    <CU:CUPlaceholder ID="content" runat="server" style="clear:both;background: #ffffff;" cssclass="inhalt" />           
<!--end single column article-->                        
<!--start double column article-->                     
                      
<!--end double column article-->                       
 <!--start four column article-->                   
                     
<!--end four column article-->                            
<!--start footer-->                           
            <control:navigation id="navigation" runat="server" />
 <!--end footer-->                       
                    </td>
                </tr>
            
        </table>
    </body>
</html>