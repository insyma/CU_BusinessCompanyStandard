<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl"  %>
<script runat="server">

	Dim CUContainer as ContentUpdate.Container
	Dim CUForm1 as ContentUpdate.Form
	Dim Redirect as String
	Dim PostURL as String
	Dim host As String
	Dim strRedirect as String 'SCHM
	dim captcha as string = ""
    dim c as integer
	Sub Page_Load(Src As Object, E As EventArgs)  
        Dim beschrWk as new contentupdate.container
		beschrWk.loadbyname("zen_shop_produkt_label_allg")
		beschrWk.LanguageCode = CUPage.LanguageCode
		beschrWk.Preview = CUPage.Preview

		CUForm1 = new ContentUpdate.Form()
		CUForm1.Load(Container.ID)
		CUForm1.LanguageCode = Container.LanguageCode
		captcha = Container.Containers("Captcha").fields("capcha_text").value
		'Redirect auf neue Seite
		If Container.Properties("Redirect").Value = "" Then 'SCHM
			If not Container.Containers("Standard").Links("ThanksPage").Properties("Value").Value = "" then
				If instr(Container.Containers("Standard").Links("ThanksPage").Properties("Value").Value,"http://") > 0 then
					strRedirect = Container.Containers("Standard").Links("ThanksPage").Properties("Value").Value
				else
					Dim TempPage as new ContentUpdate.Page
					TempPage.load(cInt(Container.Containers("Standard").Links("ThanksPage").Properties("Value").Value))
					TempPage.LanguageCode = CUPage.LanguageCode
					TempPage.Preview = CUPage.Preview
					if CUPage.Preview = true then
						strRedirect = TempPage.Link
					else
						strRedirect = CUPage.Web.LiveServer  & TempPage.Link
					end if
				End if
			else
		'Redirect Meldung
				if CUPage.Preview = true then
					strRedirect = CUPage.Link & "&danke=1"
				else
					strRedirect = CUPage.Web.LiveServer  & CUPage.Link & "?danke=1"
				end if
			End if
		else
			strRedirect= Container.Properties("Redirect").Value
		End if 'SCHM
		dim b as new contentupdate.container
		b.loadbyName("BeschriftungenContainer")
		b.languageCode = cupage.languagecode
		dim _b as string = b.fields("label_weiter_zu").value
		dim i as integer = 1
		steps.text = "<ul class='steps'>"
		
		for each c as contentupdate.container in container.containers
			if c.fields("bestellung_tabtitle").id > 0 then
				dim _t as string = ""
				dim _s as string = ""
				if i = 1 then
					_t = " active"
					_s = "style='display:none;'"
				else if i = 2 then
					_t = "inactive"
					_s = ""
				else
					_t = "inactive"
					_s = "style='display:none;'"
				end if
				steps.text += "<li class='tab " & _t & "' id='tab_" & i & "' data-type='tab' data-step='" & i & "' >" & c.fields("bestellung_tabtitle").value & "<span class='bubble_error'>0</span></li>"
				nexts.text += "<a href='javascript:void(0);' class='next_button " & _t & "' id='next_button_" & i & "' " & _s & " data-type='button' data-step='" & i & "'>" & _b & " " & c.fields("bestellung_buttontitle").value & "</a>"
				i += 1
			end if
		next
		steps.text += "</ul>"
		
		PostURL = CUPage.Web.TemplateServer & "/" & CUPage.Web.Caption & "/form/mailer.aspx?form_id=" & CUForm1.Id & "&lang=" & CUPage.LanguageCode
		CUContainer = CUForm1.Containers("Standard")
		host = CUPage.Web.LiveServer & CUPage.Web.LivePath & "html/"
		
		if not CUForm1.Containers("bestell_step4").files("form_bestellung_agb_file").filename = "" then
			filestring.Text = CUForm1.Containers("bestell_step4").files("form_bestellung_agb_file").filename & "#" & CUForm1.Containers("bestell_step4").files("form_bestellung_agb_file").properties("path").value & "#" & CUForm1.Containers("bestell_step4").fields("form_bestellung_agb_text").value
		end if
		'if not CUForm1.Containers("Standard").fields("info_gewicht").value = "" then
			'gstring.Text = CUForm1.Containers("Standard").fields("info_gewicht").value & "#" & CUForm1.Containers("Standard").fields("bestellung_gewicht").plaintext
		'end if

        emptybasket.text = beschrWk.fields("lbl_shop_warenkorbleer").value
        subtotal.text = beschrWk.fields("lbl_shop_subtotal").value
        kleinmengenzuschlag.text = beschrWk.fields("lbl_shop_kleinmengenzuschlag").value
        versandkosten.text = beschrWk.fields("lbl_shop_versandkosten").value
        total.text = beschrWk.fields("lbl_shop_gesamtpreis").value

		
	End Sub
	
	Private Sub BindItem(Sender As Object, e As RepeaterItemEventArgs)
		If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
			Dim questionField As ContentUpdate.Question = CType(e.Item.DataItem, ContentUpdate.Question)
			questionField.Preview = CUPage.Preview
			Container.Containers("Captcha").ParentPages("CaptchaPage").Preview = CUPage.Preview
			if questionField.Properties("QuestionType").Value = "7" then
				if CUPage.Preview then
					questionField.Answers(1).Properties("Rows").Value = Container.Containers("Captcha").ParentPages("CaptchaPage").Link
				else
					questionField.Answers(1).Properties("Rows").Value = CUPage.Web.LiveServer & Container.Containers("Captcha").ParentPages("CaptchaPage").Link
				end if
			end if
		End If
	End Sub
</script>




<!-- Warenkorb -->
<div class="part_warenkorb">
	<div style="display: block;" id="warenkorb" class="warenkorb_checkout">
        <div id="wk_body">
        </div>
        <div id="wk_emptybasket">
            <asp:Literal id="emptybasket" runat="server" />
        </div>
        <div id="wk_footer">
            <div class="wrap_total">
                <div>
                    <span class="wk_sub_total_label"><asp:Literal id="subtotal" runat="server" /></span><span class="wk_sub_total"></span> 
                </div>
                <div>
                    <span class="wk_kleinmengenzuschlag_label"><asp:Literal id="kleinmengenzuschlag" runat="server" /></span> <span class="wk_kleinmengenzuschlag" ></span> 
                </div>
                <div>
                    <span class="wk_versandkosten_label"><asp:Literal id="versandkosten" runat="server" /></span> <span class="wk_versandkosten" ></span> 
                </div>
                <div>
                    <span class="wk_total_label"><asp:Literal id="total" runat="server" /></span> <span class="wk_total"></span> 
                </div>
            </div>
        </div>
    </div>
</div>   


<!-- Login Form -->
<div class="part part-log-out formular hide">
<CU:CUContainer name="formlogin" runat="server">
    <CU:CUField name="formlogin_title" runat="server" tag="h2" />
    <p>Sie sind bereits eingeloggt.</p>
    <a href="javascript:user.showOrderForm();">Bestellung fortsetzen</a>
    <br />
    <a href="javascript:user.logout();">Ausloggen</a>
</CU:CUContainer>
</div>
<div class="part part-log-in formular hide">
<CU:CUContainer name="zen_produkt_label_allg" runat="server"><CU:CUField name="lbl_message_reg" runat="server" tag="p" /></CU:CUContainer>
<CU:CUContainer name="formlogin" runat="server">
	<CU:CUField name="formlogin_title" runat="server" tag="h3" tagclass="h3 item-title" />
	<ul>
		<li>
			<CU:CUField name="formlogin_lbl_username" runat="server" tag="label" />
			<input name="login_username" id="login_username" type="text" />
		</li>
		<li>
			<CU:CUField name="formlogin_lbl_pwd" runat="server" tag="label" />
			<input name="login_userpass" id="login_userpass" type="password" />
		</li>
		<li class="messages">
            <img id="loader" src="../img/layout/loading.gif" style="border:none; float:none; display:none;">
			<CU:CUField name="formlogin_lbl_nologin" runat="server" tag="span" tagclass="error_login_data" />
			<CU:CUField name="formlogin_lbl_nocontact" runat="server" tag="span" tagclass="error_login" />
		</li>
		<li>
			<input type="button" value='<CU:CUField name="formlogin_lbl_btn" runat="server" />' onclick="user.login()" />
		</li>
		<li>
			<a href="javascript:void(0);" class="withoutlogin" onclick="user.nologin()"><CU:CUField name="formlogin_wo_login" runat="server" /></a>
			<!--<CU:CULink name="formlogin_pwdvergessen" runat="server" />-->
			<CU:CULink name="formlogin_reg" runat="server" />
		</li>
	</ul>
	
</CU:CUContainer>
</div>

<!-- Bestell Form -->
<div class="bestellen formular hide">
    <asp:literal id="steps" runat="server" />

    <CU:CUForm id="form_Standardformular" name="form_Standardformular" method="post" runat="server" AcceptCharset="UTF-8" FormTest="true" SubmitButton=true Summary="Header">

        <input type="hidden" name="Redirect" value='<%=strRedirect%>' />
        <input type="hidden" name="save" value="true" />
        <input type="hidden" name="nlStatus" value="newsletter" />
        <input type="hidden" name="LanguageID" value="<%=CUPage.LanguageCode%>" />
        <input type="hidden" name="MailFormatID" value="1" />
        <input type="hidden" name="Newsletter" value="1" />
        <input type="hidden" name="PostURL" value="<%=PostURL%>" />
        <input type="hidden" name="Source" value="Website Kontakt" />
        <input type="hidden" name="PostEncoding" value="iso-8859-1" />
        <input type="hidden" name="Kosten" value="" />
        <input type="hidden" name="Bestellung" value="" />
        <input type="hidden" name="Gesamtkosten" value="" />
        <input type="hidden" name="lieferart" value="" />
        <input type="hidden" name="user" value="" />

        <!-- Step 1 -->
        <CU:CUFormFields name="bestell_step1" runat="server" onItemDataBound="BindItem">
            <HeaderTemplate>
                <div id="Message" class="Message" style="display: none;">
                    <p><%=CUContainer.Fields("Thanks").value %></p>
                </div>
                <div id="captchadiv" class="Message" style="display:none;">
                        <p><%=captcha%></p>
                        <a href="Javascript:history.back();" title="zur&uuml;ck">&raquo; zur&uuml;ck zum Formular</a>
                    </div>
                <ul id="tab_content_1" data-tab-id="1">
                <li><h3><%=Container.Containers("bestell_step1").Fields("bestellung_ueberschrift").value %></h3></li>
            </HeaderTemplate>
            <ItemTemplate>
                    <CU:CUFormField tag="li" container="Standard" runat="server" property="Value" />
                    <CU:CUFormField tag="label" container="Standard" runat="server" property="Value" />
                    <CU:CUFormField container="Standard" id="quest" runat="server" />
                </li>
            </ItemTemplate>
            <FooterTemplate>		    
                </ul>
            </FooterTemplate>
        </CU:CUFormFields>

        <!-- Step 2 -->
        <CU:CUFormFields name="bestell_step2" runat="server" onItemDataBound="BindItem">
            <HeaderTemplate>
                <ul  id="tab_content_2" data-tab-id="2" class="hide">
                <li><h3><%=Container.Containers("bestell_step2").Fields("bestellung_ueberschrift").value %></h3>
                    <a href="javascript:void(0);" onclick="orderProcess.copyDeliveryAddress();">Personendaten &uuml;bernehmen</a>
                </li>
            </HeaderTemplate>
            <ItemTemplate>
                <CU:CUFormField tag="li" container="Standard" runat="server" property="Value" />
                <CU:CUFormField tag="label" container="Standard" runat="server" property="Value" />
                <CU:CUFormField container="Standard" id="quest" runat="server" />
                </li>
            </ItemTemplate>

            <FooterTemplate>		    
                </ul>
            </FooterTemplate>
        </CU:CUFormFields>

        <!-- Step 3 -->
        <CU:CUFormFields name="bestell_step3" runat="server" onItemDataBound="BindItem">
            <HeaderTemplate>
                <ul id="tab_content_3" data-tab-id="3" class="hide">
                <li><h3><%=Container.Containers("bestell_step3").Fields("bestellung_ueberschrift").value %></h3></li>
                <li class="termin"><%=Container.Containers("bestell_step3").Fields("bestellung_datum_text").value %></li>
                <%if Container.Containers("bestell_step3").Fields("bestellung_datum_termin").value <> "" then %>
                    <li><%=Container.Containers("bestell_step3").Fields("bestellung_datum_termin").value %></li>
                <% end if %>
                <%if Container.Containers("bestell_step3").Fields("bestellung_datum_termininfo").value <> "" then %>
                    <li><%=Container.Containers("bestell_step3").Fields("bestellung_datum_termininfo").value %></li>
                <% end if %>
            </HeaderTemplate>
            <ItemTemplate>
                <% c = c + 1 %>
                <li class="form_row_<%=c%>">
                <CU:CUFormField tag="label" container="Standard" runat="server" property="Value" />
                <CU:CUFormField container="Standard" id="quest" runat="server" />
                </li>
            </ItemTemplate>
            <FooterTemplate>
                <li><%=Container.Containers("bestell_step3").Fields("bestellung_datum_termininfo").value %></li>		    
                </ul>
            </FooterTemplate>
        </CU:CUFormFields>

        <!-- Step 4 -->
        <CU:CUFormFields name="bestell_step4" runat="server" onItemDataBound="BindItem">
            <HeaderTemplate>
                <ul id="tab_content_4" data-tab-id="4" class="hide clear">
                <li><h3><%=Container.Containers("bestell_step4").Fields("bestellung_ueberschrift").value %></h3></li>
                <li id="summary"></li>
            </HeaderTemplate>
            <ItemTemplate>
                    <CU:CUFormField tag="li" container="Standard" runat="server" property="Value" />
                    <CU:CUFormField tag="label" container="Standard" runat="server" property="Value" />
                    <CU:CUFormField container="Standard" id="quest" runat="server" />
                </li>
            </ItemTemplate>
            <FooterTemplate>		    
                </ul>
            </FooterTemplate>
        </CU:CUFormFields>

        <p class="validationinfo" style="display:block"><%=CUContainer.Fields("validationinfo").value %></p>
        <asp:literal id="nexts" runat="server" />

    </CU:CUForm>
<script type="text/javascript">
/* <![CDATA[ */
	$(document).ready(function(){ 
        // AGB Doc. als Link in Label einbinden
        var f = '<asp:literal id="filestring" runat="server" />';
		if(f !== "")
		{
			$("label").each(function(){
				if($(this).html().indexOf(f.split("#")[2]) > -1)
				{
					var o = $(this).parent().find("label").eq(1).html();
					var html = "<a href='.." + f.split("#")[1] + f.split("#")[0] + "' title='" + o + "' target='_blank'>" + o + "</a>"
					$(this).parent().find("label").eq(1).html(html);
				}
			});	
		}
	});
	if (insymaUtil.getQuerystring("Captcha") == 'false'){
		document.getElementById('captchadiv').style.display = 'block';
		
	}
    if(window.location != window.parent.location){
        window.parent.location = window.location;
    }
/* ]]> */  
</script>
</div>
