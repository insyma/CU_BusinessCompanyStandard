<%@ Page Language="VB" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Import Namespace="Insyma"  %>
<%@ Import Namespace="Insyma.ContentUpdate"  %>
<%@ Import Namespace="Insyma.MessageHandler"  %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">

    Dim SendMail As New Insyma.MessageHandler.SendMessage
    dim fo as new contentupdate.container()
    Dim mSender As String = ""
    Dim mRecipient As String = ""
    Dim mSubject As String = ""
    Dim mBody As String = ""
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
    
    Dim aRecipient As List(Of String)
	Dim mAlias as string = ""

	Dim i as Integer
    Dim ArtikelNr, Typ, Preis, Anzahl, Artikel As String
	
	Dim strDankesText as String
	Dim strSalutationText as String
	
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		Try		
			If (Not Request.Form("Captcha") Is Nothing And Not Session("CUCaptchaText").Equals(Request.Form(Request.Form("Captcha")))) Then
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
				'Response.Write(_tRedirect)
				Response.End()
			End If
		Catch ex As Exception
			'Response.Write(ex.Message)
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
            fo.LanguageCode = mLanguageID
            if fo.fields("form_conversiontrack").Id <> 0 Then
                conversion = fo.fields("form_conversiontrack").value
            end if
			if Formular.containers("EmailTexte").Fields("TextVorFelder").id <> 0 then
				strDankesText = Formular.containers("EmailTexte").Fields("TextVorFelder").Value & vbCrlf
			end if
			if Formular.containers("EmailTexte").Fields("TextNachFelder").id <> 0 then
				strSalutationText = Formular.containers("EmailTexte").Fields("TextNachFelder").Value & vbCrlf
			end if
            if not fo.fields("email_alias").value = "" then
                mAlias = fo.fields("email_alias").value
            end if
                                
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

                    If question.Properties("QuestionType").Value = "0" Then
                        ' Radiobutton oder Checkbox
                        If Not question.Properties("MultipleAnswer").Value = "1" Then
                            'Radiobutton
                            'mBody = mBody & Left(formObjCaption & ":" & Space(15), 15) & " "
                            mBody = mBody & UtilCommon.StringToMultiLine(formObjCaption, 15) & ": "
                            If Not (Request.Form(question.ObjName) = "") Then
                                If (question.ObjName = "SalutationID") Then
                                    Select Case Request.Form(question.ObjName)
                                        Case "1"
                                            If mLanguageID = 0 Then
                                                mBody += "Herr" & vbCrLf
                                            Else
                                                mBody += "Monsieur" & vbCrLf
                                            End If
                                        Case "2"
                                            If mLanguageID = 0 Then
                                                mBody += "Frau" & vbCrLf
                                            Else
                                                mBody += "Madame" & vbCrLf
                                            End If
                                        Case Else
                                            mBody += Request.Form(question.ObjName) & vbCrLf
                                    End Select
                                Else
                                    mBody += Request.Form(question.ObjName) & vbCrLf
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
                            For Each AnswerField As ContentUpdate.Answer In question.Answers
                                ' Chekcbox name: Me.Parent.ObjName & Me.ObjName
                                If (AnswerField.ObjName = "CatTopicID") Then
                                    split = Request.Form(AnswerField.Parent.ObjName & "CatTopicID").Split(delimiter)
                                    Dim s As String
                                    For Each s In split
                                        If AnswerField.Value = s Then
                                            showQuestion = True
                                            CheckBoxString += Space(2) & "- " & AnswerField.Caption & vbCrLf
                                        End If
                                    Next
                                Else                                    
                                    If Not (Request.Form(AnswerField.Parent.ObjName & AnswerField.ObjName) = "") Then
                                        showQuestion = True
                                        CheckBoxString += Space(2) & "- " & AnswerField.Caption & vbCrLf
                                    End If
                                End If
                            Next
                            If showQuestion Then
                                mBody += CheckBoxString
                            End If
                        End If
                    ElseIf question.Properties("QuestionType").Value = "5" Then
                        ' a TopicFields(checkbox, radiobutton) question, check if any item is selected, send an email
                        'mBody += Left(formObjCaption & ":" & Space(15), 15) & " " & Request.Form(formObjName) & vbCrLf
                        mBody += UtilCommon.StringToMultiLine(formObjCaption, 15) & ": " & Request.Form(formObjName) & vbCrLf
						
                        For Each AnswerField As ContentUpdate.Answer In question.Answers
                            If question.Properties("MultipleAnswer").Value = "1" Then
                                ' Chekcbox name: Me.Parent.ObjName & Me.ObjName
                                If AnswerField.Value = Request.Form(AnswerField.Parent.ObjName & AnswerField.ObjName) Then
                                    'JAKN Add only if an Emailaddress exists
                                    If (Not AnswerField.Properties("TextAnswer").Value.Equals("")) Then
                                        aRecipient.Add(AnswerField.Properties("TextAnswer").Value)
                                    End If
                                    mBody += Space(2) & "- " & AnswerField.Caption & vbCrLf
                                End If
                            Else
                                If AnswerField.Value = Request.Form(question.ObjName) Then
                                    'JAKN Add only if an Emailaddress exists
                                    If (Not AnswerField.Properties("TextAnswer").Value.Equals("")) Then
                                        aRecipient.Add(AnswerField.Properties("TextAnswer").Value)
                                    End If
                                    mBody += Space(2) & "- " & AnswerField.Caption & vbCrLf
                                End If
                            End If
                        Next
                        mBody += vbCrLf
						
                    ElseIf question.Properties("QuestionType").Value = "6" Then
                        ' a TopicList (display as Dropdown) question, check if any item is selected, send an email
                        'mBody += Left(formObjCaption & ":" & Space(15), 15) & " " & Request.Form(formObjName) & vbCrLf
                        'mBody += UtilCommon.StringToMultiLine(formObjCaption, 15) & ": " & Request.Form(formObjName) & vbCrLf
                        
                        For Each AnswerField As ContentUpdate.Answer In question.Answers
                            If AnswerField.Value = Request.Form(formObjName) Then
                                mBody += UtilCommon.StringToMultiLine(formObjCaption, 15) & ": " & AnswerField.Caption  & vbCrLf
                                If (Not AnswerField.Properties("TextAnswer").Value.Equals("")) Then
                                    aRecipient.Add(AnswerField.Properties("TextAnswer").Value)
                                End If
                            End If
                        Next
						
                    Else
                        'mBody += Left(formObjCaption & ":" & Space(15), 15) & " "
                        mBody += UtilCommon.StringToMultiLine(formObjCaption, 15) & ": "
                        
                        ' Textbox oder Dropdown
                        If question.Properties("HiddenValue").Value = "1" Then
                            If Not Request.Form(formObjName) = "" Then
                                FormField = New ContentUpdate.Field()
                                FormField.Load(CInt(Request.Form(formObjName)))
                                formHiddenValue = FormField.Value
                            End If
                            mBody += formHiddenValue & vbCrLf
                        Else
                            mBody += Utility.userDataDecode(Request.Form(formObjName)) & vbCrLf
                        End If
                    End If
                Next
            Next


            ' Die Bestellinformationen werden hinzugefügt
				
						mBody +=vbcr & vblf & vbcr & vblf & "Folgende Produktezusammenstellungen wurden angewaehlt:" & vblf & vbcr
				
						for i=0 to cint(Request.Form("ProductCounter"))-1
                ArtikelNr = "Artikel" & i

                Typ = "Menge" & i

                Preis = "Preis" & i
                Anzahl = "Anzahl" & i
                If Request.Form(ArtikelNr) <> "" Then
                    mBody += Left(Request.Form(Anzahl) & " x " & Space(15), 10) & Left(Request.Form(ArtikelNr) & Space(15), 10) & " " & Left(Request.Form(Typ) & Space(15), 10) & " " & Request.Form(Preis) & " " & vbCr & vbLf

                End If
						next 


            mBody += vbcr & vblf & vbcr & vblf & "Folgende Zusatzprodukte wurden ausgefuellt:" & vblf & vbcr

            for i=0 to cint(Request.Form("ZusatzCounter"))-1
            	Artikel = "ZusatzArtikel" & i
            	Anzahl = "ZusatzAnzahl" & i
            	if (Request.Form(Anzahl) <> "") OR (Request.Form(Artikel) <> "") then
            		mBody += Left(Request.Form(Anzahl) & " x" & space(15),10) & Request.Form(Artikel) & vbcr & vblf
            	end if
            next 

            ' Mail versenden
            Mail_Send()
			

            'Kontakt speichern?!'
            SaveContact
			

            ' Confirmation Mail versenden
			if not Formular.Containers("EmailTexte").Visible = false then
	            Mail_Send_Confirmation()
			end if
            
            For Each recip As String In aRecipient
                Send_Mail_ByTopic(recip)
            Next
			

				
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
                        Response.Redirect(Request.UrlReferrer.ToString() & "&thanks=1&form=" & conversion)
                    Else
                        Response.Redirect(Request.UrlReferrer.ToString() & "?thanks=1&form=" & conversion)
                    End If
                End If
            End If
        End If
    End Sub
        
    Sub Mail_Send()
        ' Sender
        If Request.Form("Sender") <> "" Then
            mSender = Request.Form("Sender")
        Else
            mSender = Formular.Properties("sender").Value
        End If
        If Request.Form("Email") <> "" Then
            mSender = Request.Form("Email")
        End If
        
        ' Subject
        If Request.Form("Subject") <> "" Then
            mSubject = Request.Form("Subject")
        Else
            mSubject = Formular.Properties("Subject").Value
        End If
        
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
        SendMail.Subject = mSubject
        SendMail.Body = mBody
        SendMail.LanguageID = mLanguageID
        SendMail.ObjID = formularID
        SendMail.FormURL = mRedirectURL.Replace("?thanks=", "_")
        SendMail.RedirectURL = mRedirectURL
        SendMail.HTML = False
        SendMail.Send()
    End Sub
	

	Sub Mail_Send_Confirmation()
        ' Sender
        If Request.Form("Recipient") <> "" Then
            mSender = Request.Form("Recipient")
        Else
            mSender = Formular.Properties("Recipient").Value
        End If
        
        ' Subject
		If Formular.Containers("EmailTexte").Fields("Betreff").value <> "" Then
            mSubject = Formular.Containers("EmailTexte").Fields("Betreff").value
        Else
            If Request.Form("Subject") <> "" Then
				mSubject = Request.Form("Subject")
			Else
				mSubject = Formular.Properties("Subject").Value
			End If
        End If       
        
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
        SendMail.Body = strDankesText & mBody.Replace(vbCrLf,"<br/>") & strSalutationText
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

        response.write("<br />:::::" & Request.Form("Email"))
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


</body>
</html>
