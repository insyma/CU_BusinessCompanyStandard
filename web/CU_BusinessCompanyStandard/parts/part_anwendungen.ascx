<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<CU:CUField name="Titel" runat="server" tag="h2"/>
<CU:CUObjectSet name="CUList" runat="server" >
<ItemTemplate>
	<CU:CUField name="Titel" runat="server" tag="h3" tagclass="h3 item-title" />
	<CU:CUField name="Text" runat="server" />
	<CU:CUImage name="Bild" runat="server" />
	<CU:CUFile name="Download" runat="server" />
	<CU:CULink name="Link" runat="server" />
</ItemTemplate>
</CU:CUObjectSet>
