<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Dim RefObj As New ContentUpdate.Obj
    Dim ConCount As Integer = 0
    Dim ShowContentMenu As Boolean = False
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)		
		If Container.Fields("text").Value = "" Then
            TextObj.Visible = False
		else
			TextObj.InnerHtml = Container.Fields("text").Value.Replace("<ol>","<ol style='padding:0;margin:0;list-style-position:inside;'>").Replace("<ul>","<ul style='list-style:none;list-style-position:inside;padding:0;margin:0;'>").Replace("<a","<a style='color:#FB2701;'") & "<br />"
			if not (InStrRev(TextObj.InnerHtml,"<ul")) = 0 then
				If Instr(Right(TextObj.InnerHtml,Len(TextObj.InnerHtml) - InStrRev(TextObj.InnerHtml,"<ul")),">") Then
					Dim liTag as string = ""
					liTag = Right(TextObj.InnerHtml,Len(TextObj.InnerHtml) - InStrRev(TextObj.InnerHtml,"<ul"))
					if not (InStrRev(TextObj.InnerHtml,"<ol")) = 0 then
						liTag = Left(liTag,Len(Right(TextObj.InnerHtml,Len(TextObj.InnerHtml) - InStrRev(TextObj.InnerHtml,"</ul"))))
					end if
					liTag = Right(liTag,Len(liTag) - InStr(liTag,">"))
					TextObj.InnerHtml = TextObj.InnerHtml.Replace(liTag, liTag.Replace("<li>","<li style='list-style:none;'><img src=""http://www.cu3.ch/CU_BCS/mail/img/layout/list-style.gif"" alt=""*"" width=""9"" height=""10"" />&nbsp;"))
				End IF		
			end if
        End If
    End Sub
</script>
<%  If TemplateView = "text" Then%>
[Particulars]

<%  If Not Container.Fields("titel").Value = "" Then%><%=vbcrlf%><CU:CUField Name="titel" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("einleitung").Value = "" Then%><CU:CUField name="einleitung" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("text").Value = "" Then%><%=vbcrlf%><CU:CUField Name="text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("regards").Value = "" Then%><%=vbcrlf%><CU:CUField Name="regards" runat="server" PlainText="true" /><%=vbcrlf%><% end if %><%else %>
<table class="part_introduction" width="371" border="0" cellspacing="0" cellpadding="0" align="center" style="background:#ffffff" bgcolor="#ffffff">
    <tr>
        <td bgcolor="#ffffff" align="left" width="371" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="20" /></td>
    </tr>
    <tr>
        <td bgcolor="#ffffff" align="left" width="371" style="background:#ffffff; color: #66676c; font-size: 20px; font-family: Georgia, Times New Roman, serif;line-height: 24px;">
            <CUSalutation>[Particulars]</CUSalutation>
        </td>
    </tr>
    <tr>
        <td bgcolor="#ffffff" align="left" width="371" style="background: #ffffff; line-height: 0; font-size: 1px;"><img src="http://www.cu3.ch/cu_BCS/mail/img/layout/breaker.gif" alt="*" width="5" height="20" /></td>
    </tr>
    <tr>
        <td bgcolor="#ffffff" align="left" width="371" style="background: #ffffff;color: #66676c; font-size: 12px; font-family: Arial, Verdana, sans-serif;line-height: 16px;">
              <% If Not Container.Fields("einleitung").Value = "" Then%>
                <strong><CU:CUField Name="einleitung" runat="server" /></strong><br />&nbsp;<br />
              <%end if%>                                      
              <span id="TextObj" runat="server"></span>
              <% If Not Container.Fields("regards").Value = "" Then%>
                <CU:CUField Name="Regards" runat="server" /><br />&nbsp;<br />
              <%end if%>  
        </td>
    </tr>
</table>
<%end if %>