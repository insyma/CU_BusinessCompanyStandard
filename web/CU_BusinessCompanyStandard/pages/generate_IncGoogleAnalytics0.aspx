<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

        Dim googleanalytics As New ContentUpdate.Container()
        googleanalytics.Load(CUPage.ParentID)
        googleanalytics.Load(googleanalytics.containers("GoogleanalyticsContainer").id)
        googleanalytics.LanguageCode = CUPage.LanguageCode
        If googleanalytics.Fields("IDGoogleAnalytics").Value = "" Or googleanalytics.Fields("IDGoogleAnalytics").Value = "xxx" or CUPage.Preview = True Then
            GoogleanalyticsContainer.Visible = False
            GoogleanalyticsContainer2.Visible = False
        else
            GoogleanalyticsContainer.name = googleanalytics.id
            GoogleanalyticsContainer2.name = googleanalytics.id
        End If
    End Sub
</script>



<CU:CUContainer Name="" id="GoogleanalyticsContainer" runat="server" visible = false>
<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','<CU:CUField name="IDGoogleAnalytics" runat="server"/>');</script>
<!-- End Google Tag Manager -->

</CU:CUContainer>
<CU:CUContainer Name="" id="GoogleanalyticsContainer2" runat="server">
<script>var gtmid = '<CU:CUField name="IDGoogleAnalytics" runat="server"/>';</script>

</CU:CUContainer>