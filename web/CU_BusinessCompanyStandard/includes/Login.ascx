<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Login.ascx.cs" Inherits="Insyma.ContentUpdate.UI.CULogin" %>
<%
    string _lPreview = "false";
    //try
    //{
    //    _lPreview = _mPreview;
    //}
    //catch {}
    _lPreview = Request.QueryString["preview"];
 %>
<form id="FormLogin" name="FormLogin" method="post" onsubmit="JavaScript:__HandleSubmitLogin();return false;"> 
<input type="hidden" name="LoginToDo" id="LoginToDo" value="1" />
<input type="hidden" name="LoginKind" id="LoginKind" value="0" />
<input type="hidden" name="LoginPreview" id="LoginPreview" value="<%= _lPreview %>" />
<input type="hidden" name="LoginCheckCategoryFormId" id="LoginCheckCategoryFormId" value="16" />
<input type="hidden" name="LoginWebId" id="LoginWebId" value="289821" />
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
            <tr runat="server" id="trLockLoginMessage" visible="false">
				<td colspan="2" style="color:Red;">
                    <asp:Literal id="litLockLoginMessage" runat="server" Text="Lock login" ></asp:Literal>
                </td>
			</tr>
			<tr>
				<td align="right" colspan="2">
                    <%--<input type="submit" name="btLogin" value="Login" id="btLogin" class="loginbutton" runat="server" onclick="JavaScript:__HandleSubmitLogin();return false;"/>--%>
                    <input type="submit" name="btLogin" value="Login" id="btLogin" class="loginbutton" runat="server"/>
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
        document.getElementById(_mClientId + '_spanLoginUsername').style.visibility = "hidden";
        document.getElementById(_mClientId + '_spanLoginPassword').style.visibility = "hidden";
        if (document.FormLogin.LoginUserName != null && document.FormLogin.LoginPassword != null) {
            if (document.FormLogin.LoginUserName.value == '')
                document.getElementById(_mClientId + '_spanLoginUsername').style.visibility = "visible";
            if (document.FormLogin.LoginPassword.value == '')
                document.getElementById(_mClientId + '_spanLoginPassword').style.visibility = "visible";
            if (document.FormLogin.LoginUserName.value != '' && document.FormLogin.LoginPassword.value != '')
                document.FormLogin.submit();
        }
        else {
            if (document.getElementById('LoginToDo').value == "1")
                document.getElementById('LoginToDo').value = "0";
            document.FormLogin.submit();
        }
    }



//-->
</script>
