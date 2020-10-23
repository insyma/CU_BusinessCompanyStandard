<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>
<script runat="server">
    Dim RefObj As New ContentUpdate.Obj
    Dim ConCount As Integer = 0
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))    
		Container.LanguageCode = CUPage.LanguageCode
		Container.Preview = CUPage.Preview
    
       
        If Container.Fields("Einleitung").Value = "" Then
            TextObj.Visible = False
		else
			TextObj.Text = Container.Fields("Einleitung").Value.Replace("<ol>","<ol style='padding:0;margin:0;list-style-position:inside;'>").Replace("[","<strong style='color:#C20F1F;'>").Replace("]","</strong>").Replace("<ul>","<ul style='list-style:none;list-style-position:inside;padding:0;margin:0;'>").Replace("<a","<a style='color:#CC0000;'") & "<br />"
			if not (InStrRev(TextObj.Text,"<ul")) = 0 then
			If Instr(Right(TextObj.Text,Len(TextObj.Text) - InStrRev(TextObj.Text,"<ul")),">") Then
				Dim liTag as string = ""
					liTag = Right(TextObj.Text,Len(TextObj.Text) - InStrRev(TextObj.Text,"<ul"))
					if not (InStrRev(TextObj.Text,"<ol")) = 0 then
						liTag = Left(liTag,Len(Right(TextObj.Text,Len(TextObj.Text) - InStrRev(TextObj.Text,"</ul"))))
					end if
					liTag = Right(liTag,Len(liTag) - InStr(liTag,">"))
					TextObj.Text = TextObj.Text.Replace(liTag, liTag.Replace("<li>","<li style='list-style:none;'><img src=""http://www.cu3.ch/SwissLeadershipForumAdmin/mail/img/layout/list-style.gif"" alt=""*"" width=""9"" height=""10"" style=""display: inline;"" />&nbsp;"))
				End IF		
			end if
        End If

    End Sub
</script>
<%  If TemplateView = "text" Then%>
[Particulars]

<CU:CUContainer Name="leftcol" runat="server">
<%  If Not Container.Containers("leftcol").Fields("titel").Value = "" Then%><%=vbcrlf%><CU:CUField Name="titel" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Containers("leftcol").Fields("einleitung").Value = "" Then%><CU:CUField name="einleitung" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Containers("leftcol").Fields("text").Value = "" Then%><%=vbcrlf%><CU:CUField Name="text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Containers("leftcol").Fields("regards").Value = "" Then%><%=vbcrlf%><CU:CUField Name="regards" runat="server" PlainText="true" /><%=vbcrlf%><% end if %></CU:CUContainer><CU:CUContainer Name="rightcol" runat="server"><%  If Not Container.Containers("rightcol").Fields("kontakt").Value = "" Then%>
<CU:CUField Name="kontakt" runat="server" PlainText="true" /><%=vbcrlf%><% end if %></CU:CUContainer><%else %>
<table align="center" border="0" cellpadding="0" cellspacing="0">
                      <tbody><tr>
                        <td style="width:15px; max-width:15px;">&nbsp;</td>
                        <td style="width:622px; max-width:622px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:17px;" align="left" valign="top">&nbsp;</td>
                        <td style="width:15px; max-width:15px;">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="width:15px; max-width:15px;">&nbsp;</td>
                        <td class="text" style="width:622px; max-width:622px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:20px; color:#333333;" align="left" height="40" valign="top">
                        <CUSalutation>[SalutationText] [LastName]</CUSalutation></td>
                        <td style="width:15px; max-width:15px;">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="width:15px; max-width:15px;">&nbsp;</td>
                        <td class="text" style="width:622px; max-width:622px; font-family:Tahoma, Arial, Helvetica, sans-serif; font-size:13px; line-height:130%; color:#595252;" align="left" valign="top">
                        <asp:Literal ID="TextObj" runat="server" />
                        <br>
                          <br>
                          <CU:CUField name="regards" runat="server" /></td>
                        <td style="width:15px; max-width:15px;">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="width:15px; max-width:15px;">&nbsp;</td>
                        <td class="text" style="width:622px; max-width:622px;;" align="left" valign="top">&nbsp;</td>
                        <td style="width:15px; max-width:15px;">&nbsp;</td>
                      </tr>
                    </tbody></table>
<%end if %>
