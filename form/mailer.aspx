<%@ Page Language="VB" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Import Namespace="Insyma"  %>
<%@ Import Namespace="Insyma.ContentUpdate"  %>
<%@ Import Namespace="Insyma.MessageHandler"  %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">

    Dim SendMail As New Insyma.MessageHandler.SendMessage
    dim fo as new contentupdate.container()
    dim fo_user as new contentupdate.container()
    dim fo_intern as new contentupdate.container()
    Dim mSender As String = ""
    Dim mRecipient As String = ""
    Dim mSubject As String = ""

    Dim mBody As String = ""
    Dim mHBody As String = ""
    Dim mRedirectURL As String = ""
    Dim mLanguageID As Integer

    dim conversion as string = ""

    Dim Formular As ContentUpdate.Form
    Dim FormField As ContentUpdate.Field
    Dim formularID As String
    Dim formObjName As String
    Dim formObjCaption As String
    Dim formHiddenValue As String

    Dim delimStr As String = ","
    Dim delimiter As Char() = delimStr.ToCharArray()
    Dim split As String() = Nothing
    Dim mAlias as string = ""
    Dim aRecipient As List(Of String)

    Dim strDankesText_user as String
    Dim strSalutationText_user as String
    Dim strDankesText_intern as String
    Dim strSalutationText_intern as String
    dim art as string = "0"

    dim testcontent as string = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        Try
            ' Required captcha
            If Not Request.Form("Captcha") Is Nothing then
                dim captcha as string = ""
                captcha = Request.Form(Request.Form("Captcha"))

                dim storedCaptcha as string = ""
                dim uniqueKey as string = ""
                uniqueKey= Request.Form("CaptchaUniqueKey")

                if Not string.IsNullOrEmpty(uniqueKey) then
                    storedCaptcha = ContentUpdate.UtilCaptcha.GetCaptcha(uniqueKey)
                end if

                if string.IsNullOrEmpty(storedCaptcha) and Not Session("CUCaptchaText") is nothing then
                    storedCaptcha = Session("CUCaptchaText")
                end if

                ' Value is invalid
                If  (string.IsNullOrEmpty(captcha) OR Not storedCaptcha.Equals(captcha)) Then
                    Dim _tRedirect As String = ""
                    If (Not Request.Form("CaptchaErrorUrl").Equals("")) Then
                        _tRedirect = Request.Form("CaptchaErrorUrl")
                        If (Not _tRedirect.StartsWith("http")) Then
                            _tRedirect = Request.UrlReferrer.ToString()
                            _tRedirect = _tRedirect.Substring(0, _tRedirect.LastIndexOf("/") + 1) & Request.Form("CaptchaErrorUrl")
                        End If
                    Else
                        _tRedirect = Request.UrlReferrer.ToString().Replace("&Captcha=false", "").Replace("?Captcha=false", "").Replace("&thanks=1", "").Replace("?thanks=1", "")
                        If (_tRedirect.Contains("?")) Then
                            _tRedirect &= "&Captcha=false"
                        Else
                            _tRedirect &= "?Captcha=false"
                        End If
                    End If

                    Response.Redirect(_tRedirect, True)
                    'Response.Write("<br />Redirect:"  & _tRedirect)
                    Response.End()
                End If
            End If

        Catch ex As Exception
            'Response.Write("<br />Catch ex::" & ex.Message)
            'Response.End()
        End Try

        formularID = Request.QueryString("Form_id")
        mLanguageID = CInt(Request.QueryString("lang"))
        aRecipient = New List(Of String)

        ' Ohne Formular ID kann kein Formular versandt werden
        If formularID <> "" Then
            Formular = New ContentUpdate.Form()
            Formular.LanguageCode = mLanguageID.ToString()
            Formular.Load(formularID)

            fo.Load(Formular.Containers("EmailTexte").Id)
            fo_user.load(Formular.Containers("labelling").Id)
            fo_intern.load(Formular.Containers("labellingintern").Id)
            fo.LanguageCode = mLanguageID
            fo_user.LanguageCode = mLanguageID
            fo_intern.LanguageCode = mLanguageID
            if fo.fields("form_conversiontrack").Id <> 0 Then
                conversion = fo.fields("form_conversiontrack").value
            end if
            if not fo.fields("email_alias").value = "" then
                mAlias = fo.fields("email_alias").value
            end if
            mHBody = "<table border='0' cellspacing='1' cellpadding='5'>"
            ' Fuer jeden Container im Formular
            For Each CUContainer As ContentUpdate.Container In Formular.Containers
                ' Titel pro Container
                For Each AreaField As ContentUpdate.Field In CUContainer.Fields
                    If AreaField.ObjName = "title" Or AreaField.ObjName = "titel" Then
                        mBody += vbCrLf & AreaField.Value & vbCrLf
                        mBody += "----------------------------------------------------" & vbCrLf
                    End If
                Next

                ' Felder (Fragen) pro Container
                For Each question As ContentUpdate.Question In CUContainer.Questions
                    formObjName = question.ObjName
                    formObjCaption = question.Caption
                    mHBody += "<tr>"
                    If question.Properties("QuestionType").Value = "0" Then
                        ' Radiobutton oder Checkbox
                        If Not question.Properties("MultipleAnswer").Value = "1" Then
                            'Radiobutton
                            'mBody = mBody & Left(formObjCaption & ":" & Space(15), 15) & " "
                            mBody = mBody & UtilCommon.StringToMultiLine(formObjCaption, 25) & ": "
                            mHBody += "<td>" & formObjCaption & "</td><td>"
                            If Not (Request.Form(question.ObjName) = "") Then
                                If (question.ObjName = "SalutationID") Then
                                    Select Case Request.Form(question.ObjName)
                                        Case "1"
                                            If mLanguageID = 0 Then
                                                mBody += "Herr" & vbCrLf
                                                mHBody += "Herr</td>"
                                            Else
                                                mBody += "Monsieur" & vbCrLf
                                                mHBody += "Monsieur</td>"
                                            End If
                                        Case "2"
                                            If mLanguageID = 0 Then
                                                mBody += "Frau" & vbCrLf
                                                mHBody += "Frau</td>"
                                            Else
                                                mBody += "Madame" & vbCrLf
                                                mHBody += "Madame</td>"
                                            End If
                                        Case Else
                                            mBody += Request.Form(question.ObjName) & vbCrLf
                                            mHBody += Request.Form(question.ObjName) & "</td>"
                                    End Select
                                Else
                                    mBody += Request.Form(question.ObjName) & vbCrLf
                                    mHBody += Request.Form(question.ObjName) & "</td>"
                                End If
                            Else
                                mBody = mBody & vbCrLf
                            End If
                        Else
                            'Checkbox
                            Dim showQuestion As Boolean = False
                            Dim CheckBoxString As String = ""
                            'CheckBoxString += vbCrLf & question.Caption & vbCrLf
                            CheckBoxString += vbCrLf & UtilCommon.StringToMultiLine(question.Caption,15) & ": "  & vbCrLf
                            mHBody += "<td>" & question.Caption & "</td><td>"
                            dim HCheckBoxString as string = ""
                            For Each AnswerField As ContentUpdate.Answer In question.Answers
                                ' Chekcbox name: Me.Parent.ObjName & Me.ObjName
                                If (AnswerField.ObjName = "CatTopicID") Then
                                    split = Request.Form(AnswerField.Parent.ObjName & "CatTopicID").Split(delimiter)
                                    Dim s As String
                                    For Each s In split
                                        If AnswerField.Value = s Then
                                            showQuestion = True
                                            CheckBoxString += Space(2) & "- " & AnswerField.Caption & vbCrLf
                                            HCheckBoxString += "- " & AnswerField.Caption & "<br />"
                                        End If
                                    Next
                                Else
                                    If Not (Request.Form(AnswerField.Parent.ObjName & AnswerField.ObjName) = "") Then
                                        showQuestion = True
                                        CheckBoxString += Space(2) & "- " & AnswerField.Caption & vbCrLf
                                        HCheckBoxString += "- " & AnswerField.Caption & "<br />"
                                    End If
                                End If
                            Next
                            If showQuestion Then
                                mBody += CheckBoxString
                                mHBody += HCheckBoxString & "</td>"
                            End If
                        End If
                    ElseIf question.Properties("QuestionType").Value = "5" Then
                        ' a TopicFields(checkbox, radiobutton) question, check if any item is selected, send an email
                        'mBody += Left(formObjCaption & ":" & Space(15), 15) & " " & Request.Form(formObjName) & vbCrLf
                        mBody += UtilCommon.StringToMultiLine(formObjCaption, 15) & ": " & Request.Form(formObjName) & vbCrLf
                        mHBody += "<td>" & formObjCaption & "</td><td>" & Request.Form(formObjName) & "<br />"
                        For Each AnswerField As ContentUpdate.Answer In question.Answers
                            If question.Properties("MultipleAnswer").Value = "1" Then
                                ' Chekcbox name: Me.Parent.ObjName & Me.ObjName
                                If AnswerField.Value = Request.Form(AnswerField.Parent.ObjName & AnswerField.ObjName) Then
                                    'JAKN Add only if an Emailaddress exists
                                    If (Not AnswerField.Properties("TextAnswer").Value.Equals("")) Then
                                        aRecipient.Add(AnswerField.Properties("TextAnswer").Value)
                                    End If
                                    mBody += Space(2) & "- " & AnswerField.Caption & vbCrLf
                                    mHBody += "- " & AnswerField.Caption & "<br />"
                                End If
                            Else
                                If AnswerField.Value = Request.Form(question.ObjName) Then
                                    'JAKN Add only if an Emailaddress exists
                                    If (Not AnswerField.Properties("TextAnswer").Value.Equals("")) Then
                                        aRecipient.Add(AnswerField.Properties("TextAnswer").Value)
                                    End If
                                    mBody += Space(2) & "- " & AnswerField.Caption & vbCrLf
                                    mHBody += "- " & AnswerField.Caption & "<br />"
                                End If
                            End If
                        Next
                        mBody += vbCrLf
                        mHBody += "</td>"
                    ElseIf question.Properties("QuestionType").Value = "6" Then
                        ' a TopicList (display as Dropdown) question, check if any item is selected, send an email
                        'mBody += Left(formObjCaption & ":" & Space(15), 15) & " " & Request.Form(formObjName) & vbCrLf
                        'mBody += UtilCommon.StringToMultiLine(formObjCaption, 15) & ": " & Request.Form(formObjName) & vbCrLf

                        For Each AnswerField As ContentUpdate.Answer In question.Answers
                            If AnswerField.Value = Request.Form(formObjName) Then
                                mBody += UtilCommon.StringToMultiLine(formObjCaption, 15) & ": " & AnswerField.Caption  & vbCrLf
                                mHBody += "<td>" & formObjCaption & "</td><td>" & AnswerField.Caption & "</td>"
                                If (Not AnswerField.Properties("TextAnswer").Value.Equals("")) Then
                                    aRecipient.Add(AnswerField.Properties("TextAnswer").Value)
                                End If
                            End If
                        Next
                    ElseIf question.Properties("QuestionType").Value = "8" Then
                        mBody += UtilCommon.StringToMultiLine(formObjCaption, 15) & vbCrlf & vbCrlf
                        mHBody += "<td colspan='2'><strong>" & formObjCaption & "</strong></td>"
                    Else
                        'mBody += Left(formObjCaption & ":" & Space(15), 15) & " "
                        mBody += UtilCommon.StringToMultiLine(formObjCaption, 15) & ": "
                        mHBody += "<td width='200'>" & formObjCaption & "</td>"
                        ' Textbox oder Dropdown
                        If question.Properties("HiddenValue").Value = "1" Then
                            If Not Request.Form(formObjName) = "" Then
                                FormField = New ContentUpdate.Field()
                                FormField.Load(CInt(Request.Form(formObjName)))
                                formHiddenValue = FormField.Value
                            End If
                            mBody += formHiddenValue & vbCrLf
                            mHBody += "<td>" & formHiddenValue & "</td>"
                        Else
                            mBody += Utility.userDataDecode(Request.Form(formObjName)) & vbCrLf
                            mHBody += "<td>" & Request.Form(formObjName).Replace(Environment.NewLine, "<br/>") & "</td>"
                        End If
                    End If
                    mHBody += "</tr>"
                Next
            Next
            mHBody += "</table>"
            mHBody = mHBody.replace("&apos;", "'")

            dim source as string = ""
            dim mail_senden as boolean = true
            If Not Request.UrlReferrer Is Nothing Then
                source = Request.UrlReferrer.ToString()
            end if
            if Request.Form("Email") <> "" AND checkMail(Request.Form("Email")) = false then
                mail_senden = false
            end if
            if Request.Form("Address") isnot nothing
                if Request.Form("Address") <> "" AND Request.Form("Address").contains("http") = true then
                    mail_senden = false
                end if
            end if
            if (source.Contains("domain.ch") = true OR source.Contains("contentupdate.net") = true) AND mail_senden = true then
                ' Mail versenden
                if not fo.fields("email_intern").value = "" then
                    Mail_Send()
                end if

                'Kontakt speichern?!'
                'SaveContact


                ' Confirmation Mail versenden
                if not fo.fields("email_to_customer").value = "" Then
                    'Mail_Send_Confirmation()
                End if
                For Each recip As String In aRecipient
                    'Send_Mail_ByTopic(recip)
                Next
            Else
                SaveWithoutMail()
            end if



            

            


            ' Redirect
            dim red as string = ""
            If Formular.Properties("Redirect").Value <> "" Then
                red = Formular.Properties("Redirect").Value
                if red.Contains("?") = True Then
                    red += "&form=" & conversion
                Else
                    red += "?form=" & conversion
                end if
                Response.Redirect(red)
            ElseIf Request.Form("Redirect") <> "" Then
                red = Request.Form("Redirect")
                if red.Contains("?") = True Then
                    red += "&form=" & conversion
                Else
                    red += "?form=" & conversion
                end if
                Response.Redirect(red)
            Else
                If Not Request.UrlReferrer Is Nothing Then
                    If Request.UrlReferrer.ToString.Contains("?") = True Then
                        Response.Redirect(Request.UrlReferrer.ToString() & "&thanks=" & art & "&form=" & conversion)
                    Else
                        Response.Redirect(Request.UrlReferrer.ToString() & "?thanks=" & art & "&form=" & conversion)
                    End If
                End If
            End If
        End If
    End Sub
    Function checkMail(aEmail)
        dim mails as string() = {"@talkwithwebvisitor.com",".ru", "@qq.com", ".xyz"}
        For Each entry As String In mails
            if aEmail.EndsWith(entry)
                return false
            end if
        Next
        return true
    End Function
    Sub Mail_Send()
        response.write("mail an intern ")
        ' Sender
        If Request.Form("Sender") <> "" Then
            mSender = Request.Form("Sender")
        Else
            mSender = Formular.Properties("sender").Value
        End If
        If Request.Form("Email") <> "" Then
            'mSender = Request.Form("Email")
        End If

        ' Subject
        If Request.Form("Subject") <> "" Then
            mSubject = Request.Form("Subject")
        Else
            mSubject = Formular.Properties("Subject").Value
        End If
        if not fo_intern.fields("con_betreff_0").value = "" then
            mSubject = fo_intern.fields("con_betreff_0").value
        end if
        ' Recipient
        If formHiddenValue <> "" Then
            mRecipient = formHiddenValue
        Else
            If Request.Form("Recipient") <> "" Then
                mRecipient = Request.Form("Recipient")
            Else
                mRecipient = Formular.Properties("Recipient").Value
            End If
        End If

        ' Redirect
        If Request.Form("Redirect") <> "" Then
            mRedirectURL = Request.Form("Redirect")
        Else
            If Formular.Properties("Redirect").Value <> "" Then
                mRedirectURL = Formular.Properties("Redirect").Value
            End If
        End If

        ' Redirect
        If Request.Form("Redirect") <> "" Then
            mRedirectURL = Request.Form("Redirect")
        Else
            If Formular.Properties("Redirect").Value <> "" Then
                mRedirectURL = Formular.Properties("Redirect").Value
            Else
                If Not Request.UrlReferrer Is Nothing Then
                    mRedirectURL = Request.UrlReferrer.ToString()

                    mRedirectURL = mRedirectURL.Replace("&thanks=", "&")
                    mRedirectURL = mRedirectURL.Replace("?thanks=", "?")
                    If mRedirectURL.IndexOf("?") = -1 Then
                        mRedirectURL = mRedirectURL + "?"
                    Else
                        mRedirectURL = mRedirectURL + "&"
                    End If
                    mRedirectURL += "thanks=1"
                Else
                    mRedirectURL += "www.landi.ch"
                End If
            End If
        End If
        if not mAlias = "" then
            SendMail.SenderAlias = mAlias & " "
        end if
        SendMail.IsSavedToDB = True
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        SendMail.Sender = mSender
        SendMail.Recipient = mRecipient
        SendMail.BCCRecipient = "uwe.hinze@gmx.ch"
        SendMail.CCRecipient = "uwe.hinze@insyma.com"

        SendMail.Subject = mSubject
        Dim html as string = "<html><head><style> body, div, p, td { font-family: Arial; } td{ line-height: 20px; vertical-align: top; }</style></head><body>"
        dim bodystring as string = ""
        if not fo_intern.fields("emailfelderinemail").value = "" then
            bodystring = mHBody
        end if
        dim complete as string = html & fo_intern.fields("textvorfelder_0").value &  bodystring & fo_intern.fields("textnachfelder_0").value & "</body></html>"
        SendMail.Body = complete
        SendMail.LanguageID = mLanguageID
        SendMail.ObjID = formularID
        SendMail.FormURL = mRedirectURL.Replace("?thanks=", "_")
        SendMail.RedirectURL = mRedirectURL
        SendMail.HTML = true
        'testcontent = complete
        SendMail.Send()
    End Sub
    Sub SaveWithoutMail()
        response.write("SaveWithoutMail")
        ' Sender
        If Request.Form("Sender") <> "" Then
            mSender = Request.Form("Sender")
        Else
            mSender = Formular.Properties("sender").Value
        End If
        
        
        ' Subject
        If Request.Form("Subject") <> "" Then
            mSubject = Request.Form("Subject")
        Else
            mSubject = Formular.Properties("Subject").Value
        End If
        
       
                                
        ' Redirect
        If Request.Form("Redirect") <> "" Then
            mRedirectURL = Request.Form("Redirect")
        Else
            If Formular.Properties("Redirect").Value <> "" Then
                mRedirectURL = Formular.Properties("Redirect").Value
            End If
        End If
        
        ' Redirect
        
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        SendMail.Sender = mSender
        SendMail.Recipient = "junkmail@insyma.com"
        SendMail.Subject = "MARKED:" & mSubject
        SendMail.Body = mBody
        SendMail.LanguageID = mLanguageID
        SendMail.ObjID = formularID
        SendMail.FormURL = mRedirectURL.Replace("?thanks=", "_")
        SendMail.RedirectURL = mRedirectURL
        SendMail.HTML = False
        SendMail.IsSavedToDB = True
        SendMail.Send()
    End Sub 
    Sub Mail_Send_Confirmation()
        response.write("mail an user ")
        ' Sender
        If Request.Form("Sender") <> "" Then
            mSender = Request.Form("Sender")
        Else
            mSender = Formular.Properties("Sender").Value
        End If

        ' Subject
        If Request.Form("Subject") <> "" Then
            mSubject = Request.Form("Subject")
        Else
            mSubject = Formular.Properties("Subject").Value
        End If
        if not fo_user.fields("con_betreff_0").value = "" then
            mSubject = fo_user.fields("con_betreff_0").value
        end if

        ' Recipient
        If Request.Form("Email") <> "" Then
            mRecipient = Request.Form("Email")
        Else
            mRecipient = "helpdesk@insyma.com"
        End If

        ' Redirect
        If Request.Form("Redirect") <> "" Then
            mRedirectURL = Request.Form("Redirect")
        Else
            If Formular.Properties("Redirect").Value <> "" Then
                mRedirectURL = Formular.Properties("Redirect").Value
            End If
        End If

        ' Redirect
        If Request.Form("Redirect") <> "" Then
            mRedirectURL = Request.Form("Redirect")
        Else
            If Formular.Properties("Redirect").Value <> "" Then
                mRedirectURL = Formular.Properties("Redirect").Value
            Else
                If Not Request.UrlReferrer Is Nothing Then
                    mRedirectURL = Request.UrlReferrer.ToString()

                    mRedirectURL = mRedirectURL.Replace("&thanks=", "&")
                    mRedirectURL = mRedirectURL.Replace("?thanks=", "?")
                    If mRedirectURL.IndexOf("?") = -1 Then
                        mRedirectURL = mRedirectURL + "?"
                    Else
                        mRedirectURL = mRedirectURL + "&"
                    End If
                    mRedirectURL += "thanks=1"

                Else
                    mRedirectURL += "www.landi.ch"
                End If
            End If
        End If
        if not mAlias = "" then
            SendMail.SenderAlias = mAlias & " "
        end if
        SendMail.IsSavedToDB = True
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        SendMail.Sender = mSender
        SendMail.Recipient = mRecipient
        SendMail.Subject = mSubject
        dim html as string = "<html><head><style> body, div, p, td { font-family: Arial; } td{ line-height: 20px; vertical-align: top; }</style></head><body>"
        dim bodystring as string = ""
        if not fo_user.fields("emailfelderinemail").value = "" then
            bodystring = mHBody
        end if

        SendMail.Body = html & fo_user.fields("textvorfelder_0").value &  bodystring & fo_user.fields("textnachfelder_0").value & "</body></html>"
        'SendMail.Body = strDankesText & mHBody & strSalutationText
        SendMail.LanguageID = mLanguageID
        SendMail.ObjID = formularID
        SendMail.FormURL = mRedirectURL.Replace("?thanks=", "_")
        SendMail.RedirectURL = mRedirectURL
        SendMail.HTML = True
        SendMail.Send()
    End Sub

    Sub Send_Mail_ByTopic(ByVal recipient As String)
        'Dim emailContent As Insyma.ContentUpdate.Obj = New Insyma.ContentUpdate.Obj()
        'emailContent.LanguageCode = mLanguageID
        'emailContent.LoadByName("nl_mailer_topic")

        'SendMail.ConnString = ContentUpdate.Utility.ConnString
        'SendMail.Sender = emailContent.Fields("Sender").Value
        'SendMail.SenderAlias = emailContent.Fields("Alias").Value
        'SendMail.Subject = emailContent.Fields("Subject").Value
        'SendMail.Body = emailContent.Fields("Body").Value & vbCrLf & vbCrLf & mBody

        If Request.Form("Sender") <> "" Then
            mSender = Request.Form("Sender")
        Else
            mSender = Formular.Properties("sender").Value
        End If

        ' Subject
        If Request.Form("Subject") <> "" Then
            mSubject = Request.Form("Subject")
        Else
            mSubject = Formular.Properties("Subject").Value
        End If
        if not mAlias = "" then
            SendMail.SenderAlias = mAlias & " "
        end if
        SendMail.IsSavedToDB = True
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        SendMail.Sender = mSender
        SendMail.Subject = mSubject
        SendMail.Body = mBody
        SendMail.LanguageID = mLanguageID
        SendMail.ObjID = formularID
        SendMail.HTML = False
        SendMail.Recipient = recipient

        SendMail.Send()
    End Sub
    Function SaveContact()
        Dim c As New Insyma.Contact.Contact
        c.ContactStatus=""
        c.Email = Request.Form("Email")
        c.Search()
        if Request.Form("SalutationID") <> "" then
            c.SalutationID = Request.Form("SalutationID")
        else
            c.SalutationID = 1
        end if
        c.Email = Request.Form("Email")
        c.SurName = Request.Form("SurName")
        c.FirstName = Request.Form("FirstName")
        c.Source = Request.Form("Source")
        c.Address1 = Request.Form("Address1")
        c.PostalCode = Request.Form("PostalCode")
        c.City = Request.Form("City")
        if Request.Form("Company") <> "" then
            c.Company = Request.Form("Company")
        end if
        c.LanguageID = Request.Form("LanguageID")
        c.Phone = Request.Form("Tel")
        c.MailFormatID = Request.Form("MailFormatID")

        If (Request.Form("Newsletter")="1") Then
            if not c.ContactStatus = "9" then
                c.ContactStatus = "3"
            end if

        End If
        if Request.QueryString("NLForm") <> "" then
            Dim contactId As Integer = 0
            integer.TryParse(c.ContactId, contactId)
            c.saveCategories("1,1", contactId, 1, False, cint(Request.QueryString("NLForm")))
        end if
        c.Save()


    End Function
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
</head>
<body bgcolor="#FFFFFF">

<%=testcontent%>
</body>
</html>
