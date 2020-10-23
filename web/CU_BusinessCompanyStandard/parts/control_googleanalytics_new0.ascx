<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
Dim include as String = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)

		Dim googleanalytics As New ContentUpdate.Page()
        googleanalytics.load(CUPage.Web.rubrics("web").rubrics("Seiteneinstellungen").pages("google").pages("analyticsinclude0").id)
        if googleanalytics.id > 0 then
		  include = googleanalytics.Link
        end if
        'response.write(GoogleanalyticsContainer.name)
	End Sub
</script>
<% If CUPage.Arrange = false then 
    if not CUPage.Preview then
        response.write("<" + "!--#include virtual=""" & include &""" -->")
    end if
End If %>






