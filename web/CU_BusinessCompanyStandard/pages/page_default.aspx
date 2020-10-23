<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<%@ Register TagPrefix="Control" TagName="htmlheader" Src="../parts/control_htmlheader.ascx" %>
<%@ Register TagPrefix="Control" TagName="googleanalytics0" Src="../parts/control_googleanalytics_new0.ascx" %>
<%@ Register TagPrefix="Control" TagName="googleanalytics1" Src="../parts/control_googleanalytics_new1.ascx" %>
<%@ Register TagPrefix="Control" TagName="servicenavigation" Src="../parts/control_servicenavigation.ascx" %>
<%@ Register TagPrefix="Control" TagName="footernavigation" Src="../parts/control_footernavigation.ascx" %>
<%@ Register TagPrefix="Control" TagName="footerInfo" Src="../parts/control_footerInfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="sprache" Src="../parts/control_sprache.ascx" %>
<%@ Register TagPrefix="Control" TagName="suche" Src="../parts/control_suche.ascx" %>
<%@ Register TagPrefix="Control" TagName="headerbild__zentral" Src="../parts/control_headerbild__zentral.ascx" %>
<%@ Register TagPrefix="Control" TagName="headerbild__local" Src="../parts/control_headerbild__local.ascx" %>
<%@ Register TagPrefix="Control" TagName="header" Src="../parts/control_header.ascx" %>
<%@ Register TagPrefix="Control" TagName="headerInfo" Src="../parts/control_headerinfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="SocialMedia" Src="../parts/control_socialmedia.ascx" %>
<%@ Register TagPrefix="Control" TagName="javascripts" Src="../parts/control_javascripts.ascx" %>
<%@ Register TagPrefix="Control" TagName="css" Src="../parts/control_css.ascx" %>
<%@ Register TagPrefix="Control" TagName="navigation" Src="../parts/control_navigation.ascx" %>
<%@ Register TagPrefix="Control" TagName="breadcrumb" Src="../parts/control_breadcrumb.ascx" %>
<%@ Register TagPrefix="Control" TagName="metatags" Src="../parts/control_metatags.ascx" %>
<%@ Register TagPrefix="Control" TagName="Seitentitel" Src="../parts/control_seitentitel.ascx" %>
<%@ Register TagPrefix="Control" TagName="JSend" Src="../parts/control_javascript_end.ascx" %>
<%@ Register TagPrefix="Control" TagName="StrucData" Src="../parts/control_structured_data.ascx" %>
<%@ Register TagPrefix="Control" TagName="cookieinfo" Src="../parts/control_cookieinfo.ascx" %>
<%@ Register TagPrefix="Control" TagName="dataprivacy" Src="../parts/control_dataprivacy_info.ascx" %>
<script runat="server">
	Dim pagepath As String = ""
	Dim currpage As String = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		If CUPage.Arrange = True Then
			javascripts.Visible = False
		End If

		If CUPage.Containers("detail").Containers.count > 0 Then
			inhalt.visible = False
		Else
			detail.visible = False
		End If
		currpage = CUPage.id.toString()
		Dim _tPage As New ContentUpdate.Page()
		_tPage.load(CUPage.Id)
		Do While _tPage.ClassId = 3
			pagepath += _tPage.id & "~"
			_tPage.Load(_tPage.ParentID)
		Loop
		If pagepath.Length > 1 Then
			pagepath = pagepath.Substring(0, pagepath.Length - 1)
		End If
		' Headerbilder
		headerbild__zentral.visible = True
		headerbild__local.visible = False
		' deaktivierte Controls
		
	End Sub
</script>
<Control:htmlheader id="htmlheader" runat="server" />
<Control:metatags id="metatags" runat="server" />
<Control:css id="css" runat="server" />
<Control:javascripts id="javascripts" runat="server" />

<script type="text/javascript">
    var curent_page_id = "<%=currpage%>";
    var page_path_ids = "<%=pagepath%>";
</script>
<Control:googleanalytics0 id="googleanalytics0" runat="server" />
</head>
<body class="page page-default pid-<%=currpage%>" data-curr-page="<%=currpage%>">
    <Control:googleanalytics1 id="googleanalytics1" runat="server" />
    <Control:cookieinfo id="cookieinfo" runat="server" />
    <Control:dataprivacy id="dataprivacy" runat="server" />
    <div id="root">
        <cu:culibrary runat="server" id="CULibrary" showlayoutselection="true" />
        <header class="con-header clearfix">
            <div class="holder">
                <Control:header id="header" runat="server" />
                <Control:servicenavigation id="servicenavigation" runat="server" />
                <Control:suche id="suche" runat="server" />
                <Control:sprache id="sprache" runat="server" />
                <Control:headerInfo id="headerInfo" runat="server" />
                <Control:SocialMedia id="SocialMedia" runat="server" />
            </div>
            <div class="holder">
                <Control:navigation id="navigation" runat="server" />
            </div>
			<div class="con-header-image">
                <Control:headerbild__zentral id="headerbild__zentral" runat="server" />
                <Control:headerbild__local id="headerbild__local" runat="server" />
			</div>

        </header>
        <div id="wrapper" class="con-wrapper clearfix">
            <div class="holder">
                <Control:breadcrumb id="breadcrumb" runat="server" />
            </div>
			<div class="holder con-inhalt">
                <main>
                    <cu:cuplaceholder id="inhalt" runat="server" class="inhalt">
                        <Control:Seitentitel id="Seitentitel" runat="server" />
		                
                    </cu:cuplaceholder>
                    <cu:cuplaceholder id="detail" runat="server" class="inhalt detail"></cu:cuplaceholder>
                </main>
            </div>
        </div>
        <footer class="con-footer clearfix">
            <div class="holder">
                <Control:footernavigation id="footernavigation" runat="server" />
                <Control:footerInfo id="footerInfo" runat="server" />
            </div>
        </footer>
    </div>
    <Control:JSend id="JSend" runat="server" />
    <Control:StrucData id="StrucData" runat="server" />

    <!-- Size indikators for JS -->
    <span id="size-indikator-tablet" style="display:none;"></span>
    <span id="size-indikator-mobile" style="display:none;"></span>
</body>
</html>