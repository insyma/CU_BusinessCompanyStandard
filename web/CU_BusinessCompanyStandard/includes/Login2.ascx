<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Login.ascx.cs" Inherits="Insyma.ContentUpdate.UI.CULogin" %>

<form id="FormLogin" name="FormLogin" method="post" onsubmit="JavaScript:__HandleSubmitLogin();return false;"> 
<input type="hidden" name="LoginToDo" id="LoginToDo" value="1" />
<table cellspacing="0" cellpadding="1" border="0" id="tbLogin" style="border-style:None;border-collapse:collapse;">
	<tr>
		<td><table cellpadding="0" border="0">
			<tr>
				<td class="titletext" align="center" colspan="2"><asp:Literal ID="litLoginHeadline" runat="server"></asp:Literal></td>
			</tr>
			<tr runat="server" id="trLoginUsername" visible="true">
				<td align="right" id="lbluser"><asp:Literal ID="litUsername" runat="server" /></td>
				<td><input name="LoginUserName" id="LoginUserName" type="text" /><span id="spanLoginUsername" style="color:Red;visibility:hidden;" runat="server"> *</span></td>
			</tr>
			<tr runat="server" id="trLoginPassword" visible="true">
				<td align="right"><asp:Literal ID="litPassword" runat="server" /></td>
				<td><input name="LoginPassword" id="LoginPassword" type="password" /><span id="spanLoginPassword" style="color:Red;visibility:hidden;" runat="server"> *</span></td>
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
				<td class="conButton" align="right" colspan="2">
                    <input type="submit" name="btLogin" value="Login" id="btLogin" class="loginbutton" runat="server" onclick="JavaScript:__HandleSubmitLogin();return false;"/>
                </td>
			</tr>
		</table></td>
	</tr>
</table>
</form>

<asp:Placeholder ID="phJavaScript" runat="server" />
<script language="javascript" type="text/javascript">
<!--
    function __HandleSubmitLogin() {
        if (FormLogin.LoginUserName != null && FormLogin.LoginPassword != null) {
            if (FormLogin.LoginUserName.value == '')
                document.getElementById(_mClientId + '_spanLoginUsername').style.visibility = "visible";
            if (FormLogin.LoginPassword.value == '')
                document.getElementById(_mClientId + '_spanLoginPassword').style.visibility = "visible";
            if (FormLogin.LoginUserName.value != '' && FormLogin.LoginPassword.value != '')
                FormLogin.submit();
        }
        else {
            if (document.getElementById('LoginToDo').value == "1")
                document.getElementById('LoginToDo').value = "0";
            FormLogin.submit();
        }
    }
	var lbl = "E-Mail";
	$('#' + _mClientId + "_lbluser").html(lbl);
	if(typeof(jsval) != "undefined")
	{
		if(jsval !== "")
			$('#inhalt').append("<span style='color:red;'>" + jsval + "</span>")
	}

//-->
</script>
