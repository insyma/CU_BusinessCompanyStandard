<script runat="server">
    ' Grundeinstellungen die in allen Files bebraucht werden
    
    'Im control_footer link zu insyma falls true
    Dim INSYMA_BRANDING as boolean = false
    
    'FONTs
    Dim F_SpamInfo_Text as String = "color:#777; font-family:Tahoma, Geneva, sans-serif; font-size:10px; line-height:17px;"

    
    'BASICS
    Dim FontFamily as String = "font-family:Arial, Tahoma, Geneva, sans-serif;"
    Dim FontSizeTitle as String = "font-size:15px; line-height:18px;"
    Dim FontSizeText as String = "font-size:13px; line-height:18px;"
    Dim FontAdds as String = "text-decoration:none;"
    Dim PrimaryColor as String = "#03A9F4"
    Dim PrimaryHoverColor as String = "#000000"
    Dim PrimaryFooterColor as String = "#ffffff"
    Dim TitleColor as String = "#1F1F1F"
    Dim TextColor as String = "#757575"
    
    Dim space as String = "10"
    Dim border as String = "border: 1px solid #cccccc;"
    
    'BUTTONS
    Dim StandardButtonBGColor as String = PrimaryColor
    Dim StandardButtonBGColorHover as String = "#000000"
    Dim StandardButtonTextColor as String = "#ffffff"
    Dim StandardButtonTextColorHover as String = "#ffffff"
    Dim StandardButtonWidth as String = "220"

    'HEADER
    Dim F_Header_Text as String = FontFamily & FontSizeText & FontAdds
    Dim C_Header_Text as String = "color: "& TextColor &";"
    Dim F_Header_Link as String = FontFamily & FontSizeText & FontAdds
    Dim C_Header_Link as String = "color: "& PrimaryColor &";"
    
    Dim S_Header_Link as String = "color: "& PrimaryColor &"; text-decoration:none;"
    Dim S_Header_Border as String = border
    
    'FOOTER
    Dim F_Footer_Title as String = FontFamily & FontSizeTitle & FontAdds & " font-weight:bold; "
    Dim C_Footer_Title as String = "color: #bbbbbb;"
    Dim F_Footer_Text as String = FontFamily & FontSizeText & FontAdds
    Dim C_Footer_Text as String = "color: #ffffff;"
    Dim F_Footer_Link as String = FontFamily & FontSizeText & FontAdds
    Dim C_Footer_Link as String = "color: #ffffff;"
    
    Dim C_Footer_Background as String = "#000000"
    Dim S_Footer_Border as String = border
    
    'SUBFOOTER
    Dim F_SubFooter_Title as String = FontFamily & FontSizeTitle & FontAdds & " font-weight:bold; "
    Dim C_SubFooter_Title as String = "color: "& TitleColor &";"
    Dim F_SubFooter_Text as String = FontFamily & FontSizeText & FontAdds
    Dim C_SubFooter_Text as String = "color: "& TextColor &";"
    Dim F_SubFooter_Link as String = FontFamily & FontSizeText & FontAdds
    Dim C_SubFooter_Link as String = "color: "& PrimaryColor &";"
    
    Dim S_SubFooter_Link as String = "color: "& PrimaryColor &";"
    
    Dim C_SubFooter_Background as String = "#000000"
    Dim S_SubFooter_Border as String = border
    
    'NAVIGATION
    Dim F_Nav_Link as String = FontFamily & FontSizeText & FontAdds & " font-weight:bold;"
    Dim C_Nav_Link as String = "color: #ffffff;"
    Dim C_Nav_Background as String = PrimaryColor
    Dim C_Nav_Style as String = "border-bottom: 2px solid #eeeeee"
    dim C_Nav_Spacer = F_Nav_Link &" "& C_Nav_Link
    
    'INTRO
    Dim F_Intro_Title as String = FontFamily & FontSizeTitle & FontAdds & " font-weight:bold; "
    Dim C_Intro_Title as String = "color: "& TitleColor &";"
    Dim F_Intro_Text as String = FontFamily & FontSizeText & FontAdds
    Dim C_Intro_Text as String = "color: "& TextColor &";"
    Dim F_Intro_Link as String = FontFamily & FontSizeText & FontAdds
    Dim C_Intro_Link as String = "color: "& PrimaryColor &";"
    
    Dim C_Intro_Background as String = "#ffffff"
    Dim S_Intro_Border as String = border
    
    'INDEX
    Dim F_Index_Title as String = FontFamily & FontSizeTitle & FontAdds & " font-weight:bold;"
    Dim C_Index_Title as String = "color: #ffffff;"
    Dim F_Index_Link as String = FontFamily & FontSizeText & FontAdds
    Dim C_Index_Link as String = "color: #ffffff;"
    Dim C_Index_Background as String = PrimaryColor
    Dim S_Index_Border as String = border
    
    
    'PART: Standard
    Dim F_Standard_Title as String = FontFamily & FontSizeTitle & FontAdds & " font-weight:bold;"
    Dim C_Standard_Title as String = "color: "& TitleColor &";"
    Dim F_Standard_Text as String = FontFamily & FontSizeText & FontAdds
    Dim C_Standard_Text as String = "color: "& TextColor &";"
    Dim F_Standard_Link as String = FontFamily & FontSizeText & FontAdds
    Dim C_Standard_Link as String = "color: "& PrimaryColor &";"
    Dim C_Standard_Background as String = "#ffffff"
    Dim S_Standard_Border as String = border
    Dim S_Standard_Link_Border as String = "border-bottom: 1px solid #e0e0e0;"
    
    Dim F_Standard_Button as String = FontFamily & FontSizeText & FontAdds
    Dim C_Standard_Button as String = "color: #ffffff;"
    Dim BG_Standard_Button as String = PrimaryColor
    
    'PART: Promotion Gross
    Dim F_Promo_Title as String = FontFamily & FontSizeTitle & FontAdds & " font-weight:bold;"
    Dim C_Promo_Title as String = "color: "& TitleColor &";"
    Dim F_Promo_Text as String = FontFamily & FontSizeText & FontAdds
    Dim C_Promo_Text as String = "color: "& TextColor &""
    Dim F_Promo_Link as String = FontFamily & FontSizeText & FontAdds
    Dim C_Promo_Link as String = "color: "& PrimaryColor &";"
    Dim C_Promo_Background as String = "#ffffff"
    Dim S_Promo_Border as String = border
    Dim S_Promo_Link_Border as String = "border-bottom: 1px solid #e0e0e0;"
    
    Dim F_Promo_Button as String = FontFamily & FontSizeText & FontAdds
    Dim C_Promo_Button as String = "color: #ffffff;"
    Dim BG_Promo_Button as String = PrimaryColor
    
    
    'PART: Boxen
    Dim F_Boxen_Title as String = FontFamily & FontSizeTitle & FontAdds & " font-weight:bold;"
    Dim C_Boxen_Title as String = "color: "& TitleColor &";"
    Dim F_Boxen_Text as String = FontFamily & FontSizeText & FontAdds
    Dim C_Boxen_Text as String = "color: "& TextColor &";"
    Dim F_Boxen_Link as String = FontFamily & FontSizeText & FontAdds
    Dim C_Boxen_Link as String = "color: "& PrimaryColor &";"
    Dim C_Boxen_Background as String = "#ffffff"
    Dim S_Boxen_Border as String = border
    Dim S_Boxen_Link_Border as String = "border-bottom: 1px solid #e0e0e0;"

    Dim F_Boxen_Button as String = FontFamily & FontSizeText & FontAdds
    Dim C_Boxen_Button as String = "color: #ffffff;"
    Dim BG_Boxen_Button as String = PrimaryColor
    
    
    'COLORS
    'Dim C_Title as String = "color: #81BA25;"
    'Dim C_Text as String = "color: #333333;"
    'Dim C_Link as String = "color: #009688;"
    'Dim C_Button as String = "color: #81BA25;"
    
    'Dim C_Footer_Title as String = "color: #bbbbbb;"
    'Dim C_Footer_Text as String = "color: #FFFFFF;"
    'Dim C_Footer_Link as String = "color: #FFFFFF;"
    'Dim C_Footer_Button as String = "color: #FFFFFF;"
    
    
    Dim C_Footer_BG as String = "#333333"
    Dim C_Footer_Navig_BG as String = "#444444"
    Dim C_Footer_INSYMA_BG as String = "#314C0F"
    
    Dim C_Body_BG as String = "#ECEEE9"
    
    'Special
    Dim S_Style as String = "line-height: 0; font-size: 1px;"
    Dim S_BoxShadow as String = "box-shadow: 0 0 2px 2px #DDDDDD"
    
    Dim S_BG_Img as String = "bg.gif"
    Dim S_BG_Img_OL as String = "bg.gif"
        
    
    'WYSIWYG: Wird in getText() verwendet
    dim WYSIWYG_Link = PrimaryColor
    dim WYSIWYG_Text = FontFamily & FontSizeTitle & FontSizeText
    dim WYSIWYG_Text_OL = FontFamily & FontSizeTitle & FontSizeText
    dim WYSIWYG_Text_UL_Bullet = FontFamily & FontSizeTitle & FontSizeText
    
    ''Combine for runat="Server" tags
    'dim FC_Button = F_Button &" "& C_Button
    

</script>
