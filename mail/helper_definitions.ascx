<script runat="server">
    ' Grundeinstellungen die in allen Files bebraucht werden
    
    'Im control_footer link zu insyma falls true
    Dim INSYMA_BRANDING as boolean = false
    
    'FONTs
    Dim F_Title as String = "font-family:Tahoma, Geneva, sans-serif; font-size:17px; line-height:17px;"
    Dim F_Text as String = "font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px;"
    Dim F_LeadText as String = "font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px;"
    Dim F_Link as String = "font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; text-decoration:none;"
    Dim F_Button as String = "font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; text-decoration:none;"
    
    Dim F_Footer_Title as String = "font-family:Tahoma, Geneva, sans-serif; font-size:17px; line-height:17px;"
    Dim F_Footer_Text as String = "font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px;"
    Dim F_Footer_Link as String = "font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; text-decoration:none;"
    Dim F_Footer_Button as String = "font-family:Tahoma, Geneva, sans-serif; font-size:13px; line-height:17px; text-decoration:none;"
    
    Dim F_SpamInfo_Text as String = "color:#777; font-family:Tahoma, Geneva, sans-serif; font-size:10px; line-height:17px;"
    
    'COLORS
    Dim C_Title as String = "color: #81BA25;"
    Dim C_Text as String = "color: #333333;"
    Dim C_Link as String = "color: #81BA25;"
    Dim C_Button as String = "color: #81BA25;"
    
    Dim C_Footer_Title as String = "color: #81BA25;"
    Dim C_Footer_Text as String = "color: #FFFFFF;"
    Dim C_Footer_Link as String = "color: #FFFFFF;"
    Dim C_Footer_Button as String = "color: #FFFFFF;"
    
    
    Dim C_Footer_BG as String = "#333333"
    Dim C_Footer_Navig_BG as String = "#444444"
    Dim C_Footer_INSYMA_BG as String = "#314C0F"
    
    Dim C_Content_BG as String = "#FFFFFF"
    Dim C_Content_Border as String = "#efefef"
    
    Dim C_Intro_BG as String = "#f6f6f6"
    Dim C_Intro_Border as String = "#efefef"
    
    Dim C_Body_BG as String = "#ECEEE9"
    
    Dim C_Promotion_Title as String = "#ffffff"
    Dim C_Promotion_Text as String = "#ffffff"
    Dim C_Promotion_Link as String = "red"
    Dim C_Promotion_BG as String = "#434E54"
    Dim C_Promotion_Border as String = "#cccccc"
    
    Dim C_Promo_LinkList_Title as String = "#ffffff"
    Dim C_Promo_LinkList_Text as String = "#ffffff"
    Dim C_Promo_LinkList_Link as String = "#81BA25"
    Dim C_Promo_LinkList_BG as String = "#434E54"
    Dim C_Promo_LinkList_Border as String = "#cccccc"
    
    'Special
    Dim S_Style as String = "line-height: 0; font-size: 1px;"
    'Dim S_BoxShadow as String = "box-shadow: 0 0 2px 2px #DDDDDD"
    Dim S_BoxShadow as String = ""
    
    Dim S_BG_Img as String = "bg.gif"
    Dim S_BG_Img_OL as String = "bg.gif"
        
    
    'WYSIWYG: Wird in getText() verwendet
    dim WYSIWYG_Link = C_Link
    dim WYSIWYG_Text = F_Text
    dim WYSIWYG_Text_OL = F_Text
    dim WYSIWYG_Text_UL_Bullet = F_Text
    
    ''Combine for runat="Server" tags
    dim FC_Button = F_Button &" "& C_Button
    
    dim FC_Promo_LinkList_Link = F_Link &" color:"& C_Promo_LinkList_Link &";"

</script>
