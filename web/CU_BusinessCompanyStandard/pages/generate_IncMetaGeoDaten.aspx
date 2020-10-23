<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
	dim allmeta as new contentupdate.container()
	allmeta.load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("MetaTags").containers("allmetatag").id)
	allmeta.LanguageCode = CUpage.LanguageCode
	allmeta2.name = allmeta.id
End Sub
</script>
<CU:CUContainer name="" id="allmeta2" runat="server">
	<meta name="geo.region" content="<CU:CUField name='geo-region' runat='server' plaintext='true' />" />
	<meta name="geo.placename" content="<CU:CUField name='geo-placename' runat='server' plaintext='true' />" />
	<meta name="geo.position" content="<CU:CUField name='geo-position' runat='server' plaintext='true' />" />
	<meta name="ICBM" content="<CU:CUField name='geo-ICBM' runat='server' plaintext='true' />" />
</CU:CUContainer>