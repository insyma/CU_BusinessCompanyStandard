<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Register TagPrefix="CU" Namespace="Insyma.ContentProperty.Controls" Assembly="Insyma.ContentProperty.Controls" %>
<script runat="server"> 
    dim str as string = ""
    Dim i As Integer = 0

    Dim contentProperties As New Insyma.ContentProperty.Render.Domain.ContentProperties()
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        dim webrub as new contentupdate.obj()
        webrub.load(CUPage.Web.rubrics("Web").id)
        For Each tCon As contentupdate.obj In webrub.GetChildObjects(4)
            'response.write("<br />:::" & tcon.ObjName)     
            If tCon.ObjName.Contains("part_contentlist") = True Then
                For Each tPages As contentupdate.obj In tcon.GetChildObjects(3)
                    If tPages.Objname.contains("generateonlycontent") = false AND tPages.Objname.contains("jobs_") = false AND tPages.Objname.contains("news_") = false AND tPages.Objname.contains("CaptchaPage") = false Then
                        Dim ppage As New contentupdate.page()
                        ppage.load(tPages.id)
                        If ppage.Publish(CUPage.LanguageCode) = True Then
                            'Response.Write(":::" & tPages.Id)
                            str += getJSONValues(tPages) & ","
                        End If
                    End If
                Next
            End If
        Next

        str = str.TrimEnd(",")
    End Sub

    Function getJSONValues(aPage)
        dim p0 as new contentupdate.Page()
        p0.load(aPage.ID)
        p0.preview = true
        p0.LanguageCode = CUPage.LanguageCode
        dim ret as string = ""
        ret += "{""Id"":" & i.toString() & ","
        i += 1
        ret += """PageId"":" & aPage.ID & ","
        ret += """ConId"":" & aPage.ParentID & ","
        
        ret += """URL_Prev_Detail"":""" & p0.Link & ""","
        p0.preview = false
        ret += """URL_Live_Detail"":""" & p0.Link & ""","

        p0.load(p0.pages("generateonlycontent").id)
        p0.preview = true
        p0.LanguageCode = CUPage.LanguageCode
        
        ret += """URL_Prev_Snippet"":""" & p0.Link & ""","
        p0.preview = false
        ret += """URL_Live_Snippet"":""" & p0.Link & ""","


        Dim clientId As Nullable(Of Integer) = 0
        Dim objParentId As Nullable(Of Integer) = 0
        Dim objId As Nullable(Of Integer) = aPage.Id

        contentProperties = Insyma.ContentProperty.Controls.Utility.CreateContentProperties(clientId, objParentId, objId, CUPage.LanguageCode)
        
        dim tempcontent as string = ""
        If contentProperties IsNot Nothing Then
            If contentProperties.AuthorContacts IsNot Nothing AndAlso contentProperties.AuthorContacts.Count > 0 Then
                For Each con As Insyma.ContentProperty.Render.Domain.Contact In contentProperties.AuthorContacts
                    tempcontent += con.Fullname + "#"
                Next
                If tempcontent.length > 2 Then
                    tempcontent = tempcontent.substring(0, tempcontent.length - 1)
                End If
            End If
            ret += """Author"":""" & tempcontent & ""","
            tempcontent = ""
            If contentProperties.DateContent.ToString <> "" Then
                If contentProperties.DateContent.Value.TimeOfDay.ToString <> "00:00:00" Then
                    tempcontent = contentProperties.DateContent.Value.ToString("dd.MM.yyyy") & "#"
                End If
                If tempcontent.length > 2 Then
                    tempcontent = tempcontent.substring(0, tempcontent.length - 1)
                End If
            End If
            ret += """DateContent"":""" & tempcontent & ""","
            tempcontent = ""
            tempcontent = Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.DateValidFrom, "dd.MM.yyyy")
            ret += """DateValidFrom"":""" & tempcontent.replace("<span class=""content-property-empty""></span>", "") & ""","
            tempcontent = Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.DateValidTo, "dd.MM.yyyy")
            ret += """DateValidTo"":""" & tempcontent.replace("<span class=""content-property-empty""></span>", "") & ""","
            tempcontent = Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.DateAppointmentFrom, "dd.MM.yyyy")
            ret += """DateAppFrom"":""" & tempcontent.replace("<span class=""content-property-empty""></span>", "") & ""","
            tempcontent = Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.DateAppointmentTo, "dd.MM.yyyy")
            ret += """DateAppTo"":""" & tempcontent.replace("<span class=""content-property-empty""></span>", "") & ""","
            tempcontent = ""
            If contentProperties.Origins IsNot Nothing AndAlso contentProperties.Origins.Count > 0 Then
                tempcontent = Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.Origins, "ASC", "#")
            End If
            ret += """Origin"":""" & tempcontent & ""","
            tempcontent = ""
            If contentProperties.Dossier IsNot Nothing AndAlso contentProperties.Dossier.Count > 0 Then
                tempcontent = Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.Dossier, "ASC", "#")
            End If
            ret += """Company"":""" & tempcontent & ""","
            If contentProperties.Tags.ToString <> "" Then
                tempcontent = Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.Tags, "ASC", "#")
            End If
            ret += """Tags"":""" & tempcontent.replace("<span class=""content-property-empty""></span>", "") & ""","
            If contentProperties.Themes.ToString <> "" Then
                tempcontent = Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.Themes, "ASC", "#")
            End If
            ret += """Themes"":""" & tempcontent.replace("<span class=""content-property-empty""></span>", "") & ""","
            If contentProperties.Types.ToString <> "" Then
                tempcontent = Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.Types, "ASC", "#")
            End If
            ret += """Types"":""" & tempcontent.replace("<span class=""content-property-empty""></span>", "") & ""","
            tempcontent = ""
            Try
                If contentProperties.ContentName.ToString <> "" Then
                    tempcontent = contentProperties.ContentName
                End If
            Catch
            End Try
            ret += """Title"":""" & tempcontent.replace("""", "") & """"
        Else
            ret += """Author"":""" & tempcontent & ""","
            ret += """DateContent"":""" & tempcontent & ""","
            ret += """DateValidFrom"":""" & tempcontent & ""","
            ret += """DateValidTo"":""" & tempcontent & ""","
            ret += """DateAppFrom"":""" & tempcontent & ""","
            ret += """DateAppTo"":""" & tempcontent & ""","
            ret += """Origin"":""" & tempcontent & ""","
            ret += """Company"":""" & tempcontent & ""","
            ret += """Tags"":""" & tempcontent & ""","
            ret += """Themes"":""" & tempcontent & ""","
            ret += """Types"":""" & tempcontent & ""","
            ret += """Title"":""" & tempcontent & """"
        End If

        If ret.Length > 3 Then
            Return ret & "}"
        End If
    End Function
</script>
{
	"Data":[ <%=str%>],
    "Comments" : [{
        "Id": "eindeutige ID intern / fortlaufend",
        "PageId": "CU-ID der Detailseite",
        "ConId": "CU-ID des Contentlist-Objektes",
        "URL_Prev_Detail" : "URL Detailseite Preview",
        "URL_Live_Detail" : "URL Detailseite Live",
        "URL_Prev_Snippet" : "URL Snippet Overview Preview",
        "URL_Live_Snippet" : "URL Snippet Overview Live",
        "Author" : "Author",
        "DateContent" : "Datum Inhalt",
        "DateValidFrom" : "gültig ab",
        "DateValidTo" : "gültig bis",
        "DateAppFrom" : "Termin/Treffen ab",
        "DateAppTo" : "Termin/Treffen bis",
        "Origin" : "Herkunft",
        "Company" : "Firma",
        "Tags" : "Stichwörter",
        "Themes" : "Themen",
        "Types" : "Inhaltstyp",
        "Title" : "Titel"
    }]
}
