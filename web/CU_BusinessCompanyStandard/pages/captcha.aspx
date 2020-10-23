<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
	Dim myControl As Control
	Dim CUContainer as new ContentUpdate.Container()
	Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)	
		myControl = Page.LoadControl(CUPage.Containers(1).Properties("Template").value)
		Panel1.Controls.Add(myControl)
		Panel1.name = CUPage.Containers(1).id
		CUContainer.Load(CUPage.Containers(1).id)
		CUContainer.Preview = CUPage.Preview
	End Sub
</script>
<CU:CUContainer id="Panel1" runat="server"></CU:CUContainer>