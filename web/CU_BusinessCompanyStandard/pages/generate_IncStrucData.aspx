<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
dim jsonpath as string = ""
dim detail as integer = 0
dim news as boolean = false
dim addresscon as new Contentupdate.Container()
dim adressdata as boolean = false
dim socialdata as boolean = false
dim addrdata0 as string = ""
dim addrdata1 as string = ""
dim addrdata2 as string = ""
dim socdata0 as string = ""
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        'Zusammensuchen der Kontaktdaten'
        addresscon.loadByName("FooterAddressCon")
        if addresscon.objectsets("FooterInfoCon_AddressList").containers.count > 0 then
            adressdata = true ' JUHU, es gibt Adressdaten'
            addresscon.load(addresscon.objectsets("FooterInfoCon_AddressList").containers(1).id)
            addresscon.LanguageCode = CUpage.LanguageCode
            for each c as contentupdate.container in addresscon.objectsets("FooterInfoCon_Address_ContactList").containers
                c.LanguageCode = CUPage.LanguageCode
                if c.fields("FooterInfoCon_Address_ContactType").properties("value").value = "iconphone" then
                    if not c.links("FooterInfoCon_Address_ContactLink").properties("description").value = "" then
                        addrdata0 = c.links("FooterInfoCon_Address_ContactLink").properties("description").value
                    end if
                else if c.fields("FooterInfoCon_Address_ContactType").properties("value").value = "iconfax" then
                    addrdata1 = c.fields("FooterInfoCon_Address_ContactText").value
                else if c.fields("FooterInfoCon_Address_ContactType").properties("value").value = "iconmail" then
                    addrdata2 = c.links("FooterInfoCon_Address_ContactLink").properties("description").value
                end if
            next
        end if
        'Schauen wir nach Social-Media-Links:'
        dim socialos as new Contentupdate.Objectset()
        socialos.loadByName("consocialmedialist")
        for each c as contentupdate.container in socialos.containers
            socialdata = true
            c.LanguageCode = CUpage.LanguageCode
            socdata0 += """" & c.links("consocialmedialink").properties("value").value & """," & vbcrlf
        next
        'Da Eintraege durch Komma getrennt werden(der letzte Eintrag aber kein abschliessendes Komma benoetigt) entfernen wir das letzte Komma'
        if socdata0.length > 1 Then
            socdata0 = socdata0.substring(0, socdata0.lastIndexOf(","))
        end if

        'Nun noch das Betreiber-logo'
        Dim HeaderLogoContainer As New ContentUpdate.Container()
		HeaderLogoContainer.Load(CUPage.Web.Rubrics("Web").Rubrics("Seiteneinstellungen").Pages("Beschriftungen").Containers("HeaderLogoContainer").id)
        HeaderLogoContainer.LanguageCode = CUPage.LanguageCode
        imgJson.text = CUPage.Web.LiveServer & HeaderLogoContainer.Images("HeaderLogo").src
    End Sub

</script>
<% if adressdata = true then %>
<script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "<%=addresscon.fields("FooterInfoCon_Address_Type").value%>",
      "address": {
        "@type": "PostalAddress",
        "addressLocality": "<%=addresscon.fields("FooterInfoCon_Address_City").value%>, <%=addresscon.fields("FooterInfoCon_Address_Country").value%>",
        "postalCode": "<%=addresscon.fields("FooterInfoCon_Address_ZIP").value%>",
        "streetAddress": "<%=addresscon.fields("FooterInfoCon_Address_Street").value%> <%=addresscon.fields("FooterInfoCon_Address_StreetNumber").value%>"
      },
      "email": "<%=addrdata2%>",
      "faxNumber": "<%=addrdata1%>",
      "name": "<%=addresscon.fields("FooterInfoCon_Address_Name").value%>",
      "telephone": "<%=addrdata0%>",
      "url" : "<%=CUPage.Web.LiveServer & CUPage.Web.LivePath%>"
      <% if socialdata = true then %>
      ,
      "sameAs" : [
        <%=socdata0%>
      ]
      <% end if %>
      ,"logo": [
        "<asp:literal id="imgJson" runat="server" />"
        ]
    }
</script>
<% end if %>
