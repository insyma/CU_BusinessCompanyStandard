<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<%@ Import Namespace="Insyma" %>
<script runat="server">
     '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''  HINU: part zur Integration der Sprachumschaltung

    '' Empfehlung: nicht innerhalb eines Includes verwenden, da in einem Include die Links immer die selben sind. 
    '' Diese müssen dann Clientseitig bei Aufruf einer jeden Seite korrigiert werden.


    '' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    ''  die Zeile "if PageNow.navigable then" bei jeder Sprache sorgt dafür, dass eine "nicht navigierbare Seite" auch keine verlinkte Sprachumschaltung bekommt.
    '' sollte dies beim aktuellen Projekt nicht gewünscht sein: jeweils diese und die Zeile "end if"(2 Zeilen später) auskommentieren/löschen
    
    '' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        Dim PageNow As New ContentUpdate.Page
        '' Befinden wir uns auf einer Detailseite?
        if CUpage.Containers("detail").Containers.count> 0 then
            '' Laden der entsprechenden Detailseite
            '' Da die CUPage.ID immer die der Masterpage ist!!
            PageNow.Load(CUPage.Containers("detail").Containers(1).ParentPages(1).Id)
        Else
            '' wir sind auf "normaler" Page
            PageNow.Load(CUPage.Id)
        End If
        ' Link für deutsche Version vergeben oder ausblenden
        If CUPage.LanguageCode = 0 Then
            '' befinden wir uns aktuell auf deutscher Seite?
            LinkDeuOption.Attributes.Add("class","active option language-deu")
        Else
            '' wenn nicht, dann lade die Seite in deutsch und setze den Link entsprechend
            if PageNow.Publish(0) = true then
                PageNow.LanguageCode = 0
                'if PageNow.navigable then
                    LinkDeu.HRef = PageNow.Link
                'end if
            Else    
                LinkDeuOption.Visible = false
            end if
        End If
        
        ' Link für französische Version vergeben oder ausblenden
        If CUPage.LanguageCode = 1 Then
            LinkFraOption.Attributes.Add("class","active option language-fra")
        Else
            if PageNow.Publish(1) = true then
                PageNow.LanguageCode = 1
                'if PageNow.navigable then
                    LinkFra.HRef = PageNow.Link
                'end if
            Else    
                LinkFraOption.Visible = false
            end if
        End If

        ' Link für italienische Version vergeben oder ausblenden
        If CUPage.LanguageCode = 2 Then
            LinkItaOption.Attributes.Add("class","active option language-ita")
        Else
            if PageNow.Publish(2) = true then
                PageNow.LanguageCode = 2
                if PageNow.navigable then
                    LinkIta.HRef = PageNow.Link
                end if
            Else
                LinkItaOption.Visible = false
            End if
        End If

        ' Link für englische Version vergeben oder ausblenden
        If CUPage.LanguageCode = 3 Then
            LinkEngOption.Attributes.Add("class","active option language-eng")
        Else
            if PageNow.Publish(3) = true then
                PageNow.LanguageCode = 3
                'if PageNow.navigable then
                    LinkEng.HRef = PageNow.Link
                'end if
            Else    
                LinkEngOption.Visible = false
            end if
        End If

        ' Link für spanische Version vergeben oder ausblenden
        If CUPage.LanguageCode = 4 Then
            LinkEspOption.Attributes.Add("class","active option language-esp")
        Else
            if PageNow.Publish(4) = true then
                PageNow.LanguageCode = 4
                'if PageNow.navigable then
                    LinkEsp.HRef = PageNow.Link
                'end if
            Else    
                LinkEspOption.Visible = false
            end if
        End If

        ' Link für niederlaendische Version vergeben oder ausblenden
        If CUPage.LanguageCode = 5 Then
            LinkNetOption.Attributes.Add("class","active option language-net")
        Else
            if PageNow.Publish(5) = true then
                PageNow.LanguageCode = 5
                'if PageNow.navigable then
                    LinkNet.HRef = PageNow.Link
                'end if
            Else    
                LinkNetOption.Visible = false
            end if
        End If

    End Sub
</script>
<CU:CUContainer name="SprachauswahlContainer" runat="server" >
    <ul class="control con-sprache">
        <li>
            <CU:CUField name="SprachauswahlContainer_Label" runat="server" tag="span" tagclass="label" />
            <div class="SwitchLanguage" data-grid-columns="1" data-anim-effect="fade" data-open-mode="click">
                <ul style="display: none">
                    <li id="LinkDeuOption" runat="server" class="option language-deu"><a title="deu" data-lang-id="de" id="LinkDeu" runat="server"><CU:CUField name="SprachauswahlContainer_DEU" runat="server" /></a></li>
                    <li id="LinkFraOption" runat="server" class="option language-fra"><a title="fra" data-lang-id="fr" id="LinkFra" runat="server"><CU:CUField name="SprachauswahlContainer_FRA" runat="server" /></a></li>
                    <li id="LinkItaOption" runat="server" class="option language-ita"><a title="ita" data-lang-id="it" id="LinkIta" runat="server"><CU:CUField name="SprachauswahlContainer_ITA" runat="server" /></a></li>
                    <li id="LinkEngOption" runat="server" class="option language-eng"><a title="eng" data-lang-id="en" id="LinkEng" runat="server"><CU:CUField name="SprachauswahlContainer_ENG" runat="server" /></a></li>
                    <li id="LinkEspOption" runat="server" class="option language-esp"><a title="esp" data-lang-id="es" id="LinkEsp" runat="server"><CU:CUField name="SprachauswahlContainer_EPS" runat="server" /></a></li>
                    <li id="LinkNetOption" runat="server" class="option language-net"><a title="net" data-lang-id="es" id="LinkNet" runat="server"><CU:CUField name="SprachauswahlContainer_NET" runat="server" /></a></li>
                </ul>
            </div>
        </li>
    </ul>
</CU:CUContainer>
