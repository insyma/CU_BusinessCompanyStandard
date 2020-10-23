<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage"  %>
<%@ Register TagPrefix="Control" TagName="HiddenInfo" Src="../../parts/responsive/control_HiddenInfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="footer" Src="../../parts/responsive/control_Footer.ascx" %>
<script runat="server">
    Dim RefObj As New ContentUpdate.Obj

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        '' Laden der ReferenzObjektID, welche auf dem NL-Objekt hinterlegt ist
        '' diese ID verweist auf die Seite mit den Einstellungen für diesen NL
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        RefObj.IsMail = CUPage.IsMail
        '' Zuweisen der entsprechenden ContainerIDs(welche in der Eigenschafts-Seite angelegt sind)
        HiddenInfo.Container = RefObj.Containers("HiddenInfo")
		    footer.Container = RefObj.Containers("Footer")
        HiddenInfo.Container.LanguageCode = CUPage.LanguageCode
		    footer.Container.LanguageCode = CUPage.LanguageCode
        if CUPage.Preview = true
          ' In Preview nicht notwendig'
          HiddenInfo.visible = false
        end if
    End Sub
</script>
<Control:HiddenInfo ID="HiddenInfo" runat="server" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns:v="urn:schemas-microsoft-com:vml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<title>insyma AG</title>
<style type="text/css">
body {
  width: 100% !important;
  margin: 0;
  padding: 0;
  background-color:#E4E4E4;
  border-collapse:collapse;
  -webkit-font-smoothing: antialiased;
  -webkit-text-size-adjust:none;
  -ms-text-size-adjust:none;
}
.ReadMsgBody {
  width: 100%;
}
*+html body > table > tbody > td > tr > table {
  width: 647px;
}

.ExternalClass {
  width: 100%;
}

table td {
  border-collapse:collapse !important;
}
#wrapper {
  height: 100% !important;
  margin: 0;
  padding: 0;
  width: 100% !important;
}
a {
  color: #82BB25;
}
a:link {
  color: #82BB25;
}
a:visited {
  color: #82BB25;
}
a:hover {
  color: #82BB25;
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

@media only screen and (min-width:500px) {
  [class=hide_500]{
    display:none !important;
  }
  [class=wide150px] {
  width: !important;}
}
@media only screen and (max-width:500px) {
 [class=hide_647] {
 display:none !important;
}
td[class=left]{
 text-align:left !important;}
 {float:none !important;}
 table[class=left]{
 text-align:left !important;
 float:none !important;
 margin-left:auto !important;
 margin-right:auto !important;
 }
}
@media only screen and (max-width:747px) {
  [class=text]{
    font-size:15px !important;
    line-height:22px !important;
  }
  [class=textlhdefault]{
    font-size:15px !important;
	line-height:17px !important;
  }
  [class=wide100] {
  width: 100% !important;
  float: inherit !important;
  }
div, p, a, li, td { -webkit-text-size-adjust:none; }
    td[class=emailcolsplit]{width:100%!important; float:left!important;}
    img[class=emailnomob]{display:none !important;}
    table[class=emailnomob]{ margin-left:auto !important; margin-right:auto !important; width:100% !important; text-align:center !important;}
	table[class=w100]{width:100% !important; margin-left:auto !important; margin-right:auto !important;}
    td[class=emailnomob]{display:none !important; text-align:center !important;}
	td[class=center]{text-align:center !important; margin-left:auto !important; margin-right:auto !important;}
    span[class=emailnomob]{display:none !important;}
	img[class=emailnomob]{display:none !important;}
     a[class=emailmobbutton]{display:block !important;font-size:15px !important; padding:6px 4px 8px 4px !important; margin:20px 0 !important; line-height: 18px !important; background:#82BB25 !important; border-radius:3px !important; width:74%; text-align:center; color:#FFFFFF !important; text-decoration: none; text-shadow:#435928 1px 0 0 ; text-align:center;}
    }
</style>
</head>
    <body style="padding:0; margin:0; -webkit-text-size-adjust:none;-ms-text-size-adjust:100%; background-color:#E4E4E4;">
<CU:CULibrary runat="server" id="CULibrary" />

                    
<!--start email info-->                        
                         
<!--end email info-->                            
                            
<!-- start header-->                                    
                        <CU:CUPlaceholder ID="header" runat="server" />                
<!--end header-->                            
                           
<!--start introduction-->                           
						<CU:CUPlaceholder ID="introduction" runat="server" />
<!--end introduction-->
                
<!--start single column article-->                           
                    <CU:CUPlaceholder ID="content" runat="server" cssclass="inhalt" />           
<!--end single column article-->                        
<!--start img left/right article-->                     

<!--start img left/right articl-->                       
 <!--start four column article-->                   
                  
<!--end four column article-->                            
<!--start footer-->                           
                <Control:footer id="footer" runat="server" />              
 <!--end footer-->                       
</div>
<CUForward><CU:CUMailLink ID="CUMailLink2" MailLinkType="LogImage" runat="server" Width="1" Height="1" /></CUForward> 
</body>
</html>