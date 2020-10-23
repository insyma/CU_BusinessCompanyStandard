<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Dim css_part__setting__width As String = ""
    Dim css_part__setting__align As String = ""
    Dim css_part__setting__margin As String = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

    	If Not container.Containers("part_content") Is Nothing AndAlso container.Containers("part_content").Id > 0 Then
            part_content.name = container.Containers("part_content").Id
            ' First: get the setting container
            Dim settingContainer As New ContentUpdate.Container()
            settingContainer = container.Containers("part_settings")
            ' Then reset main part to content container
            container = container.Containers("content")

            If Not settingContainer.fields("part__setting__width").value = "" Then
                css_part__setting__width = "content-width-" & settingContainer.fields("part__setting__width").Properties("Value").value
            End If

            If Not settingContainer.fields("part__setting__align").value = "" Then
                css_part__setting__align = "part-align-" & settingContainer.fields("part__setting__align").Properties("Value").value
            End If

            If Not settingContainer.fields("part__setting__margin").value = "" Then
                css_part__setting__margin = "content-margin-" & settingContainer.fields("part__setting__margin").Properties("Value").value
            End If
        End If
    End Sub
</script>
<CU:CUContainer name="" id="part_content" runat="server">
<div class="part part-faq clearfix">
    <div class="holder <%=css_part__setting__width%>  <%=css_part__setting__align%> <%=css_part__setting__margin%>">
	<CU:CUField name="part_faq_title" runat="server" tag="h2" class="h3 item-title" />
	<CU:CUObjectSet name="part_faq_culist" runat="server" >
	<HeaderTemplate><div class="part-faq-accordeon"></HeaderTemplate>
	<FooterTemplate></div></FooterTemplate>
	<ItemTemplate>
		<CU:CUField name="part_faq_cuentry_itemname" runat="server" tag="h3" tagclass="h4 item-title" />
		<CU:CUField name="part_faq_cuentry_itemvalue" runat="server" tag="div" tagclass="liststyle" />
	</ItemTemplate>
	</CU:CUObjectSet>
	</div>
	<script>$(".part-faq-accordeon").accordion();</script>
</div>
</CU:CUContainer>