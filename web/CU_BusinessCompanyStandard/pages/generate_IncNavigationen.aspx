<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<script runat="server">

    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: Generierung der Navigations-Includes
    '' benötigt die angelegte Struktur für Navigation - eine Seite pro Navigation
    '' der darin enthaltene Settings-Container mit Navi-Auswahl muss in den Values die IDs der navi-Rubriken haben

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Dim i As Integer = 1
    Dim y As Integer = 1
    Dim count As Integer = 0
    Dim primaerRubric As New ContentUpdate.Rubric
    Dim what As Integer = 0
    Dim addClass As Boolean
    Dim navart As String = ""
    Dim liclass As String = ""
    Dim zusatz As String = ""
    Dim mobile As String = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        If CUPage.containers("settings").id > 0 Then
            Dim c As New contentupdate.container(CUPAge.containers("settings").id)
      
            '' Setzen des Ausgangspubktes der Navi(hinterlegte ID bei Auswahl)
            If Not c.fields("art").value = "" Then
                Dim rub As New Contentupdate.obj()
                rub.load(CUPage.Web.rubrics("Web").rubrics(c.fields("art").properties("value").value).id)
                Navigation.RootObjectId = rub.id
                If c.fields("art").properties("value").value = "FooterNavigation" Then
                    navart = "NavFooter"
                    liclass = "LiNF"
                ElseIf c.fields("art").properties("value").value = "ServiceNavigation" Then
                    navart = "NavService"
                    liclass = "LiNS"
                ElseIf c.fields("art").properties("value").value = "MainNavigation" Then
                    navart = "NavMain"
                    liclass = "LiNM"
                ElseIf c.fields("art").properties("value").value = "" Then
            
                End If
      
            End If
        End If
        '' Zusätzliche Buttons für Mobile-Geräte(Ein- und Ausblenden der Navi)
        Dim m As New contentupdate.container()
        'm.loadByName("beschriftungenmobilecontainer")
        m.Load(CUPage.Web.rubrics("Web").rubrics("Seiteneinstellungen").pages("beschriftungen_mobile").containers("beschriftungenmobilecontainer").id)
        m.preview = cupage.preview
        m.languageCode = CUpage.languageCode
        If navart = "NavMain" Then
            Dim _m As String = "lbl_mobile_" & navart & "_show"
            mobile = "<span class='hide clickheader mobileOnly icon menu " & navart & "-open NavOpen showMobile'>" & m.fields(_m).value & "</span>"
            _m = "lbl_mobile_" & navart & "_hide"
            mobile += "<span class='hide clickheader mobileOnly icon menu " & navart & "-close NavClose'>" & m.fields(_m).value & "</span>"
        End If
    End Sub
    Private Sub BindItem(Sender As Object, e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim pageLink As Literal = CType(e.Item.FindControl("pageLink"), Literal)
            Dim navPage As ContentUpdate.Obj = CType(e.Item.DataItem, ContentUpdate.Obj)
            navPage.Preview = CUPage.Preview
            navPage.LanguageCode = CUPage.LanguageCode
        
            If Not navPage.navigable Then
                e.Item.Visible = False
            End If
        
            pageLink.Text = "<a data-page-id='" & navPage.Id.toString() & "' class='icon navshow' href='" & navPage.Link & "' title='" & navPage.Caption & "'>" & navPage.Caption & "</a>"
            If navPage.Pages.NaviPages.Count() > 0 Then
                If (navPage.Containers("Inhalt").Containers.Count = 0) Then
                    pageLink.Text = "<a data-page-id='" & navPage.Id.toString() & "' class='icon navshow' href='" & navPage.Pages.NaviPages(0).Link & "' title='" & navPage.Caption & "'>" & navPage.Caption & "</a>"
                End If
            Else
                'Abfrage auf den Redirect-Part
                For Each _tcon As contentupdate.container In navPage.Containers("Inhalt").Containers
                    If _tcon.objname = "part_redirect" Then
                        If _tcon.links("zielurl").properties("value").value <> "" Then
                            If _tcon.links("zielurl").properties("Intern").value = "True" Then
                                Dim _tpage As New contentupdate.page
                                _tpage.load(CInt(_tcon.links("zielurl").properties("value").value))
                                _tpage.preview = cupage.preview
                                _tpage.LanguageCode = cupage.Languagecode
                                pageLink.Text = "<a data-page-id='" & _tpage.Id.toString() & "' class='icon navshow' href='" & _tpage.link & "'>" & navPage.Caption & "</a>"
                            Else
                                pageLink.Text = "<a class='icon navshow' title='" & navPage.Caption & "' target='_blank' href='" & _tcon.links("zielurl").properties("value").value & "'>" & navPage.Caption & "</a>"
                            End If
                        End If
                        Exit For
                    End If
                Next
            End If
      

        End If
    
    End Sub
    Protected Sub SBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim formlink As Literal = CType(e.Item.FindControl("formlink"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            con.LanguageCode = CUPage.LanguageCode
            con.Preview = CUPage.Preview
        End If
    End Sub
  
  
</script>
<% If navart = "NavFooter" Then%>
<ul id="hilfsnavi" class="ConNavOptions">
    <li><a class="icon iconbefore print" rel="nofollow" href="javascript:print()" title='<CU:CUField name="footer_lbl_print" runat="server"/>'>
        <cu:cufield name="footer_lbl_print" runat="server" />
    </a></li>
    <li><a class="icon iconbefore totop" href="javascript:void(0)" rel="nofollow" title='<CU:CUField name="footer_label_totop" runat="server"/>'>
        <cu:cufield name="footer_label_totop" runat="server" />
    </a></li>
</ul>
<% End If%>
<cu:cunavigation id="Navigation" rootobjectid="" open="true" setparentactiveclass="true" runat="server" onitemdatabound="BindItem">
    <HeaderTemplate>
        <div id="ID<%=navart%>" class="ConNav Con<%=navart%> clearfix">
			<% If Not navart = "NavFooter" Then%>
          		<%=mobile%>
			<% End If%>
          <ul class="NavLevel-1 Ul<%=navart%>">
    </HeaderTemplate>
    <ItemTemplate>
        <li class="<%=liclass%>1_<%=y%>">
            <asp:Literal id="pageLink" runat="server" />
            <CU:CUNavigation ID="Navigation2" Open="true" SetParentActiveClass="true" runat="server" onItemDataBound="BindItem">
                <HeaderTemplate>
                    <ul class="NavLevel-2">
                </HeaderTemplate>
                <ItemTemplate>
                    <li style="display: none;">
                        <asp:Literal id="pageLink" runat="server" />
                        <CU:CUNavigation ID="Navigation2" Open="true" SetParentActiveClass="true" runat="server" onItemDataBound="BindItem">
                            <HeaderTemplate>
                                <ul class="NavLevel-3">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <li style="display: none;">
                                    <asp:Literal id="pageLink" runat="server" />
                                    <CU:CUNavigation ID="Navigation3" Open="true" SetParentActiveClass="true" runat="server" onItemDataBound="BindItem">
                                        <HeaderTemplate>
                                            <ul class="NavLevel-4">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <li style="display: none;">
                                                <asp:Literal id="pageLink" runat="server" />
                                                <CU:CUNavigation ID="Navigation4" Open="true" SetParentActiveClass="true" runat="server" onItemDataBound="BindItem">
                                                    <HeaderTemplate>
                                                        <ul class="NavLevel-5">
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <li style="display: none;">
                                                            <asp:Literal id="pageLink" runat="server" />
                                                        </li>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        </ul>
                                                    </FooterTemplate>
                                                </CU:CUNavigation>
                                            </li>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                             </ul>
                                        </FooterTemplate>
                                    </CU:CUNavigation>
                                </li>
                            </ItemTemplate>
                            <FooterTemplate>
                                </ul>
                            </FooterTemplate>
                        </CU:CUNavigation>
                    </li>
                </ItemTemplate>
                <FooterTemplate>
                
                     </ul>
                </FooterTemplate>
            </CU:CUNavigation>
        </li>
        <%y = y + 1%>
    </ItemTemplate>
    <FooterTemplate>
    <%=zusatz%>
    </ul></div>
    </FooterTemplate>
</cu:cunavigation>
