<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: Part zur Integration der Google Custom Search
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Dim google_lang as String = "de" 
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        '' aktuelle Sprache definieren
        if CUPage.LanguageCode = 1 then
            google_lang = "fr"  
        elseif CUPage.LanguageCode = 2 then
            google_lang = "it"  
        elseif CUPage.LanguageCode = 3 then
            google_lang = "en"  
        elseif CUPage.LanguageCode = 4 then
            google_lang = "es"  
        elseif CUPage.LanguageCode = 5 then
            google_lang = "nl"  
        end if

        '' es benötigt immer eine Seite im CU, welche den eindeutigen (Objekt)Namen "suchergebnisseite" besitzt.
        Dim SearchPage as new ContentUpdate.Page
        
        
        
        'SearchPage.LoadByName("suchergebnisseite")
        SearchPage.Load(CUPage.Web.rubrics("Web").rubrics("ServiceNavigation").pages("Suchergebnisseite").id)
        if not SearchPage.Link = "" then
            actionLink.Text = SearchPage.Link   
        else
        end if
        SiteSearch.Name = CUPage.Web.rubrics("Web").rubrics("Seiteneinstellungen").pages("google").containers("GoogleSiteSearch").id.toString()

    End Sub
</script>
<ul class="control con-suche">
  <li>
    <script type="text/javascript" src="http://www.contentupdate.net/insymaLib/standard/hideInputValue/insymahideInputValue.js"></script>
    <form action="<asp:Literal id='actionLink' runat='server' />" id="cse-search-box" class="con-form">
        <CU:CUContainer name="" id="SiteSearch" runat="server">
        <input type="text" class="search" placeholder='<CU:CUField name="GoogleInputText" runat="server" />' size="31" name="q" />
        <input type="hidden" value="<%=google_lang%>" name="hl">
        <input type="submit" class="cse-button" value='<CU:CUField name="GoogleButtonText" runat="server" />' name="sa" />
        </CU:CUContainer>
    </form>
    
  </li>
</ul>
