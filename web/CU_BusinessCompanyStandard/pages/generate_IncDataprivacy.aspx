<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">

</script>
<div class="dataprivacy-info movie" style="display: none;">
	<header class="dataprivacy-info-header">
	    <CU:CUField name="zencondataprivacy_movie_infotitle" runat="server" tag="span" tagclass="h3 item-title" />
	</header>
	<div class="dataprivacy-info-body">

		<CU:CUField name="zencondataprivacy_movie_infotext" runat="server" tag="div" tagclass="liststyle" />
	</div>
	<footer class="dataprivacy-info-footer">
		<CU:CUField name="zencondataprivacy_movie_infobtncancel" runat="server" tag="span" tagclass="button button-cancel btnCancel" />
		<CU:CUField name="zencondataprivacy_movie_infobtn" runat="server" tag="span" tagclass="button button-ok btnAccept" />
	</footer>
</div>
<div class="dataprivacy-info map" style="display: none;">
	<header class="dataprivacy-info-header">
	    <CU:CUField name="zencondataprivacy_map_infotitle" runat="server" tag="span" tagclass="h3 item-title" />
	</header>
	<div class="dataprivacy-info-body">

		<CU:CUField name="zencondataprivacy_map_infotext" runat="server" tag="div" tagclass="liststyle" />
	</div>
	<footer class="dataprivacy-info-footer">
		<CU:CUField name="zencondataprivacy_map_infobtncancel" runat="server" tag="span" tagclass="button button-cancel btnCancel" />
		<CU:CUField name="zencondataprivacy_map_infobtn" runat="server" tag="span" tagclass="button button-ok btnAccept" />
	</footer>
</div>
<div class="dataprivacy-info search" style="display: none;">
	<header class="dataprivacy-info-header">
	    <CU:CUField name="zencondataprivacy_search_infotitle" runat="server" tag="span" tagclass="h3 item-title" />
	</header>
	<div class="dataprivacy-info-body">

		<CU:CUField name="zencondataprivacy_search_infotext" runat="server" tag="div" tagclass="liststyle" />
	</div>
	<footer class="dataprivacy-info-footer">
		<CU:CUField name="zencondataprivacy_search_infobtncancel" runat="server" tag="span" tagclass="button button-cancel btnCancel" />
		<CU:CUField name="zencondataprivacy_search_infobtn" runat="server" tag="span" tagclass="button button-ok btnAccept" />
	</footer>
</div>