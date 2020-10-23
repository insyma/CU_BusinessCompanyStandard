<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
dim p as new contentupdate.obj()
	Dim CUContainer as new ContentUpdate.Container()
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		if CUPage.objname = "CaptchaPage" then
			CUContainer.Load(CUPage.Containers(1).id)
			CUContainer.Preview = CUPage.Preview
			Me.Container = CUContainer
		end if
		if Container.ParentPages("CaptchaPage").Properties("MasterPageID").value = "" then
			Container.ParentPages("CaptchaPage").Properties("MasterPageID").value = Container.ParentPages("CaptchaPage").getParentObjects(3)(CUPage.getParentObjects(3).count).ID & "&detail"
		end if
		dim a = Container.ParentPages("CaptchaPage").Parent.Parent.ParentId
		
		p.load(a)
		p.preview = CUPage.Preview
	End Sub
</script>
<div class="part clearfix">
    <CU:CUField runat="server" Name="capcha_titel" tag="h3" tagclass="h3 item-title" />
    <CU:CUField runat="server" Name="capcha_text"/>
    <a class="icon iconbefore iconReturnTo link block" href="<%=p.link%>"><CU:CUField runat="server" Name="capcha_link"/></a>
</div>


