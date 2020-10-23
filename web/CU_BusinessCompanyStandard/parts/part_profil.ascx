<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server"> 
        Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
            if CUPage.Preview = true then
				 Dim clsSessionState As New CUSessionState
				 clsSessionState = CType(Session("CUSessionState"), CUSessionState)
				 if(clsSessionState._Login) then
					profillink.text = "https://www.contentupdate.net/bcs/nlpro.aspx?co=" & clsSessionState._UserCode & "&fi=11&ci=" & clsSessionState._UserId				
				 end if
			else
				Response.Write("<scr" & "ipt runat=""server"">" & vbCrLf)
				Response.Write("Sub Page_Init(ByVal Src As Object, ByVal E As EventArgs)" & vbCrLf)
				Response.Write("   Dim clsSessionState As New CUSessionState" & vbCrLf)
				Response.Write("   clsSessionState=CType(Session(""CUSessionState""), CUSessionState)" & vbCrLf)
				Response.Write("   if(clsSessionState._Login) then" & vbCrLf)
				Response.Write("      profillink.text = ""https://www.contentupdate.net/CU_BusinessCompanyStandard/nlpro.aspx?co="" & clsSessionState._UserCode & ""&fi=11&ci="" & clsSessionState._UserId " & vbCrLf)
				Response.Write("   end if" & vbCrLf)
				Response.Write("End Sub" & vbCrLf)
				Response.Write("</scr" & "ipt>" & vbCrLf)
			end if   
        End Sub
</script>
<div class="part part-iframe part-iframe-profil">
    <CU:CUField Name="ueberschrift" runat="server" Tag="h3" tagclass="h3 item-title" />
	<% if CUPage.Preview = true then %>
    	<iframe class="part_profil" frameborder="0" width='100%' height='750' scrolling='auto' src='<asp:Literal id="profillink" runat="server" />'></iframe>
	<% else %>
    	<iframe class="part_profil" frameborder="0" width='100%' height='750' scrolling='auto' src='<% response.write("<asp:Literal id=""profillink"" runat=""server"" />") %>'></iframe>
    <% end if %>
</div>