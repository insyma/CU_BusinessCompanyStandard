<%@ Page Language="VB" Inherits="Insyma.ContentUpdate.CUPage" %>

<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="Insyma"  %>
<%@ Import Namespace="Insyma.ContentUpdate"  %>
<%@ Import Namespace="Insyma.MessageHandler"  %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="Insyma.Utility" %>
<script runat="server">

    Dim SendMail As New Insyma.MessageHandler.SendMessage

    Dim mSender As String = ""
    Dim mRecipient As String = ""
    Dim mSubject As String = ""
    Dim mBody As String = ""
    Dim mRedirectURL As String = ""
    Dim mLanguageID As Integer
    
	Dim PayData as string = ""
	Dim stamp
    Dim Formular As ContentUpdate.Form
    Dim FormField As ContentUpdate.Field
    Dim formularID As String
    Dim formObjName As String
    Dim formObjCaption As String
    Dim formHiddenValue As String
    
    Dim delimStr As String = ","
    Dim delimiter As Char() = delimStr.ToCharArray()
    Dim split As String() = Nothing
    Dim bodybestellung as string = ""
    Dim aRecipient As List(Of String)
	Dim MAXW as integer = 68
    Dim i As Integer = 0
	dim j as integer = 0
	dim langactive as string = "/deu/"
	dim langinactive as string = "/fra/"
    dim zusatz as string = ""
    dim MailAttachment = ""
    DIM zahlung as string = ""
    dim mail1 as string = ""
    dim mail2 as string = ""
    dim betreff2 as string = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        Try
            If Not Request.UrlReferrer Is Nothing Then
                Dim bestellung As String = ""
                Dim _tcon As New ContentUpdate.Container
                Dim _tshop As New ContentUpdate.Container
                
                _tshop.LoadByName("zen_shop_produkt_label_allg") 'Container ShopBeschriftung
                _tshop.LanguageCode = CInt(Request.QueryString("lang"))
                
                _tcon.Load(27419) 'Container bestell_texte
                _tcon.LanguageCode = CInt(Request.QueryString("lang"))
                
                PayData = _tcon.Fields("bankdaten").Plaintext
                mail1 = _tcon.Fields("wk_text_first").Plaintext
                mail2 = _tcon.Fields("wk_text_last").Plaintext
                If Request.Form("Bestellung") <> "" Then
                    bestellung = Request.Form("Bestellung")
                    Dim jsSerializer As New JavaScriptSerializer()
                    Dim bestellt As Object = jsSerializer.Deserialize(Of Object)(bestellung)
                    For Each p As KeyValuePair(Of String, Object) In bestellt
                        If p.Key = "Products" Then
                            'Loop Products Array
                            For Each c As Object In p.Value
                                For Each x As KeyValuePair(Of String, Object) In c
                                    If x.Key = "Quantity" Then
                                        bodybestellung += x.Value.ToString + " x "
                                    End If
                                    If x.Key = "Serial" Then
                                        bodybestellung += x.Value.ToString + " ("
                                    End If
                                    If x.Key = "ProductName" Then
                                        bodybestellung += x.Value.ToString + ") zu "
                                    End If
                                    If x.Key = "Total" Then
                                        bodybestellung += Convert.ToDecimal(x.Value).ToString("0.00") + " " + _tshop.Fields("lbl_shop_waehrung").Value
                                    End If
                                Next
                                bodybestellung += vbCrLf & "------------------------------------------" & vbCrLf & vbCrLf
                            Next
                        End If
                    Next
                    If Request.Form("ReferenzID") <> "" Then
                        bodybestellung += vbCrLf & "ReferenzID: " & Request.Form("ReferenzID") & vbCrLf & vbCrLf
                    End If
                End If
                For Each formfield As String In Request.Form.Keys
                    If formfield.Contains("zus_pers") Then
                        zusatz += "- " & Request.Form(formfield) & vbCrLf
                    End If
                Next

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
					
                        If CUContainer.ObjName = "bestell_step2" Or CUContainer.ObjName = "extra" Then
                            mBody += vbCrLf & vbCrLf & "Rechnungsempfänger" & vbCrLf
                            mBody += "----------------------------------------------------" & vbCrLf
                        ElseIf CUContainer.ObjName = "bestell_step1" Then
                            mBody += vbCrLf & "Personendaten" & vbCrLf
                            mBody += "----------------------------------------------------" & vbCrLf
                        End If
					
                        ' Felder (Fragen) pro Container
                        For Each question As ContentUpdate.Question In CUContainer.Questions
                            formObjName = question.ObjName
                            formObjCaption = question.Plaintext
						
                            If Not formObjName = "Zahlungsart" And Not formObjName = "Lieferart" And Not formObjName = "Kreditkarte" Then
                                If question.Properties("QuestionType").Value = "0" Then
                                    ' Radiobutton oder Checkbox
                                    If Not question.Properties("MultipleAnswer").Value = "1" Then
                                        'Radiobutton
                                        mBody = mBody & Left(formObjCaption & ":" & Space(15), 15) & " "
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
                                        End If
                                    Else
                                        'Checkbox
                                        Dim showQuestion As Boolean = False
                                        Dim CheckBoxString As String = ""
                                        CheckBoxString += vbCrLf & question.Caption & vbCrLf
                                        For Each AnswerField As ContentUpdate.Answer In question.Answers
                                            If (AnswerField.ObjName = "CatTopicID") Then
                                                split = Request.Form("CatTopicID").Split(delimiter)
                                                Dim s As String
                                                For Each s In split
                                                    If AnswerField.Value = s Then
                                                        showQuestion = True
                                                        CheckBoxString += Space(2) & "- " & AnswerField.Caption & vbCrLf
                                                    End If
                                                Next
                                            Else
                                                If Not (Request.Form(AnswerField.ObjName) = "") Then
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
                                    mBody += Left(formObjCaption & ":" & Space(15), 15) & " " & Request.Form(formObjName) & vbCrLf
														
                                    For Each AnswerField As ContentUpdate.Answer In question.Answers
                                        If question.Properties("MultipleAnswer").Value = "1" Then
                                            If AnswerField.Value = Request.Form(AnswerField.ObjName) Then
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
                                Else
                                    mBody += Left(formObjCaption & ":" & Space(15), 15) & " "
								
                                    ' Textbox oder Dropdown
                                    If question.Properties("HiddenValue").Value = "1" Then
                                        If Not Request.Form(formObjName) = "" Then
                                            FormField = New ContentUpdate.Field()
                                            FormField.Load(CInt(Request.Form(formObjName)))
                                            formHiddenValue = FormField.Value
                                        End If
                                        mBody += formHiddenValue & vbCrLf
                                    Else
                                        If Not Request.Form(formObjName) = "" Then
                                            mBody += Request.Form(formObjName).Replace(",", "") & vbCrLf
                                        End If
                                    End If
                                End If
                            Else
                                If formObjName = "Lieferart" Then
                                    mBody += Left(formObjCaption & ":" & Space(15), 15) & " "
                                    If Not Request.Form(formObjName) = "" Then
                                        mBody += Request.Form(formObjName).Replace(",", "") & vbCrLf
                                        betreff2 = Request.Form(formObjName).Replace(",", "")
                                    End If
                                ElseIf formObjName = "Zahlungsart" Then
                                    mBody += Left(formObjCaption & ":" & Space(15), 15) & " "
                                    If Not Request.Form(formObjName) = "" Then
                                        If Not Request.Form(formObjName) = "Rechnung" Then
                                            zahlung = "kk"
                                        End If
                                        mBody += Request.Form(formObjName).Replace(",", "") & vbCrLf
                                    End If
                                End If
                                If formObjName = "Kreditkarte" And zahlung = "kk" Then
                                    mBody += Left(formObjCaption & ":" & Space(15), 15) & " "
                                    If Not Request.Form(formObjName) = "" Then
                                        Dim _t As String = Request.Form(formObjName)
                                        Dim _kk As String = ""
                                        Select Case _t
                                            Case "Visa"
                                                _kk = "Visa"
                                            Case "American Express"
                                                _kk = "American Express"
                                            Case "Mastercard"
                                                _kk = "Mastercard"
                                            Case "Postcard"
                                                _kk = "Postcard"
                                        End Select
                                        mBody += _kk & vbCrLf
                                    End If
                                End If
                            End If
                        Next
                    Next

                    If Request.Form("Redirect") <> "" Then
                        mRedirectURL = Request.Form("Redirect")
                    Else
                        If Formular.Properties("Redirect").Value <> "" Then
                            mRedirectURL = Formular.Properties("Redirect").Value
                        Else
                            If Not Request.UrlReferrer Is Nothing Then
                                mRedirectURL = Request.UrlReferrer.ToString()
														
                                mRedirectURL = mRedirectURL.Replace("&resthanx=", "&")
                                mRedirectURL = mRedirectURL.Replace("?resthanx=", "?")
                                If mRedirectURL.IndexOf("?") = -1 Then
                                    mRedirectURL = mRedirectURL + "?"
                                Else
                                    mRedirectURL = mRedirectURL + "&"
                                End If
                                mRedirectURL += "resthanx=1"
							
                            Else
                                mRedirectURL += "http://www.tropenhaus-wolhusen.ch"
                            End If
                        End If
                    End If
				
                    Dim _d = Date.Now()
                    mBody += Left("Datum:" & Space(15), 15) & " " & _d & vbCrLf
                    If Request.Form("Kosten") <> "" Then
                        Dim outputKosten As String = ""
                        Dim jsSerializer As New JavaScriptSerializer()
                        Dim kosten As Object = jsSerializer.Deserialize(Of Object)(Request.Form("Kosten"))
                        For Each k As KeyValuePair(Of String, Object) In kosten
                            If k.Key = "subtotal" Then
                                outputKosten += _tshop.Fields("lbl_shop_subtotal").Value & " " & k.Value.ToString & vbCrLf
                            End If
                            If k.Key = "versandkosten" Then
                                outputKosten += _tshop.Fields("lbl_shop_versandkosten").Value & " " & k.Value.ToString & vbCrLf
                            End If
                            If k.Key = "kleinmengenzuschlag" Then
                                outputKosten += _tshop.Fields("lbl_shop_kleinmengenzuschlag").Value & " " & k.Value.ToString & vbCrLf
                            End If
                            If k.Key = "gesamtpreis" Then
                                outputKosten += _tshop.Fields("lbl_shop_gesamtpreis").Value & " " & k.Value.ToString & vbCrLf
                            End If
                        Next
                        mBody += vbCrLf & vbCrLf & bodybestellung & outputKosten & vbCrLf
                    Else
                        mBody += vbCrLf & vbCrLf & bodybestellung & vbCrLf
                    End If
                    'Vorkasse
                    If Request.Form("Zahlungsart") = "Rechnung" Then
                        mBody += PayData & vbCrLf
                    End If
                    Response.Write("<br /> - " & mBody)
                    ' Mails versenden
				
                    Mail_Send2()
                    Mail_Send()
                    ' Redirect
                    'Response.Redirect(mRedirectURL)
				
                    For Each recip As String In aRecipient
                        Send_Mail_ByTopic(recip)
                    Next
                Else
                    Throw New Exception("formularID has no value")
                End If
            Else
                'response.Redirect("http://www.tropenhaus-wolhusen.ch")
                Throw New Exception("Request.UrlReferrer Is Nothing")
            End If
        Catch ex As Exception
            DevLog.Write("Page_Load", "mailer_bestellung.aspx", "mail sending problem", ex.Message)
        End Try
    End Sub
    
    
    
    Sub Mail_Send()

        
        If Request.Form("pdfPath") <> "" Then
            MailAttachment = Request.Form("pdfPath")
            Dim att As New System.Net.Mail.Attachment(MailAttachment)
        End If

        ' Sender
        If Request.Form("Sender") <> "" Then
            mSender = Request.Form("Sender")
        Else
            mSender = Formular.Properties("sender").Value
        End If
        If Request.Form("Email") <> "" Then
            'mSender = Request.Form("Email").Replace(",","")
        End If
        
        ' Subject
        mSubject = Formular.Properties("Subject").Value & ":" & betreff2
        
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
                                                
                    mRedirectURL = mRedirectURL.Replace("&resthanx=", "&")
                    mRedirectURL = mRedirectURL.Replace("?resthanx=", "?")
                    If mRedirectURL.IndexOf("?") = -1 Then
                        mRedirectURL = mRedirectURL + "?"
                    Else
                        mRedirectURL = mRedirectURL + "&"
                    End If
                    mRedirectURL += "resthanx=1"
                    
                Else
                    mRedirectURL += "www.helipartner.ch"
                End If
            End If
        End If

        SendMail.AttachementPath = MailAttachment
        SendMail.IsSavedToDB = True
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        'SendMail.Sender = mSender
        'Mail's landeten im Spam (tropenhaus.cu3.ch), deswegen Sender umgestellt
        SendMail.Sender = "info@insyma.ch"
        'DevLog.Write("helping to find problem 1", "mailer_bestellung.aspx", "mSender", mSender)
		'DevLog.Write("helping to find problem 1", "mailer_bestellung.aspx", "mRecipient", mRecipient)
        SendMail.Recipient = mRecipient
        SendMail.Subject = mSubject
        SendMail.Body = mBody
        SendMail.LanguageID = mLanguageID
        SendMail.ObjID = formularID
        SendMail.FormURL = mRedirectURL.Replace("?resthanx=", "_")
        SendMail.RedirectURL = mRedirectURL
        SendMail.HTML = False
         TRY        
            SendMail.Send()
        Catch ex As Exception
	        DevLog.Write("Mail_Send", "mailer_bestellung.aspx", "SendMail.Send()", ex.Message)
			Throw
        End Try
    End Sub
	
    Sub Mail_Send2()
        ' Sender
        If Request.Form("Sender") <> "" Then
            mSender = Request.Form("Sender")
        Else
            mSender = Formular.Properties("sender").Value
        End If
        If Request.Form("Email") <> "" Then
            ' mSender = Request.Form("Email")
            mRecipient = Request.Form("Email").Replace(",", "")
        End If
        
        ' Subject
        mSubject = Formular.Properties("Subject").Value
        
        ' Redirect
        If Request.Form("Redirect") <> "" Then
            mRedirectURL = Request.Form("Redirect")
        Else
            If Formular.Properties("Redirect").Value <> "" Then
                mRedirectURL = Formular.Properties("Redirect").Value
            Else
                If Not Request.UrlReferrer Is Nothing Then
                    mRedirectURL = Request.UrlReferrer.ToString()
                                                
                    mRedirectURL = mRedirectURL.Replace("&resthanx=", "&")
                    mRedirectURL = mRedirectURL.Replace("?resthanx=", "?")
                    If mRedirectURL.IndexOf("?") = -1 Then
                        mRedirectURL = mRedirectURL + "?"
                    Else
                        mRedirectURL = mRedirectURL + "&"
                    End If
                    mRedirectURL += "resthanx=1"
                    
                Else
                    mRedirectURL += "www.helipartner.ch"
                End If
            End If
        End If
		
        SendMail.IsSavedToDB = True
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        'SendMail.Sender = mSender
        'Mail's landeten im Spam (tropenhaus.cu3.ch), deswegen Sender umgestellt
        SendMail.Sender = "info@insyma.ch"
        'DevLog.Write("helping to find problem 2", "mailer_bestellung.aspx", "mSender", mSender)
        'DevLog.Write("helping to find problem 2", "mailer_bestellung.aspx", "mRecipient", mRecipient)
        SendMail.Recipient = mRecipient
        SendMail.Subject = mSubject
        SendMail.Body = mail1 & vbCrLf & vbCrLf & mBody & vbCrLf & vbCrLf & mail2
        SendMail.LanguageID = mLanguageID
        SendMail.ObjID = formularID
        SendMail.FormURL = mRedirectURL.Replace("?resthanx=", "_")
        SendMail.RedirectURL = mRedirectURL
        SendMail.HTML = False
        TRY        
            SendMail.Send()
        Catch ex As Exception
			DevLog.Write("Mail_Send2", "mailer_bestellung.aspx", "SendMail.Send()", ex.Message)
			Throw
        End Try
    End Sub
        
    Sub Send_Mail_ByTopic(ByVal recipient As String)
       
                
        If Request.Form("Sender") <> "" Then
            mSender = Request.Form("Sender")
        Else
            mSender = Formular.Properties("sender").Value
        End If
        
        ' Subject
        mSubject = Formular.Properties("Subject").Value
        
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        SendMail.Sender = mSender
        SendMail.Subject = mSubject
        SendMail.Body = mBody
        SendMail.LanguageID = mLanguageID
        SendMail.ObjID = formularID
        SendMail.HTML = False
        SendMail.Recipient = recipient
    
        TRY        
            SendMail.Send()
        Catch ex As Exception
	        DevLog.Write("Send_Mail_ByTopic", "mailer_bestellung.aspx", "SendMail.Send()", ex.Message)
			Throw
        End Try
    End Sub
</script>
