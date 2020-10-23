<script runat="server">
    ''FUNCTIONS Overview
    '   spacer() -> Platzhalter Bild
    '   getImg(CUImage) -> CU3 Pfad für Bilder
    '   getPath("layout" optional) -> Pfad Bild/File
    '   getCleanText(text, linkCSS otional, textCSS optional) -> Wysiwyg TextLinks / ULs / OLs
    '   getImgSize(CUImage) -> FileSystem Bild grösse

    ''INFOS    
    '   CUPage.Properties("FormURL") kann auch PublicURL sein
    Dim FORM_URL as String = "PublicURL"

    'Get cu3.ch Path //Optional for Layout images
    Function getPath(Optional ByVal type As String = "") As String
        Dim t As String = CUPage.Properties(FORM_URL).Value + "mail/"
        Select Case type
            Case "layout"
                Return t + "img/layout/"
            Case Else
                if CUPage.Preview = true then
                    Return ""
                else 
                    Return t
                end if
        End Select
    End Function

    'Get cu3.ch Path for Images
    Function getImg(ByVal img As Insyma.ContentUpdate.Image) As String
        Return CUPage.Properties(FORM_URL).Value + "mail/" + img.Properties("path").Value + "cuimgpath/" + img.ProcessedFileName
    End Function

    'Space img
    Function spacer(Optional ByVal w As String = "1", Optional ByVal h As String = "1") As String
        Dim s as String = "<img width='" & w & "' height='" & h & "' src='" & getPath("layout") & "1px.gif'  alt='*' />"
        Return s
    End Function



    Function getText(ByVal str as String, Optional ByVal linkStyle As String = "", Optional ByVal textStyle As String = "", Optional ByVal bulletStyle As String = "") as String
        'Define Stuff
        dim abstand as string = "7"
        dim bullet_img = getPath("layout")&"list-style.gif"
        'Bild oder Zeichen fuer Auflistung verwenden
        dim bullet = "<img src=""" & bullet_img & """ alt=""*"" style=""display:inline;"" width=""9"" height=""8"" />&nbsp;"
        bullet = "&bull;"

        if linkStyle <> "" then
            WYSIWYG_Link = linkStyle
        end if
        if textStyle <> "" then
            WYSIWYG_Text = textStyle
        end if
        if bulletStyle <> "" then
            WYSIWYG_Text_UL_Bullet = bulletStyle
        end if


        'Replace Stuff
        dim _t as string = ""
        dim ref0 as string = "<ul"
        dim _ref0 as string = "~"
        dim ref1 as string = "</ul>"
        dim _ref1 as string = "Â¬"
        dim ref2 as string = "<li>"
        dim _ref2 as string = "~"
        dim ref3 as string = "</li>"
        dim _ref3 as string = "Â¬"
        dim ref4 as string = "</ol>"
        dim _ref4 as string = "Â¬"

        _t = str.replace("<a", "<a style='" & WYSIWYG_Link & "'")
        if _t.contains("<ol") then
            if _t.contains("<ul") then
                dim _tu as string = _t.substring(_t.indexOf(ref0), (_t.indexOf(ref1) - _t.indexOf(ref0)) + 5)
                _t = _t.replace(_tu, _ref0)
                _tu = _tu.replace("<li>", "<table border=""0"" cellpadding=""0"" cellspacing=""0""><tr><td width='15' valign='top' style='" & WYSIWYG_Text_UL_Bullet & "' >"& bullet &"</td><td class=""text"" style='" & WYSIWYG_Text & "'>").replace("</li>", "</td></tr></table>").replace("<ul>", "").replace("</ul>", "<table border=""0"" cellpadding=""0"" cellspacing=""0""><tr><td><img src=""" & getPath("layout") & "/1px.gif"" alt='' height='" & abstand & "' width='1' /></td></tr></table>")
                _t = _t.replace(_ref0, _tu)
            end if
            Dim regex As New System.Text.RegularExpressions.Regex("<ol")
            if regex.Matches(_t).Count = 1 then
                _t = System.Text.RegularExpressions.Regex.Replace(_t, ref3, _ref3)
                dim _tt() as string = _t.split(_ref3)
                dim i as integer = 0
                for i = 0 to ubound(_tt)
                    _tt(i) = _tt(i).replace(ref2, "<table border=""0"" cellpadding=""0"" cellspacing=""0""><tr><td width='15' valign='middle' style='" & WYSIWYG_Text_OL & "'>" & (i +1).toString() & ".&nbsp;</td><td class=""text"" style='" & WYSIWYG_Text & "'>")
                next
                _t = join(_tt, "</td></tr></table>")
            else if regex.Matches(_t).Count > 1 then
                _t = System.Text.RegularExpressions.Regex.Replace(_t, ref4, _ref4)
                dim _ts() as string = _t.split(_ref4)
                dim i as integer = 0
                dim j as integer = 0
                for j = 0 to ubound(_ts)
                    _ts(j) = System.Text.RegularExpressions.Regex.Replace(_ts(j), ref3, _ref3)
                    dim _tt() as string = _ts(j).split(_ref3)
                    for i = 0 to ubound(_tt)
                        _tt(i) = _tt(i).replace(ref2, "<table border=""0"" cellpadding=""0"" cellspacing=""0""><tr><td width='15' valign='middle' style='" & WYSIWYG_Text_OL & "'>" & (i +1).toString() & ".&nbsp;</td><td class=""text"" style='" & WYSIWYG_Text & "'>")
                    next
                    _ts(j) = join(_tt, "</td></tr></table>")
                next
                _t = join(_ts, _ref4)
            end if
            _t = _t.replace("<ol>", "").replace("</ol>", "<table border=""0"" cellpadding=""0"" cellspacing=""0""><tr><td style=""mso-table-lspace:0pt; mso-table-rspace:0pt; font-size:1px; line-height:1px;""><img src=""" & getPath("layout") & "/1px.gif"" style=""display:block;"" alt='' height='" & abstand & "' width='1' /></td></tr></table>").replace(_ref4, "<table border=""0"" cellpadding=""0"" cellspacing=""0""><tr><td><img src=""" & getPath("layout") & "/1px.gif"" style=""display:block;"" alt='' height='7' width='1' /></td></tr></table>")
        else
            _t = _t.replace("<li>", "<table border=""0"" cellpadding=""0"" cellspacing=""0""><tr><td width='15' valign='top' style='" & WYSIWYG_Text_UL_Bullet & "'>&bull;</td><td class=""text"" style='" & WYSIWYG_Text & "'>").replace("</li>", "</td></tr></table>").replace("<ul>", "").replace("</ul>", "<table border=""0"" cellpadding=""0"" cellspacing=""0""><tr><td style=""mso-table-lspace:0pt; mso-table-rspace:0pt; font-size:1px; line-height:1px;""><img src=""" & getPath("layout") & "/1px.gif"" style=""display:block;"" alt='' height='" & abstand & "' width='1' /></td></tr></table>")
        end if
        return _t.replace("[rsquo]", "&#39;")
    End Function


    'Gets Image size form filesystem
    Function getImgSize(ByVal img as Insyma.ContentUpdate.Image) as ImageSize
        Dim imgSrc As String = img.PathInfo.LocalPath
        Dim myObj As New ImageSize()
        If System.IO.File.Exists(imgSrc) Then
            Using imgBitmap As New System.Drawing.Bitmap(imgSrc)
                myObj.width = imgBitmap.Size.Width
                myObj.height = imgBitmap.Size.Height
            End Using
        else
            myObj.width = 0
            myObj.height = 0
        End If
        Return myObj
    End Function

    Class ImageSize
        Public width As String
        Public height As String
    End Class
</script>
