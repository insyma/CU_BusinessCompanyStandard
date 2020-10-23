<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ''  HINU: part zur Anzeige eines Hinweises bei veralteter IE-Version(6)
       
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
  		'' Laden des Containers bei den Seiteneinstellungen
		dim cont as new contentupdate.container	
		'cont.loadByName("labelling_ie6")
		cont.load(tempPage.Load(CUPage.Web.Rubrics("Web").rubrics("Seiteneinstellungen").pages("beschriftungen").containers("labelling_ie6").id))
		cont.preview = cupage.preview
		cont.languagecode = cupage.languagecode
		ie6.visible = false
		'' wird nur aktiv, wenn entsprechende Checkbox gesetzt ist
		if cont.fields("hinweis").value = "1" then
			ie6.visible = true
		end if
		'' bastle nun den Inhalt zusammen
		ie6text.text = "<h3>" & cont.fields("titel").value & "</h3>"
		ie6text.text += "<p>" & cont.fields("text").value & "</p>"
		if cont.objectsets("linkliste").containers.count > 0 then
			ie6text.text += "<ul>"
				for each _tcon as contentupdate.container in cont.objectsets("linkliste").containers
					if not _tcon.Links("Link").Properties("description").value = "" then
						ie6text.Text += "<li>" + _tcon.links("link").tag.Replace(_tcon.Links("Link").Caption,_tcon.Links("Link").Properties("description").value).Replace("<a ","<a title='" &  _tcon.Links("Link").Properties("description").value & "' ") + "</li>"
					else
						ie6text.text += "<li>" + _tcon.links("link").tag + "</li>"
					end if
				next
			ie6text.text += "</ul>"
		end if
		
  End Sub
</script>
<!--[if lt IE 7]>
    <div class="ie6" id="ie6" runat="server">
        <asp:literal id="ie6text" runat="server" />
    </div>
<![endif]-->