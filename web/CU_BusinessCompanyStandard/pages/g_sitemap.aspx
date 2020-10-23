<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: generierung einer Google-XML-Sitemap
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim livepath as string = "[projekt]"
Dim lang as integer = 0
dim _tPage as new contentupdate.page
dim _tCon as new contentupdate.container
''algemeine Parameter
dim frequenz as string = "weekly"
dim prio as string = "0.5"
dim timestamp
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    	'' sollten bei den im SettingsContainer ein Wert für die Priorität einstellbar sein
		if cupage.containers("settings").id > 0 then
			if not cupage.containers("settings").fields("priority").value = "" then
				prio = cupage.containers("settings").fields("priority").value
			end if
			if not cupage.containers("settings").fields("frequenz").value = "" then
				frequenz = cupage.containers("settings").fields("frequenz").value
			end if
		end if
		'heutiges Datum'
		timestamp = Format(now(),"yyyy-MM-dd")
		'' Laden des Web-Objektes(im Regelfall die oberste Instanz für die Inhalte) - muss möglicherweise bei einem Zweitweb im CU auf ID oder anderen Namen angepasst werden
		dim webobj as new contentupdate.obj
		webobj.load(CUPage.Web.rubrics("Web").id)
		webobj.languagecode = CUpage.languagecode
		webobj.preview = cupage.preview
		'' Durchgehen aller Page-Objekte unter dem Webobjekt
		for each _tPage as contentupdate.obj in webobj.GetChildObjects(3)
			'' Aufruf Funktion zur Erstellung 
			_getValues(_tPage.Id)
		next
		'' Header für valides Google-XML
		lit_header.text = "<?xml version=""1.0"" encoding=""UTF-8""?>" & vbCrLf & "<urlset xmlns=""http://www.sitemaps.org/schemas/sitemap/0.9"">"
    End Sub
	
	Function _getValues(PageId as integer)
		'' LAden der übergebenen Seite
		_tPage.load(PageId)
		_tPage.languagecode = cupage.languagecode
		_tPage.Preview = false
		'Ausnahmen: 
		''	leerer Filename(z.B. bei Labelcontainern)
		''	Werte mit eckigen Klammern(Masterseiten mit Schema zur Filename-Generierung)
		''	INC-Daten(Includes welche vom Server eh nicht ausgeliefert werden)
		'' 	HTML-Dateien für Includes(welche nicht nur als SSI, sondern auch für AJAX benutzt werden können)
		'' 	JS-Dateien
		if _tPage.Status_Obj = 1 and _tPage.properties("filename").value <> "" AND instr(_tPage.properties("filename").value, "[") = 0 AND instr(_tPage.properties("filename").value, ".inc") = 0 AND instr(_tPage.properties("filename").value, ".html") = 0 AND instr(_tPage.properties("filename").value, ".js") = 0  AND _tPage.containers("metatags").fields("meta_index_follow").value = "" then
			rubric.text += "<url>" & vbCrLf
			rubric.text += vbtab & "<loc>" & _tPage.AbsoluteLink & "</loc>" & vbCrLf
			rubric.text += vbtab & "<lastmod>" & timestamp & "</lastmod>" & vbCrLf
			rubric.text += vbTab & "<changefreq>" & frequenz & "</changefreq>" & vbCrLf
			rubric.text += vbTab & "<priority>" & prio & "</priority>" & vbCrLf
			rubric.text += "</url>" & vbCrLf
		end if
	End Function
	
	
</script>

<asp:literal id="lit_header" runat="server" />
<asp:Literal id="rubric" runat="server" />
</urlset>