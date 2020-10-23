<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''	HINU: hier können JS-Aufrufe integriert werden, die zum Schluss des HTML-Aufbaus ausgeführt werden sollen

    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Dim acc As String = ""
    Dim con As New contentupdate.container
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        con.Load(CUPage.Web.rubrics("Web").rubrics("Seiteneinstellungen").pages("inc_addthis").containers("addthisinfocon").id)
        acc = con.fields("AddThisID").value
    End Sub
</script>
<% If Not con.fields("AddThisActive").value = "" Then %>
    <!-- 'Nur bei AddThis aktiv-->
	<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=<%=acc%>" async="async"></script>
<% End If %>
<script type="text/javascript">
/* <![CDATA[ */
	insymaScripts._setActiveUrl();
/* ]]> */ 
</script>
<% if request.QueryString("grid") = "1" and CUPage.Preview = true then %>
<!-- Layout Grid -->
<div id="insymagrid">
<ul class="centergrid gridwidth">
<li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li><li></li>
</ul>
</div>
<% end if %>