<%@ Page Language="VB" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Import Namespace="Insyma"  %>
<%@ Import Namespace="Insyma.ContentUpdate"  %>
<%@ Import Namespace="System.Web.Mail" %>
<%@ Import Namespace="Insyma.MessageHandler"  %>
<script runat="server">

    Dim SendMail As New Insyma.MessageHandler.SendMessage
    
    Dim mSender As String = ""
    Dim mRecipient As String = ""
    Dim mSubject As String = ""
    Dim mBody As String = ""
    Dim mRedirectURL As String = ""
    Dim mLanguageID As Integer
    
    Dim cAnrede As String = ""
    Dim cName As String = ""
    Dim cVorname As String = ""
    Dim cEMail As String = ""
    Dim cAdresse As String = ""
    Dim cPLZ As String = ""
    Dim cOrt As String = ""
    Dim cTel As String = ""
    Dim cWettbewerbsAntwort As String = ""
    Dim contactsaved As Boolean = False
    
    Dim Formular As ContentUpdate.Form
    Dim FormField As ContentUpdate.Field
    Dim formularID As String
    Dim formObjName As String
    Dim formObjCaption As String
    Dim formHiddenValue As String
    
    Dim delimStr As String = ","
    Dim delimiter As Char() = delimStr.ToCharArray()
    Dim split As String() = Nothing
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    
        formularID = Request.QueryString("Form_id")
        mLanguageID = CInt(Request.QueryString("lang"))
		
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
                            End If
                        Else
                            'Checkbox
                            Dim showQuestion as Boolean = false
                            Dim CheckBoxString As String = ""
                            CheckBoxString +=  vbCrLf & question.Caption & vbCrLf
                            For Each AnswerField As ContentUpdate.Answer In question.Answers
                                if (AnswerField.ObjName = "CatTopicID") then
                                    split = Request.Form("CatTopicID").Split(delimiter)
                                    Dim s As String
                                    For Each s In  split
                                        if AnswerField.Value = s then
                                        	showQuestion = true
                                            	CheckBoxString += Space(2) & "- " & AnswerField.Caption & vbCrLf
                                        end if
                                    Next
                                else
                                    If Not (Request.Form(AnswerField.ObjName) = "") Then
                                    	showQuestion  = true
                                        CheckBoxString += Space(2) & "- " & AnswerField.Caption  & vbCrLf
                                    End If
                                end if
                            Next
                            if showQuestion then
                            	mBody += CheckBoxString
                            end if
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
            
            For Each key As String In Request.Form.AllKeys
                If (Not key Is Nothing) Then
                    If cAnrede = "" And ((key.ToLower().IndexOf("anrede") > -1) Or (key.ToLower().IndexOf("salutation") > -1) Or (key.ToLower().IndexOf("herr") > -1) Or (key.ToLower().IndexOf("frau") > -1)) Then
                        cAnrede = Request.Form(key)
                    End If
                    If cName = "" And ((key.ToLower().IndexOf("nachname") > -1) Or (key.ToLower().IndexOf("surname") > -1)) Then
                        cName = Request.Form(key)
                    End If
                    If cEMail = "" And ((Request.Form(key).IndexOf("@") > -1 AndAlso Request.Form(key).IndexOf(".") > -1)) Then
                        cEMail = Request.Form(key)
                    End If
                    If cVorname = "" And ((key.ToLower().IndexOf("vorname") > -1) Or (key.ToLower().IndexOf("firstname") > -1)) Then
                        cVorname = Request.Form(key)
                    End If
                    If cAdresse = "" And ((key.ToLower().IndexOf("strasse") > -1) Or (key.ToLower().IndexOf("adresse") > -1)) Then
                        cAdresse = Request.Form(key)
                    End If
                    If cPLZ = "" And (key.ToLower().IndexOf("plz") > -1) Then
                        cPLZ = Request.Form(key)
                    End If
                    If cOrt = "" And (key.ToLower().IndexOf("ort") > -1) Then
                        cOrt = Request.Form(key)
                    End If
                    If cTel = "" And ((key.ToLower().IndexOf("tel") > -1) Or (key.ToLower().IndexOf("telefon") > -1)) Then
                        cTel = Request.Form(key)
                    End If
                    If cWettbewerbsAntwort = "" And ((key.ToLower().IndexOf("antwort") > -1) Or (key.ToLower().IndexOf("wettbewerbsantwort") > -1) Or (key.ToLower().IndexOf("frage") > -1)) Then
                        cWettbewerbsAntwort = Request.Form(key)
                    End If
                End If
            Next
            
            contactsaved = SaveContact()
            
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
        'If mSender = "" And Request.Form("Email") <> "" Then
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
                    mRedirectURL += "www.landi.ch"
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
    
    Dim cid As String = "0"
    Function SaveContact() As Boolean
        If cEMail <> "" Then
            Dim wettbewerbcontact As New Insyma.Contact.Contact
            wettbewerbcontact.ContactStatus = ""
            wettbewerbcontact.Email = cEMail
            wettbewerbcontact.Search()
        
            If (wettbewerbcontact.ContactID = "") Then
                wettbewerbcontact.FirstName = cVorname
                wettbewerbcontact.SurName = cName
                wettbewerbcontact.Address1 = cAdresse
                wettbewerbcontact.PostalCode = cPLZ
                wettbewerbcontact.City = cOrt

                wettbewerbcontact.Email = cEMail
                wettbewerbcontact.Phone = cTel
                wettbewerbcontact.Supplement1 = cWettbewerbsAntwort
            
                If (cAnrede.ToLower() = "frau") Then
                    wettbewerbcontact.SalutationID = "2"
                Else
                    wettbewerbcontact.SalutationID = "1"
                End If
                wettbewerbcontact.LanguageID = mLanguageID
                wettbewerbcontact.ContactStatus = "3"
                wettbewerbcontact.MailFormatID = "1"
                wettbewerbcontact.generateCode()
                wettbewerbcontact.Source = "Wettbewerbsformular"
                wettbewerbcontact.Save()
                cid = wettbewerbcontact.ContactID
                wettbewerbcontact.AddTopicID(3)
                Return True
            Else
                cid = wettbewerbcontact.ContactID
                Return False
            End If
        Else
            Return False
        End If
	
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
