<%@ Page Language="VB" Inherits="Insyma.ContentUpdate.CUPage" %>
          <script runat="server">
          Dim host as String
          Sub Page_Load(Src As Object, E As EventArgs)
          if CUPage.Preview then
          	host = "http://www.contentupdate.net/[project]/web/[project]"
          else
          	host = "http://www.contentupdate.net/[project]/web/[project]"
          end if
          End Sub
          </script>
          
          <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
          <html xmlns="http://www.w3.org/1999/xhtml" lang="de">
          <head>
          <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
          <link rel="stylesheet" href="<%=host%>/css/screen.css" type="text/css" media="screen" />
          <link rel="stylesheet" href="<%=host%>/css/parts.css" type="text/css" media="screen" />
          <link rel="stylesheet" href="<%=host%>/css/print.css" type="text/css" media="print" />
          </head>
          <body class="inserate">
          <div class="form_blackboard">
          <form id="form1" method="post" runat="server">
          <div id="col2" runat="server"><CU:CUPlaceHolder id="Mitte" runat="server"></CU:CUPlaceHolder>
          </div>
          </form>
          </div>	
          
          </body>
          </html>