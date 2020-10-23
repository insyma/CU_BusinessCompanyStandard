<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: generierung einer Movie-XML-Sitemap
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim livepath as string = ""
Dim lang as integer = 0
dim _tPage as new contentupdate.page
dim _tCon as new contentupdate.container
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		
		'Zusammenbau des Live-Pfades'
		livepath = "http://" & cupage.web.properties("LiveServer").value
		if not cupage.web.properties("LivePath").value = "" then
			if cupage.web.properties("LivePath").value.IndexOf("/") > 0 then
				livepath += "/" & cupage.web.properties("LivePath").value
			else
				livepath += cupage.web.properties("LivePath").value
			end if	
		end if
		if livepath.EndsWith("/") = true
			livepath = livepath.SubString(0,livepath.length-1)
		end if
		' Laden des Webobjektes'
		dim webobj as new contentupdate.obj
		webobj.loadByName("web")
		webobj.languagecode = CUpage.languagecode
		webobj.preview = cupage.preview
		'' Untersuche JEDE Seite unterhalb des Webobjektes
		for each _tPage as contentupdate.obj in webobj.GetChildObjects(3)
			_CheckSite(_tPage.Id)
		next
		'' Ausgabe XML-Header
		lit_header.text = "<urlset xmlns=""http://www.sitemaps.org/schemas/sitemap/0.9""" & vbCrLf & "xmlns:video=""http://www.google.com/schemas/sitemap-video/1.1"">"
    End Sub
	
	'' Funktion zur Suche und Ausgabe der Movies
	Function _CheckSite(PageId as integer)
		_tPage.load(PageId)
		for each container as ContentUpdate.Container in _tPage.Containers("inhalt").containers
			'' gehe alle Container im Inhalt durch und schaue ob Movie-Part integriert
			if container.ObjName = "part_movie" then
				if container.containers("movie").id > 0 then
					if not container.containers("movie").files("movie").filename = "" then
						'' Wenn Movie gefunden
						_getValues(container.containers("movie").id)
					end if
				end if
			end if
		next
	End Function
	
	'' FUnktion zur Generierung der XML-Nodes
	Function _getValues(ConId as integer)
		_tCon.load(ConId)
		_tcon.languagecode = cupage.languagecode
		rubric.text += "<url>" & vbCrLf
		rubric.text += vbtab & "<loc>" & _tPage.AbsoluteLink & "</loc>" & vbCrLf
		rubric.text += vbtab & "<video:video>" & vbCrLf
		rubric.text += vbtab & vbTab & "<video:content_loc>" & livepath & _tCon.Files("movie").Properties("Path").value & _tCon.Files("movie").Filename & "</video:content_loc>" & vbCrLf
		rubric.text += vbtab & vbTab & "<video:thumbnail_loc>" & livepath & _tCon.Images("previewimg").Properties("path").value & _tCon.Images("previewimg").Processedfilename & "</video:thumbnail_loc>" & vbCrLf
		rubric.text += vbtab & vbTab & "<video:title>" & _tCon.Caption & "</video:title>" & vbCrLf
		rubric.text += vbtab & vbTab & "<video:description>" & _tCon.Containers("metatags").fields("metatitle").value & "</video:description>" & vbCrLf
		rubric.text += vbtab & "</video:video>" & vbCrLf
		rubric.text += "</url>" & vbCrLf
	End Function
	
	
</script>

<asp:literal id="lit_header" runat="server" />
<asp:Literal id="rubric" runat="server" />
</urlset>