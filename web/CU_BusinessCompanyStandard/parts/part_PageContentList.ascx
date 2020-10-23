<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<%@ Register TagPrefix="CU" Namespace="Insyma.ContentProperty.Controls" Assembly="Insyma.ContentProperty.Controls" %>

<script Language="VB" runat="server">
dim css as string = ""
dim maincss as string = ""
dim vis as boolean = false
dim contentProperties as new Insyma.ContentProperty.Render.Domain.ContentProperties()
dim pagesize as string = ""
dim sortBy as string = ""
dim filter as string = ""
Dim contList As Obj
dim archive as string = ""
dim evtype as string = ""
dim backv as string = ""
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        
        vis = true
        if not Container.Objects("Title").Properties("Value").Value = "" then
            listTitle.Text = "<h3 class='ItemTitle'>" & Container.Objects("Title").Properties("Value").Value & "</h3>"
        end if

        if(Container.Objects("contentlist").Properties("ContentPropertyID").Value = "4") then
            css = "part-events"
        else
            css = "part-news"
        end if
        
        if( not Container.Objects("part_contentlist_news_archiv").Properties("Value").Value = "") then
            archive = "ja"
        end if
        
        
        
        dim objId as integer = Container.Objects("contentlist").Id
        'contentProperties = Insyma.ContentProperty.Controls.Utility.CreateContentProperties(0, 0, objId, CUPage.LanguageCode)
        contentProperties = Insyma.ContentProperty.Controls.Utility.CreateContentProperties(0, 0, objId, 0)
        If (contentProperties IsNot Nothing) Then
            evtype = Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.Types, "ASC", "#").replace("<span class=""content-property-empty""></span>", "")
            if evtype = "" AND css = "PartEvents" then
                evtype = "Events"
            end if
            contList = Container.Objects("contentlist")
            If (Not contList Is Nothing) Then
                Dim dtoSetting As ContentUpdate.ContentPropertiesDto = contList.ContentPropertiesSelectionDef
                If (Not dtoSetting Is Nothing AndAlso Not dtoSetting.ContentSettings Is Nothing) Then
                    
                    pageSize = dtoSetting.GetSettingPageSize(10)
                    sortBy = dtoSetting.GetSettingSortBy()
                    filter = dtoSetting.GetSettingFilter()
                    
                    
                End If
            End if
            
        end if
    End Sub
</script>

<div class="part part-cards <%=css%> con_<%=Container.Id%>">
    <asp:Literal runat="server" id="listTitle"/>
    <div class="cards ">
        <div class="ConListEntries cards-con item-count-4"></div>
        
        <!-- Archiv / Pageing -->
        <CU:CULink name="contentlist_link_newsarchive" runat="server" id="news_a" />
        
        <!--
        <div id="pager_<%=container.id%>" class="pager">
            <a class="first icon icon-fast_rewind"></a>
            <a class="prev icon icon-skip_previous"></a>
            <span class="pagecount">
                
            </span>
            <a class="next icon icon-skip_next"></a>
            <a class="last icon icon-fast_forward"></a>
        </div>
        -->
    </div>
    <script language="javascript">
        $(document).ready(function () {
            <% if(vis = true) AND contentProperties IsNot Nothing then%>
            var options={
                elem: "con_<%=Container.Id%>",
                Types: "<%=evtype%>",
                Tags: "<%=Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.Tags, "ASC", "#").replace("<span class=""content-property-empty""></span>", "")%>",
                Themes: "<%=Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.Themes, "ASC", "#").replace("<span class=""content-property-empty""></span>", "")%>",
                Origin: "<%=Insyma.ContentProperty.Controls.Utility.DataBinder(contentProperties.Origins, "ASC", "#").replace("<span class=""content-property-empty""></span>", "")%>",
                LivePath: "<%=CUpage.Web.LivePath%>",
                LangPath: "<%=CUpage.properties("path").value.substring(1)%>",
                LangCode: "<%=CUpage.LanguageCode%>",
                PageSize: "<%=pageSize%>",
                Sorting: "<%=sortBy%>",
                Filter: "<%=filter%>",
                Archive: "<%=archive%>",
                Preview: "<%=CUPage.Preview%>"
            }
            insymaContentlist._loadContentList(options);
            <% end if%>
            
        });
</script>
</div>

