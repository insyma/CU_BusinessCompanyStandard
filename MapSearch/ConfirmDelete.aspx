<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfirmDelete.aspx.cs" Inherits="MapSearch.ConfirmDelete" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
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
                <div class="EditParts">
                    <div class="PartS">
                        <h2><asp:Label ID="LabelCategories" runat="server" Text="Alle Daten der Kategorien löschen:"></asp:Label></h2>
                        <ul>
                            <li>
                                <asp:CheckBox ID="CheckBoxKat0" CssClass="CheckBox" runat="server" Text="Landi"/>
                            </li>
                            <li>
                                <asp:CheckBox ID="CheckBoxKat1" CssClass="CheckBox" runat="server" Text="Volg"/>
                            </li>
                            <li>
                                <asp:CheckBox ID="CheckBoxKat2" CssClass="CheckBox" runat="server" Text="Landi mit Topangebot"/>
                            </li>
                            <li>
                                <asp:CheckBox ID="CheckBoxKat3" CssClass="CheckBox" runat="server" Text="Volg (Warenverkauf)"/>
                            </li>
                            <li>
                                <asp:CheckBox ID="CheckBoxKat4" CssClass="CheckBox" runat="server" Text="Agrola Tankstelle"/>
                            </li>
                            <li>
                                <asp:CheckBox ID="CheckBoxKat5" CssClass="CheckBox" runat="server" Text="Agrola Top Shop"/>
                            </li>
                        </ul>
                        <div class="action">
                            <ul>
                                <li>
                                    <asp:Button ID="ButtonDelete" runat="server" Text="Löschung durchführen" OnClick="ButtonDelete_Click" />
                                </li>
                                <li>
                                    <asp:Button ID="ButtonAbort" runat="server" Text="Abbrechen" OnClick="ButtonAbort_Click" />
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div id="FinalConfirm" runat="server">
                <div class="action">
                    <h2><asp:Label ID="LabelConfirmDelete" runat="server" Text="Wollen Sie die Löschung wirklich durchführen?"></asp:Label></h2>
                    <ul>
                        <li>
                            <asp:Button ID="ButtonDeleteFinal" runat="server" Text="Löschung durchführen" OnClick="ButtonDeleteFinal_Click" />
                        </li>
                        <li>
                            <asp:Button ID="ButtonAbortFinal" runat="server" Text="Abbrechen" OnClick="ButtonAbortFinal_Click" />
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
