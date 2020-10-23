<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">	
	Dim host As String
	Dim hostPath As String
	Sub Page_Load(Src As Object, E As EventArgs)

		
		
	End Sub
</script>
	
<div class="part part-mp3">
<CU:CUField name="part_mp3_title" runat="server" tag="h3" tagclass="h3 item-title"  />
<span class="swfwrap">
    <object type="application/x-shockwave-flash" data="../swf/mp.swf" width="100%" height="20">
	     <param name="movie" value="../swf/mp.swf" />
	     <param name="bgcolor" value="#E26610" />
	     <param name="FlashVars" value='mp3=../files/<CU:CUFile name="part_mp3_file" runat="server" property="filename" />&amp;autoplay=<CU:CUField name="part_mp3_auto" runat="server" />' />
	</object>
</span>
</div>
