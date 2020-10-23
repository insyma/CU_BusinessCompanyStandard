<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage"  %>
<%@ Register TagPrefix="Control" TagName="MailInfo" Src="../parts/control_MailInfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="HiddenInfo" Src="../parts/control_HiddenInfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="Footer" Src="../parts/control_Footer.ascx" %>

<% ''Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    Dim settings As New ContentUpdate.Obj

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        '' Lade ReferenzObjektID aus NL-Objekt, verweist auf die Seite mit den Einstellungen
        settings.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        settings.IsMail = CUPage.IsMail
        
        '' Zuweisen der entsprechenden ContainerIDs(welche in der Eigenschafts-Seite angelegt sind)
        HiddenInfo.Container = settings.Containers("HiddenInfo")
        HiddenInfo.Container.LanguageCode = CUPage.LanguageCode
        Footer.Container = settings.Containers("Footer")
        Footer.Container.LanguageCode = CUPage.LanguageCode
        
        ''HiddenInfo in Vorschau ausblenden
        if CUPage.Preview = true
          HiddenInfo.visible = false
        end if
    End Sub
</script>
<% 'NO HTML info %>
<Control:HiddenInfo ID="HiddenInfo" runat="server" />

<% 'Start HTML %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"
 xmlns:v="urn:schemas-microsoft-com:vml"
 xmlns:o="urn:schemas-microsoft-com:office:office">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <meta name="viewport" content="width=device-width; initial-scale=1.0;" />
        <title><%=CUPage.Properties("subject").Value%></title>
        <style type="text/css">
            /* WindowsPhone FIX */
            @-ms-viewport{width:device-width;}
            
            
            /* Generll style */
            body {
              width: 100% !important;
              margin: 0 !important;
              padding: 0;
              background-color:<%=C_Body_BG%>;
              background-repeat: repeat-x;
              border-collapse:collapse;
              -webkit-font-smoothing: antialiased;
              -webkit-text-size-adjust:none;
              -ms-text-size-adjust:none;
            }
            /* Android Margin FIX */
            div[style*="margin: 16px 0"] { margin:0 !important; }
            
            /* Table */
            table td {
              border-collapse:collapse !important;
            }
            /* Links */
            a {
              color:<%=PrimaryColor%>;
            }
            a:link {
              color:<%=PrimaryColor%>;
            }
            a:visited {
              color:<%=PrimaryColor%>;
            }
            a:hover {
              color:<%=PrimaryHoverColor%> !important;
              text-decoration:underline !important;
            }
            
            a.button:hover {
                color: <%=StandardButtonTextColorHover%> !important;
                background-color: <%=StandardButtonBGColorHover%> !important;
                text-decoration: none !important;
            }
            
            
            
                        
            /* Links - Alternativ color */
            .footer a {
              color:<%=PrimaryFooterColor%>;
            }
            .footer a:link {
              color:<%=PrimaryFooterColor%>;
            }
            .footer a:visited {
              color:<%=PrimaryFooterColor%>;
            }
            .footer a:hover {
              color:<%=PrimaryFooterColor%>;
              text-decoration:underline;
            } 
            /* Images */
            img {
              display: block;
              line-height: 100%;
              outline: none;
              text-decoration: none;
            }
            img[src$=".gif"], img[src$=".png"] {
              image-rendering: -moz-crisp-edges;
              -ms-interpolation-mode: nearest-neighbor;
              image-rendering: -o-crisp-edges;
              image-rendering:-webkit-optimize-contrast;
            }
            img[src$=".jpg"]{
              image-rendering:optimizeQuality;
              -ms-interpolation-mode:bicubic;
            }
            /* Helper */
            .mobileOnly{ max-height: 0px; font-size: 0; overflow: hidden; display: none; text-align: center; }
            .mobileOnlyNoPadding{ max-height: 0px; font-size: 0; overflow: hidden; display: none; text-align: center; }
            /* Media Queries */
            @media only screen and (max-width:747px) {
                [class=mobileText]{
                    font-size:15px !important;
                    line-height:22px !important;
                }
                div, p, a, li, td { -webkit-text-size-adjust:none; }
            }
            @media only screen and (max-width:600px) {
                [class=mobileFullWidthNavig] {
                    width:100% !important;
                }
                [class=mobileFullWidthTable] {
                    width:100% !important;
                    float:none !important;
                }
                [class=mobileFullWidth] {
                    width:auto !important;
                    float:none !important;
                }
                td[class=mobileFullWidth] {
                    max-width: none !important;
                }
                [class=mobileFullWidthAlignLeft] {
                    max-width: none !important;
                    text-align: left !important;
                }
                [class=mobileTextLeft] {
                    text-align: left !important;
                    float: left !important;
                }
                [class=hideMobile] {
                    display: none !important;
                }
                a[class=mobileButton]{display:block !important;font-size:15px !important; padding:6px 4px 8px 4px !important; margin:1px 0 !important; line-height: 18px !important; background:#ffffff !important; text-align:center; color:<%=PrimaryColor%> !important; text-decoration: none;}
                
            }
            @media only screen and (max-width:480px) {
                a[class=button]{ width: auto !important; line-height: 17px !important; padding: 10px 30px !important; }
                .mobileOnly { max-height: none !important; font-size: 10px !important; overflow: visible !important; display: block !important; padding: 10px; border-bottom: 1px solid #666666; text-align:center; text-decoration:none !important; }
                .mobileOnlyNoPadding { max-height: none !important; font-size: 10px !important; overflow: visible !important; display: block !important; border-bottom: 1px solid #666666; text-align:center; text-decoration:none !important; }
            }
            @media only screen and (max-width:320px) {
                [class=mobileLogo] {
                    width: 100% !important;
                }
                [class=fullWidthArticleImage] img, 
                [class=fullWidthArticleImage] {
                    width:100% !important;
                    float:left !important;
                }
                td[class=fullWidthArticleImage] {
                    max-width: none !important;
                }  
            }
        </style>
        <!-- Outlook dpi FIX (zoomed view) -->
        <!--[if gte mso 9]>
            <xml>
              <o:OfficeDocumentSettings>
                <o:AllowPNG/>
                <o:PixelsPerInch>96</o:PixelsPerInch>
             </o:OfficeDocumentSettings>
            </xml>
        <![endif]-->
    </head>
    <body style="padding:0; margin:0; -webkit-text-size-adjust:none; -ms-text-size-adjust:100%; background-color:<%=C_Body_BG%>; background-image: url('<%=getPath("layout") %><%=S_BG_Img_Ol %>');">
        <!--[if gte mso 9]>
            <v:background xmlns:v="urn:schemas-microsoft-com:vml" fill="t">
                <v:fill type="tile" src="<%=getPath("layout") %><%=S_BG_Img_Ol %>" color="<%=C_Body_BG%>"/>
            </v:background>
        <![endif]-->
        <CU:CULibrary runat="server" id="CULibrary" />
        <!-- Header -->
        <CU:CUPlaceholder ID="header" runat="server" />                
        
        <!-- Einleitung -->
        <CU:CUPlaceholder ID="introduction" runat="server" />
        
        <!-- Inhalt -->
        <CU:CUPlaceholder ID="content" runat="server" />           
        
        <!-- Footer -->
        <Control:Footer id="Footer" runat="server" />              
        
        <!-- Spam Info -->
        <Control:MailInfo ID="MailInfo" runat="server" />  
        
        <!-- Log -->
        <CUForward>
            <CU:CUMailLink ID="CUMailLink2" MailLinkType="LogImage" runat="server" Width="1" Height="1" />
        </CUForward> 
    </body>
</html>