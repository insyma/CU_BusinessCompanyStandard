<%@ Page Language="VB" %>
<%@ Import Namespace="Insyma"  %>
<%@ Import Namespace="Insyma.ContentUpdate"  %>
<%@ Import Namespace="System.Web.Mail" %>

<script runat="server">

	Dim Formular as ContentUpdate.Form
	Dim Form as ContentUpdate.Field
	Dim CUField as ContentUpdate.Field
	Dim strText as String
	Dim strName as String
	Dim strSubject as String
	Dim strSender as String
	Dim FormID as String
	Dim strFieldName as String
	Dim strFieldCaption as String
	Dim strRecipient as String
	Dim strFormRecipient as String
	Dim Redirect AS String
	
	Dim mail as MailMessage

    Sub Page_Load(Src As Object, E As EventArgs)
		
		FormID = Request.Querystring("Form_id")
		
			if FormID <> "" then

				Formular = new ContentUpdate.Form()
				Formular.LanguageCode = Request.Querystring("lang")
				Formular.load(FormID)
				
				strText = ""
				strFormRecipient = ""
				
				' Für jeden Container im Formular
				For each Area as ContentUpdate.Container in Formular.Containers
				
					' Titel pro Block
					For each AreaField as ContentUpdate.Field in Area.Fields
						if AreaField.ObjName = "title" then
							'strText = strText & vbcr & "**** " & vblf & AreaField.value & " ****" & vbcr & vblf
						end if
					Next
					
					
					Dim countField as Integer
					countField = 0
					
					' Felder pro Block
					For each FormField as ContentUpdate.Question in Area.Questions
						strFieldName = FormField.ObjName
						strFieldCaption = FormField.Caption

						' Radiobutton oder Checkbox
						if FormField.properties("QuestionType").value = "0" then
							if not FormField.properties("MultipleAnswer").value = "1" then
								'Radiobutton
								strText = strText & Left(strFieldCaption &":" & space(15),15) & " "
								'if countField = 0 then
								'	strText = strText & vbcr & vblf
								'	countField = countField + 1
								'end if
								'For each AnswerField as ContentUpdate.Answer in FormField.Answers
									if not (Request.Form(FormField.ObjName) = "") then
										'if Request.Form(AnswerField.ObjName).IndexOf(AnswerField.Value) > -1 then
												strText = strText & Request.Form(FormField.ObjName) & vbcr & vblf	
										'end if
									end if
									'Exit For
								'Next
							else
								'Checkbox
								strText = strText & FormField.Caption & vbcr & vblf
								For each AnswerField as ContentUpdate.Answer in FormField.Answers
									if not (Request.Form(AnswerField.ObjName) = "") then
										strText = strText & space(2) & "- " & Request.Form(AnswerField.ObjName) & vbcr & vblf
									end if
								Next
							end if
						
						' Textbox oder Dropdown
						else
							if FormField.properties("HiddenValue").value = "1" then
								if not Request.Form(strFieldName) = "" then
									CUField = new ContentUpdate.Field
									CUField.Load(CInt(Request.Form(strFieldName)))
									strFormRecipient = CUField.value
								end if
								strName = Left(strFieldCaption &":" & space(15),15) & " "
								strText = strText & strName & strFormRecipient & vbcr & vblf
							else
								strName = Left(strFieldCaption &":" & space(15),15) & " "
								strText = strText & strName & Request.Form(strFieldName) & vbcr & vblf
							end if
						end if
					Next
				Next
				
				'Dim valuearray() as String
				'valuearray = Request.Form("CatTopicID").Split(",")
				'for i as Integer =0 to valuearray.Length -1
				'	strText = strText & space(2) & "IDs " & valuearray(i) & vbcr & vblf	
				'next
										
				
				' Mail senden und den Body übergeben
				Mail_Send(strText)
			
				' Redirect
				IF Request.Form("Redirect") <> "" then
					Response.Redirect(Request.Form("Redirect"))
				else
					IF Formular.Properties("Redirect").value <> "" then
						Response.Redirect(Formular.Properties("Redirect").value)
					ELse
						Redirect = Request.UrlReferrer.ToString()
						
						Redirect = Redirect.Replace("&thanks=", "&")
						Redirect = Redirect.Replace("?thanks=", "?")
						if Redirect.IndexOf("?") = -1 then
							Redirect = Redirect + "?"
						else
							Redirect = Redirect + "&"
						end if
						Redirect = Redirect + "thanks=1"
						
						Response.Redirect(Redirect)
					End if
				end if
			end if
	End Sub
	
	Sub Mail_Send(strBody as String)

		if Request.Form("Sender") <> "" then
			strSender = Request.Form("Sender")
		else
			strSender = Formular.Properties("sender").value
		end if

		if Request.Form("Email") <> "" then
			strSender = Request.Form("Email")
		end if

		if Request.Form("Subject") <> "" then
			strSubject  = Request.Form("Subject")
		else
			strSubject = Formular.Properties("Subject").value
		end if

		if strFormRecipient <> "" then
			strRecipient  = strFormRecipient
		else
			if Request.Form("Recipient") <> "" then
				strRecipient  = Request.Form("Recipient")
			else
				strRecipient = Formular.Properties("Recipient").value
			end if
		end if

		mail = new System.Web.Mail.MailMessage()
		mail.From = strSender
		mail.To = strRecipient
		mail.Subject = strSubject
		mail.Body = strBody
		mail.BodyFormat = MailFormat.Text
		SmtpMail.Send(mail)
	End Sub
	
</script>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>

<body bgcolor="#FFFFFF">
<H3>Vielen Dank</H3>
</body>
</html>
