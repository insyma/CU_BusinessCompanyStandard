<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
        <%@ Import Namespace="Insyma" %>
        
        <script runat="server">
        Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)	
       
        end sub
        Protected Function GetUrl() As String
			Dim formPage As ContentUpdate.Page
			Dim contentform as new ContentUpdate.Container
			contentform.LoadByName("container_blackboard")
			contentform.LanguageCode = CUPage.LanguageCode
			formPage = contentform.Pages("Formular")
			formPage.Preview = True
			Return formPage.AbsoluteLink
        End Function
        
        
        </script>
        
        <script language="javascript" type="text/javascript">
        
        
        document.write("<iframe width=\"450\" height=\"800\" id=\"formframe\" frameborder=\"0\" scrolling=\"auto\" src=\"<%=GetUrl() %>&parentpage=<%=CUPage.Id  %>\"></iframe>");
       
                
        
        </script>