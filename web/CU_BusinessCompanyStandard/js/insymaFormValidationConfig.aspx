<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<script runat="server">
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        labellingCon.Name = CUPage.Containers("labelling_formval").Id
    End Sub
</script>
<CU:CUContainer Name="" ID="labellingCon" runat="server">
<%if CUPage.Preview = true then %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<%=CUPage.MetaTags(CUPage.Caption,false) %>
</head>
<body style="white-space: pre; font-family: 'Courier New', Courier, Monospace; font-size: 12px;">
<%end if %>
/**
 * @author MURA
 * @copyright insyma AG
 * @projectDescription insyma JavaScript Library Konfiguration FormValidation Module
 * @version 1.0 
 * 
 */
// Alle Validierungstexte
insymaFormValidation.config.validationTexts = [
    "<CU:CUField name='val_norm' runat='server' />",			// für normale Validierung
    "<CU:CUField name='val_radio' runat='server' />",			// für Radiobuttons
    "<CU:CUField name='val_mail' runat='server' />",			// für E-Mail-Feld
    "<CU:CUField name='val_decimal' runat='server' />",	        // für Dezimalzahlen
    "<CU:CUField name='val_phone' runat='server' />",			// für Telefonnummer
    "<CU:CUField name='val_currency' runat='server' />",		// für Währung
    "<CU:CUField name='val_digits' runat='server' />",	        // für positive Ganzzahlen
    "<CU:CUField name='val_integers' runat='server' />"			// für positive und negative Ganzzahlen
];

// Querystring, der in der URL vom Redirect steht
insymaFormValidation.config.ThanksUrlVar = "thanks";
// Id des Containers mit dem Dankestext
insymaFormValidation.config.ThanksContainerId = "thanks";

<%if CUPage.Preview = true then %>
	</body>
</html>
<%end if %>
</CU:CUContainer>