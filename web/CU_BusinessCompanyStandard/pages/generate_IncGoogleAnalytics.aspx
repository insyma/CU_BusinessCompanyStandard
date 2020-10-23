<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		CUPage.LanguageCode = 0
		Dim googleAnalyticsCon As New ContentUpdate.Container()
		'googleAnalyticsCon.LoadByName("GoogleanalyticsContainer")
		googleAnalyticsCon.Load(CUPage.ParentId)
		googleAnalyticsCode.name = googleAnalyticsCon.id
		if CUPage.Preview or googleAnalyticsCon.Fields("IDGoogleAnalytics").Value = "" then
		'	googleAnalyticsCode.visible = false
		end if
	End Sub
</script>
<CU:CUContainer Name="" id="googleAnalyticsCode" runat="server">
<!-- Google Tag Manager -->
<noscript><iframe src="//www.googletagmanager.com/ns.html?id=<CU:CUField name='IDGoogleAnalytics' runat='server'/>"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','<CU:CUField name="IDGoogleAnalytics" runat="server"/>');</script>
<!-- End Google Tag Manager -->
</CU:CUContainer>