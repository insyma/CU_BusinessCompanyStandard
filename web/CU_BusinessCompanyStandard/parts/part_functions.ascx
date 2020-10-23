<script runat="server">

'' Abfrage auf alle Textfelder, welche in dem part vorhanden sind( ObjectClass 5 = Textfeld)
function _checkTextFields(aId as Integer)
	dim ret as boolean = false
	dim c as new contentupdate.container()
	c.load(aId)
	for each o as contentupdate.obj in c.GetChildObjects(5)
		if not o.properties("wysiwyg").value = "3" AND not o.properties("wysiwyg").value = "2" then
			dim f as new contentupdate.field()
	        f.load(o.id)
	        f.languageCode = CUpage.languageCode
	        if not f.value = "" then
	            ret = true
	            exit for
	        end if
	    end if
    next
    return ret
end function

'' Abfrage auf alle Bilder, welche in dem part vorhanden sind( ObjectClass 6 = Image)
function _checkImages(aId as Integer)
	dim ret as boolean = false
	dim c as new contentupdate.container()
	c.load(aId)
	for each o as contentupdate.obj in c.GetChildObjects(6)
        o.languageCode = CUpage.languageCode
        if not o.properties("filename").value = "" then
            ret = true
            exit for
        end if
    next
    return ret
end function

'' Abfrage auf alle Files, welche in dem part vorhanden sind( ObjectClass 9 = File)
function _checkFiles(aId as Integer)
	dim ret as boolean = false
	dim c as new contentupdate.container()
	c.load(aId)
	for each o as contentupdate.obj in c.GetChildObjects(9)
        o.languageCode = CUpage.languageCode
        if not o.properties("filename").value = "" then
            ret = true
            exit for
        end if
    next
    return ret
end function

'' Abfrage auf alle Links, welche in dem part vorhanden sind( ObjectClass 12 = File)
function _checkLinks(aId as Integer)
	dim ret as boolean = false
	dim c as new contentupdate.container()
	c.load(aId)
	for each o as contentupdate.obj in c.GetChildObjects(12)
        o.languageCode = CUpage.languageCode
        if not o.properties("value").value = "" then
            ret = true
            exit for
        end if
    next
    return ret
end function

function getPositioninContent(aConId as Integer, aId as Integer)
	dim c as new contentupdate.Container()
	c.load(aConId)
	dim i as integer = 0
	for each cc as contentupdate.container in c.containers
		i += 1
		if cc.id = aId then
			return i
			exit for
		end if
	next
	return 0
end function

Sub StandardBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
   	If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
		Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
		con.LanguageCode = CUPage.LanguageCode
		con.Preview = CUPage.Preview
	End If
End Sub
</script>
