<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		''	HINU: part zur Einbindung des Includes für GoogleAnalytics
	
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim include as String = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		' ### Zentraler Analytics Container definieren und laden
		Dim googleAnalyticsCon As New ContentUpdate.Container()
		'googleAnalyticsCon.LoadByName("GoogleanalyticsContainer")
		googleAnalyticsCon.Load(CUPage.Web.rubrics("web").rubrics("Seiteneinstellungen").pages("google").containers("GoogleanalyticsContainer").id)

		googleAnalyticsCon.Preview = CUPage.Preview
		include = googleAnalyticsCon.Pages("inc_googleanalytics").Link
		
		if CUPage.Id = 27566 then
			include = ".." & googleAnalyticsCon.Pages("inc_googleanalytics").properties("path").value & googleAnalyticsCon.Pages("inc_googleanalytics").properties("filename").value
		end if
	End Sub
</script>

<% If CUPage.Arrange = false then 
	if not CUPage.Preview then
		response.write("<" + "!--#include virtual=""" & include &""" -->")
	end if
End If %>