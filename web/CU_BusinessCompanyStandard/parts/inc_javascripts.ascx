<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: part zur Integration der JS-Files fürs Include(incl. Umgehung des Caching bei Publizierung des Includes)
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Dim imageConfigPage As New ContentUpdate.Page
	dim path as string = "../"
	dim acc as string = ""
    dim caching as string = ""
	dim con as new contentupdate.container
    dim mapkey as string = ""
    dim socials as new contentupdate.container()
    dim p as new contentupdate.Page()
    dim sociallinks as string = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        '' Laden der Page zur generierung des JS - Files, welche Labels für Bilderanzeigen enthält
        'imageConfigPage.LoadByName("insymaImage-config")
        imageConfigPage.Load(CUPage.Web.Rubrics("Web").Rubrics("Seiteneinstellungen").Pages("beschriftungen").Pages("insymaImage-config").Id)
        imageConfigPage.LanguageCode = CUPage.LanguageCode
        imageConfigPage.Preview = False

		'con.loadByName("addthisinfocon")
		con.Load(CUPage.Web.rubrics("Web").rubrics("Seiteneinstellungen").pages("inc_addthis").containers("addthisinfocon").id)
        acc = con.fields("AddThisID").value
        
		if cupage.Preview = false then
            path = CUPage.Web.LiveServer & CUPage.Web.Livepath
        end if

		ImageConfig.Text = path & imageConfigPage.Properties("path").Value.substring(1) & imageConfigPage.Properties("filename").Value
        caching = "?cache=" & DateTime.UtcNow.Subtract(New DateTime(1970, 1, 1)).TotalMilliseconds
        con.Load(CUPage.Web.rubrics("Web").rubrics("Seiteneinstellungen").pages("beschriftungen").containers("labelling_map").id)
        mapkey = "?key=" & con.fields("map_key").value

        
        socials.loadByName("zenconshariff")
        socials.Preview = CUpage.Preview
        socials.LanguageCode = CUpage.LanguageCode
        for each c as contentupdate.container in socials.objectsets("zenconshariff_culist").containers
            sociallinks += """" & c.fields("zenconshariff_val").value & ""","
        next
        if sociallinks.length > 2 then
            'sociallinks = sociallinks.substring(0, sociallinks.lemgth-1)
            sociallinks += """info"""
        end if
        p.load(cint(socials.links("zenconshariff_infolink").properties("value").value))
        p.Preview = CUpage.Preview
        p.LanguageCode = CUpage.LanguageCode
    End Sub
</script>
<!-- LANG Scritps -->
<script type="text/javascript" src="<asp:Literal id='ImageConfig' runat='server' />"></script>
<script type="text/javascript">
    var shariff_link = "<%=p.link%>";
    var schariff_socials = [<%=sociallinks%>];
</script>
<% if CUPage.Preview then %>
<!-- SCREEN -->
<!--<script type="text/javascript" src="<%=path%>js/jquery-2.1.3.min.js"></script>-->
<script type="text/javascript" src="<%=path%>js/lib/modernizr.min.js"></script>
<script type="text/javascript" src="<%=path%>js/jquery-3.5.1.min.js"></script>

<script type="text/javascript" src="<%=path%>js/lib/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=path%>js/lib/jquery.flexslider-min.js"></script>
<script type="text/javascript" src="<%=path%>js/lib/jquery-polyglot.language.switcher.min.js"></script>
<script type="text/javascript" src="<%=path%>js/lib/jquery.tinysort.min.js<%=caching%>"></script>
<script type="text/javascript" src="<%=path%>js/lib/jquery.touchSwipe.min.js<%=caching%>"></script>
<script type="text/javascript" src="<%=path%>js/lib/jquery-ui-custom.min.js"></script>
<script type="text/javascript" src="<%=path%>js/lib/fancybox/jquery.fancybox.min.js"></script>
<script type="text/javascript" src="<%=path%>js/lib/uniform.min.js"></script>
<%--<script type="text/javascript" src="https://maps.google.com/maps/api/js<%=mapkey%>"></script>--%>
<script type="text/javascript" src="<%=path%>js/shuffle.js"></script>

<script type="text/javascript" src="<%=path%>js/insymaFormValidation.js<%=caching%>"></script>
<script type="text/javascript" src="<%=path%>js/social.js"></script>
<script type="text/javascript" src="<%=path%>js/youtube.js<%=caching%>"></script>
<script type="text/javascript" src="<%=path%>js/insymaFancyScripts.js<%=caching%>"></script>
<%--
<script type="text/javascript" src="<%=path%>js/insymaOverlaybox.js<%=caching%>"></script>

--%>
<script type="text/javascript" src="<%=path%>js/insymaDataprivacy.js<%=caching%>"></script>
<script type="text/javascript" src="<%=path%>js/map.js<%=caching%>"></script>
<script type="text/javascript" src="<%=path%>js/insymaContentlists.js<%=caching%>"></script>
<script type="text/javascript" src="<%=path%>js/project_scripts.js<%=caching%>"></script>

<% else %>
<%--    <script type="text/javascript" src="https://maps.google.com/maps/api/js<%=mapkey%>"></script>--%>
    <script type="text/javascript" src="<%=path%>js/main.min.js<%=caching%>"></script>
<% end if %>

<% if false then %>
    <!-- deactivate smooth font rendering for remotes and vpn  -->
    <script type="text/javascript" src="<%=path%>js/fontrendering/EventHelpers.min.js<%=caching%>"></script>
    <script type="text/javascript" src="<%=path%>js/fontrendering/TypeHelpers.min.js<%=caching%>"></script>
<% end if %>

<% if false then %>
    <!-- 'Nur bei Shopintegration -->
    <script type="text/javascript" src="<%=path%>/deu/shop_produkte.js<%=caching%>"></script>
    <script type="text/javascript" src="<%=path%>js/shop.js<%=caching%>"></script>
<% end if %>

<script type="text/javascript">
    var MAP_API = "https://maps.google.com/maps/api/js<%=mapkey%>";
</script>



<!--[if (gte IE 6)&(lte IE 8)]>
    <script type="text/javascript" src="<%=path%>js/lib/selectivizr-min.js<%=caching%>"></script>
<![endif]-->
<!-- FAVICON http://www.favicomatic.com/ -->
<link rel="shortcut icon" href="<%=path%>favicon.ico" type="image/x-icon" />
<link rel="apple-touch-icon-precomposed" sizes="57x57" href="<%=path%>apple-touch-icon-57x57.png" />
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="<%=path%>apple-touch-icon-114x114.png" />
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="<%=path%>apple-touch-icon-72x72.png" />
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="<%=path%>apple-touch-icon-144x144.png" />
<link rel="apple-touch-icon-precomposed" sizes="60x60" href="<%=path%>apple-touch-icon-60x60.png" />
<link rel="apple-touch-icon-precomposed" sizes="120x120" href="<%=path%>apple-touch-icon-120x120.png" />
<link rel="apple-touch-icon-precomposed" sizes="76x76" href="<%=path%>apple-touch-icon-76x76.png" />
<link rel="apple-touch-icon-precomposed" sizes="152x152" href="<%=path%>apple-touch-icon-152x152.png" />
<link rel="icon" type="image/png" href="<%=path%>favicon-196x196.png" sizes="196x196" />
<link rel="icon" type="image/png" href="<%=path%>favicon-96x96.png" sizes="96x96" />
<link rel="icon" type="image/png" href="<%=path%>favicon-32x32.png" sizes="32x32" />
<link rel="icon" type="image/png" href="<%=path%>favicon-16x16.png" sizes="16x16" />
<link rel="icon" type="image/png" href="<%=path%>favicon-128.png" sizes="128x128" />
<CU:CUcontainer name="allmetatag" runat="server"><meta name="application-name" content='<CU:CUfield name="websitetitle" runat="server" />'/></CU:CUcontainer>
<meta name="theme-color" content="#ffffff" />
<meta name="msapplication-TileColor" content="#FFFFFF" />
<meta name="msapplication-TileImage" content="<%=path%>mstile-144x144.png" />
<meta name="msapplication-square70x70logo" content="<%=path%>mstile-70x70.png" />
<meta name="msapplication-square150x150logo" content="<%=path%>mstile-150x150.png" />
<meta name="msapplication-wide310x150logo" content="<%=path%>mstile-310x150.png" />
<meta name="msapplication-square310x310logo" content="<%=path%>mstile-310x310.png" />