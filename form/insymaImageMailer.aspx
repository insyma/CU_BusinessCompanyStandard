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
    Dim mRedirectURL  As String = ""
    Dim mLanguageID As Integer = 0
        
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    
    	mRedirectURL = Request.UrlReferrer.ToString()
		
		mRedirectURL = mRedirectURL.Replace("&thanks=", "&").Replace("&fwCase=", "&")
		mRedirectURL = mRedirectURL.Replace("?thanks=", "?").Replace("?fwCase=", "?")
		if mRedirectURL.IndexOf("?") = -1 then
			mRedirectURL += "?"
		else
			mRedirectURL += "&"
		end if
		
        If Request.Form("fwMessage") <> "" Then
            mBody += Request.Form("fwMessage")
			'mBody = mBody.replace()
        Else
            mBody += "---------------------------------------------------------------" & vbCrLf
            mBody += "Folgendes Bild wurde Ihnen von [AbsenderName] ([AbsenderMail]) empfohlen. Sie können das Bild anschauen unter: [ImageUrl]" & vbCrLf

            mBody += "---------------------------------------------------------------" & vbCrLf
            mBody += "Kommentar von [AbsenderName]: [Kommentar]" & vbCrLf

            mBody += "---------------------------------------------------------------" & vbCrLf

        End If
		mBody = mBody.Replace("[AbsenderName]", Request.Form("AbsenderName"))
        mBody = mBody.Replace("[AbsenderMail]", Request.Form("AbsenderMail"))
        mBody = mBody.Replace("[Kommentar]", Request.Form("Kommentar"))
        mBody = mBody.Replace("[ImageUrl]", Request.Form("fwImageUrl"))
        mBody = mBody.Replace("[ECardLink]", Request.Form("fwRedirect"))
		
        'If Request.Form("fwRedirect") <> "" Then
'            mRedirectURL = Request.Form("fwRedirect")
'			if mRedirectURL.IndexOf("?") = -1 then
'				mRedirectURL += "?thanks=1&fwCase=" + Request.Form("fwCase")
'			else
'				mRedirectURL += "&thanks=1&fwCase=" + Request.Form("fwCase")
'			end if
'        Else
            mRedirectURL += "thanks=1&fwCase=" + Request.Form("fwCase")
        'End If
		
        ' Sprache Setzen
        If (Not Request.QueryString("lang") = Nothing) Then
            mLanguageID = CInt(Request.QueryString("lang"))
        End If
        
        ' Mail versenden
        Mail_Send()
        
        ' Redirect
        Response.Redirect(mRedirectURL)
    End Sub
	
    Sub Mail_Send()
   
        ' Sender
        If Request.Form("fwSender") <> "" Then
            mSender = Request.Form("fwSender")
        End If
	
        ' Subject
        If Request.Form("fwSubject") <> "" Then
            mSubject = Request.Form("fwSubject") + " " + Request.Form("AbsenderName")
        End If
	
        ' Recipient
        If Request.Form("Recipient") <> "" Then
            mRecipient = Request.Form("Recipient")
        End If
        'response.Write(mSender & " | " & mRecipient & " | " & mSubject & " | " & mBody & " | " & mRedirectURL)
        SendMail.IsSavedToDB = True
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        SendMail.Sender = mSender
        SendMail.Recipient = mRecipient
        SendMail.Subject = mSubject
        SendMail.Body = mBody
        SendMail.LanguageID = mLanguageID
        SendMail.FormURL = mRedirectURL
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
<body bgcolor="#FFFFFF"><div>Vielen Dank</div></body>
</html>
