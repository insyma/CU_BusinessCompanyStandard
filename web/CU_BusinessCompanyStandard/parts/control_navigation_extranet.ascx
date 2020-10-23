<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">
  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: part zur Integration des Hauptnavigations-Includes
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
dim navart as string = ""
dim mobile as string = ""
Dim y as integer = 1
Dim category As Dictionary(Of String, String)
Dim primaerRubric As New ContentUpdate.Rubric
Dim i as integer = 1
Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    Navigation.RootObjectId = CUpage.Web.Rubrics("web").Pages("startseite").id
    navart = "mainnavigation"
    dim m as new contentupdate.container()
    m.loadByName("beschriftungenmobilecontainer")
    m.preview = cupage.preview
    m.languageCode = CUpage.languageCode
    dim _m as string = "lbl_mobile_" & navart & "_show"
    mobile = "<span class='hide clickheader mobileOnly icon menu " & navart & "-open showMobile'>" & m.fields(_m).value & "</span>"
    _m = "lbl_mobile_" & navart & "_hide"
    mobile += "<span class='hide clickheader mobileOnly icon menu " & navart & "-close'>" & m.fields(_m).value & "</span>"
End Sub


  Private Sub BindItem(Sender As Object, e As RepeaterItemEventArgs)
    
    If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
      Dim pageLink as Literal = CType(e.Item.FindControl("pageLink"), Literal)
      Dim navPage as ContentUpdate.Obj = CType(e.Item.DataItem, ContentUpdate.Obj)
      navPage.Preview=CUPage.Preview
      navPage.LanguageCode = CUPage.LanguageCode
      Dim cat As Literal = CType(e.Item.FindControl("cat"), Literal)
      Dim cat2 As Literal = CType(e.Item.FindControl("cat2"), Literal)
      if not navPage.navigable then
        e.Item.visible = false
      end if
      dim css as string = ""
      if navart = "servicenavigation" then
        css = "class='icon " & navPage.objname & "'"
      end if
      pageLink.Text = "<a " & css & " href='" & navPage.Link & "' title='" & navPage.Caption & "'>" & navPage.Caption & "</a>"
      if navPage.id = 25334 then
        pageLink.Text = "<a class='speciallink shop' href='" & navPage.Link & "' title='" & navPage.Caption & "'><span class='icon shoplink'></span>" & navPage.Caption & "</a>"
      end if
      
      If navPage.Pages.NaviPages.Count() > 0 Then
                if(navPage.Containers("Inhalt").Containers.Count = 0) then  
          pageLink.Text = "<a " & css & " href='" & navPage.Pages.NaviPages(0).Link & "' title='" & navPage.Caption & "'>" & navPage.Caption & "</a>"
                end if
      else
        'Abfrage auf den Redirect-Part
        for each _tcon as contentupdate.container in navPage.Containers("Inhalt").Containers
          if _tcon.objname = "part_redirect" then
            if _tcon.links("zielurl").properties("value").value <> "" then
              if _tcon.links("zielurl").properties("Intern").value = "True" then
                dim _tpage as new contentupdate.page
                _tpage.load(cint(_tcon.links("zielurl").properties("value").value))
                _tpage.preview = cupage.preview
                _tpage.LanguageCode = cupage.Languagecode
                pageLink.Text = "<a " & css & "  href='" & _tpage.link & "'>" & navPage.Caption & "</a>"
              else
                pageLink.Text = "<a " & css & "  title='" & navPage.Caption & "' target='_blank' href='" & _tcon.links("zielurl").properties("value").value & "'>" & navPage.Caption & "</a>"
              end if
            end if 
            exit for
          end if
        next
      End If
      Dim tObjList As List(Of Dictionary(Of String, String))
      Dim _navpage as new Contentupdate.page()
      _navpage.load(navpage.Id)
      tObjList = _navPage.ObjCategories()
      'Response.Write(tObjList.Count.ToString() & "-")
      
      
      Dim _tId As Integer = 0
      Dim _tChecked As Boolean = False
      if not CUPage.preview = true then
        cat.text = "<" & "% if "
      end if
      For Each dict As Dictionary(Of String, String) In tObjList
          For Each kvp As KeyValuePair(Of String, String) In dict
              If (kvp.Key.ToLower().Equals("id")) Then
                  _tId = kvp.Value
              End If
              If (kvp.Key.ToLower().Equals("checked") And kvp.Value.ToLower().Equals("true")) Then
                  _tChecked = True
                  if not CUPage.preview = true then
                    cat.text += "instr(Session(""insyma_categories""), ""#" & _tId & """) > 0 OR "
                  end if
              End If
          Next kvp
      Next
      if not CUPage.preview = true then
        cat.text = left(cat.text, cat.text.length-3)
        cat.text += "then %" & ">"
        cat2.text = "<" & "% end if %" & ">"
      End If
    End If
  End Sub
   
  
</script>
<nav class="hauptnavi">
<CU:CUNavigation ID="Navigation" RootObjectId="" open="true" SetParentActiveClass="true" runat="server" onItemDataBound="BindItem">
     <HeaderTemplate>
        <div id="<%=navart%>con">
          <%=mobile%>
          <ul class="level1 navigation <%=navart%>">
     </HeaderTemplate>
     <ItemTemplate>
          <asp:literal id="cat" runat="server" />
          <li class="hn1_<%=y%>">
               <asp:Literal id="pageLink" runat="server" />
               <CU:CUNavigation ID="Navigation2" Open="true" SetParentActiveClass="true" runat="server" onItemDataBound="BindItem">
                    <HeaderTemplate>
                         <ul class="level2">
                    </HeaderTemplate>
                    <ItemTemplate>
                          <asp:literal id="cat" runat="server" />
                          <li>
                              <asp:Literal id="pageLink" runat="server" />
                                <CU:CUNavigation ID="Navigation2" Open="true" SetParentActiveClass="true" runat="server" onItemDataBound="BindItem">
                                    <HeaderTemplate>
                                         <ul class="level3">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                          <asp:literal id="cat" runat="server" />
                                          <li>
                                              <asp:Literal id="pageLink" runat="server" />
                                              <CU:CUNavigation ID="Navigation3" Open="true" SetParentActiveClass="true" runat="server" onItemDataBound="BindItem">
                                                <HeaderTemplate>
                                                     <ul class="level3">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                     <li>
                                                          <asp:Literal id="pageLink" runat="server" />
                                                          <CU:CUNavigation ID="Navigation4" Open="true" SetParentActiveClass="true" runat="server" onItemDataBound="BindItem">
                                                                <HeaderTemplate>
                                                                     <ul class="level3">
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                     <li>
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
                                         </li><asp:literal id="cat2" runat="server" />
                                    </ItemTemplate>
                                    <FooterTemplate>
                                         </ul>
                                    </FooterTemplate>
                               </CU:CUNavigation>
                         </li><asp:literal id="cat2" runat="server" />
                    </ItemTemplate>
                    <FooterTemplate>
                    
                         </ul>
                    </FooterTemplate>
               </CU:CUNavigation>
          </li><asp:literal id="cat2" runat="server" />
          <%y=y+1%>
     </ItemTemplate>
     <FooterTemplate>
     
     </ul></div>
     </FooterTemplate>
</CU:CUNavigation>
</nav>