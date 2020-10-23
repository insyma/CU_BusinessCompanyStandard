<%@ Page Language="VB" %>

<%@ Import Namespace="Insyma" %>
<%@ Import Namespace="Insyma.ContentUpdate" %>
<%@ Import Namespace="System.Web.Mail" %>
<%@ Import Namespace="Insyma.MessageHandler" %>
<%@ Import Namespace="Insyma.Contact" %>

<script runat="server">
	
	Dim strText as String
	Dim strName as String
	Dim strSubject as String
	Dim strSender as String
	Dim FormID as String
	Dim strFieldName as String
	Dim strFieldCaption as String
	Dim strRecipient as String
	Dim strFormRecipient as String
	
    
    Dim mailbody As String = ""
    Dim mailbodybestaetigung As String = ""
    Dim name As String = ""
    Dim vorname As String = ""
    Dim adresse As String = ""
    Dim plz As String = ""
    Dim ort As String = ""
    Dim postfach As String = ""
    Dim tel As String = ""
    Dim anrede As String = ""
    Dim abteilung As String = ""
    Dim firma As String = ""
    Dim recmail As String = ""
    Dim land As String = ""
    Dim SendMail As New Insyma.MessageHandler.SendMessage

    
    
    Sub Page_Load(Src As Object, E As EventArgs)
    
        Dim zwischentotal As New ContentUpdate.Field
        zwischentotal.LoadByName("total_bestellwert")
        
        Dim rechnungsbetrag As New ContentUpdate.Field
        rechnungsbetrag.LoadByName("total_rechnungsbetrag")
        
        Dim anfragetext As New ContentUpdate.Field
        anfragetext.LoadByName("preis-auf-anfrage")
         
        Dim anfragemailtext As New ContentUpdate.Field
        anfragemailtext.LoadByName("anfragemailtext")
        
        Dim separator(1) As String
        separator(0) = "__"
        Dim lieferadresse As Boolean = False
        Dim rechnungsadresse As Boolean = False
        Dim totalpreis As Double = 0.0
        Dim MwStSatz As Double = 0.0
        Dim MwStField As New Insyma.ContentUpdate.Field
        MwStField.LoadByName("mwstwert")
        Dim Versandkosten As Double = 0.0
        Dim VersandkostenField As New Insyma.ContentUpdate.Field
        Dim anfrage As Boolean = False
        
        If (Request.QueryString("land") Is Nothing) Then
            VersandkostenField.LoadByName("versandkostenwert")
        Else
            VersandkostenField.LoadByName("versandkostenwertausland")
        End If
        
        dim r_adresse as string
        dim l_adresse as string
        
        MwStSatz = CType(MwStField.Value, Double)
        
        Versandkosten = CType(VersandkostenField.Value, Double)
                
        Dim contactsaved As Boolean = False
        For Each key As String In Request.Form.AllKeys
            If (Not key Is Nothing) Then
                If (key.StartsWith("prod")) Then
                    Dim proddata() As String = Request.Form(key).Split(separator, StringSplitOptions.None)
                    If (proddata.Length = 3) Then
                        Dim stueck As Integer = CType(proddata(0), Integer)
                        If (Not IsNumeric(proddata(2))) Then
                            mailbody &= proddata(0) & " Stk. " & proddata(1) & " - " & anfragetext.Value & vbCrLf & vbCrLf
                            mailbodybestaetigung &= proddata(0) & " Stk. " & proddata(1) & " - " & anfragetext.Value & vbCrLf & vbCrLf
                            anfrage = True
                        Else
                            Dim preisStueck As Double = CType(proddata(2), Double)
                            Dim totpreis As Double = stueck * preisStueck
                            totalpreis += totpreis
                            mailbody &= proddata(0) & " Stk. " & proddata(1) & " à CHF " & preisStueck.ToString("###,###.00") & vbCrLf & vbCrLf
                            mailbodybestaetigung &= proddata(0) & " Stk. " & proddata(1) & " à CHF " & preisStueck.ToString("###,###.00") & vbCrLf & vbCrLf
                        
                        End If
                        
                    End If
                End If
                
                If (key.StartsWith("L_")) Then
                    If (Not lieferadresse) Then
                        l_adresse &= "" & vbCrLf & vbCrLf & "Lieferadresse" & vbCrLf & vbCrLf
                    End If
                    l_adresse &= key.Substring(2) & ": " & Request.Form(key) & vbCrLf
                    If (key.ToLower().IndexOf("anrede") > -1) Then
                        anrede = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("nachname") > -1) Then
                        name = Request.Form(key)
                    End If
                    lieferadresse = True
                    If (Request.Form(key).IndexOf("@") > -1 AndAlso Request.Form(key).IndexOf(".") > -1) Then
                        recmail = Request.Form(key)
                    End If
                    
                    If (key.ToLower().IndexOf("vorname") > -1) Then
                        vorname = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("strasse") > -1) Then
                        adresse = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("postfach") > -1) Then
                        postfach = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("plz") > -1) Then
                        plz = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("ort") > -1) Then
                        ort = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("tel") > -1) Then
                        tel = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("land") > -1) Then
                        land = Request.Form(key)
                    End If
                    
                    If (key.ToLower().IndexOf("abt") > -1) Then
		                            abteilung = Request.Form(key)
                    End If
                    
                    If (key.ToLower().IndexOf("firma") > -1) Then
		                            firma = Request.Form(key)
                    End If
                    
                End If
                                                
                If (key.StartsWith("R_")) Then
                    If (Not rechnungsadresse) Then
                        r_adresse &= "" & vbCrLf & vbCrLf & "Rechnungsadresse" & vbCrLf & vbCrLf
                    End If
                    r_adresse &= key.Substring(2) & ": " & Request.Form(key) & vbCrLf
                    rechnungsadresse = True
                    
                    
                    If (key.ToLower().IndexOf("anrede") > -1) Then
                        anrede = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("nachname") > -1) Then
                        name = Request.Form(key)
                    End If
                    
                    If (Request.Form(key).IndexOf("@") > -1 AndAlso Request.Form(key).IndexOf(".") > -1) Then
                        recmail = Request.Form(key)
                    End If
                    
                    If (key.ToLower().IndexOf("vorname") > -1) Then
                        vorname = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("strasse") > -1) Then
                        adresse = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("postfach") > -1) Then
                        postfach = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("plz") > -1) Then
                        plz = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("ort") > -1) Then
                        ort = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("tel") > -1) Then
                        tel = Request.Form(key)
                    End If
                    If (key.ToLower().IndexOf("land") > -1) Then
                        land = Request.Form(key)
                    End If
                    
                    If (key.ToLower().IndexOf("abt") > -1) Then
		    		                            abteilung = Request.Form(key)
		                        End If
		                        
		                        If (key.ToLower().IndexOf("firma") > -1) Then
		    		                            firma = Request.Form(key)
                    End If
                    
                End If
                
            End If
        Next

        
        contactsaved = SaveContact()
        
        'Abfüllen der Bestätigungs-Infos
        Dim beschriftungscontainer As New Insyma.ContentUpdate.Container()
        Dim mwstwert As Double = (totalpreis + Versandkosten) * (MwStSatz / 100)
        
        mwstwert = Math.Round((Math.Round(mwstwert * 100) / 100) * 20) / 20
        
        beschriftungscontainer.LoadByName("beschriftungen-shop-email")
        Dim mailtext As String = ""
        If (anrede.ToLower() = "herr") Then
            mailtext = beschriftungscontainer.Fields("anrede_m").Value & " " & anrede & " " & name & vbCrLf & vbCrLf
        Else
            mailtext = beschriftungscontainer.Fields("anrede_f").Value & " " & anrede & " " & name & vbCrLf & vbCrLf
        End If
        mailtext &= beschriftungscontainer.Fields("mailtext").Value & vbCrLf & vbCrLf & vbCrLf
        mailbodybestaetigung = mailtext & mailbodybestaetigung & vbCrLf
        mailbodybestaetigung &= zwischentotal.Value & ": CHF " & totalpreis.ToString("##.00") & vbCrLf
        mailbodybestaetigung &= "Versandkosten: CHF " & Versandkosten.ToString("##.00") & vbCrLf
        mailbodybestaetigung &= "MwSt " & MwStSatz.ToString() & "% : CHF " & mwstwert.ToString("###,###.00") & vbCrLf
        mailbodybestaetigung &= rechnungsbetrag.Value & " : CHF " & (totalpreis + Versandkosten + mwstwert).ToString("###,###.00") & vbCrLf
 
        mailbody &= zwischentotal.Value & ": CHF " & totalpreis.ToString("##.00") & vbCrLf
        mailbody &= "Versandkosten: CHF " & Versandkosten.ToString("##.00") & vbCrLf
        mailbody &= "MwSt " & MwStSatz.ToString() & "% : CHF " & mwstwert.ToString("###,###.00") & vbCrLf
        mailbody &= rechnungsbetrag.Value & " : CHF " & (totalpreis + Versandkosten + mwstwert).ToString("###,###.00") & vbCrLf

        mailbody &= vbcrlf & l_adresse & vbcrlf & vbcrlf & r_adresse
 
 '       If ((Request.QueryString("privat") = "1" AndAlso contactsaved AndAlso Request.QueryString("abb") Is Nothing) OrElse Not Request.QueryString("land") Is Nothing) Then
 '           mailbodybestaetigung &= vbCrLf & vbCrLf & beschriftungscontainer.Fields("mailtextvorauszahlung").Value & vbCrLf
 '       End If      
        
        If ( contactsaved ) Then
            mailbodybestaetigung &= vbCrLf & vbCrLf & beschriftungscontainer.Fields("mailtextvorauszahlung").Value & vbCrLf
        End If
        
        
        If (anfrage) Then
            mailbodybestaetigung &= vbCrLf & vbCrLf & anfragemailtext.Value & vbCrLf
        End If
        
        mailbodybestaetigung &= vbCrLf & vbCrLf & beschriftungscontainer.Fields("mail_gruss").Value & vbCrLf
            
        If (Not rechnungsadresse) Then
            mailbody &= vbCrLf & " Rechnungsadresse ist identisch mit der Lieferadresse" & vbCrLf
        End If
        Mail_SendOrder(mailbody)
        Mail_SendOrderBestaetigung(mailbodybestaetigung, recmail)
    End Sub
    Dim cid As String = "0"
    Function SaveContact() As Boolean
        Dim ordercontact As New Insyma.Contact.Contact
        ordercontact.ContactStatus = ""
        ordercontact.Email = recmail
        ordercontact.Search()
        
        If (ordercontact.ContactID = "") Then
            ordercontact.FirstName = vorname
            ordercontact.SurName = name
            ordercontact.Address1 = adresse
            ordercontact.PostalCode = plz
            ordercontact.City = ort

ordercontact.Company = firma
ordercontact.Departement = abteilung

            If (land.ToLower().Contains("schweiz")) Then
                ordercontact.CountryCode = "756"
            End If
            
            If (land.ToLower().Contains("liechtens")) Then
                ordercontact.CountryCode = "900"
            End If
            
            If (land.ToLower().Contains("österr")) Then
                ordercontact.CountryCode = "40"
            End If
            If (land.ToLower().Contains("deutschl")) Then
                ordercontact.CountryCode = "276"
            End If
                
            
            ordercontact.Email = recmail
            ordercontact.Phone = tel
            ordercontact.PostBox = postfach
            If (anrede.ToLower() = "herr") Then
                ordercontact.SalutationID = "1"
            Else
                ordercontact.SalutationID = "2"
            End If
            ordercontact.LanguageID = "0"
            ordercontact.ContactStatus = "3"
            ordercontact.MailFormatID = "2"
            ordercontact.generateCode()
            ordercontact.Source = "Bestellformular"
            ordercontact.Save()
            cid = ordercontact.ContactID
            Return True
        Else
            cid = ordercontact.ContactID
            Return False
        End If
	
    End Function
    
    Sub Mail_SendOrderBestaetigung(ByVal strBody As String, ByVal recipient As String)
        Dim sender As New Insyma.ContentUpdate.Field
        sender.LoadByName("mailabsender")
        
        Dim subject As New Insyma.ContentUpdate.Field
        subject.LoadByName("mailbetreff_Order")
        
        
        strSender = sender.Value
        strRecipient = recipient
        strSubject = subject.Value
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        SendMail.Sender = strSender
        SendMail.Recipient = recipient
        SendMail.Subject = strSubject
        If (IsNumeric(cid)) Then
            SendMail.ContactID = Integer.Parse(cid)
        End If
        
        SendMail.Body = strBody
        SendMail.LanguageID = 0
        
        SendMail.HTML = False
        SendMail.Send_Message()
    End Sub
    
    
    
    Sub Mail_SendOrder(ByVal strBody As String)
        Dim sender As New Insyma.ContentUpdate.Field
        sender.LoadByName("empfaenger-audioprotect")
        
        
        strSender = sender.Value
        strRecipient = sender.Value
        strSubject = "Bestellung"
        SendMail.ConnString = ContentUpdate.Utility.ConnString
        SendMail.Sender = strSender
        SendMail.Recipient = strRecipient
        SendMail.Subject = strSubject
        
        SendMail.Body = strBody
        SendMail.LanguageID = 0
        SendMail.HTML = False
        SendMail.Send_Message()
    End Sub
	
</script>

<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#FFFFFF">
    <h3>
        Vielen Dank</h3>
</body>
</html>
