<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        ReplacePlaceholder.ReplaceText = Container.Fields("HiddenInfo").Plaintext
    End Sub
</script>
<!-- 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

<CU:CUMailLink ID="ReplacePlaceholder" MailLinkType="ReplacePlaceholder" runat="server" />

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-->