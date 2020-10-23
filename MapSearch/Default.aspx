<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MapSearch._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Map Administration</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../tool/css/CUStyle.css" type="text/css" rel="stylesheet" />
    <style type="text/css">
        table.map-data {
            table-layout: fixed;
            padding: 10px;
            width: 565px;    
        }
        table.map-data .col1 {
            width: 35px;
        }
        table.map-data .col2 {
            width: 35px;
        }
        table.map-data .col3 {
            width: 50px;
        }
        table.map-data .col4 {
            width: 130px;
        }
        table.map-data .col5 {
            width: 100px;
        }
        table.map-data .col6 {
            width: 35px;
        }
        table.map-data .col7 {
            width: 120px;
        }
                
        div.action a.map-action {
            padding: 0.1em 0.2em;
        }
        div.action input.nostyle {
            background: none;
        }
        li span.RadioButtonList {
            padding: .5em 1em;
        }
        .invis {
            display:none;
        }
        table.table tr.alt td {
            background-color:#F6F4EA;
        }
        span.CheckBox input {
            float: left;
        }
    </style>
</head>
<body class="page">
    <form id="form1" runat="server">
    <h1><asp:Label ID="MapSearchTitleLabel" runat="server" Text="MAP Administration"></asp:Label></h1>
    <div class="CUPage">
        <div class="CUContainerBody">
            <div class="Content">
            <div class="InfoBar">
                <div class="Message">
                    <asp:RegularExpressionValidator ID="PlzRegExValidator" runat="server" ControlToValidate="PlzTextBox"
                    ErrorMessage="PLZ muss eine Nummer sein." SetFocusOnError="True" ValidationExpression="[0-9]*">*</asp:RegularExpressionValidator>
                    <asp:RegularExpressionValidator ID="LaengenGradRegExValidator" runat="server" ControlToValidate="LaengenGradTextBox"
                    ErrorMessage="Längengrad muss eine Fliesskommazahl sein." SetFocusOnError="True" ValidationExpression="(\b[0-9]+\,([0-9]+\b)?|\.[0-9]+\b)">*</asp:RegularExpressionValidator>
                    <asp:RegularExpressionValidator ID="BreitenGradRegExValidator" runat="server" ControlToValidate="BreitenGradTextBox"
                    ErrorMessage="Breitengrad muss eine Fliesskommazahl sein." SetFocusOnError="True" ValidationExpression="(\b[0-9]+\,([0-9]+\b)?|\.[0-9]+\b)">*</asp:RegularExpressionValidator>
                    <asp:ValidationSummary ID="ValidationSummary" runat="server" />
                    <asp:Label ID="StatusLabel" runat="server"></asp:Label>
                </div>
            </div>
            <div class="EditParts">
                <div class="PartS">
                <h2><asp:Label ID="MapSearchFilialenTypLabel" runat="server" Text="Filialen Typ"></asp:Label></h2>
                <ul>
                    <li>
                        <asp:CheckBox ID="CheckBoxKat0" CssClass="CheckBox" runat="server" Text="Landi"/>
                    </li>
                    <li>
                        <asp:CheckBox ID="CheckBoxKat1" CssClass="CheckBox" runat="server" Text="Volg"/>
                    </li>
                    <li>
                        <asp:CheckBox ID="CheckBoxKat2" CssClass="CheckBox" runat="server" Text="Agrola Tankstelle"/>
                    </li>
                    <li>
                        <asp:CheckBox ID="CheckBoxKat3" CssClass="CheckBox" runat="server" Text="Agrola Top Shop"/>
                    </li>
                    <li>
                        <asp:CheckBox ID="CheckBoxKat4" CssClass="CheckBox" runat="server" Text="Landi mit Topangebot"/>
                    </li>
                    <li>
                        <asp:CheckBox ID="CheckBoxKat5" CssClass="CheckBox" runat="server" Text="Volg (Warenverkauf)"/>
                    </li>
                </ul>
                </div>
                <div class="PartS">
                    <h2><asp:Label ID="MapSearchAdressdatenLabel" runat="server" Text="Adressdaten"></asp:Label></h2>
                    <ul>
                        <li>
                            <asp:Label AssociatedControlID="IDTextBox" ID="MapSearchIDLabel" runat="server" Text="ID"></asp:Label>
                            <asp:TextBox CssClass="TextBox" ID="IDTextBox" runat="server"></asp:TextBox>
                            <asp:ImageButton ID="IDSuchenImageButton" runat="server" AlternateText="Suchen" ImageUrl="Images/lupe.gif" OnClick="IDSuchenImageButton_Click" BorderStyle="None" BorderWidth="0" />
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="NameTextBox" ID="MapSearchNameLabel" runat="server" Text="Name"></asp:Label>
                            <asp:TextBox CssClass="TextBox" ID="NameTextBox" runat="server"></asp:TextBox>
                            <asp:ImageButton ID="NameSuchenImageButton" runat="server" AlternateText="Suchen" ImageUrl="Images/lupe.gif" OnClick="NameSuchenImageButton_Click" BorderStyle="None" BorderWidth="0" />
                        </li>
                        <li>
                            <asp:Label ID="MapSearchZusatzLabel" AssociatedControlID="ZusatzTextBox" runat="server" Text="Zusatz"></asp:Label>
                            <asp:TextBox CssClass="TextBox" ID="ZusatzTextBox" runat="server"></asp:TextBox>
                            <asp:ImageButton ID="ZusatzSuchenImageButton" runat="server" AlternateText="Suchen"
                        ImageUrl="Images/lupe.gif" OnClick="ZusatzSuchenImageButton_Click" />
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="StrasseTextBox" ID="MapSearchStrasseLabel" runat="server" Text="Strasse"></asp:Label>
                            <asp:TextBox CssClass="TextBox" ID="StrasseTextBox" runat="server"></asp:TextBox>
                            <asp:ImageButton ID="StrasseSuchenImageButton" runat="server" AlternateText="Suchen" ImageUrl="Images/lupe.gif" OnClick="StrasseSuchenImageButton_Click" BorderStyle="None" BorderWidth="0" />
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="PlzTextBox" ID="MapSearchPlzLabel" runat="server" Text="Plz"></asp:Label>
                            <asp:TextBox CssClass="TextBoxS" ID="PlzTextBox" runat="server"></asp:TextBox>
                            <asp:ImageButton ID="PlzSuchenImageButton" runat="server" AlternateText="Suchen"
                        ImageUrl="Images/lupe.gif" OnClick="PlzSuchenImageButton_Click" />
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="OrtTextBox" ID="MapSearchOrtLabel" runat="server" Text="Ort"></asp:Label>
                            <asp:TextBox CssClass="TextBox" ID="OrtTextBox" runat="server"></asp:TextBox>
                            <asp:ImageButton ID="OrtSuchenImageButton" runat="server" AlternateText="Suchen" ImageUrl="Images/lupe.gif" OnClick="OrtSuchenImageButton_Click" BorderStyle="None" BorderWidth="0" />
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="TelefonTextBox" ID="MapSearchTelefonLabel" runat="server" Text="Telefon"></asp:Label>
                            <asp:TextBox CssClass="TextBox" ID="TelefonTextBox" runat="server"></asp:TextBox>
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="EmailTextBox" ID="MapSearchEmailLabel" runat="server" Text="E-Mail"></asp:Label>
                            <asp:TextBox CssClass="TextBox" ID="EmailTextBox" runat="server"></asp:TextBox>
                            <asp:ImageButton ID="EmailSuchenImageButton" runat="server" AlternateText="Suchen"
                        ImageUrl="Images/lupe.gif" OnClick="EmailSuchenImageButton_Click" />
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="WebTextBox" ID="MapSearchWebLabel" runat="server" Text="Web"></asp:Label>            
                            <asp:TextBox CssClass="TextBox" ID="WebTextBox" runat="server"></asp:TextBox>
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="FaxTextBox" ID="MapSearchFaxLabel" runat="server" Text="Fax"></asp:Label>
                            <asp:TextBox CssClass="TextBox" ID="FaxTextBox" runat="server"></asp:TextBox>
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="OeffnungsZeitenTextBox" ID="MapSearchOeffungsZeitenLabel" runat="server" Text="Öffnungszeiten"></asp:Label>
                            <asp:TextBox CssClass="TextBox" ID="OeffnungsZeitenTextBox" runat="server" TextMode="MultiLine" Rows="2"></asp:TextBox>
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="LaengenGradTextBox" ID="MapSearchLaengenGradLabel" runat="server" Text="Längengrad"></asp:Label>
                            <asp:TextBox CssClass="TextBoxVal" ID="LaengenGradTextBox" runat="server"></asp:TextBox>
                            <asp:ImageButton ID="LaengeSuchenImageButton" runat="server" AlternateText="Suchen"
                        ImageUrl="Images/lupe.gif" OnClick="LaengeSuchenImageButton_Click" BorderStyle="None" BorderWidth="0" />
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="BreitenGradTextBox" ID="MapSearchBreitenGradLabel" runat="server" Text="Breitengrad"></asp:Label>
                            <asp:TextBox CssClass="TextBoxVal" ID="BreitenGradTextBox" runat="server"></asp:TextBox>
                            <asp:ImageButton ID="BreiteSuchenImageButton" runat="server" AlternateText="Suchen"
                        ImageUrl="Images/lupe.gif" OnClick="BreiteSuchenImageButton_Click" BorderStyle="None" BorderWidth="0" />
                        </li>
                        <li>
                            <asp:Label AssociatedControlID="ExternalIDTextBox" ID="MapSearchExternalIDLabel" runat="server" Text="External-ID"></asp:Label>
                            <asp:TextBox CssClass="TextBoxVal" ID="ExternalIDTextBox" runat="server"></asp:TextBox>
                            <asp:ImageButton ID="ExternalIDSuchenImageButton" runat="server" AlternateText="Suchen"
                        ImageUrl="Images/lupe.gif" OnClick="ExternalIDSuchenImageButton_Click" BorderStyle="None" BorderWidth="0" />
                        </li>
                    </ul>    
                </div>
            </div>
            <div class="EditParts">
                <div class="PartM">
                    <h2><asp:Label ID="MapSearchFilialenTableLabel" runat="server" Text="Filialen"></asp:Label></h2>
                    <asp:GridView ID="AddressGridView" runat="server" CssClass="table map-data"
                        AllowPaging="True" 
                        CellPadding="2"
                        GridLines="None" 
                        AllowSorting="True"  
                        AutoGenerateColumns="False" 
                        OnPageIndexChanging="AddressGridView_PageIndexChanging" 
                        OnSorting="AddressGridView_Sorting" 
                        OnRowCommand="AddressGridView_RowCommand"
                        AlternatingRowStyle-CssClass="alt" OnRowDataBound="AddressGridView_RowDataBound">
                        <Columns>
                        <asp:TemplateField HeaderText="&nbsp;" HeaderStyle-CssClass="col1" ItemStyle-CssClass="col1">
                            <ItemTemplate>
                                <asp:LinkButton ID="SelectLinkButton" 
                                CommandArgument='<%# Eval("ID_Adresse") %>' 
                                CommandName="Select" runat="server">
                                Select</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField datafield="ID_Adresse" headertext="ID" SortExpression="ID_Adresse" HeaderStyle-CssClass="col2" ItemStyle-CssClass="col2"/>
                        <asp:TemplateField HeaderText="Typ" HeaderStyle-CssClass="col3" ItemStyle-CssClass="col3">
                            <ItemTemplate>
                                <asp:Literal ID="TypeLiteral" runat="server"></asp:Literal>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField datafield="Name" headertext="Name" SortExpression="Name" HeaderStyle-CssClass="col4" ItemStyle-CssClass="col4"/>
                        <asp:BoundField datafield="Zusatz" headertext="Zusatz" SortExpression="Zusatz" HeaderStyle-CssClass="col5" ItemStyle-CssClass="col5"/>
                        <asp:BoundField datafield="Plz" headertext="PLZ" SortExpression="Plz" HeaderStyle-CssClass="col6" ItemStyle-CssClass="col6"/>
                        <asp:BoundField datafield="Ort" headertext="Ort" SortExpression="Ort" HeaderStyle-CssClass="col7" ItemStyle-CssClass="col7"/>   
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            
            <div class="action">
                <asp:Button ID="MapSearchSpeichernButton" runat="server" TabIndex="23" Text="Speichern" OnClick="SpeichernButton_Click" />
                <asp:Button ID="MapSearchAbbrechenButton" runat="server" TabIndex="23" Text="Abbrechen" OnClick="MapSearchAbbrechenButton_Click" />
                <asp:Button ID="MapSearchUpdateButton" runat="server" TabIndex="23" Text="Aktualisieren" Enabled="False" OnClick="UpdateButton_Click" Visible="False" />
                <asp:Button ID="MapSearchDeletEntryButton" runat="server" TabIndex="23" Text="Eintrag Löschen" Enabled="False" Visible="False" OnClick="MapSearchDeletEntryButton_Click" />
                <asp:Button ID="MapSearchBuildXMLButton" runat="server" OnClick="BuildXMLButton_Click" Text="Build Map" />
                <asp:Button ID="MapSearchExportExcelButton" runat="server" OnClick="ExportExcelButton_Click" Text="Export Excel" />
                <asp:HyperLink ID="MapSearchDownloadXLSHyperLink" runat="server" CssClass="map-action" NavigateUrl="ImportExport/excel/filialen.xls">Download Excel</asp:HyperLink>
                <asp:FileUpload ID="XLSFileUpload" runat="server" CssClass="nostyle" />
                <asp:Button ID="MapSearchImportExcelButton" runat="server" OnClick="ImportExcelButton_Click" Text="Import Excel" />
                <asp:Button ID="MapSearchDeletAllButton" runat="server" OnClick="MapSearchDeletAllButton_Click" TabIndex="23" Text="Alles Löschen" />
            </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
