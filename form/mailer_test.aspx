<%@ Page Language="VB" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Import Namespace="Insyma"  %>
<%@ Import Namespace="Insyma.ContentUpdate"  %>
<%@ Import Namespace="Insyma.MessageHandler"  %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Threading" %>
<script runat="server">  
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        Response.Write("Slow form processing: 10 seconds.")
        Thread.Sleep(10000)
    End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
</head>
<body bgcolor="#FFFFFF">


</body>
</html>
