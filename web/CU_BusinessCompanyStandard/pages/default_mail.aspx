<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Import Namespace="Insyma"  %>
<%@ Import Namespace="Insyma.ContentUpdate"  %>
<%@ Import Namespace="Insyma.MessageHandler"  %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Configuration" %>
<script runat="server">
Dim SendMail As New Insyma.MessageHandler.SendMessage
Dim mSubject as string = ""
dim mBody as string = ""
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
	mBody = "Werte Anwesende,<br /><br />"
	mBody += "Die Publizierung der News war erfolgreich<br /><br />"
	mSubject = "Publizierung der News bei " & CUPage.Web.Caption & " war erfolgreich!"
	mBody += "<table><tr><td>News</td><td>Aktivierung</td><td>Archivierung</td></tr>"
    Dim appSettings = ConfigurationManager.AppSettings
    Dim result As String = appSettings("DSN")
    'response.write(":::" & result)
	Dim conn As New OleDbConnection
    conn.ConnectionString = "Provider=SQLOLEDB;" & result
    Dim os as new ContentUpdate.Objectset()
    Dim strSQL As String = ""
    dim i as integer = 1
    Try
        conn.Open()
        
        os.loadByName("zennews_newslist")
        strSQL = "EXEC udsp_IND_CheckNewsEntries " & os.id
    
    
        Dim cmd As New OleDbCommand(strSQL, conn)
        Dim dr As OleDbDataReader = cmd.ExecuteReader()
        While dr.Read()
            if(dr(2) = 24)
                mBody += "<tr><td>" & i.toString() & "</td><td>" & dr(3) & "</td>"
            else
                mBody += "<td>" & dr(3) & "</td></tr>"
                i += 1
            end if


            'response.write("<br />" & dr(0) & ":" & dr(1) & ":" & dr(2) & ":::" & dr(3))
        End While
    Catch
        conn.close()
        result = result.replace("10.55.31.20", "10.55.31.21")
        conn.ConnectionString = "Provider=SQLOLEDB;" & result
        conn.Open()
        os.loadByName("zennews_newslist")
        strSQL = "EXEC udsp_IND_CheckNewsEntries " & os.id
        i = 1
        Try
            Dim cmd As New OleDbCommand(strSQL, conn)
            Dim dr As OleDbDataReader = cmd.ExecuteReader()
            While dr.Read()
                if(dr(2) = 24)
                    mBody += "<tr><td>" & i.toString() & "</td><td>" & dr(3) & "</td>"
                else
                    mBody += "<td>" & dr(3) & "</td></tr>"
                    i += 1
                end if


                'response.write("<br />" & dr(0) & ":" & dr(1) & ":" & dr(2) & ":::" & dr(3))
            End While
        Catch ex As Exception
            response.write("<!--" & ex.Message & ":::" & strSQL & "-->")
        End Try
    End Try
    conn.close()
    mBody += "</table><br /><br />Bis morgen<br />"
	mBody += "HINU"
	Send_Mail()
    CreateHurraEntry()
End Sub
Function CreateHurraEntry()
    Try
        dim pfad as string = "h:\Internet\curoot\Mandanten-Test\HINU\"
        dim datei as string = now().toString("yyyy-MM-dd") & "_newspublish.txt"
        response.write("<br />:::" & pfad & datei)
        If System.IO.File.Exists(pfad & datei) then
            response.write("<br />:::vorhanden")
        else
            System.IO.File.Create(pfad & datei).Dispose()
            response.write("<br />:::erstellen")
        end if
        Using w As StreamWriter = New StreamWriter(pfad & datei, true)
            ' Add some text to the file.
            vbNewLine.ToString()
            w.WriteLine(CUPage.Web.Caption)
            w.Close()
        End Using
    Catch  ex As Exception
        response.write("<br >--" & ex.Message)
    End Try
End Function
Sub Send_Mail()
	SendMail.ConnString = ContentUpdate.Utility.ConnString
    SendMail.Sender = "news@bcs.cu3.ch"
    SendMail.Subject = mSubject
    SendMail.Body = mBody
    SendMail.LanguageID = 0
    SendMail.ObjID = 0
    SendMail.HTML = true
	SendMail.Recipient = "helpdesk@insyma.com"
	SendMail.Send()
End Sub
</script>
<h1><%=mSubject%></h1>
<%=mBody%>