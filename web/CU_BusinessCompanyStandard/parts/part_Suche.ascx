<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>

<script runat="server">
    Dim homePage As ContentUpdate.Page
    Dim topPage As New ContentUpdate.Page
	Dim google_lang as String = "de"

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		if CUPage.LanguageCode = 1 then
				google_lang = "fr"		
		end if
        
        Dim PageNow As New ContentUpdate.Page
		Dim SearchPage as new ContentUpdate.Page
		
		'SearchPage.LoadByName("suchergebnisseite")
		SearchPage.Load(CUPage.Web.rubrics("Web").rubrics("Servicenavigation").pages("suchergebnisseite").id)
		if not SearchPage.Link = "" then
			actionLink.Text = SearchPage.Link	
		else
		
		end if
    End Sub
</script>

<form action="<asp:Literal id='actionLink' runat='server' />" id="cse-search-box">
    <input type="hidden" name="cx" value="015776976063486125748:je0nmfoxj58" />
	<input type="hidden" name="hl" value="<%=google_lang%>" />
    <input type="hidden" name="cof" value="FORID:10;NB:1" />
    <input type="hidden" name="ie" value="UTF-8" />
    <input type="text" class="search insymaHideInputValue insymaInputBlur" value="" size="31" name="q" />
	<input type="submit" class="cse-button" value="Suchen" name="sa" />
</form>
<script type="text/javascript" src="http://www.google.com/cse/brand?form=cse-search-box&lang=de">