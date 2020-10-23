<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<%@ Register TagPrefix="CU" Namespace="Insyma.ContentProperty.Controls" Assembly="Insyma.ContentProperty.Controls" %>
<script runat="server"> 
    Dim content As String = ""
    Dim hasTitle As Boolean = False
    Dim hasText As Boolean = False
    Dim hasImage As Boolean = False
    Dim CSSclass As String = ""
    Dim contentProperties As New Insyma.ContentProperty.Render.Domain.ContentProperties()
    dim gal as boolean = false
    Dim temp_date As String = ""
    Dim temp_title As String = ""
    Dim temp_text As String = ""
    Dim temp_img As String = ""
    Dim temp_link as string = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        'Save the type of the Page
        Dim PageType As String = ""
        Select Case CUPage.Parent.Properties("ContentPropertyID").value
            Case 3
                PageType = "Aktuelles"
            Case Else
                PageType = "UndefinedPageType"
        End Select
        
        Dim clientId As Nullable(Of Integer) = 0
        Dim objParentId As Nullable(Of Integer) = 0
        Dim objId As Nullable(Of Integer) = CUPage.Parent.Id
        contentProperties = Insyma.ContentProperty.Controls.Utility.CreateContentProperties(clientId, objParentId, objId, CUPage.LanguageCode)
        
        dim p as new contentupdate.Page()
        p.load(CUPage.Parent().id)
        p.Preview = CUpage.Preview
        p.LanguageCode = CUpage.LanguageCode
        temp_link = p.link
        
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ''  Handle Page Aktuelles 
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''  
        If PageType = "Aktuelles" Then
            
            'Set values from properties
            If (contentProperties IsNot Nothing) Then
                If contentProperties.DateContent.ToString <> "" Then
                    If contentProperties.DateContent.Value.TimeOfDay.ToString <> "00:00:00" Then
                        temp_date = "<time class=""ConTime"" datetime=""" & contentProperties.DateContent.Value.ToString("dd.MM.yyyy") & """>" & contentProperties.DateContent.Value.ToString("dd. MM yyyy") & "</time>"
                    End If
                End If
                If contentProperties.AuthorContacts IsNot Nothing AndAlso contentProperties.AuthorContacts.Count > 0 Then
                    For Each con As Insyma.ContentProperty.Render.Domain.Contact In contentProperties.AuthorContacts
                        'tempcontent += "<li><span class=""ConEditor"">" + con.Fullname + "</span></li>"
                    Next
                End If
            End If
            
            dim c as new contentupdate.container()
            c.load(CUPage.Parent.Containers("inhalt").containers("part_snippet_overview").id)
            if c.id > 0 AND c.id <> CUPage.ID then
                c.languageCode = CUPage.LanguageCode
                c.Preview = CUPage.Preview
                if not c.fields("part_snippet_overview_title").value = "" then
                    temp_title = c.fields("part_snippet_overview_title").value
                    hasTitle = True
                end if
                if not c.fields("part_snippet_overview_text").value = "" then
                    temp_text = c.fields("part_snippet_overview_text").value
                    hasText = True
                end if
                if not c.images("part_snippet_overview_img").properties("filename").value = "" then
                    temp_img = c.images("part_snippet_overview_img").processedsrc
                    hasImage = True
                end if
            end if
            if hasTitle = False AND contentProperties.ContentName <> "" then
                temp_title = contentProperties.ContentName
                hasTitle = True
            end if
            If hasTitle = False AND CUPage.Parent.Containers("settings").Fields("Seitentitel").Value <> "" Then
                temp_title = CUPage.Parent.Containers("settings").Fields("Seitentitel").Value
                hasTitle = True
            End If
            
            if hasText = False OR hasTitle = False OR hasImage = False then
                For Each con As ContentUpdate.Container In CUPage.Containers("inhalt").Containers
                    if hasImage = False then
                        For Each o As contentupdate.obj In con.GetChildObjects(6)
                            o.languageCode = CUpage.languageCode
                            o.Preview = CUPage.Preview
                            If Not o.properties("filename").value = "" AND hasImage = false Then
                                Dim oi As New ContentUpdate.Image()
                                oi.load(o.id)
                                oi.Preview = CUPage.Preview
                                temp_img += oi.processedsrc
                                hasImage = True
                            End If
                        Next
                    end if
                    If con.ObjName = "part_Basic" Then
                        For Each obj As ContentUpdate.Field In con.Fields
                            obj.LanguageCode = CUPage.languageCode
                            'Find only one Title
                            If obj.ObjName = "part_Basic_Titel" And hasTitle = False Then
                                If obj.Properties("value").Value <> "" Then
                                    temp_title = obj.Properties("value").Value
                                    hasTitle = True
                                End If
                            End If

                            'Find only one Lead (not WYSIWYG)
                            If obj.ObjName = "part_Basic_Einleitung" And hasText = False Then
                                If obj.Properties("value").Value <> "" Then
                                    temp_text = obj.Value
                                    hasText = True
                                End If
                            End If

                            If hasText = True Then
                                Exit For
                            End If

                            'Find only one Text if no Lead was found(WYSIWYG)
                            If obj.ObjName = "part_Basic_Text" And hasText = False Then
                                If obj.Properties("value").Value <> "" Then
                                    temp_text = obj.Value
                                    hasText = True
                                End If
                            End If
                        Next
                    End If
                    If hasTitle = True And hasText = True AND hasImage = true Then
                        Exit For
                    End If
                Next
			end if
            
        End If
    End Sub
</script>
<% if not temp_img = "" OR not temp_title = "" or not temp_text = "" then %>

    <a href="<%=temp_link%>" class="card-link" target="_self" title="<%=temp_title%>"></a>
    <div class="card-con">
        <div class="card-header">
            <% if not temp_img = "" then %>
            <figure class="card-image bg-img" style="background-image: url(<%=temp_img%>);">
                <img src="" alt="Bild">
            </figure>
            <% end if %>
        </div>
        <div class="card-body">
            <% if not temp_title = "" then %>
            <h3 class="h3 item-title card-title"><%=temp_title%></h3>
            <% end if %>
            <% if not temp_date = "" then %>
            <div class="lead card-lead"><%=temp_date%></div>
            <% end if %>
            <% if not temp_text = "" then %>
            <div class="liststyle card-text"><%=temp_text%></div>
            <% end if %>
        </div>
    </div>

<% end if %>