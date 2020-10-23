<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Data" %>
<%@ Register TagPrefix="Control" TagName="footer" Src="../parts/control_footer.ascx" %>
<%@ Register TagPrefix="Control" TagName="header" Src="../parts/control_header_extranet.ascx" %>
<%@ Register TagPrefix="Control" TagName="javascripts" Src="../parts/control_javascripts.ascx" %>
<%@ Register TagPrefix="Control" TagName="servicenavigation" Src="../parts/control_servicenavigation_extranet.ascx" %>
<%@ Register TagPrefix="Control" TagName="breadcrumb" Src="../parts/control_breadcrumb.ascx" %>
<%@ Register TagPrefix="Control" TagName="metatags" Src="../parts/control_metatags.ascx" %>
<%@ Register TagPrefix="Control" TagName="googleanalytics" Src="../parts/control_googleanalytics.ascx" %>
<%@ Register TagPrefix="Control" TagName="Login" Src="../includes/Login.ascx" %>
<%@ Register TagPrefix="Control" TagName="Seitentitel" Src="../parts/control_seitentitel.ascx" %>
<%@ Register TagPrefix="Control" TagName="JSend" Src="../parts/control_javascript_end.ascx" %>
<%@ Register TagPrefix="Control" TagName="htmlheader" Src="../parts/control_htmlheader.ascx" %>
<%@ Register TagPrefix="Control" TagName="css" Src="../parts/control_css.ascx" %>
<%@ Register TagPrefix="Control" TagName="navigation" Src="../parts/control_navigation_extranet.ascx" %>
<%@ Register TagPrefix="Control" TagName="footerInfo" Src="../parts/control_footerInfo.ascx" %>
<script runat="server"> 
DIM _mLogin AS Boolean 
DIM kategorien AS String = ""
dim pagecategories as String = ""
'Dim category As Dictionary(Of String, String)
Dim _tId As Integer = 0
dim _tstr as string = ""
Dim _tChecked As Boolean = False
Dim _tpageCats as string = ""
Dim _tpageid as string = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
		_tpageid = cstr(CUPage.Id)
		Dim tObjList' As List(Of string)
		tObjList = CUPage.ObjCategories()
		For Each dict As Dictionary(Of String, String) In tObjList
			For Each kvp As KeyValuePair(Of String, String) In dict
				If (kvp.Key.ToLower().Equals("id")) Then
					_tId = kvp.Value
				End If
				If (kvp.Key.ToLower().Equals("checked") And kvp.Value.ToLower().Equals("true")) Then
					_tChecked = True
					_tpageCats += cstr(_tId) & "#"
				End If
			Next kvp
		Next
		If CUPage.Arrange = True Then
            javascripts.Visible = False
        End If
        
        _mLogin = false
		If CUPage.Preview = True Then
       		'Session.Clear()
			if(Session("CUSessionState") IS NOTHING) then
					Dim clsSessionStateNew As New CUSessionState
					clsSessionStateNew._UserLanguageId = CUPage.LanguageCode
					Session("CUSessionState") = clsSessionStateNew
			end if
			Dim clsSessionState As New CUSessionState
			clsSessionState = CType(Session("CUSessionState"), CUSessionState)
			'Response.Write("Error: " & clsSessionState._LoginErrorMessage)
			'Response.Write("<br />State: " & clsSessionState._Login)
			if(clsSessionState._Login) then
				_mLogin = true
				kategorien = clsSessionState._UserCategoryIds
			Else
				if not CUPage.Id = 34061 then
					'Response.Redirect("default_login.aspx?Page_id=34061&Lang=0&preview=true&WebId=33933", true)
				end if
			End If
			'response.write("--: " & kategorien & " :::: " & _tpageCats)
        else
            Response.Write("<%@ Page Language=""VB"" %>" & vbCrLf)
            Response.Write("<scr" & "ipt runat=""server"">" & vbCrLf)
            Response.Write("DIM _mLogin AS Boolean" & vbCrLf)
            Response.Write("DIM kategorien AS String = """"" & vbCrLf)
            Response.Write("dim i as integer = 0" & vbCrLf)
            Response.Write("DIM Pagekat AS String = """ & _tpageCats & """" & vbCrLf)
            Response.Write("DIM PageId AS String = """ & _tpageid & """" & vbCrLf)
            Response.Write("dim TopicRight as boolean = false" & vbCrLf)
            Response.Write("dim _tCat as String() = Pagekat.Substring(0, PageKat.Length-1).split(""#"")" & vbCrLf)
            Response.Write("Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)" & vbCrLf)
            Response.Write("   _mLogin = false" & vbCrLf)
            Response.Write("   if(Session(""CUSessionState"") IS NOTHING) then" & vbCrLf)
            Response.Write("      Dim clsSessionStateNew As New CUSessionState" & vbCrLf)
            Response.Write("      clsSessionStateNew._UserLanguageId = " & CUPage.LanguageCode & vbCrLf) 
            Response.Write("      Session(""CUSessionState"") = clsSessionStateNew" & vbCrLf) 
            Response.Write("   end if" & vbCrLf)
            Response.Write("   Dim clsSessionState As New CUSessionState" & vbCrLf)
            Response.Write("   clsSessionState = CType(Session(""CUSessionState""), CUSessionState)" & vbCrLf)
            Response.Write("   if(clsSessionState._Login) then" & vbCrLf)
            Response.Write("       _mLogin = true" & vbCrLf)
            Response.Write("       Session(""insyma_categories"") = clsSessionState._UserCategoryTopicIds" & vbCrLf)
            Response.Write("       for i = 0 to ubound(_tCat)" & vbCrLf)
            Response.Write("        if clsSessionState.__CheckUserCategoryTopicRight(Cint(_tCat(i))) = true AND TopicRight = false then" & vbCrLf)
            Response.Write("         TopicRight = true" & vbCrLf)
            Response.Write("        end if" & vbCrLf)
            Response.Write("       next" & vbCrLf)
            Response.Write("   		if not PageId = ""39977"" AND TopicRight = false then" & vbCrLf)
            Response.Write("       		Response.Redirect(""startseite_39977.aspx"", true)"  & vbCrLf)
            Response.Write("   		end if" & vbCrLf)
            Response.Write("   end if" & vbCrLf)
            Response.Write("   if not _mLogin = true then" & vbCrLf)
            Response.Write("       Response.Redirect(""../default.aspx"", true)"  & vbCrLf)
            Response.Write("   end if" & vbCrLf)
            Response.Write("   if clsSessionState._LoginErrorMessage.length > 0 then" & vbCrLf)
            Response.Write("   end if" & vbCrLf)
            Response.Write("End Sub" & vbCrLf)
            Response.Write("</scr" & "ipt>" & vbCrLf)
            Response.write("<%@ Register TagPrefix=""Control"" TagName=""Login"" Src=""../includes/login.ascx"" %>")
        end if
					
    End Sub
</script>
    <Control:htmlheader id="htmlheader" runat="server" />
    <head>
        <Control:metatags id="metatags" runat="server" />
        <Control:css id="css" runat="server" />
        <Control:javascripts id="javascripts" runat="server" />
    </head>
<body class="page page-extranet">
    <cu:culibrary runat="server" id="CULibrary" showlayoutselection="true" />
    <div id="root">
        <header class="con-header clearfix">
            <div class="holder">
                <Control:header id="header" runat="server" />
                <Control:servicenavigation id="servicenavigation" runat="server" />
            </div>
        </header>

        <div class="con-wrapper clearfix">
            <div class="holder">
                <Control:navigation id="navigation" runat="server" />
            </div>
            <div class="holder">
                <Control:breadcrumb id="breadcrumb" runat="server"/>
            </div>
            <div class="holder con-inhalt">
                <main>
                    <cu:cuplaceholder id="inhalt" runat="server" class="inhalt"><title><asp:literal id="metatitle" runat="server" /> | <CU:CUContainer name="" id="allmeta0" runat="server"><CU:CUField name="websitetitle" runat="server" /></CU:CUContainer></title>
                            <Control:Seitentitel id="Seitentitel" runat="server" />
                        </cu:cuplaceholder>
                    <cu:cuplaceholder id="detail" runat="server" class="inhalt"></cu:cuplaceholder>
                </main>
            </div>
        </div>
        <footer class="con-footer clearfix">
            <div class="holder">
                <Control:footerInfo id="footerInfo" runat="server" />
                <Control:footer id="footer" runat="server" />
            </div>
        </footer>
    </div>
    <Control:JSend id="JSend" runat="server" />

    <!-- Size indikators for JS -->
    <span id="size-indikator-tablet" style="display: none;"></span>
    <span id="size-indikator-mobile" style="display: none;"></span>
</body>
</html>