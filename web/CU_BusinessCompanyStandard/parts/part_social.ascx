<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
dim include as string = ""
dim os as new ContentUpdate.Objectset()
dim str_share as string = ""
dim tempPage as new Contentupdate.page()
	Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
		Dim tempCon as new ContentUpdate.Container()
		tempCon.LoadByName("zenConShariff")
		tempCon.Preview = CUPage.Preview
		tempCon.LanguageCode = CUPage.LanguageCode 
		os.load(tempCon.objectsets("zenconshariff_culist").id)
		str_share = tempCon.fields("zenconshariff_lbl_share").value
		tempPage.load(CUpage.ID)
		tempPage.LanguageCode = CUpage.LanguageCode
		tempPage.Preview = false
	End Sub
</script>

<div class="shariff part-shariff">
    <ul class="shariff-list">
    <% for each c as contentupdate.container in os.containers
    	c.LanguageCode = CUpage.LanguageCode
    	'response.write("<br />:::" & c.fields("zenconshariff_val").value)
    	if c.fields("zenconshariff_val").value.Contains("facebook") = true then 
    %>
        <li class="shariff-button">
            <a aria-label="<%=str_share.replace("***", c.fields("zenconshariff_val").value)%>" data-rel="popup" href="https://www.facebook.com/sharer/sharer.php?u=<%=tempPage.AbsoluteLink%>" role="button" title="<%=str_share.replace("***", c.fields("zenconshariff_val").value)%>">
                
            </a>
        </li>
    <% else if c.fields("zenconshariff_val").value.Contains("twitter") = true %>
        <li class="shariff-button twitter icon">
            <a class="social-icon twitter" data-rel="popup" href="https://twitter.com/intent/tweet?text=<?=socialtitle ?>&url=<%=tempPage.AbsoluteLink%>" role="button" title="<%=str_share.replace("***", c.fields("zenconshariff_val").value)%>">
               
            </a>
        </li>
    <% else if c.fields("zenconshariff_val").value.Contains("google") = true %>
        <li class="shariff-button googleplus icon">
            <a aria-label="<%=str_share.replace("***", c.fields("zenconshariff_val").value)%>" data-rel="popup" href="https://plus.google.com/share?url=<%=tempPage.AbsoluteLink%>" role="button" title="<%=str_share.replace("***", c.fields("zenconshariff_val").value)%>">
               
            </a>
        </li>
    <% else if c.fields("zenconshariff_val").value.Contains("xing") = true %>
    	<li class="shariff-button xing icon">
            <a aria-label="<%=str_share.replace("***", c.fields("zenconshariff_val").value)%>" data-rel="popup" href="https://www.xing.com/social_plugins/share?url=<%=tempPage.AbsoluteLink%>" role="button" title="<%=str_share.replace("***", c.fields("zenconshariff_val").value)%>">
               
            </a>
        </li>
    <% else if c.fields("zenconshariff_val").value.Contains("linked") = true %>
    	<li class="shariff-button linkedin icon">
            <a aria-label="<%=str_share.replace("***", c.fields("zenconshariff_val").value)%>" data-rel="popup" href="https://www.linkedin.com/shareArticle?url=<%=tempPage.AbsoluteLink%>" role="button" title="<%=str_share.replace("***", c.fields("zenconshariff_val").value)%>">
               
            </a>
        </li>
    <%end if
     next %>    
    </ul>
</div>
<div class="shariff-info dataprivacy-info" style="display: none;">
	<header class="dataprivacy-info-header">
	    <CU:CUField name="zenconshariff_infotitle" runat="server" tag="h3" tagclass="h3 item-title iconinfo" />
	</header>
	<div class="dataprivacy-info-body">

		<CU:CUField name="zenconshariff_infotext" runat="server" tag="div" tagclass="liststyle" />
	</div>
	<footer class="dataprivacy-info-footer">
		<CU:CUField name="zenconshariff_infobtncancel" runat="server" tag="span" tagclass="button button-cancel btnCancel" />
		<CU:CUField name="zenconshariff_infobtn" runat="server" tag="span" tagclass="button button-ok btnAccept" />
	</footer>
</div>