<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
Dim google_lang as String = "lang_de" 
	
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		'' aktuelle Sprache definieren
		if CUPage.LanguageCode = 1 then
			google_lang = "lang_fr"	
		elseif CUPage.LanguageCode = 2 then
			google_lang = "lang_it"	
		elseif CUPage.LanguageCode = 3 then
			google_lang = "lang_en"	
		end if

		
    End Sub
</script>
<div class="part part-suche-ergebnisse clearfix">
	<gcse:searchresults-only lr="<%=google_lang%>"></gcse:searchresults-only>
</div>