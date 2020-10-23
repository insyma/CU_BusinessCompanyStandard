<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Dim language as string
	Dim metalanguage as string

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
		
'	Abfrage Language aus dem CU-DropDown "Sprache"
'-----------------------------------------------------------------------------------------------------
'	Beim Hinzufügen von russisch, chinesisch etc. werden hier weitere Sprachen abgefragt
'	Referenz ISO Country-Code: http://de.selfhtml.org/diverses/sprachenlaenderkuerzel.htm

		language = CUPage.Languages.ActiveLanguage.name.Replace(" ","") 
		if language = "Deutsch" then 
			metalanguage = "de"
		else if language = "Français" then 
			metalanguage = "fr"
		else if language = "Italiano" then 
			metalanguage = "it"
		else if language = "English" then 
			metalanguage = "en"
		else 
			Response.Write("In >control_htmlheader.ascx< bitte die neue Sprache hinzufuegen")
		end if

    End Sub
</script>
<!DOCTYPE html>
<!--[if lt IE 7]> <html class="no-js ie6 oldie" lang="<%= metalanguage %>"> <![endif]-->
<!--[if IE 7]>    <html class="no-js ie7 oldie" lang="<%= metalanguage %>"> <![endif]-->
<!--[if IE 8]>    <html class="no-js ie8 oldie" lang="<%= metalanguage %>"> <![endif]-->
<!--[if IE 9]>    <html class="no-js ie9 oldie" lang="<%= metalanguage %>"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js" lang="<%= metalanguage %>"> <!--<![endif]-->
<head>