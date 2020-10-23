<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<script runat="server">

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

    End Sub


</script>

<div class="control cookieinfo" style="display: none;">
    <div class="holder">
        <cu:cucontainer name="zenConCookieInfo" runat="server">
        <!--<span class="close-cookie-info hasicon do-hide-cookieinfo"></span>-->
		<div class="cookieinfo-body">
			<CU:CUField name="zenconcookieinfo_text" runat="server" tag="div" tagclass="part liststyle " />
		</div>
		<div class="cookieinfo-footer">
			<CU:CUField name="zenconcookieinfo_button_ok" runat="server" tag="button" tagclass="button button-cookie do-close-cookieinfo" />
			<CU:CULink name="zenconcookieinfo_link_info" runat="server" class="button button-info" />
		</div>
	</cu:cucontainer>
    </div>
</div>
