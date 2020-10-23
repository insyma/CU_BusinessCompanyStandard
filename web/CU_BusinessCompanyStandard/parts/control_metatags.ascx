<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''	HINU: part zur Integration der META-Daten
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Dim livepath as string = ""
    Dim aktuelleID as Integer
    Dim language as string
    Dim tempDetailPage as new ContentUpdate.Page()
    Dim tempDetailCon as new ContentUpdate.Container()
    dim allmeta as new contentupdate.container()
    dim vis as boolean = true
    dim social_title as string = ""
    dim social_desc as string = ""
    dim social_img0 as string = ""
    dim social_img1 as string = ""
    dim pagemeta as new contentupdate.container()
    dim social_active as boolean = false
    Dim include as String = ""
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        'Fallback laden(falls auf Page keine Inhalte eingegeben'
        '	livepath = "http://" & cupage.web.properties("LiveServer").value
        '	path.text = "<link rel='canonical' href='" & livepath & "' itemprop='url' />"

        
        social_active = true
        

        'allmeta.loadbyname("allmetatag")
        allmeta.load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("MetaTags").containers("allmetatag").id)
        allmeta1.name = allmeta.id
        allmeta2.name = allmeta.id
        allmeta3.name = allmeta.id
        allmeta4.name = allmeta.id

        allmeta.preview = CUPage.preview
        allmeta.LanguageCode = CUPage.LanguageCode
        if allmeta.fields("language_tag_href").value = "" then
            vis = false
        end if
        pagemeta.load(CUPage.Containers("MetaTags").id)
        pagemeta.LanguageCode = CUpage.LanguageCode

        if not pagemeta.fields("share_title").value = "" then
            social_title = pagemeta.fields("share_title").value
        end if
        if not pagemeta.fields("share_desc").value = "" then
            social_desc = pagemeta.fields("share_desc").value
        end if
        if not pagemeta.images("share_img").filename = "" then
            social_img0 = CUPage.Web.LiveServer & pagemeta.images("share_img").src
            social_img1 = CUPage.Web.LiveServer & pagemeta.images("share_img").alternativesrc
        end if
        if social_img0 = "" then
            social_img0 = _checkImages(CUPage.Containers("inhalt").id, 0)
            social_img1 = _checkImages(CUPage.Containers("inhalt").id, 1)
        end if
        '' Ist der Metatitle auf der Page ausgefüllt?
        if len(pagemeta.Fields("metatitle").value)>0 then
            metatitleSchema.text = pagemeta.Fields("metatitle").value
            metatitle.text = pagemeta.Fields("metatitle").value
            if social_title = "" then
                social_title = pagemeta.Fields("metatitle").value
            end if
        else
            '' Befinden wir uns auf einer (News)Detailseite, dann nimm den Titel der News
            if CUpage.Containers("detail").Containers.count> 0 then
                metatitle.text = CUPage.containers("detail").containers(1).fields("news_newsentry_title").value.replace("& ","&amp; ") & " "
                metatitleSchema.text = CUPage.containers("detail").containers(1).fields("news_newsentry_title").plaintext.replace("& ","&amp; ")
                if social_title = "" then
                    social_title = CUPage.containers("detail").containers(1).fields("news_newsentry_title").value.replace("& ","&amp; ")
                end if
                '' oder den Namen der Seite
            else
                metatitle.text = CUPage.properties("caption").value & " "
                metatitleSchema.text = CUPage.properties("caption").value
                if social_title = "" then
                    if not CUPage.Containers("settings").fields("Seitentitel").value = "" then
                        social_title = CUPage.Containers("settings").fields("Seitentitel").value

                    else
                        social_title = CUPage.properties("caption").value
                    end if
                end if
            end if
        end if

        '' Sind die Keywords bei der Page ausgefüllt?
        if pagemeta.Fields("keywords").value <> "" then
            metadesc_key.text = CUPage.Caption & "," & pagemeta.Fields("keywords").value
        else
            '' nimm ansonsten den zentralen Fallback
            metadesc_key.text = CUPage.Caption & "," & allmeta.fields("websitekeys").value
        end if
        '' Ist die Description auf Page ausgefüllt?
        if pagemeta.Fields("description").value <> "" then
            metadesc_desc.text = CUPage.Caption & ". " & pagemeta.Fields("description").value
            if social_desc = "" then
                social_desc = pagemeta.Fields("description").value
            end if
        else
            '' nimm ansonsten den Seitentitel plus den zentralen Fallback
            metadesc_desc.text = CUPage.Caption & ". " & allmeta.fields("websitedesc").value
            if social_desc = "" then
                social_desc = allmeta.fields("websitedesc").value
            end if
        end if
        '	Abfrage Meta-Description ob News-Detail-Seite oder nicht
        '-----------------------------------------------------------------------------------------------------

        if Request.QueryString("detail") <> "" then
            tempDetailCon.Load(Request.QueryString("detail"))
            '' Wenn News eine Einleitung hat: nimm diese oder den Text
            if tempDetailCon.Fields("news_newsentry_intro").Value <> ""
                metadesc_desc.text = tempDetailCon.Fields("news_newsentry_intro").Value
                social_desc = tempDetailCon.Fields("news_newsentry_intro").Value
            else
                metadesc_desc.text = tempDetailCon.Fields("text").Value
                social_desc = tempDetailCon.Fields("text").Value
            end if
            social_img0 = _checkImages(tempDetailCon.id, 0)
            social_img1 = _checkImages(tempDetailCon.id, 1)
        else
            'metadesc_desc.text = pagemeta.Fields("description").value
        end if

        Dim geoInfoIncPage As New ContentUpdate.Page()
        'footerInfoIncPage.LoadByName("inc_FooterInfo")
        geoInfoIncPage.Load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("MetaTags").id)
        geoInfoIncPage.Preview = CUPage.Preview
        include = geoInfoIncPage.Link
    End Sub

    function _checkImages(aId as Integer, aTodo as integer)
        dim ret as string = ""
        dim c as new contentupdate.container()
        c.load(aId)
        for each o as contentupdate.obj in c.GetChildObjects(6)
            o.languageCode = CUpage.languageCode
            if not o.properties("filename").value = "" then
                dim i as new contentupdate.image()
                i.load(o.id)
                if aTodo = 0 then
                    ret = CUPage.Web.LiveServer & i.src
                else
                    ret = CUPage.Web.LiveServer & i.alternativesrc
                end if
                exit for
            end if
        next
        return ret
    end function

</script>
<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "WebSite",
  "name" : "<CU:CUContainer name="" id="allmeta1" runat="server"><CU:CUField name="websitetitle" runat="server" /></CU:CUContainer>",
  "alternateName" : "<asp:literal id="metatitleSchema" runat="server" />",
  "url" : "<%=CUPage.Web.LiveServer & CUPage.Web.LivePath%>"
}

</script>
<title><asp:literal id="metatitle" runat="server" /></title>
<asp:Literal id="path" runat="server" />
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<% If CUPage.Arrange = false then 
	if cuPage.Preview then
		Server.Execute(include)
	else 
		response.write("<" + "!--#include virtual=""" & include &""" -->")
	end if
End If %>

<CU:CUContainer name="" id="allmeta2" runat="server">
<% if vis = true then %>
<link rel="alternate" hreflang="<CU:CUField name='language_tag_lang' runat='server' plaintext='true' />" href="<CU:CUField name='language_tag_href' runat='server' plaintext='true' />" />
<% end if %>
</CU:CUContainer>
<meta name="keywords" content='<asp:literal id="metadesc_key" runat="server" />' />
<meta name="description" content='<asp:literal id="metadesc_desc" runat="server" />'/>
<CU:CUContainer Name="GoogleanalyticsContainer2.0.0" id="googleAnalyticsCode" runat="server">
<meta name="google-site-verification" content="<CU:CUField name='GoogleSiteVerification' runat='server' />" />
</CU:CUContainer>
<meta name="format-detection" content="telephone=no">
<!-- Via Checkbox aktivieren/deaktivieren HINU 
<meta name="robots" content="noydir">
<meta name="robots" content="noodp">
-->

<!--Social Sharing -->
<% if not social_title = "" AND social_active = true then %>
<meta name="twitter:title" content="<%=social_title%>" />
<meta name="twitter:card" content="summary" />
<meta name="twitter:site" content='<CU:CUContainer name="" id="allmeta3" runat="server"><CU:CUField name="websitetitle" runat="server" /></CU:CUContainer>' />

<meta property="og:title" content="<%=social_title%>" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content='<CU:CUContainer name="" id="allmeta4" runat="server"><CU:CUField name="websitetitle" runat="server" /></CU:CUContainer>' />

<% end if %>
<% if not social_desc = "" AND social_active = true then %>
<meta name="twitter:description" content="<%=social_desc%>" />
<meta property="og:description" content="<%=social_desc%>" /> 
<% end if %>
<% if not social_img0 = "" AND social_active = true then %>
<meta name="twitter:image" content="<%=social_img0%>" /> 
<meta property="og:image" content="<%=social_img1%>" />
<% end if %>

<% if CUPage.preview = true OR not CUPage.containers("metatags").fields("meta_index_follow").value = "" %>
<meta name="robots" content="noindex, nofollow" />
<% end if %>
<% if not CUPage.containers("metatags").fields("meta_index_dc").value = "" AND not CUPage.containers("metatags").links("meta_index_origurl").properties("value").value = "" then %>
<link rel='canonical' href='<%=CUPage.containers("metatags").Links("meta_index_origurl").Url%>'/>	
<% end if %> 
<meta name="viewport" content="width=device-width, initial-scale=1"/>


