<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Register TagPrefix="Control" TagName="footer" Src="../parts/control_footer.ascx" %>
<%@ Register TagPrefix="Control" TagName="header" Src="../parts/control_header_extranet.ascx" %>
<%@ Register TagPrefix="Control" TagName="javascripts" Src="../parts/control_javascripts.ascx" %>
<%@ Register TagPrefix="Control" TagName="servicenavigation" Src="../parts/control_servicenavigation.ascx" %>
<%@ Register TagPrefix="Control" TagName="breadcrumb" Src="../parts/control_breadcrumb.ascx" %>
<%@ Register TagPrefix="Control" TagName="metatags" Src="../parts/control_metatags.ascx" %>
<%@ Register TagPrefix="Control" TagName="googleanalytics" Src="../parts/control_googleanalytics.ascx" %>
<%@ Register TagPrefix="Control" TagName="Login" Src="../includes/Login.ascx" %>
<%@ Register TagPrefix="Control" TagName="Seitentitel" Src="../parts/control_seitentitel.ascx" %>
<%@ Register TagPrefix="Control" TagName="JSend" Src="../parts/control_javascript_end.ascx" %>
<%@ Register TagPrefix="Control" TagName="htmlheader" Src="../parts/control_htmlheader.ascx" %>
<%@ Register TagPrefix="Control" TagName="css" Src="../parts/control_css.ascx" %>
<%@ Register TagPrefix="Control" TagName="navigation" Src="../parts/control_navigation_extranet.ascx" %>
<%@ Register TagPrefix="Control" TagName="footerInfo" Src="../parts/control_footerInfo.ascx" %>
<script runat="server"> 
DIM _mLogin AS Boolean 
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		
        If CUPage.Arrange = True Then
            javascripts.Visible = False
        End If
        servicenavigation.visible = false
        navigation.visible = false
        
		_mLogin = false
		If CUPage.Preview = True Then
       		'Session.Clear()
			if(Session("CUSessionState") IS NOTHING) then
					Dim clsSessionStateNew As New CUSessionState
					clsSessionStateNew._UserLanguageId = CUPage.LanguageCode
					Session("CUSessionState") = clsSessionStateNew
			end if
			Dim clsSessionState As New CUSessionState
			clsSessionState = CType(Session("CUSessionState"), CUSessionState)
			'response.write(clsSessionState._Login & ":::" & clsSessionState._LoginErrorMessage)
			if(clsSessionState._Login) then
				_mLogin = true
				response.Redirect("default_extranet.aspx?Page_Id=39977&Lang=0&WebId=33933&preview=true&arrange=False", true)
			Else
				if not CUPage.Id = 34061 then
					'Response.Redirect("default_login.aspx?Page_Id=34061&Lang=0&WebId=33933&preview=true&arrange=False", true)
				end if
			End If
        else
			Response.Write("<%@ Page Language=""VB"" %>" & vbCrLf)
			Response.Write("<scr" & "ipt runat=""server"">" & vbCrLf)
			Response.Write("DIM _mLogin AS Boolean" & vbCrLf)
			Response.Write("Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)" & vbCrLf)
			Response.Write("   _mLogin = false" & vbCrLf)
			Response.Write("   if(Session(""CUSessionState"") IS NOTHING) then" & vbCrLf)
			Response.Write("      Dim clsSessionStateNew As New CUSessionState" & vbCrLf)
			Response.Write("      clsSessionStateNew._UserLanguageId = " & CUPage.LanguageCode & vbCrLf) 
			Response.Write("      Session(""CUSessionState"") = clsSessionStateNew" & vbCrLf) 
			Response.Write("   end if" & vbCrLf)
			Response.Write("   Dim clsSessionState As New CUSessionState" & vbCrLf)
			Response.Write("   clsSessionState = CType(Session(""CUSessionState""), CUSessionState)" & vbCrLf)
			Response.Write("   if(clsSessionState._Login) then" & vbCrLf)
			Response.Write("       _mLogin = true" & vbCrLf)
			Response.Write("       Response.Redirect(""startseite_39977.aspx"", true)"  & vbCrLf)
			Response.Write("   end if" & vbCrLf)
			Response.Write("   if not _mLogin = true then" & vbCrLf)
			Response.Write("       'Response.Redirect(""default.aspx"", true)"  & vbCrLf)
			Response.Write("   end if" & vbCrLf)
			Response.Write("   if clsSessionState._LoginErrorMessage.length > 0 then" & vbCrLf)
			Response.Write("   end if" & vbCrLf)
			Response.Write("End Sub" & vbCrLf)
			Response.Write("</scr" & "ipt>" & vbCrLf)
			response.write("<%@ Register TagPrefix=""Control"" TagName=""Login"" Src=""../includes/Login.ascx"" %>")
        end if
		
    End Sub
</script>

<Control:htmlheader id="htmlheader" runat="server" />
<Control:metatags id="metatags" runat="server" />
<Control:css id="css" runat="server" />
<Control:javascripts id="javascripts" runat="server" />

</head>


<body class="page page-extranet page-login">
    <cu:culibrary runat="server" id="CULibrary" showlayoutselection="true" />
    <div id="root">
        <header class="con-header clearfix">
            <div class="holder">
                <Control:header id="header" runat="server" />
                <Control:servicenavigation id="servicenavigation" runat="server" />
            </div>
        </header>

        <div class="con-wrapper clearfix">
            <div class="holder">
                <Control:navigation id="navigation" runat="server" />
            </div>
            <div class="holder">
                <Control:breadcrumb id="breadcrumb" runat="server"/>
            </div>
            <div class="holder con-inhalt">
                <main>
                    <cu:cuplaceholder id="inhalt" runat="server" class="inhalt"><title><asp:literal id="metatitle" runat="server" /> | <CU:CUContainer name="" id="allmeta0" runat="server"><CU:CUField name="websitetitle" runat="server" /></CU:CUContainer></title>
                            <Control:Seitentitel id="Seitentitel" runat="server" />
                        </cu:cuplaceholder>
                    <cu:cuplaceholder id="detail" runat="server" class="inhalt"></cu:cuplaceholder>
                </main>
            </div>
        </div>
        <footer class="con-footer clearfix">
            <div class="holder">
                <Control:footerInfo id="footerInfo" runat="server" />
                <Control:footer id="footer" runat="server" />
            </div>
        </footer>
    </div>
    <Control:JSend id="JSend" runat="server" />

    <!-- Size indikators for JS -->
    <span id="size-indikator-tablet" style="display: none;"></span>
    <span id="size-indikator-mobile" style="display: none;"></span>
</body>

</html>
