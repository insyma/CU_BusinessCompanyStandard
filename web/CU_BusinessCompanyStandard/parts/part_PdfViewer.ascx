<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<!--#include file="part_functions.ascx" -->
<script runat="server">
''Variable für die Entscheidung, ob Part ausgegeben wird
dim part_visible as boolean = false

Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
    
    '' weiter falls noch keine Inhalte gefunden wurden
    if part_visible = false then
        '' Abfrage auf alle Files, welche in dem Part vorhanden sind( ObjectClass 9 = File)
        part_visible = _checkFiles(container.id)
    end if

End Sub
</script>
<% if part_visible = true then %>
<div class="Part PartPagelead transition clearfix unten effect PartPDFviewer">
<div class="holder ConText liststyle">
	<%-- CU:CUFile name="pdf" flashviewer="true" runat="server" / --%>
<CU:CUFile Name="pdf" runat="server" Target="_blank" Class="filetype pdf-viewer-link ConLink" ID="cuFile" PDFBrowser="true" NoEncrypt="true" FileHandler="viewer.html">    
                <CU:CUFile Name="pdf" runat="server" Property="Legend" id="showFileName"></CU:CUFile> 
            </CU:CUFile>

</div></div>
<% end if %>