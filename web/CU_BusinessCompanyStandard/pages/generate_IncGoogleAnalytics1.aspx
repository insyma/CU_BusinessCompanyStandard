<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

        Dim googleanalytics As New ContentUpdate.Container()
        googleanalytics.Load(CUPage.ParentID)
        googleanalytics.Load(googleanalytics.containers("GoogleanalyticsContainer").id)
        googleanalytics.LanguageCode = CUPage.LanguageCode
        If googleanalytics.Fields("IDGoogleAnalytics").Value = "" Or googleanalytics.Fields("IDGoogleAnalytics").Value = "xxx" or CUPage.Preview = True Then
            GoogleanalyticsContainer.Visible = False
        else
            GoogleanalyticsContainer.name = googleanalytics.id
        End If
    End Sub
</script>



<CU:CUContainer Name="" id="GoogleanalyticsContainer" runat="server">
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=<CU:CUField name='IDGoogleAnalytics' runat='server'/>"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->

</CU:CUContainer>