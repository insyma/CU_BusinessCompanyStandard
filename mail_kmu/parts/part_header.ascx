<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ import Namespace="Insyma" %>

<% ''Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        Dim RefObj As New ContentUpdate.Obj
        RefObj.Load(Convert.ToInt32(CUPage.Properties("ReferenceObjID").Value))
        RefObj.IsMail = CUPage.IsMail
        Nav.name = RefObj.Containers("conlinkliste").id
        Nav_PlainText.name = RefObj.Containers("conlinkliste").id
        
        'Hidden Text for Iphone content preview
        if Cupage.Containers("introduction").Containers("intro").Containers("leftcol").Fields("einleitung").value <> "" then
            if Cupage.Containers("introduction").Containers("intro").Containers("leftcol").Fields("einleitung").value.length > 120 then
                hiddenTextForIphone.text =  " | " & Regex.Replace(Cupage.Containers("introduction").Containers("intro").Containers("leftcol").Fields("einleitung").plaintext, "<[^>]*(>|$)", string.Empty).Substring(0, 120) & "..."
            else
                hiddenTextForIphone.text =  " | " & Regex.Replace(Cupage.Containers("introduction").Containers("intro").Containers("leftcol").Fields("einleitung").plaintext, "<[^>]*(>|$)", string.Empty)
            end if
        end if   
        
        MailLink.CssStyle = S_Header_Link
    End Sub
    Sub BindNavigation(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview

            Dim naviSpacer As HtmlControl = CType(e.Item.FindControl("naviSpacer"), HtmlControl)
            Dim maxItems as Integer = con.Parent.Containers.count
            
            if e.Item.ItemIndex >= maxItems-1 then
                naviSpacer.visible = false
            end if
        End If
    End Sub
    Sub BindNavigationPT(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
        End If
    End Sub
</script>
<%  If TemplateView = "text" Then%>
<%=vbcrlf%>
----------------------------------------------------------------------
<CU:CUField Name="thema" runat="server" PlainText="true" />
----------------------------------------------------------------------
 <CU:CUContainer name="" id="Nav_PlainText" runat="server">
    <CU:CUField name='title' runat='server' plaintext="true" />
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<CU:CUObjectset name="culist" runat="server" OnItemDataBound="BindNavigationPT"><itemtemplate>
            <CU:CUField name='desc' runat='server' plaintext="true" />
            <CU:CUField name='url' runat='server' plaintext="true" />
        </itemtemplate></CU:CUObjectset></CU:CUContainer>~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<%else %>
<!-- Header / Thema - Online Version -->
<table align="center" border="0" cellpadding="0" cellspacing="0" >
    <!-- Preview Text mobile devices -->
    <![if !mso]>
        <span class="mobileOnly" style="display: none !important;"><%=Container.fields("thema").value %> <asp:literal runat="server" id="hiddenTextForIphone" /></span>
    <![endif]-->
    <!-- Extra Abstand nicht Outlook clients -->
    <![if !mso]>
    <tr>
        <td height="5" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(5,20)%></td>
        <td height="5" style="line-height: 0; font-size: 1px;"><%=spacer(1,5)%></td>
        <td height="5" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(5,20)%></td>
    </tr>
    <![endif]-->
    <tr>
        <td width="20"  style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
        <td width="600" style="width:600px; max-width:600px;">
            <table align="left" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width='450' style="width:450px; max-width:450px; <%=F_Header_Text%> <%=C_Header_Text%>">
                        <strong><%=Container.fields("thema").value %></strong>
                       
                    </td>
                </tr>
            </table>
            <table class="mobileFullWidth" align="right" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="left" width='130' class="mobileFullWidthAlignLeft" style="width:130px; max-width:130px; text-align: right; <%=F_Header_Text%>">
                        <CU:CUMailLink id="MailLink" MailLinkType="MailLink" Target="_blank" Link="true" runat="server">
                            <cu:cucontainer name="head" runat="server">
                                <cu:cufield name="onlineversion" runat="server" />
                            </cu:cucontainer>
                        </CU:CUMailLink>
                    </td>
                </tr>
            </table>
        </td>
        <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
    </tr>
    <tr>
        <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
        <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
    </tr>
</table>
<!-- Header / Logo, Ausgabe -->
<table align="center" bgcolor="#ffffff" border="0" cellpadding="0" cellspacing="0" style='<%=S_Header_Border%>'>
    <tr>
        <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
        <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
    </tr>
    <tr>
        <td width="20" style="width:20px; max-width:20px;"><%=spacer(20,1)%></td>
        <td style="width:598px; max-width:598px;" align="<%=Container.fields("logo_position").properties("value").value%>">
            <!-- Logo -->
            <a style="padding:0;margin:0;display: inline-block;" href="<%=Container.fields("url").properties("value").value%>" title="<%=Container.fields("url").properties("Description").value%>" target='_blank'>
              <img class="mobileLogo" src='<%=getImg(Container.Images("logo-img"))%>' alt="<%=container.links("logo-link").properties("Description").value%>" style="display:inline;" border="0" />
            </a>
        </td>
        <td width="20" style="width:20px; max-width:20px;"><%=spacer(20,1)%></td>
    </tr>
    <tr>
        <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
        <td height="20" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,20)%></td>
    </tr>
</table>

<!-- Spacer -->
<table align="center" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="<%=space%>" style="line-height: 0; font-size: 1px;"><%=spacer(1,space)%></td>
    </tr>
</table>

<!-- Header / Bild -->
<table align="center" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td bgcolor="#ffffff" width="640" style="width:640px; max-width:640px;">
            <img src="<%=getImg(Container.Images("header-image"))%>" style="width:100%; <%=F_Header_Text%>" alt="<%=Container.Images("header-image").Legend %>" />
        </td>
    </tr>
</table>

<!-- Spacer -->
<table align="center" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="<%=space%>" style="line-height: 0; font-size: 1px;"><%=spacer(1,space)%></td>
    </tr>
</table>

<!-- Header / Main Navig -->
<table class="mobileFullWidthNavig" align="center" bgcolor="<%=C_Nav_Background%>" style="<%=C_Nav_Style%>" border="0" cellpadding="0" cellspacing="0">
    <tr class="hideMobile">
        <td  height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
        <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
        <td height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
    </tr>
    <tr>
        <td class="hideMobile" height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
        <td class="mobileFullWidth" width="600" style="width:600px; max-width:600px; text-align: center;">
            <CU:CUContainer name="" id="nav" runat="server">
                <CU:CUObjectset name="culist" runat="server" OnItemDataBound="BindNavigation">
                    <itemtemplate>
                        <a href="<CU:CUField name='url' runat='server' />" title="<CU:CUField name='desc' runat='server' />" class="mobileButton" style="<%=F_Nav_Link%> <%=C_Nav_Link%>"><CU:CUField name="desc" runat="server" /></a> 
                        <span id="naviSpacer" runat="server" class="hideMobile" style='<%#C_Nav_Spacer%>'>&nbsp;&nbsp;&nbsp;</span>
                    </itemtemplate>
                </CU:CUObjectset>
            </CU:CUContainer>
        </td>
        <td class="hideMobile" height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
    </tr>
    <tr class="hideMobile">
        <td height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
        <td height="10" style="line-height: 0; font-size: 1px;"><%=spacer(1,10)%></td>
        <td height="10" width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,10)%></td>
    </tr>
</table>

<!-- Spacer -->
<table align="center" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="<%=space%>" style="line-height: 0; font-size: 1px;"><%=spacer(1,space)%></td>
    </tr>
</table>

<%End If%>