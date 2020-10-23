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
    navart = "servicenavigation"
    dim m as new contentupdate.container()
    m.loadByName("beschriftungenmobilecontainer")
    m.preview = cupage.preview
    m.languageCode = CUpage.languageCode
    dim _m as string = "lbl_mobile_" & navart & "_show"
    mobile = "<span class='hide clickheader mobileOnly icon menu " & navart & "-open showMobile'>" & m.fields(_m).value & "</span>"
    _m = "lbl_mobile_" & navart & "_hide"
    mobile += "<span class='hide clickheader mobileOnly icon menu " & navart & "-close'>" & m.fields(_m).value & "</span>"
End Sub
Private Sub ServiceTarget(Sender As Object, e As RepeaterItemEventArgs)
    Dim link as HtmlAnchor
    

    If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
      Dim cat As Literal = CType(e.Item.FindControl("cat"), Literal)
      Dim cat2 As Literal = CType(e.Item.FindControl("cat2"), Literal)
      link = CType(e.Item.FindControl("Navi1Action"), HtmlAnchor)
      Dim navPage as ContentUpdate.Obj = CType(e.Item.DataItem, ContentUpdate.Obj)
      navPage.Preview = CUPage.Preview
      'response.write("--: " & navPage.CategoryMatch)
      if navPage.Properties("RedirectPage").value <> "" then
        Dim tempPage as new ContentUpdate.Page
        tempPage.Load(navPage.Properties("RedirectPage").value)
        link.HRef = tempPage.Link
      else

        If navPage.Pages.NaviPages.Count() > 0 Then
          if(navPage.Containers("Inhalt").Containers.Count = 0) then
            link.Href = navPage.Pages.NaviPages(0).Link
          else
            link.HRef = navPage.Link
          end if
        Else
          link.HRef = navPage.Link
        End If
      
      end if
      Dim classname as string
      if e.Item.ItemIndex > 3 then
        Dim classid as integer = e.Item.ItemIndex-3
        classname = ""
        'link.attributes.add("class",classname)
      end if

      if CUPage.ID = navPage.ID then
        if e.Item.ItemIndex < 4 then
          link.attributes.add("class","active")
        else
          Dim classid as integer = e.Item.ItemIndex-3
          classname = "active"
          'link.attributes.add("class",classname)
        end if
      end if

      if CUPage.getParentObjects(3).count > 0 then
        if(CUPage.getParentObjects(3)(1).ID=navPage.ID) then
          if e.Item.ItemIndex < 4 then
            link.attributes.add("class","active")
          else
            Dim classid as integer = e.Item.ItemIndex-3
            classname = "active"
            'link.attributes.add("class",classname)
          end if
        end if
      end if
      i = i+1
      dim _navpage as new contentupdate.page()
      _navpage.load(navpage.id)
      _navpage.Preview = CUPage.Preview
      link.attributes.add("class",classname)
            Dim tObjList As List(Of Dictionary(Of String, String))
            'Dim dict As Dictionary(Of String, String) = New Dictionary(Of String, String)
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
      end if
            
            
            
            ''      dim categoryset1 as ContentUpdate.categoryset = CType(e.Item.DataItem, ContentUpdate.categoryset)
            'Dim _tCategory As Dictionary(Of String, String)
            '_tCategory = CType(e.Item.DataItem, Dictionary(Of String, String))
            'For Each kvp As KeyValuePair(Of String, String) In _tCategory
            '    Response.Write(kvp.Key & ": " & kvp.Value & "<BR />")
            'Next kvp
        End If
  End Sub

  Private Sub Navi2Style(Sender As Object, e As RepeaterItemEventArgs)
    Dim link as HtmlAnchor
    Dim navPage as ContentUpdate.Page
    If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
      link = CType(e.Item.FindControl("Navi2Action"), HtmlAnchor)
      navPage = CType(e.Item.DataItem, ContentUpdate.Page)
      navPage.Preview=CUPage.Preview
      if navPage.Properties("RedirectPage").value <> "" then
        Dim tempPage as new ContentUpdate.Page
        tempPage.Load(navPage.Properties("RedirectPage").value)
        link.HRef = tempPage.Link
      else
       If navPage.Pages.NaviPages.Count() > 0 Then
                if(navPage.Containers("Inhalt").Containers.Count = 0) then
          link.Href = navPage.Pages.NaviPages(0).Link
              else
          link.HRef = navPage.Link
                end if
            Else
                link.HRef = navPage.Link
            End If
      end if
      if CUPage.ID = navPage.ID then
        link.attributes.add("class", "active")
      end if
          
    End If
  End Sub
  function getCat(pageid as integer)
    'response.write("hallo")
'   dim _tPage as contentupdate.page
'   _tPage.load(pageId)
'   categoryset1.DataSource = _tPage.ObjCategories
'   categoryset1.DataBind()
  End function
   
  Protected Sub CatBindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
    If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
      Dim cat As Literal = CType(e.Item.FindControl("cat"), Literal)
      
      category = CType(e.Item.DataItem, Dictionary(Of String, String))
      For Each kvp As KeyValuePair(Of String, String) In category
        'Response.Write(kvp.Key &": "& kvp.Value & "<BR />")
        if kvp.Key = "checked" AND kvp.Value = "True" then
          'response.write("<br />passt")
          cat.text += category("id") & "#"
        else
          if kvp.Key = "category" then
            'cat.text += "<br />" & kvp.Value
          end if
        end if
      Next kvp
    End If
  End Sub
</script>
<nav class="servicenavi">
<CU:CUNAVIGATION rootobjectid="30191" id="Navigation" runat="server" OnItemDataBound="ServiceTarget">
  <HeaderTemplate>
    <div id="<%=navart%>con">
    <%=mobile%>
    <ul class="level1 navigation <%=navart%>">
  </HeaderTemplate>
  <ItemTemplate>
      <asp:literal id="cat" runat="server" />
    <li class="hn1_<%=y%>"><a runat="server" id="Navi1Action" title='<%# DataBinder.Eval(Container.DataItem, "Caption") %>'><%# DataBinder.Eval(Container.DataItem, "Caption") %></a>
      <CU:CUNAVIGATION id="Navi2" runat="server" OnItemDataBound="Navi2Style">
        <HeaderTemplate>
          <ul id="menu<%=y%>">
        </HeaderTemplate>
        <ItemTemplate>
          <li><a id="Navi2Action" runat="server" href='<%# DataBinder.Eval(Container.DataItem, "Link") %>' title='<%# DataBinder.Eval(Container.DataItem, "Caption") %>'><%# DataBinder.Eval(Container.DataItem, "Caption") %></a>
              <CU:CUNAVIGATION id="Navi3" runat="server" OnItemDataBound="Navi2Style">
                    <HeaderTemplate>
                        <ul class="level2">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li><a id="Navi2Action" runat="server" href='<%# DataBinder.Eval(Container.DataItem, "Link") %>' title='<%# DataBinder.Eval(Container.DataItem, "Caption") %>'><%# DataBinder.Eval(Container.DataItem, "Caption") %></a>
                        <CU:CUNAVIGATION id="Navi4" runat="server" OnItemDataBound="Navi2Style">
                    <HeaderTemplate>
                        <ul class="level3">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li><a id="Navi2Action" runat="server" href='<%# DataBinder.Eval(Container.DataItem, "Link") %>' title='<%# DataBinder.Eval(Container.DataItem, "Caption") %>'><%# DataBinder.Eval(Container.DataItem, "Caption") %></a></li>
                    </ItemTemplate>
                    <FooterTemplate>
                        </ul>
                    </FooterTemplate>
                </CU:CUNAVIGATION>
                </li>
                </ItemTemplate>
                <FooterTemplate>
                    </ul>
                </FooterTemplate>
            </CU:CUNAVIGATION>
            </li>
        </ItemTemplate>
        <FooterTemplate>
          </ul>
        </FooterTemplate>
      </CU:CUNAVIGATION>
           
    </li> <asp:literal id="cat2" runat="server" />
    <%y=y+1%>
  </ItemTemplate>
  <FooterTemplate>
    </ul></div>
  </FooterTemplate>
</CU:CUNAVIGATION>

</nav>