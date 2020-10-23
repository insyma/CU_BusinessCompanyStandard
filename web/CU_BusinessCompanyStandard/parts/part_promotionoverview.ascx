<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	Dim include as String
	Dim tempPage as new ContentUpdate.Page
	dim path as string = ""
	Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		if not container.fields("dezen_promotionverview_cat").value = "" then

			dim c as new ContentUpdate.container()
			c.load(cint(container.fields("dezen_promotionverview_cat").properties("value").value))
			c.load(c.parentid)
			tempPage.Load(c.pages("inc_promo_overview").id)
			tempPage.Preview = CUPage.Preview
			tempPage.LanguageCode = CUPage.LanguageCode 
			
			if CUPage.Preview then
			    include = tempPage.Link
			else
			    include = tempPage.properties("Filename").value
			end if
		end if
  		if CUPage.id = 23335 and CUPage.Languagecode = 0 then
      		'path = "deu/"
    	end if
	End Sub
</script>
<% If CUPage.Arrange = false then 
	  if include <> "" then
		if cuPage.Preview then
			Server.Execute(include)
		else 
			response.write("<" + "!--#include file=""" & path & include & """ -->")
		end if
	  end if
   End If %>