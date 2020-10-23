<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Data" %>

<script runat="server"> 
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		dim p as new contentupdate.page()
		p.load(34061)
		p.LanguageCode = CUpage.LanguageCode
		p.Preview = CUPage.Preview

		If CUPage.Preview = True Then
       		Session.Clear()
       		response.redirect(p.link)	
        else
			Response.Write("<%@ Page Language=""VB"" %>" & vbCrLf)
			Response.Write("<scr" & "ipt runat=""server"">" & vbCrLf)
			Response.Write("Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)" & vbCrLf)
			Response.write(" Session.Clear()"  & vbCrLf)
			Response.write(" response.redirect(""" & p.link & """)"  & vbCrLf)
			Response.Write("End Sub" & vbCrLf)
			Response.Write("</scr" & "ipt>" & vbCrLf)
        end if
					
    End Sub
</script>
