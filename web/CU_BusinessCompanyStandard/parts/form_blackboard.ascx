<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ Import Namespace="Insyma.ContentUpdate" %>
<%@ Import Namespace="System.Web.Mail" %>
<script runat="server">
          dim adresse as string = ""
          dim msubject as string = ""
		  dim inserat as string = ""
		  dim daten as String = ""
		  Dim anzeigetyp as String
		  Dim kategorie as String
		  Dim beschreibung as String
		  
		  Dim feldName as String
		  Dim feldVorname as String
		  Dim feldEMail as String
		  Dim feldTel as String
		  Dim feldFax as String
		  Dim feldStrasse as String
		  Dim feldPlz as String
		  Dim feldOrt as String
		  Dim feldTitel as String
		  Dim feldBild as String
		  
		  dim validatetext as String = ""
		  
          Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
          
		  Dim Beschriftung as new contentupdate.container()
		  Beschriftung.LoadByName("blackboard_beschriftung")
		  Beschriftung.LanguageCode = CUPage.LanguageCode
		  daten = Beschriftung.Fields("daten").value
		  inserat = Beschriftung.Fields("inseratdaten").value
		  anzeigetyp = Beschriftung.Fields("anzeigetyp").value
		  kategorie = Beschriftung.Fields("kategorie").value
		  beschreibung = Beschriftung.Fields("beschreibung").value

		  
		  Dim BeschrForm As New contentupdate.container()
		  BeschrForm.LoadByName("blackboard_beschriftung_formular")
		  BeschrForm.LanguageCode = CUPage.LanguageCode
		  feldName = BeschrForm.Fields("name").value
		  feldVorname = BeschrForm.Fields("vorname").value
		  feldEMail = BeschrForm.Fields("eMail").value
		  feldTel = BeschrForm.Fields("telefon").value
		  feldFax = BeschrForm.Fields("fax").value
		  feldStrasse = BeschrForm.Fields("strasse").value
		  feldPlz = BeschrForm.Fields("plz").value
		  feldOrt = BeschrForm.Fields("ort").value
		  feldTitel = BeschrForm.Fields("titel").value
		  feldBild = BeschrForm.Fields("bild").value
		  
		  BeschrForm.loadByName("labelling_formval")
		  BeschrForm.LanguageCode = CUPage.LanguageCode
		  validatetext =  BeschrForm.Fields("val_norm").value
		  
          dim cont as new ContentUpdate.Container
          cont.loadByName("Blackboard_Formular")
		  cont.LanguageCode = CUPage.LanguageCode
          ConfirmationLiteral.Text = cont.Fields("Blackboard_DankeText").Value
          danke.visible = false
          'adresse = cont.Fields("mailadresse").Value
          'msubject = cont.Fields("mailsubject").Value
          If Not IsPostBack Then
          DankeLiteral.Mode = LiteralMode.PassThrough
          ConfirmationLiteral.Mode = LiteralMode.PassThrough
          DankeLiteral.Text = Container.Fields("Blackboard_DankeText").Value
          'ConfirmationLiteral.Text = Container.Fields("Blackboard_ConfirmationText").Value
          OnlineLiteral.Text = Container.Fields("OnlineText").Value
          ViewSwitcher.ActiveViewIndex = 0
          ViewState.Add("containerid", Container.Id)
          ViewState.Add("recipient", Container.Fields("recipient").Value)
          ViewState.Add("mailtextintern", Container.Fields("MailTextIntern").Value)
          'Validiert Seite (E-Mail-Validierung)
          Me.Page.Form.Attributes.Add("onsubmit", "return ValidateEmail()")
          If (CUPage.LanguageCode = 0) Then
          ValidationError.Text = "Es muss eine E-Mail-Adresse eingegeben werden."
          Else
          ValidationError.Text = "Vous devez donner une adresse e-mail."
          End If
          
          End If
          
          
          Dim z As New ContentUpdate.Page
          z.Load(CUPage.Id)
          z.LanguageCode = 0
          z.LanguageCode = 1
          
          If (CUPage.LanguageCode = 1) Then
          SendButton.Text = "Envoyer"
          ConfirmButton.Text = "Confirmer"
          SaveButton.Text = "Mémoriser"
          Else
          SendButton.Text = "Senden"
          ConfirmButton.Text = "Bestätigen"
          SaveButton.Text = "Speichern"
          End If
          
          
          Dim c As New ContentUpdate.Container
          c.LoadByName("Blackboard_RequestEntries")
          c.LanguageCode = CUPage.LanguageCode
          
          'Falls bestehender Eintrag: diesen Laden und e-mail-Adresse auf
          'nicht editierbar setzen
          'If (Request.QueryString("entryid") <> "") Then
'          
'			  'Dim objset As ContentUpdate.ObjectSet
''			  objset = c.ObjectSets(1)
''			  objset.Filter = "entryid='" & Request.QueryString("entryid") & "'"
''			  objset.ShowAll = True
''			  If (objset.Containers.Count > 0) Then
''				  Container = objset.Containers(1)
''				  SendButton.Visible = False
''				  SaveButton.Visible = False
''			  Else
''				  c.LoadByName("ConfirmationEntries")
''				  c.LanguageCode = CUPage.LanguageCode
''				  objset = c.ObjectSets(1)
''				  objset.Filter = "entryid='" & Request.QueryString("entryid") & "'"
''				  objset.ShowAll = True
''				  If (objset.Containers.Count > 0) Then
''					  Container = objset.Containers(1)
''					  ConfirmButton.Visible = False
''					  SendButton.Visible = False
''				  Else
''					ViewSwitcher.ActiveViewIndex = 3
''				  End If
''          		End If
'          
'          'email.Edit = False
'          Else
          Container = c.ObjectSets(1).GetMaster
          ConfirmButton.Visible = False
          SaveButton.Visible = False
'          End If
          
          End Sub
          ''' <summary>
          ''' Beim Absenden wird ein neuer Eintrag in die Liste eingefgt
          ''' und jedes Feld wird einzeln gesetzt. Zudem wird eine eindeutige ID generiert
          ''' und ein Workflow angestossen
          ''' </summary>
          ''' <param name="sender"></param>
          ''' <param name="e"></param>
          ''' <remarks></remarks>
          Protected Sub SendButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SendButton.Click
          Dim c As New ContentUpdate.Container
          c.LoadByName("Blackboard_RequestEntries")
          c.LanguageCode = CUPage.LanguageCode
          
          Dim newEntry As ContentUpdate.Container = c.ObjectSets(1).AddEntry()
          SaveFields(newEntry)
          newEntry.Fields("blackboard_entry_entryid").Value = ContentUpdate.Utility.GenerateRandomID(16)
          newEntry.Events("Add").Workflow.Start()
          
          SendMail(adresse, newEntry.Fields("blackboard_entry_entryid").Value)
          danke.visible = true
          'ViewSwitcher.ActiveViewIndex = 1
          End Sub
          
          Private Sub SaveFields(ByVal con As ContentUpdate.Container)
          For Each formfield As String In Request.Form.Keys
          con.Fields(formfield).Value = Request.Form(formfield)
          Next
          SaveImages(con)
          
          End Sub
          
          Private Sub SaveImages(ByVal con As ContentUpdate.Container)
          If (Bild1.HasFile) Then
          Dim filename As String = Bild1.PostedFile.FileName
          Dim filetype As String = FileTypeCheck(filename)
          Dim path As String = ""
          If (filetype.Length > 0) Then
          con.Images("blackboard_entry_Bild1").FileName = con.Images("blackboard_entry_Bild1").Id & "." & filetype
          
          path = con.Images("blackboard_entry_Bild1").ProcessedPath.Replace("\cuimgpath", "").Replace("/", "\")
          path = path.Substring(0, path.LastIndexOf("\") + 1) & con.Images("blackboard_entry_Bild1").FileName
          Bild1.PostedFile.SaveAs(path)
          
          con.Images("blackboard_entry_Bild1").ProcessImage(True)
          con.Images("blackboard_entry_Bild1").Width = 90
          con.Images("blackboard_entry_Bild1").Height = 70
          con.Images("blackboard_entry_Bild1").ProcessImage(True)
          End If
          End If
          If (Bild2.HasFile) Then
          Dim filename As String = Bild2.PostedFile.FileName
          Dim filetype As String = FileTypeCheck(filename)
          Dim path As String = ""
          If (filetype.Length > 0) Then
          con.Images("blackboard_entry_Bild2").FileName = con.Images("blackboard_entry_Bild2").Id & "." & filetype
          
          path = con.Images("blackboard_entry_Bild2").ProcessedPath.Replace("\cuimgpath", "").Replace("/", "\")
          path = path.Substring(0, path.LastIndexOf("\") + 1) & con.Images("blackboard_entry_Bild2").FileName
          Bild2.PostedFile.SaveAs(path)
          
          con.Images("blackboard_entry_Bild2").ProcessImage(True)
          con.Images("blackboard_entry_Bild2").Width = 90
          con.Images("blackboard_entry_Bild2").Height = 70
          con.Images("blackboard_entry_Bild2").ProcessImage(True)
          End If
          End If
          
          If (Bild3.HasFile) Then
          Dim filename As String = Bild3.PostedFile.FileName
          Dim filetype As String = FileTypeCheck(filename)
          Dim path As String = ""
          If (filetype.Length > 0) Then
          con.Images("blackboard_entry_Bild3").FileName = con.Images("blackboard_entry_Bild3").Id & "." & filetype
          
          path = con.Images("blackboard_entry_Bild3").ProcessedPath.Replace("\cuimgpath", "").Replace("/", "\")
          path = path.Substring(0, path.LastIndexOf("\") + 1) & con.Images("blackboard_entry_Bild3").FileName
          Bild3.PostedFile.SaveAs(path)
          
          con.Images("blackboard_entry_Bild3").ProcessImage(True)
          con.Images("blackboard_entry_Bild3").Width = 90
          con.Images("blackboard_entry_Bild3").Height = 70
          con.Images("blackboard_entry_Bild3").ProcessImage(True)
          End If
          End If
          
          If (Bild4.HasFile) Then
          Dim filename As String = Bild4.PostedFile.FileName
          Dim filetype As String = FileTypeCheck(filename)
          Dim path As String = ""
          If (filetype.Length > 0) Then
          con.Images("blackboard_entry_Bild4").FileName = con.Images("blackboard_entry_Bild4").Id & "." & filetype
          
          path = con.Images("blackboard_entry_Bild4").ProcessedPath.Replace("\cuimgpath", "").Replace("/", "\")
          path = path.Substring(0, path.LastIndexOf("\") + 1) & con.Images("blackboard_entry_Bild4").FileName
          Bild4.PostedFile.SaveAs(path)
          
          con.Images("blackboard_entry_Bild4").ProcessImage(True)
          con.Images("blackboard_entry_Bild4").Width = 90
          con.Images("blackboard_entry_Bild4").Height = 70
          con.Images("blackboard_entry_Bild4").ProcessImage(True)
          End If
          End If
          
          
          End Sub
          
          Private Function FileTypeCheck(ByVal filename As String) As String
          Dim filetype As String = filename.Substring(filename.LastIndexOf(".") + 1)
          If (filetype = "jpg" Or filetype = "jpeg" Or filetype = "gif" Or filetype = "bmp" Or filetype = "png") Then
          Return filetype
          Else
          Return ""
          End If
          End Function
          
          Protected Sub SaveButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SaveButton.Click
          'Dim c As New ContentUpdate.Container
'          c.LoadByName("ConfirmationEntries")
'          c.LanguageCode = CUPage.LanguageCode
'          
'          Dim objset As ContentUpdate.ObjectSet = c.ObjectSets(1)
'          objset.ShowAll = True
'          objset.Filter = "entryid='" & Request.QueryString("entryid") & "'"
'          If (objset.Containers.Count > 0) Then
'          Dim entry As ContentUpdate.Container = objset.Containers(1)
'          SaveFields(entry)
'          Response.Redirect(Request.Url.AbsoluteUri, True)
'          End If
'          End Sub
'          
'          Protected Sub ConfirmButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ConfirmButton.Click
'          Dim c As New ContentUpdate.Container
'          c.LoadByName("RequestEntries")
'          c.LanguageCode = CUPage.LanguageCode
'          
'          Dim objset As ContentUpdate.ObjectSet = c.ObjectSets(1)
'          objset.ShowAll = True
'          objset.Filter = "entryid='" & Request.QueryString("entryid") & "'"
'          If (objset.Containers.Count > 0) Then
'          Dim entry As ContentUpdate.Container = objset.Containers(1)
'          SaveFields(entry)
'          'Event ausfhren
'          entry.Events("Add").Workflow.NextTaskId = 0
'          entry.Events("Notification").Workflow.Tasks(4).XmlData("Recipient").Value = ViewState("recipient").ToString()
'          entry.Events("Notification").Workflow.Tasks(4).XmlData("Mailtext").Value = ViewState("mailtextintern").ToString()
'          entry.Events("Notification").Workflow.Tasks(4).XmlData("Sender").Value = entry.Fields("email").value
'          entry.Events("Notification").Workflow.Start()
'          'test.Text = entry.Events("Notification").Workflow.Tasks(4).Name
'          ViewSwitcher.ActiveViewIndex = 2
'          End If
          End Sub
          
          ' Versendet das Email samt Link zur Besttigung des Eintrags.
          
          Private Sub SendMail(ByVal recipient As String, ByVal entryid As String)
           	Dim con as new ContentUpdate.Container
				con.LoadByName("Blackboard_Formular")
				con.LanguageCode = CUPage.LanguageCode

			Dim mail
			Dim body as String
			Dim link as String
			Dim obj as Insyma.ContentUpdate.Obj
	
			body += con.fields("Blackboard_mailtext").value & vbcrlf & vbcrlf
			body += "http://www.contentupdate.net/[project]/tool/default.aspx"
		  
	 
			mail = new System.Web.Mail.MailMessage()
			mail.From = "helpdesk@insyma.com"
			mail.To = con.fields("Blackboard_recipient").value
			mail.Subject = con.fields("Blackboard_Mailsubject").value
			mail.Body = body
			'mail.BodyFormat = MailFormat.Html
			SmtpMail.Send(mail)
          'Dim mail As New System.Net.Mail.MailMessage(ViewState("recipient").ToString(), recipient)
'          Dim c As New Container
'          Dim smtpClient As New System.Net.Mail.SmtpClient()
'          Dim mailbody As String
'          Dim p As New ContentUpdate.Page
'          p.Load(Convert.ToInt32(Request.QueryString("parentpage")))
'          p.Preview = False
'          p.LanguageCode = CUPage.LanguageCode
'          
'          c.Load(ViewState("containerid"))
'          c.LanguageCode = CUPage.LanguageCode
'          mail.IsBodyHtml = True
'          mailbody = "Ein neuer Eintrag mit der Id '" & entryid & "' wurde empfangen!<br />"
'          'If (p.Preview) Then
'          
'          ' mailbody += "<a href=""" & p.AbsoluteLink & "&entryid=" & id & """>" & p.AbsoluteLink & "&entryid=" & id & "</a>"
'          ' Else
'          mailbody += "<a href=""http://www.contentupdate.net/ufaag/"">zum ContentUpdate</a>"
'          ' End If
'          
'          mail.Body = "<p style=""font-family:Verdana"">" & Insyma.ContentUpdate.Utility.EncodeToHtml(mailbody) & "</p>"
'          'mail.Subject = c.Fields("Mailsubject").Value
'          mail.Subject = msubject
'          mail.BodyEncoding = Encoding.GetEncoding(1252)
'          smtpClient.DeliveryMethod = SmtpDeliveryMethod.PickupDirectoryFromIis
'          smtpClient.Host = "localhost"
'          smtpClient.Send(mail)
          
          End Sub
          
          
          </script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">

function ValidateEmail()
{
	var validatetxt = '<%=validatetext%>';
	$('.validate').hide();
	if($('input[name=blackboard_entry_email]').length > 0)
		{
			var emailaddress = $("input[name=blackboard_entry_email]")[0].value;
			var regex=/^(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}$/;
			if(!emailaddress.match(regex))
				{
					var new_validatetxt = validatetxt.replace("[label]", $("input[name=blackboard_entry_email]").prev("label").text());
					$('input[name=blackboard_entry_email]').parent('li').html($('input[name=blackboard_entry_email]').parent('li').html() + "<br /><span class='validate'>" + new_validatetxt + "</span>");
					$('input[name=blackboard_entry_email]').focus();
					return false;
				}
		}
	
	if($('input[name=blackboard_entry_telefon]')[0].value.length < 7)
		{
			var new_validatetxt = validatetxt.replace("[label]", $("input[name=blackboard_entry_telefon]").prev("label").text());
			$('input[name=blackboard_entry_telefon]').parent('li').html($('input[name=blackboard_entry_telefon]').parent('li').html() + "<br /><span class='validate'>" + new_validatetxt + "</span>");
			$('input[name=blackboard_entry_telefon]').focus();
			return false;
		}
	if($('input[name=blackboard_entry_fax]')[0].value.length < 7)
		{
			var new_validatetxt = validatetxt.replace("[label]", $("input[name=blackboard_entry_fax]").prev("label").text());
			$('input[name=blackboard_entry_fax]').parent('li').html($('input[name=blackboard_entry_fax]').parent('li').html() + "<br /><span class='validate'>" + new_validatetxt + "</span>");
			$('input[name=blackboard_entry_fax]').focus();
			return false;
		}
	if($('input[name=blackboard_entry_name]')[0].value == "")
		{
			var new_validatetxt = validatetxt.replace("[label]", $("input[name=blackboard_entry_name]").prev("label").text());
			$('input[name=blackboard_entry_name]').parent('li').html($('input[name=blackboard_entry_name]').parent('li').html() + "<br /><span class='validate'>" + new_validatetxt + "</span>");
			$('input[name=blackboard_entry_name]').focus();
			return false;
		}
 	if($('input[name=blackboard_entry_vorname]')[0].value == "")
		{
			var new_validatetxt = validatetxt.replace("[label]", $("input[name=blackboard_entry_vorname]").prev("label").text());
			$('input[name=blackboard_entry_vorname]').parent('li').html($('input[name=blackboard_entry_vorname]').parent('li').html() + "<br /><span class='validate'>" + new_validatetxt + "</span>");
			$('input[name=blackboard_entry_vorname]').focus();
			return false;
		}
	if($('input[name=blackboard_entry_strasse]')[0].value == "")
		{
			var new_validatetxt = validatetxt.replace("[label]", $("input[name=blackboard_entry_strasse]").prev("label").text());
			$('input[name=blackboard_entry_strasse]').parent('li').html($('input[name=blackboard_entry_strasse]').parent('li').html() + "<br /><span class='validate'>" + new_validatetxt + "</span>");
			$('input[name=blackboard_entry_strasse]').focus();
			return false;
		}
	if($('input[name=blackboard_entry_plz]')[0].value.length < 4 || $('input[name=blackboard_entry_plz]')[0].value.length > 5)
		{
			var new_validatetxt = validatetxt.replace("[label]", $("input[name=blackboard_entry_plz]").prev("label").text());
			$('input[name=blackboard_entry_plz]').parent('li').html($('input[name=blackboard_entry_plz]').parent('li').html() + "<br /><span class='validate'>" + new_validatetxt + "</span>");
			$('input[name=blackboard_entry_plz]').focus();
			return false;
		}
	if($('input[name=blackboard_entry_ort]')[0].value == "")
		{
			var new_validatetxt = validatetxt.replace("[label]", $("input[name=blackboard_entry_ort]").prev("label").text());
			$('input[name=blackboard_entry_ort]').parent('li').html($('input[name=blackboard_entry_ort]').parent('li').html() + "<br /><span class='validate'>" + new_validatetxt + "</span>");
			$('input[name=blackboard_entry_ort]').focus();
			return false;
		}
	if($('input[name=blackboard_entry_titel]')[0].value == "")
		{
			var new_validatetxt = validatetxt.replace("[label]", $("input[name=blackboard_entry_titel]").prev("label").text());
			$('input[name=blackboard_entry_titel]').parent('li').html($('input[name=blackboard_entry_titel]').parent('li').html() + "<br /><span class='validate'>" + new_validatetxt + "</span>");
			$('input[name=blackboard_entry_titel]').focus();
			return false;
		}
	if($('textarea[name=blackboard_entry_description]')[0].value == "")
		{
			var new_validatetxt = validatetxt.replace("[label]", $("input[name=blackboard_entry_description]").prev("label").text());
			$('textarea[name=blackboard_entry_description]').parent('li').html($('textarea[name=blackboard_entry_description]').parent('li').html() + "<br /><span class='validate'>" + new_validatetxt + "</span>");
			$('textarea[name=blackboard_entry_description]').focus();
			return false;
		}
}
</script>

<div class="form_blackboard formular clearfix">
  <asp:MultiView ID="ViewSwitcher" runat="server">
    <asp:View ID="formview" runat="server">
      <p id="ValidationErrorPart" style="display:none">
        <asp:Literal ID="ValidationError" runat="server"></asp:Literal>
      </p>
      
        <h4 class="danke" id="danke" runat="server">
          <asp:Literal ID="ConfirmationLiteral" runat="server"></asp:Literal>
        </h4>
        <ul>
        </ul>
        <ul class="clearfix">
        <li class="distance"><%=daten %></li>
        <li>
        <label><%=feldName %></label>
          <CU:CUField ID="name" Edit="true" Name="blackboard_entry_name" runat="server"></CU:CUField>
        </li>
        <li>
          <label><%=feldVorname %></label>
          <CU:CUField ID="vorname" Edit="true" Name="blackboard_entry_vorname" runat="server"></CU:CUField>
        </li>
        <li>
         <label><%=feldEMail %></label>
          <CU:CUField ID="email" Edit="true" Name="blackboard_entry_email" runat="server"></CU:CUField>
        </li>
        <li>
          <label><%=feldTel %></label>
          <CU:CUField ID="telefon" Edit="true" Name="blackboard_entry_telefon" runat="server"></CU:CUField>
        </li>
        <li>
          <label><%=feldFax %></label>
          <CU:CUField ID="fax" Edit="true" Name="blackboard_entry_fax" runat="server"></CU:CUField>
        </li>
        <li>
          <label><%=feldStrasse %></label>
          <CU:CUField ID="strasse" Edit="true" Name="blackboard_entry_strasse" runat="server"></CU:CUField>
        </li>
        <li>
          <label><%=feldPlz %></label>
          <CU:CUField ID="plz" Edit="true" Name="blackboard_entry_plz" runat="server"></CU:CUField>
        </li>
        <li>
          <label><%=feldOrt %></label>
          <CU:CUField ID="ort" Edit="true" Name="blackboard_entry_ort" runat="server"></CU:CUField>
        </li>
        </ul>
        <ul>
        <li class="distance"><%=inserat %></li>
         <li>
          <label><%=anzeigetyp %></label>
          <CU:CUField ID="CUField2" Edit="true" Name="blackboard_entry_Art" runat="server"></CU:CUField>
        </li>
        <li>
          <label><%=kategorie %></label>
          <CU:CUField ID="CUField12" Edit="true" Name="blackboard_entry_Kategorie" runat="server"></CU:CUField>
        </li>
        <li>
 		<label><%=feldTitel %></label>          
        <CU:CUField ID="titel" Edit="true" Name="blackboard_entry_titel" runat="server"></CU:CUField>
        </li>
        <li>
 		<label><%=beschreibung %></label>          
        </li>
        <li>
          <CU:CUField ID="description" Edit="true" Name="blackboard_entry_description" runat="server"></CU:CUField>
        </li>
        <li>
		<label><%=feldBild %> 1</label> 
          <CU:CUImage Preview="true" Thumbnail=true  Name="blackboard_entry_Bild1" runat="server" />
          <asp:FileUpload ID="Bild1" runat="server"  cssclass="bild"/>
        </li>
        <li>
		<label><%=feldBild %> 2</label> 
          <CU:CUImage Preview="true" Thumbnail=true  Name="blackboard_entry_Bild2" runat="server" />
          <asp:FileUpload ID="Bild2" runat="server" cssclass="bild"/>
        </li>
        <li>
		<label><%=feldBild %> 3</label>           
        <CU:CUImage Preview="true" Thumbnail=true  Name="blackboard_entry_Bild3" runat="server" />
          <asp:FileUpload ID="Bild3" runat="server" cssclass="bild"/>
        </li>
        <li>
		<label><%=feldBild %> 4</label>           
        <CU:CUImage Preview="true" Thumbnail=true  Name="blackboard_entry_Bild4" runat="server" />
          <asp:FileUpload ID="Bild4" runat="server" cssclass="bild"/>
        </li>
      </ul>
      <p>
        <asp:Button ID="SendButton" runat="server" Text="Senden" CssClass="submit" />
      </p>
      <asp:Button ID="ConfirmButton" runat="server" Text="Bestätigen" />
      <asp:Button ID="SaveButton" runat="server" Text="Speichern" />
    </asp:View>
    <asp:View ID="DankeView" runat="server">
      <asp:Literal ID="DankeLiteral" runat="server"></asp:Literal>
    </asp:View>
    <asp:View ID="ConfirmationView" runat="server">
      <asp:Literal ID="ConfirmationLiteral2" runat="server"></asp:Literal>
    </asp:View>
    <asp:View ID="AlreadyOnlineView" runat="server">
      <asp:Literal ID="OnlineLiteral" runat="server"></asp:Literal>
    </asp:View>
  </asp:MultiView>
  <asp:Literal id="test" runat="server"></asp:Literal>
</div>
