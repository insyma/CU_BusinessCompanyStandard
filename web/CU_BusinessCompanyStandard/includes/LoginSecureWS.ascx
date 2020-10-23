<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LoginSecureWS.ascx.cs" Inherits="Insyma.ContentUpdate.UI.LoginSecureWS" %>

<form id="FormLogin" name="FormLogin" method="post" <%=formAction %> > 
<input type="hidden" name="LoginToDo" value="1" />
<input type="hidden" name="LoginKind" id="LoginKind" value="0" />
<input type="hidden" name="DimesionId" id="DimesionId" value="100" />
<input type="hidden" name="formDefId" id="formDefId" value="1" />
<input type="hidden" name="LoginPreview" id="LoginPreview" value="" />
<table cellspacing="0" cellpadding="1" border="0" id="tbLogin" style="border-style:None;border-collapse:collapse;">
	<tr>
		<td><table cellpadding="0" border="0">
			<tr>
				<td class="titletext" align="center" colspan="2"><asp:Literal ID="litLoginHeadline" runat="server"></asp:Literal></td>
			</tr>
			<tr runat="server" id="trLoginUsername" visible="true">
				<td align="right"><asp:Literal ID="litUsername" runat="server" /></td>
				<td><input name="LoginUserName" id="LoginUserName" type="text" /><span id="spanLoginUsername" style="color:Red;visibility:hidden;" runat="server"> *</span></td>
			</tr>
			<tr runat="server" id="trLoginPassword" visible="true">
				<td align="right"><asp:Literal ID="litPassword" runat="server" /></td>
				<td><input name="LoginPassword" id="LoginPassword" type="password" /><span id="spanLoginPassword" style="color:Red;visibility:hidden;" runat="server"> *</span></td>
			</tr>
            <tr runat="server" id="trEmail" visible="false">
				<td align="right"><asp:Literal ID="Literal3" runat="server" Text="E-Mail" /></td>
				<td><input name="Email" id="Email" type="text" readonly="readonly" value="<%=currentEmail %>" /></td>
			</tr>
            <tr runat="server" id="trNewPassword" visible="false">
				<td align="right"><asp:Literal ID="Literal1" runat="server" Text="Neues Passwort" /></td>
				<td><input name="NewPassword" id="NewPassword" type="password" /><span id="span1" style="color:Red;visibility:hidden;" runat="server"> *</span></td>
			</tr>
            <tr runat="server" id="trNewPasswordConfirm" visible="false">
				<td align="right"><asp:Literal ID="Literal2" runat="server" Text="Passwort bestätigen" /></td>
				<td><input name="NewPasswordConfirm" id="NewPasswordConfirm" type="password" /><span id="span2" style="color:Red;visibility:hidden;" runat="server"> *</span></td>
			</tr>
			<tr runat="server" id="trLoginLogout" visible="false">
				<td colspan="2" class="">
                    <asp:Literal id="litLogout" runat="server" text="LogoutButton"></asp:Literal>
                </td>
			</tr>
			<tr runat="server" id="trLoginMessage" visible="false">
				<td colspan="2" style="color:Red;">
                    <asp:Literal id="litMessage" runat="server" ></asp:Literal>
                </td>
			</tr>
			<tr>
				<td align="right" colspan="2">
                    <input type="submit" name="btLogin" value="Login" id="btLogin" class="loginbutton" runat="server"/>
                    <asp:Literal runat="server" Visible="False" ID="litButtonContainer"></asp:Literal>
                </td>
			</tr>
		</table></td>
	</tr>
</table>
</form>