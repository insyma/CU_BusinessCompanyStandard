<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>

<% 'Include Helpers %>
<!--#include file="../helper_functions.ascx" -->
<!--#include file="../helper_definitions.ascx" -->

<script runat="server">
    Dim conCount As Integer = 0
    Dim CC as Integer = 0
    dim lang as String = ""
    Dim variantWidth = 600
    
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        
    End Sub
</script>
<%  If TemplateView = "text" Then%>
<%  If Not Container.Fields("title").Value = "" Then%>
-----------------------------------------------------------------
<CU:CUField Name="title" runat="server" PlainText="true" /><%=vbcrlf%>-----------------------------------------------------------------
<%  If Not Container.Fields("intro").Value = "" Then%><%=vbcrlf%><CU:CUField name="intro" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<%  If Not Container.Fields("text").Value = "" Then%><%=vbcrlf%><CU:CUField Name="text" runat="server" PlainText="true" /><%=vbcrlf%><% end if %>
<% if not container.fields("button_link").Value = "" Then%><%=vbcrlf%><CU:CUField name="button_text" runat="server" /><%=vbcrlf%><CU:CUField name="button_link" runat="server" /><%=vbcrlf%><%end if%>
<% end if %>
<%else %>

<asp:panel runat="server" id="fullContent">
<!-- Full Width Table -->
    <table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="<%=C_Promotion_BG%>" style="background-color: <%=C_Promotion_BG%>; border-bottom: 1px solid <%=C_Promotion_Border%>; width:100%;">
        <tr>
            <td>
                
                <!-- Holder -->                
                <table align="center" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    </tr>
                    <tr>
                        <td width="20" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                        <td width="600" style="width:600px; max-width:600px; position: relative;">
                            <iframe id="iframe" style="display: none; border:0; position: absolute; background: transparent !important;" ALLOWTRANSPARENCY="true" width="100%" height="100%" src="http://www.youtube.com/embed/nOEw9iiopwI"></iframe>
                            <a href="https://www.youtube.com/watch?v=nOEw9iiopwI">
                                <img border="0" src="http://www.contentupdate.net/CU_BusinessCompanyStandard/mail/img/fallbackimage.jpg" label="Fallback Image" width="600">
                            </a>
                            <script>document.getElementById("iframe").style.display = "block";</script>
                            
                            
                            <!--[if gte mso 9]>
                                <v:image xmlns:v="urn:schemas-microsoft-com:vml" id="image" style="behavior: url(#default#VML); display:inline-block; position:absolute; height:91px; width:647px; top:0; left:0; border:0; z-index:1;" src="http://www.contentupdate.net/CU_BusinessCompanyStandard/mail/img/play.png" />
                                <v:shape xmlns:v="urn:schemas-microsoft-com:vml" id="text" style="behavior: url(#default#VML); display:inline-block; position:absolute; height:91px; width:647px; top:0; left:0; border:0; z-index:2;">
                            <![endif]-->
                                <img border="0" src="http://www.contentupdate.net/CU_BusinessCompanyStandard/mail/img/play.png" width="60">
                            <!--[if gte mso 9]>
                            </v:shape>
                            <![endif]-->

                            
                        </td>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    </tr>
                    <tr>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                        <td height="20" style="line-height: 0; font-size: 1px;"><%=spacer(1,20)%></td>
                        <td width="20" height="1" style="line-height: 0; font-size: 1px;"><%=spacer(20,1)%></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

</asp:panel>
<%end if %>