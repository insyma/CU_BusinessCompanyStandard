<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        If container.fields("part_jobs_nojobs").value = "" Then
            ConNoJobs.Visible = False
        Else
            joblist.visible = False
        End If
    End Sub
    Protected Sub BindItem(ByVal sender As System.Object, ByVal e As RepeaterItemEventArgs)
        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            Dim dokument As Literal = CType(e.Item.FindControl("dokument"), Literal)
            Dim con As ContentUpdate.Container = CType(e.Item.DataItem, ContentUpdate.Container)
            '' diese beiden Aufrufe in einem Binditem immer machen, das sonst Sprache und Preview-Status vergessen werden kann
            con.preview = CUPage.preview
            con.languagecode = CUPage.languagecode

            '' Bauen des File-Links, weil bei leerer Legende sonst die Object-Caption benutzt wird. Hier alternativ der Filename
            If Not con.files("part_jobs_entry_file").Properties("Filename").Value = "" Then
                If con.Files("part_jobs_entry_file").Properties("Legend").Value <> "" Then
                    dokument.Text = "<li class='link download'><a class='" & con.Files("part_jobs_entry_file").Properties("filetype").Value & "' href='" & con.Files("part_jobs_entry_file").src & "' title='" & con.Files("part_jobs_entry_file").Properties("Legend").Value & "' target='_blank'>" & con.Files("part_jobs_entry_file").Properties("Legend").Value & "</a></li>"
                Else
                    dokument.Text = "<li class='link download'><a class='" & con.Files("part_jobs_entry_file").Properties("filetype").Value & "' href='" & con.Files("part_jobs_entry_file").src & "' title='" & con.Files("part_jobs_entry_file").Properties("Filename").Value & "' target='_blank'>" & con.Files("part_jobs_entry_file").Properties("Filename").Value & "</a></li>"
                End If
            End If
        End If
    End Sub



</script>

<div class="part part-jobs">
    <div class="ConNoJobs" id="ConNoJobs" runat="server">
        <cu:cufield name="part_jobs_title" runat="server" tag="h3" tagclass="h3 item-title" />
        <cu:cufield name="part_jobs_intro" runat="server" tag="div" tagclass="lead" />
        <cu:cufield name="part_jobs_text" runat="server" tag="div" tagclass="liststyle" />
    </div>
    <cu:cuobjectset name="part_jobs_culist" id="joblist" runat="server" onitemdatabound="BindItem" filter="part_jobs_active='ja'">
        <headertemplate><ul class="jobs-list"></headertemplate>
        <footertemplate></ul></footertemplate>
        <ItemTemplate>
            <li class="jobs-entry" id="con_<%# CType(Container.DataItem,ContentUpdate.Container).ID %>">
                <CU:CUField name="part_jobs_bezeichnung" runat="server" tag="h3" tagclass="h3 item-title" />
                <CU:CUField name="part_jobs_entry_intro" runat="server" tag="div" tagclass="lead liststyle" />
                <CU:CUObjectSet name="part_jobs_entry_files" runat="server" OnItemDataBound="BindItem">
                    <headertemplate><ul class="linklist"></headertemplate>
                    <footertemplate>
                        </ul>
                    </footertemplate>
                    <itemtemplate>
                        <asp:literal id="dokument" runat="server" />
                    </itemtemplate>
                </CU:CUObjectSet>
                <div class="con-content-more liststyle" style="display: none;">
                    <CU:CUField name="part_jobs_entry_text" runat="server" />
                </div>
                <CU:CUContainer name="HeaderLogoContainer" runat="server">
                <CU:CUField name="labelling_general_more" runat="server" tag="span" tagclass="icon icon-more action-content-more href" />
                <CU:CUField name="labelling_general_less" runat="server" tag="span" tagclass="icon icon-less action-content-less href" />
                </CU:CUContainer>
                <script type="text/javascript">
                    insymaScripts.setParts("con_<%# CType(Container.DataItem,ContentUpdate.Container).ID %>", "basic");
                </script>
            </li>
        </ItemTemplate>
</CU:CUObjectSet>
</div>