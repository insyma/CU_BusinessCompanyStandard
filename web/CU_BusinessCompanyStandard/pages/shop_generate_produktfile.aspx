<%@ Page Language="VB" ClientTarget="uplevel" Inherits="Insyma.ContentUpdate.CUPage" %>

<%@ Import Namespace="System.Collections.Generic" %>

<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    Dim products As String = ""
    Dim labels As String = ""
    Dim preise As String = ""
    Dim oCount As Integer = 0

    Sub Page_Load(ByVal Src As Object, ByVal E As EventArgs)
        Dim FileName As String = CUPage.PathInfo.PhysicalApplicationPath & "web" & CUPage.PathInfo.TargetPath.Replace("/", "\") & "shop_produkte.txt"

        Dim con As New ContentUpdate.Container()
        con.LoadByName("zen_shop_produkte")
        con.Preview = CUPage.Preview
        con.LanguageCode = CUPage.LanguageCode

        Dim conCategories As New ContentUpdate.Container()
        conCategories.LoadByName("zen_shop_produkt_categories")
        conCategories.Preview = CUPage.Preview
        conCategories.LanguageCode = CUPage.LanguageCode
        
        Dim conL As New ContentUpdate.Container()
        conL.LoadByName("zen_shop_produkt_label_allg")
        conL.Preview = CUPage.Preview
        conL.LanguageCode = CUPage.LanguageCode

        Dim conP As New ContentUpdate.Container()
        conP.LoadByName("zen_shop_produkt_label_preise")
        conP.Preview = CUPage.Preview
        conP.LanguageCode = CUPage.LanguageCode
        ''Standard Labels
        For Each lable As ContentUpdate.Field In conL.Fields
            labels += "'" & lable.ObjName & "' : '" & lable.Value & "', "
        Next
        ''Preise Kleinmengenzuschlag etc.
        For Each lable As ContentUpdate.Field In conP.Fields
            preise += "'" & lable.ObjName & "' : '" & lable.Value & "', "
        Next
        ''Versand Limite
        preise += "versandValues : {"
        For Each obj As ContentUpdate.Container In conP.ObjectSets("zen_shop_produkt_versand_list").Containers
            preise += oCount & " : {von : '" & obj.Fields("zen_shop_produkt_versand_von").Value & "', "
            preise += "bis : '" & obj.Fields("zen_shop_produkt_versand_bis").Value & "', "
            preise += "preis : '" & obj.Fields("zen_shop_produkt_versand_preis").Value & "'},"
            oCount += 1
        Next
        preise += "}, "
        ''Express Limite
        oCount = 0
        preise += "expressValues : {"
        For Each obj As ContentUpdate.Container In conP.ObjectSets("zen_shop_produkt_express_list").Containers
            preise += oCount & " : {von : '" & obj.Fields("zen_shop_produkt_express_von").Value & "', "
            preise += "bis : '" & obj.Fields("zen_shop_produkt_express_bis").Value & "', "
            preise += "preis : '" & obj.Fields("zen_shop_produkt_express_preis").Value & "'},"
            oCount += 1
        Next
        preise += "}"
        

        'Alle Produkte loopen
        Dim countProduct As Integer = 1
        For Each conProduct As ContentUpdate.Container In con.ObjectSets("zen_shop_produkte_list").Containers
            
            '// Nur ausgeben wenn aktiv
            If conProduct.Fields("zen_shop_produkte_entry_active").Value = "1" Then
            
                Dim name As String = conProduct.Fields("zen_shop_produkte_entry_name").Value
                Dim desc As String = conProduct.Fields("zen_shop_produkte_entry_desc").Value
                Dim category As String = conProduct.Fields("zen_shop_produkte_entry_category").Value
                Dim mwst As String = conProduct.Fields("zen_shop_produkte_entry_mwst").Value
                Dim product As String = ""
                Dim specVersand As String = ""

                For Each cat As ContentUpdate.Container In conCategories.ObjectSets("zen_shop_produkt_categories_list").Containers
                    If category = cat.Fields("zen_shop_produkt_categories_entry_cat").Value Then
                        specVersand = cat.Fields("zen_shop_produkt_categories_entry_special").Value
                    End If
                Next
            
                product += conProduct.Id & " : {"
                product += "name : '" & name & "', "
                product += "desc : '" & desc & "', "
                product += "category : '" & category & "', "
                product += "mwst : '" & mwst & "', "
                product += "specialDelivery : '" & specVersand & "', "

                '/Produktbilder loopen
                Dim countImages As Integer = 1
                product += "images : ["
                For Each conProductImages As ContentUpdate.Container In conProduct.ObjectSets("zen_shop_produkte_entry_list_img").Containers
                    Dim path As String = conProductImages.Images("zen_shop_produkte_entry_list_img_entry_img").Properties("Path").Value
                    Dim file As String = conProductImages.Images("zen_shop_produkte_entry_list_img_entry_img").Properties("Filename").Value
                    If countImages = conProduct.ObjectSets("zen_shop_produkte_entry_list_img").Containers.Count Then
                        product += "'" & path & file & "'"
                    Else
                        product += "'" & path & file & "', "
                    End If
                    countImages += 1
                Next
                product += "], "
                
                '/Produktdetails loopen
                Dim countDetail As Integer = 1
                For Each conProductDetail As ContentUpdate.Container In conProduct.ObjectSets("zen_shop_produkte_entry_list_detail").Containers
                    Dim nr As String = conProductDetail.Fields("zen_shop_produkte_entry_list_entry_nr").Value
                    Dim menge As String = conProductDetail.Fields("zen_shop_produkte_entry_list_entry_menge").Value
                    Dim price As String = conProductDetail.Fields("zen_shop_produkte_entry_list_entry_price").Value
                    Dim active As String = conProductDetail.Fields("zen_shop_produkte_entry_list_entry_active").Value
                    Dim status As String = conProductDetail.Fields("zen_shop_produkte_entry_list_entry_status").Value
                    Dim prductDetail As String = ""
                
                    product += conProductDetail.Id & " : {"
                    product += "nr : '" & nr & "', "
                    product += "menge : '" & menge & "', "
                    product += "price : '" & price & "', "
                    product += "active : '" & active & "', "                   
                    If countDetail = conProduct.ObjectSets("zen_shop_produkte_entry_list_detail").Containers.Count Then
                        product += "status : '" & status & "'}"
                    Else
                        product += "status : '" & status & "'}, "
                    End If
                    countDetail += 1
                Next
                
                If countProduct = con.ObjectSets("zen_shop_produkte_list").Containers.Count Then
                    product += "}"
                Else
                    product += "}, "                    
                End If
                products += product
            
            End If
            
            countProduct += 1
        Next
        
        IO.File.WriteAllText(FileName, "{" & products & "}")
    End Sub
</script>

<% if cupage.preview = true then %>
<pre>
<% end if %>
var wk_preise = { 
    <%= preise%>
};
var wk_labels = { 
    <%= labels%>
};
var products = { 
    <%= products%>
};
<% if cupage.preview = true then %>
</pre>
<% end if %>