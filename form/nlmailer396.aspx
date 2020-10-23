<%@ Page Language="VB" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Import Namespace="Insyma"  %>
<%@ Import Namespace="Insyma.ContentUpdate"  %>
<%@ Import Namespace="Insyma.MessageHandler" %>
<%@ Import Namespace="Insyma.Contact" %>
<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">

    Dim SendMail As New Insyma.MessageHandler.SendMessage
    
    Dim mSender As String = ""
    Dim mRecipient As String = ""
    Dim mSubject As String = ""
    Dim mBody As String = ""
    'Dim mRedirectURL As String = ""
    Dim mLanguageID As Integer
    
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
	
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    
        formularID = Request.QueryString("Form_id")
        mLanguageID = CInt(Request.QueryString("lang"))
		aRecipient = New List(Of String)
                
        ' Ohne Formular ID kann kein Formular versandt werden
        If formularID <> "" Then
            Formular = New ContentUpdate.Form()
            Formular.LanguageCode = mLanguageID.ToString()
            Formular.Load(formularID)
                                
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
                                                if mLanguageID = 0 then
                                                    mBody += "Herr" & vbCrLf
                                                else
                                                    mBody += "Monsieur" & vbCrLf
                                                end if
                                            Case "2"
                                                if mLanguageID = 0 then
                                                    mBody += "Frau" & vbCrLf
                                                else
                                                    mBody += "Madame" & vbCrLf
                                                end if
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
                            Dim showQuestion as Boolean = false
                            Dim CheckBoxString As String = ""
                            CheckBoxString +=  vbCrLf & question.Caption & vbCrLf
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
                            if showQuestion then
                                mBody += CheckBoxString
                            end if
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
						Dim tmp as String = Request.Form(formObjName)
						
						For Each AnswerField As ContentUpdate.Answer In question.Answers
                            If AnswerField.Value = Request.Form(formObjName) Then
                                mBody += UtilCommon.StringToMultiLine(formObjCaption, 15) & ": " & AnswerField.Caption & vbCrLf
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
                            'mBody += Request.Form(formObjName) & vbCrLf
                            mBody += Insyma.ContentUpdate.Utility.userDataDecode(Request.Form(formObjName)) & vbCrLf
						End If
                    End If
                Next
            Next
            
            ' Newsletter abspeichern
			SaveContact()
            
            ' Mail versenden
			Mail_Send()
            
			For Each recip As String In aRecipient
				Send_Mail_ByTopic(recip)
			Next
			
			' Redirect
            If Formular.Properties("Redirect").Value <> "" Then
                Response.Redirect(Formular.Properties("Redirect").Value)
            ElseIf Request.Form("Redirect") <> "" Then
                Response.Redirect(Request.Form("Redirect"))
            Else
                If Request.UrlReferrer.ToString.Contains("?") = True Then
                    Response.Redirect(Request.UrlReferrer.ToString() & "&thanks")
                Else
                    Response.Redirect(Request.UrlReferrer.ToString() & "?thanks")
                End If
            End If
		End If
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
        c.Save()
        End If
        
        If (Request.Form("Newsletter")="1") then
            c.setCategoryTopicID("1", "Monats-Highlights")
            c.setCategoryTopicID("1", "Produkte-Neuheiten")
	    ' Newsletter Kategorien setzten
	    c.setCategoryTopicID("4", "Landi Aktionen")
	    c.setCategoryTopicID("4", "Landi News")
	    c.setCategoryTopicID("4", "Agrar Newsletter")
	    c.setCategoryTopicID("4", "Energy News")
	    c.setCategoryTopicID("4", "Wetter News")
	    ' Herkunftskategorie setzen
	    if Request.Form("CatTopicID") = "landi.ch / Kontakt" then
	    	c.setCategoryTopicID("3", "landi.ch / Kontakt")
	    elseif Request.Form("CatTopicID") = "LandiShop" then
	    	c.setCategoryTopicID("3", "LandiShop")
	    elseif Request.Form("CatTopicID") = "landi.ch / Feedback" then
	    	c.setCategoryTopicID("3", "landi.ch / Feedback")
	    elseif Request.Form("CatTopicID") = "landi.ch / Kontakt" then
	    	c.setCategoryTopicID("3", "landi.ch / Kontakt")
	    elseif Request.Form("CatTopicID") = "landi.ch / Agrola - Offerte" then
	    	c.setCategoryTopicID("3", "landi.ch / Agrola - Offerte")
	    elseif Request.Form("CatTopicID") = "landi.ch / Agrola - Supercard" then
	    	c.setCategoryTopicID("3", "landi.ch / Agrola - Supercard")
	    elseif Request.Form("CatTopicID") = "landi.ch / Mitglieder" then
	    	c.setCategoryTopicID("3", "landi.ch / Mitglieder")
	    elseif Request.Form("CatTopicID") = "landi.ch / Newsletter" then
	    	c.setCategoryTopicID("3", "landi.ch / Newsletter")  
	    elseif Request.Form("CatTopicID") = "landi.ch / Wettbewerb" then
	    	c.setCategoryTopicID("3", "landi.ch / Wettbewerb")  
	    elseif Request.Form("CatTopicID") = "landi.ch / Holz-Pellet" then
	    	c.setCategoryTopicID("3", "landi.ch / Holz-Pellet")  
	    elseif Request.Form("CatTopicID") = "landi.ch / UFA-Revue" then
	    	c.setCategoryTopicID("3", "landi.ch / UFA-Revue")  
	    elseif Request.Form("CatTopicID") = "landi.ch / Raufutter" then
	    	c.setCategoryTopicID("3", "landi.ch / Raufutter")  
	    else
	    	c.setCategoryTopicID("3", "landi.ch / Standardformular")  
	    end if
        end if        
    End Function
        
    Sub Mail_Send()
        ' Sender
        If Request.Form("Sender") <> "" Then
            mSender = Request.Form("Sender")
        Else
            mSender = Formular.Properties("sender").Value
        End If
        'If Request.Form("Email") <> "" Then
        '    mSender = Request.Form("Email")
        'End If
        
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
                       
        SendMail.IsSavedToDB = True
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        SendMail.Sender = mSender
        SendMail.Recipient = mRecipient
        SendMail.Subject = mSubject
        SendMail.Body = mBody
        SendMail.LanguageID = mLanguageID
        SendMail.ObjID = formularID
        'SendMail.FormURL = mRedirectURL.Replace("?thanks=", "_")
        SendMail.HTML = False
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
