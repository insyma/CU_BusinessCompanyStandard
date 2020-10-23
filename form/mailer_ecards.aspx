<%@ Page Language="VB" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Import Namespace="Insyma"  %>
<%@ Import Namespace="Insyma.ContentUpdate"  %>
<%@ Import Namespace="Insyma.MessageHandler"  %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">

    Dim SendMail As New Insyma.MessageHandler.SendMessage
    
    Dim mSender As String = ""
    Dim mRecipient As String = ""
    Dim mSubject As String = ""
    Dim mBody As String = ""
    Dim mRedirectURL  As String = ""
    Dim mLanguageID As Integer = 0
    
    Dim Formular As ContentUpdate.Form
    Dim FormField As ContentUpdate.Field
    Dim formularID As String
    Dim formObjName As String
    Dim formObjCaption As String
    Dim formHiddenValue As String
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    
    	mRedirectURL = Request.UrlReferrer.ToString()
		
		mRedirectURL = mRedirectURL.Replace("&thanks=", "&")
		mRedirectURL = mRedirectURL.Replace("?thanks=", "?")
		mRedirectURL = mRedirectURL.Replace("&image=", "&")
		mRedirectURL = mRedirectURL.Replace("?image=", "?")
		if mRedirectURL.IndexOf("?") = -1 then
			mRedirectURL += "?"
		else
			mRedirectURL += "&"
		end if
		
		mBody += Request.Form("popup$ECardInfo")

		mBody = mBody.Replace("[AbsenderName]", Request.Form("AbsenderName"))
		mBody = mBody.Replace("[AbsenderMail]", Request.Form("AbsenderMail"))
		mBody = mBody.Replace("[Kommentar]", Request.Form("Kommentar"))
		mBody = mBody.Replace("[ECardLink]", mRedirectURL + "image=" + Request.Form("ImageID")) 

		IF Request.Form("Redirect") <> "" THEN
			mRedirectURL = Request.Form("Redirect")
		else
			mRedirectURL += "thanks=1"
		END IF
		
        ' Sprache Setzen
        if (not Request.QueryString("lang") = Nothing) Then
            mLanguageID = CInt(Request.QueryString("lang"))
        end if
        
        ' Mail versenden
        Mail_Send()
        
        ' Redirect
       Response.Redirect(mRedirectURL)
    End Sub
	
    Sub Mail_Send()
   
        ' Sender
        If Request.Form("AbsenderMail") <> "" Then
            mSender = Request.Form("AbsenderMail")
        End If
	
        ' Subject
        If Request.Form("popup$Subject") <> "" Then
            mSubject = Request.Form("popup$Subject") + " " + Request.Form("AbsenderMail")
        End If
	
        ' Recipient
        If Request.Form("Recipient") <> "" Then
            mRecipient = Request.Form("Recipient")
        End If

        SendMail.ConnString = ContentUpdate.Utility.ConnString
        SendMail.Sender = mSender
        SendMail.Recipient = mRecipient
        SendMail.Subject = mSubject
        SendMail.Body = mBody
        SendMail.LanguageID = mLanguageID
        SendMail.FormURL = mRedirectURL.Replace("thanks=1", "_")
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
<body bgcolor="#FFFFFF">Vielen Dank</body>
</html>
