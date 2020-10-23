<%@ Page Language="VB" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Import Namespace="Insyma"  %>
<%@ Import Namespace="Insyma.ContentUpdate"  %>
<%@ Import Namespace="Insyma.MessageHandler"  %>
<script runat="server">

    Dim SendMail As New Insyma.MessageHandler.SendMessage
    
    Dim mSender As String = ""
    Dim mRecipient As String = ""
    Dim mSubject As String = ""
    Dim mBody As String = ""
    Dim mRedirectURL As String = ""
    Dim mLanguageID As Integer
    
    Dim Formular As ContentUpdate.Form
    Dim FormField As ContentUpdate.Field
    Dim formularID As String
    Dim formObjName As String
    Dim formObjCaption As String
    Dim formHiddenValue As String
    
    ' Mailer-Speziefische Variabeln
	dim i as Integer
    Dim ArtikelNr, Typ, Preis, Anzahl As String
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    
        formularID = Request.QueryString("Form_id")
        mLanguageID = CInt(Request.QueryString("lang"))
		
        ' Ohne Formular ID kann kein Formular versandt werden
        If formularID <> "" Then
            Formular = New ContentUpdate.Form()
            Formular.LanguageCode = mLanguageID.ToString()
            Formular.Load(formularID)
				
            ' Für jeden Container im Formular
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
                                mBody += Request.Form(question.ObjName) & vbCrLf
                            End If
                        Else
                            'Checkbox
                            mBody += question.Caption & vbCrLf
                            For Each AnswerField As ContentUpdate.Answer In question.Answers
                                If Not (Request.Form(AnswerField.ObjName) = "") Then
                                    mBody += Space(2) & "- " & Request.Form(AnswerField.ObjName) & vbCrLf
                                End If
                            Next
                        End If
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
                            mBody += Utility.userDataDecode(Request.Form(formObjName)) & vbCrLf
                        End If
                    End If
                Next
            Next
            
            ' Die Bestellinformationen werden hinzugefügt
				
				mBody +=vbcr & vblf & vbcr & vblf & "Folgende Produktezusammenstellung wurden angewaehlt:" & vblf & vbcr
				
				for i=0 to cint(Request.Form("ProductCounter"))-1
                ArtikelNr = "ArtikelNr-" & i

                Typ = "Typ-" & i

                Preis = "Preis-" & i
                Anzahl = "Anzahl-" & i
                If Request.Form(ArtikelNr) <> "" Then
                    mBody += Left(Request.Form(Anzahl) & " x " & Space(15), 10) & Left(Request.Form(ArtikelNr) & Space(15), 10) & " " & Left(Request.Form(Typ) & Space(15), 10) & " " & Request.Form(Preis) & " " & vbCr & vbLf

                End If
				next 

            'mBody += vbcr & vblf & vbcr & vblf & "Folgende Zusatzprodukte wurden ausgefuellt:" & vblf & vbcr

            'for i=0 to cint(Request.Form("ZusatzCounter"))-1
            '	Artikel = "ZusatzArtikel" & i
            '	Anzahl = "ZusatzAnzahl" & i
            '	if (Request.Form(Anzahl) <> "") OR (Request.Form(Artikel) <> "") then
            '		mBody += Left(Request.Form(Anzahl) & " x" & space(15),10) & Request.Form(Artikel) & vbcr & vblf
            '	end if
            'next 
            
            ' Mail versenden
            Mail_Send()
            
            ' Redirect
            Response.Redirect(mRedirectURL)
        End If
    End Sub
	
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
                    mRedirectURL += "www.insyma.com"
                End If
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
        SendMail.FormURL = mRedirectURL.Replace("?thanks=", "_")
        SendMail.RedirectURL = mRedirectURL
        SendMail.HTML = False
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
