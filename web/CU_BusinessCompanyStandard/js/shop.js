/* Templating */
var templates = [];
templates["line"] = '<div class="wk_line clearfix"><img class="wk_bild" /><h3 class="wk_name" /><h4 class="wk_menge" /><input class="wk_input" type="text" /> x <span class="wk_preis_singel" /> <span class="wk_preis" /><span class="wk_delete icon delete" /></div>';

/* GO */
$(document).ready(function() {
    insymaShop.init();
    user.init();
    orderProcess.init();
    
    //TEMP
    $("#form_Standardformular_27268").submit(function(){
        $("[id^=tab]").find(".bubble_error").html("0").hide();
        var $v = $(".InLineValidate");
        if($v.length > 0){
            $v.each(function(){
                var pid = $(this).parents("ul").attr("data-tab-id");
                var c = $("#tab_"+pid).find(".bubble_error").html();
                $("#tab_"+pid).find(".bubble_error").html(parseInt(c)+1).show();
            });
        }
    });
});
/* SHOP */
var insymaShop = {
    //Globale Variabeln
    _sessionURL : 'http://www.contentupdate.net/CU_BusinessCompanyStandard/web/CU_BusinessCompanyStandard/shop/SimpleSessionStore.ashx',
    _appendBasketSelector : "#seitenleiste",
    _highlightColor : "#D2EAC5",
    _warenkorbID : "#warenkorb",
    init : function(){
        var _shop = this;
        //Draw Basket
        _shop.drawBasketFromData();
        //Delegate: Delete from WK
        $(this._warenkorbID).on("click", ".wk_delete", function(){
            var $this = $(this);
            var pID = $this.closest(".wk_line").data("parent-id");
            var dID = $this.closest(".wk_line").data("detail-id");
            _shop.deleteSingleProduct(pID, dID, $this.closest(".wk_line"));
        });
        //Delegate: Input change
        $(this._warenkorbID).on("change", ".wk_input", function(){
            var $this = $(this);
            var pID = $this.closest(".wk_line").data("parent-id");
            var dID = $this.closest(".wk_line").data("detail-id");
            var val = parseInt($this.val());
            if(insymaHelper.isNumber(val)){
                _shop.updateSingelProduct(pID, dID, val, $this.closest(".wk_line"));
                $this.val(val);
            }
        });
        //Delegate: Hover
        $(this._warenkorbID).on("mouseenter", ".wk_line", function(){
            var $this = $(this);
            $this.find(".wk_bild").stop(true).show().animate({
                left : -61,
                opacity : 1
            });
        });
        $(this._warenkorbID).on("mouseleave", ".wk_line", function(){
            var $this = $(this);
            $this.find(".wk_bild").stop(true).hide().animate({
                left : 0,
                opacity : 0
            });
        });
    },
    //Draw Basket form Sessiondata and add Values to Placeholders
    drawBasketFromData : function(){
        var wk = JSON.parse(this.getSession());
        var templateWrap = $("#wk_body").html("");
        var total = 0, count = 1;
        if(wk.length > 0){//Basket has items
            for(var key in wk){
                var templateLine = $(templates["line"]).clone();
                var parentID = wk[key].parentID;
                var detailID = wk[key].detailID;
                var p = products[parentID];
                var c = products[parentID][detailID];
                var price = parseFloat(wk[key].count * c.price);
                //Count Total
                total += price;

                //Set ID's
                templateLine.data("parent-id", parentID);
                templateLine.data("detail-id", detailID);

                //Fill the template
                templateLine.find(".wk_name").html(p.name);
                templateLine.find(".wk_menge").html(c.menge);
                templateLine.find(".wk_input").val(parseInt(wk[key].count));
                templateLine.find(".wk_preis_singel").html(this.formatPriceWithLabel(parseFloat(c.price)));
                templateLine.find(".wk_preis").html(this.formatPriceWithLabel(price) );

                //Product Image: Check if there is one, and pick first
                var img = "";
                if(p.images.length > 0) {
                    img = p.images[0];
                    templateLine.find(".wk_bild").prop("src", ".."+img);
                }
                
                //Add first/last class
                if(count === 1)
                    templateLine.addClass("first");
                if(count === wk.length)
                    templateLine.addClass("last");

                //Add Line to WK
                templateWrap.append(templateLine);
                count++;
            }  
        }
        //Update Total after insert in DOM
        this.updateTotal(total, wk);
    },
    //Function gets called from onlick Button in HTML
    addToBasket : function(parentID, detailID){
        var val = $("#shop_menge_"+detailID).val(); 
        $("span[id^='error_value']").fadeOut(); //Alle error's ausblenden
        
        if(this.checkInputValue(val)){ //Input prüfen auf Zahl
            //Falls Dezimal, Aufrunden und wieder ins Input schreiben
            val = Math.round(val);
            $("#shop_menge_"+detailID).val(val)
            //Hinzufügen und Zeichnen
            this.addSingelProduct(parentID, detailID, val);
            this.drawBasketFromData();
            this.hightlight($(this._warenkorbID));
        }else {
            $("#error_value_"+detailID).fadeIn();
        }
    },
    //Add Single Product to Session
    addSingelProduct : function(parentID, detailID, val) {
        var wk = [];
        var wk_from_session = this.getSession();
        
        if(wk_from_session){ 
            //Warenkorb bereits vorhanden
            wk = JSON.parse(wk_from_session);
            for(var key in wk){ // Durch alle positionen loopen
                if(wk[key].detailID === detailID){ //Wenn Arikel bereits in Warenkorb, anzahl addieren
                    wk[key].count = parseInt(wk[key].count) + parseInt(val);
                    this.setSession(JSON.stringify(wk));
                    return false; // Funktion verlassen, da Artikel gefunden wurde
                }
            }
            //Arikel ist neu, in Session speichern
            wk.push({ parentID : parentID, detailID : detailID, count : val });
            this.setSession(JSON.stringify(wk));
        } else {
            //Neuer Warenkrob
            wk.push({ parentID : parentID, detailID : detailID, count : val });
            this.setSession(JSON.stringify(wk));
        }
    },
    //Update Single Product form existing Session
    updateSingelProduct : function(parentID, detailID, val, item) {
        var wk = [];
        var wk_from_session = this.getSession();
        
        if(wk_from_session){ 
            //Warenkorb bereits vorhanden
            wk = JSON.parse(wk_from_session);
            for(var key in wk){ // Durch alle positionen loopen
                if(wk[key].detailID === detailID){ //Wenn Arikel bereits in Warenkorb, anzahl addieren
                    //Wenn Anzahl kleiner oder gleich 0, Artikel löschen
                    if(parseInt(val) < 1){ 
                        this.deleteSingleProduct(parentID, detailID, item);
                        return true;
                    }
                    wk[key].count = parseInt(val);
                    
                }
            }
            this.setSession(JSON.stringify(wk));
            this.updateVisual(parentID, detailID, val, item);
            //Pass undefined, because we dont have price here.
            this.updateTotal(undefined,wk);
        }
    },        
    //Delete Single Product form existing Session
    deleteSingleProduct : function(parentID, detailID, item){
        var wk = [];
        var wk_from_session = this.getSession();
        if(wk_from_session){ 
            //Warenkorb bereits vorhanden
            wk = JSON.parse(wk_from_session);
            for(var key in wk){ // Durch alle positionen loopen
                if(wk[key].detailID === detailID){ //Arikel im Warenkorb gefunden
                    var index = wk.indexOf(wk[key]); //Suche Position im Array
                    if(index > -1){
                        wk.splice(index, 1); //Entfernen aus Array
                    }
                }
            }
            this.setSession(JSON.stringify(wk)); //In Session speichern
            this.deleteVisual(item);
            //Pass undefined, because we dont have price here.
            this.updateTotal(undefined,wk);
        } 
    },
    //Calc Price for single product         
    calculateSingleProduct : function(parentID, detailID, val){
        var article = products[parentID][detailID];
        return (parseFloat(article.price) * parseFloat(val)).toFixed(2);
    },
    //Calc only subtotal of all products in basket
    calculateTotal : function(){
        var wk = [];
        var wk_from_session = this.getSession();
        var total = 0;
        if(wk_from_session){ 
            //Warenkorb bereits vorhanden
            wk = JSON.parse(wk_from_session);
            for(var key in wk){ // Durch alle positionen loopen
                var parentID = wk[key].parentID;
                var detailID = wk[key].detailID;
                var article = products[parentID][detailID];
                total += parseFloat(article.price) * parseFloat(wk[key].count);
            }
            return total;
        }
    },
    //Checks if "kleinmenge" is over the price, if so returns cost         
    calculateKleinmenge : function(price) {
        if(parseFloat(price) < parseFloat(wk_preise.val_shop_kleinmengenzuschlagfrom))
            return parseFloat(wk_preise.val_shop_kleinmengenzuschlag);
        else
            return false;
    },
    //Calc delivery cost! Following Fields might change name in FORM
    //From name: Lieferart
    //From values: "Noramllieferung", "Expresslieferung", "abgeholt im Shop"
    calculateVersand : function(price, spicalDelivery) {
        var ret = false;
        var preise = wk_preise.versandValues;
        var type = $("input[name='Lieferart']:checked").val();
        switch(type){
            case "Noramllieferung" : 
                if(spicalDelivery) return wk_preise.val_shop_specversand; break;
            case "Expresslieferung" : 
                if(spicalDelivery) return wk_preise.val_shop_specversandexp;
                preise = wk_preise.expressValues; break;
            case "abgeholt im Shop" : return false; break;
        }
        for(index in preise){
            if(preise[index].bis != ""){
                if(parseFloat(price) > parseFloat(preise[index].von) && parseFloat(price) < parseFloat(preise[index].bis))
                    ret = parseFloat(preise[index].preis)
            }else{
                if(parseFloat(price) > parseFloat(preise[index].von))
                    ret = parseFloat(preise[index].preis)
            }
        }
        if(ret)
            return ret;
        else 
            return false;
    },
    //Check for speical delivery, returns true, if only speical products are in basket
    checkSpecialDelivery : function(wk){
        var arr = [];

        if(wk.length > 0){
            for(var key in wk){
                var p = products[wk[key].parentID];
                if(p.specialDelivery == 1)
                    arr.push(parseInt(p.specialDelivery));
                else
                    arr.push(0);
            }
        }
        //Es sind Produkte im WK, die nicht Specail sind
        if(arr.indexOf(0)>=0){
            return false;
        }else {
            //Es sind nur Speical Produkte im WK
            return true;
        }
    },
    //Updates Cost in View and Hiddenfields for form submit
    updateTotal : function(price, wk) {
        var $footer = $("#wk_footer");
        var kleinmengenpreis = 0;
        var versandpreis = 0;
        //If no param was given, get wk from session
        if(wk === undefined){
             var wk = JSON.parse(this.getSession());
        }
        var SpD = this.checkSpecialDelivery(wk);
        if(price === undefined){
            var price = this.calculateTotal();
            //If no param was given, calculate price form session
            $footer.find(".wk_sub_total").html(this.formatPriceWithLabel(price));
        }else {
            $footer.find(".wk_sub_total").html(this.formatPriceWithLabel(price));
        }
        if(this.calculateKleinmenge(price) && !SpD) {
            kleinmengenpreis = this.calculateKleinmenge(price);
            $footer.find(".wk_kleinmengenzuschlag_label").show();
            $footer.find(".wk_kleinmengenzuschlag").html(this.formatPriceWithLabel(kleinmengenpreis)).show();
        } else {
            $footer.find(".wk_kleinmengenzuschlag_label").hide();
            $footer.find(".wk_kleinmengenzuschlag").hide();
        }
        if(this.calculateVersand(price, SpD)) {
            versandpreis = this.calculateVersand(price, SpD);
            $footer.find(".wk_versandkosten_label").show();
            $footer.find(".wk_versandkosten").html(this.formatPriceWithLabel(versandpreis)).show();
        } else {
            $footer.find(".wk_versandkosten_label").hide();
            $footer.find(".wk_versandkosten").hide();
        }
        var total = parseFloat(price) + parseFloat(kleinmengenpreis) + parseFloat(versandpreis);
        $footer.find(".wk_total").html(this.formatPriceWithLabel(total));
        
        //SAVE DATA TO SEND IT PER POST //TODO: Enycrption=?
        var kosten = {};
        kosten.subtotal = this.formatPriceWithLabel(price);
        kosten.versandkosten = this.formatPriceWithLabel(versandpreis);
        kosten.kleinmengenzuschlag = this.formatPriceWithLabel(kleinmengenpreis);
        kosten.gesamtpreis = this.formatPriceWithLabel(total);
        $("input[name=Gesamtkosten]").val(total.toFixed(2).toString().replace(".", ""));
        $("input[name=Kosten]").val(JSON.stringify(kosten));
        $("input[name=Bestellung]").val(JSON.stringify(wk));
        
        if(parseFloat(price) <= 0){
            this.handleEmptyBasket(true);
        }else {
            this.handleEmptyBasket(false);
        }
    },
    //View handling functions        
    deleteVisual : function(item){
        item.animate({
            right : -300,
            opacity : 0
        },function(){
            $(this).remove();
            // Update class .first .last 
            var $lines = $("#wk_body").find(".wk_line");
                $lines.removeClass("first").removeClass("last").each(function(i, el){
                    if(i === 0) $(el).addClass("first");
                    if(i === $lines.length-1) $(el).addClass("last");
                });
        });
    },
    updateVisual : function(parentID, detailID, val, item){
        var newPrice = this.calculateSingleProduct(parentID, detailID, val);
        item.find(".wk_preis").html(this.formatPriceWithLabel(newPrice));
        item.effect("highlight",{color:this._highlightColor});
    },
    handleEmptyBasket : function(visible){
 
       if(visible){ 
            $("#wk_emptybasket").show();
            $("#wk_footer").hide();
        }else {
            $("#wk_emptybasket").hide();
            $("#wk_footer").show();
        }
    },
    hightlight : function(item){
        item.effect("highlight",{color:this._highlightColor});
    },
    //Validiert Menge: Zahl und grösser 0
    checkInputValue : function(n){
        if(insymaHelper.isNumber(n)){
            if(n > 0) {
                return true;
            }else {
                return false;
            }
        }else {
            return false;
        }
    },
    //Returns formatted value with currency
    formatPriceWithLabel : function(price) {
        return  parseFloat(price).toFixed(2) + " " + wk_labels.lbl_shop_waehrung;
    },
    //Session handling
    setSession : function(value){
        $.ajax({ url: insymaShop._sessionURL, type: 'POST', dataType: 'html', async: false, data: "ValueToStore="+value,
            success: function(data) {}
        });
    },
    getSession : function(){
        var session, t = new Date().getTime();
        $.ajax({ dataType: 'html', async: false, url: insymaShop._sessionURL+'?t=' + t,
            success: function(data) {
                if(data === ""){
                    session = false;
                } else {
                    session = data;
                }
            }
        });
        return session;
    }  
};
/* USER */
var user = {
    _loginURL : "http://www.contentupdate.net/CU_BusinessCompanyStandard/web/CU_BusinessCompanyStandard/services/public/shop/login.ashx",
    _addressURL : "http://www.contentupdate.net/CU_BusinessCompanyStandard/web/CU_BusinessCompanyStandard/services/public/shop/getAddress.ashx",
    _sessionURL : 'http://www.contentupdate.net/CU_BusinessCompanyStandard/web/CU_BusinessCompanyStandard/shop/UserSessionStore.ashx',
    init : function(){
        this.checkLogin();
    },
    checkLogin : function(){
        var user = this.getSession();
        if(user){
            user = JSON.parse(user);
            //$("input[name='user']").val(c);
            $("div.login").hide();
            $("div.logout").show();
            $("input[name='Zahlungsart']").parent().show();
            //Send user per POST, Session is on other server
            $("input[name=user]").val(JSON.stringify(user));
        }else{
            $("div.login").show();
            $("div.logout").hide();
        }
    },
    login : function(username, userpass) {
        var _this = this, username, password, valid = true;
        //Validate Inputs and make the call if both arent empty
        $(".error_login_data, .error_login").hide();
        if($("#login_username").val() == "") {
            $("#login_username").addClass("Validate");
            valid = false;
        }
        else {
            username = $("#login_username").val()
            $("#login_username").removeClass("Validate");
        }
        if($("#login_userpass").val() == "")
        {
            $("#login_userpass").addClass("Validate");
            valid = false;
        }
        else {
            password = $("#login_userpass").val()
            $("#login_userpass").removeClass("Validate");
        }
         //Username Password set, make the call         
        if(valid){
            $("#loader").show();
            $.ajax({
                url: _this._loginURL, dataType: 'jsonp', type: 'GET', crossDomain: true, data: {email: username, password: password},
                success:function(data){
                    $("#loader").hide();
                    if (data == "-2" || data == "-3") { $(".error_login").show(); } //No User with this username
                    if (data == "-4") { $(".error_login_data").show(); } //Userdata is wrong
                    if (typeof data == "object" ) {
                        var contact = {}
                            contact.username = username;
                            contact.password = password;
                            contact.id = data.ContactId;
                            contact.code = data.ContactCode;
                        _this.setSession(JSON.stringify(contact));
                        
                        _this.getAddressShipping(contact);
                        _this.getAddressBilling(contact);
                        $("input[name='Zahlungsart']").parent().show();
                        $("#inhalt .login").hide();
                        $("#inhalt .bestellen").show();
                        //Send user per POST, Session is on other server
                        $("input[name=user]").val(JSON.stringify(contact));
                    }
                }, error:function(){ },
              });
        }
    },
    nologin : function(){
        $("div.login").hide();
        $("div.bestellen").show();
    },
    logout : function(){
        this.setSession("");
        $("div.login").show();
        $("div.logout").hide();
    },
    showOrderForm : function(){
        var contact = this.getSession();
        if(contact){
            contact = JSON.parse(contact);
            $("div.logout").hide();
            $("div.bestellen").show();
            this.getAddressShipping(contact);
            this.getAddressBilling(contact);
        }
    },
    getAddressShipping : function(u){
        var _this = this;
        $.ajax({
            url: _this._addressURL, dataType: 'jsonp', type: 'GET', crossDomain: true,
            data: {email: u.username, password: u.password, addressType: 1},
            success: function(data) {
                if (data != -5 && data.Salutation) { // Shipping Adress nicht vorhanden oder Leer
                    if (data.Salutation == "Herr") { $('input[name=SalutationID][value="Herr"]').prop("checked", true); }
                    if (data.Salutation == "Frau") { $('input[name=SalutationID][value="Frau"]').prop("checked", true); }
                    $('input[name=SurName]').val(data.LastName)
                    $('input[name=FirstName]').val(data.FirstName)
                    $('input[name=Address]').val(data.Address1)
                    $('input[name=PLZ]').val(data.PostalCode) // plz
                    $('input[name=City]').val(data.City)
                    $('input[name=Telefon]').val(data.Phone)//tel
                    $('input[name=Mobile]').val(data.Mobile) //mobile
                    $('input[name=Email]').val(data.EMail)
                } else {
                     _this.getAddressDefault(u);
                }
            }, error: function() { },
        });
    },
    getAddressDefault : function(u){
        var _this = this;
        $.ajax({
            url: _this._addressURL, dataType: 'jsonp', type: 'GET', crossDomain: true,
            data: {email: u.username, password: u.password},
            success: function(data) {
                if (data.Salutation == "Herr") { $('input[name=SalutationID][value="Herr"]').prop("checked", true); }
                if (data.Salutation == "Frau") { $('input[name=SalutationID][value="Frau"]').prop("checked", true); }
                $('input[name=SurName]').val(data.LastName)
                $('input[name=FirstName]').val(data.FirstName)
                $('input[name=Address]').val(data.Address1)
                $('input[name=PLZ]').val(data.PostalCode) // plz
                $('input[name=City]').val(data.City)
                $('input[name=Telefon]').val(data.Phone)//tel
                $('input[name=Mobile]').val(data.Mobile) //mobile
                $('input[name=Email]').val(data.EMail)
            }, error: function() { },
        });
    },
    getAddressBilling : function(u){
        var _this = this;
        $.ajax({
            url: _this._addressURL, dataType: 'jsonp', type: 'GET', crossDomain: true,
            data: {email: u.username, password: u.password, addressType: 0},
            success: function(data) {
                    if (data.Salutation == "Herr") { $('input[name=SalutationID_bill][value="Herr"]').prop("checked", true); }
                    if (data.Salutation == "Frau") { $('input[name=SalutationID_bill][value="Frau"]').prop("checked", true); }
                    $('input[name=SurName_bill]').val(data.LastName)
                    $('input[name=FirstName_bill]').val(data.FirstName)
                    $('input[name=Address_bill]').val(data.Address1)
                    $('input[name=PLZ_bill]').val(data.PostalCode) // plz
                    $('input[name=City_bill]').val(data.City)
                    $('input[name=Telefon_bill]').val(data.Phone)//tel
                    $('input[name=Mobile_bill]').val(data.Mobile) //mobile
                    $('input[name=Email_bill]').val(data.EMail)
            }, error: function() { },
        });
    },
    //Session handling
    setSession : function(value){
        $.ajax({ url: user._sessionURL, type: 'POST', dataType: 'html', async: false, data: "ValueToStore="+value,
            success: function(data) {}
        });
    },
    getSession : function(){
        var session, t = new Date().getTime();
        $.ajax({ dataType: 'html', async: false, url: user._sessionURL+'?t=' + t,
            success: function(data) {
                if(data === ""){
                    session = false;
                } else {
                    session = data;
                }
            }
        });
        return session;
    }  
};
/* ORDER */
var orderProcess = {
    init : function(){
        this.setTabbing();
        //Versandart Handler
        $("input[name='Lieferart']").on("change", function(){
            insymaShop.updateTotal(undefined, undefined);
            insymaShop.hightlight($(insymaShop._warenkorbID));
        });
    },
    setTabbing : function(){
        var op = this;
        var $tabnav = $("ul.steps").find("li");
        var $tabnextButton = $("a[id^='next_button_']");
        $('input[name=submitbutton]').hide();
        $tabnav.add($tabnextButton).on("click", function(){
            var $this = $(this);
            var type = $this.attr("data-type");
            var step = parseInt($this.attr("data-step"));
            $('input[name=submitbutton]').hide();
            if(op.validateStep(step)){
                //Set Class on active step
                $tabnav.removeClass("active").removeClass("inactive").addClass("inactive");
                $("li[id^='tab_"+step+"']").addClass("active");	
                //Hide Forms, and show active one
                $("ul[id^='tab_content_']").addClass("hide");
                $('#tab_content_' + step).removeClass("hide");
                //Show Next button
                $tabnextButton.hide();
                $('#next_button_' + (step + 1)).show();
                if(step === 4) {
                    $('input[name=submitbutton]').show();
                    op.getSummary();
                }
            }
        });
    },
    copyDeliveryAddress : function(){
        //Copy only, if Field is empty
        $('input[name=SurName_bill]').val($('input[name=SurName]').val());
        $('input[name=FirstName_bill]').val($('input[name=FirstName]').val());
        $('input[name=Address_bill]').val($('input[name=Address]').val());
        $('input[name=PLZ_bill]').val($('input[name=PLZ]').val());
        $('input[name=City_bill]').val($('input[name=City]').val());
        $('input[name=Telefon_bill]').val($('input[name=Telefon]').val());
        $('input[name=Mobile_bill]').val($('input[name=Mobile]').val());
        $('input[name=Email_bill]').val($('input[name=Email]').val());
        var _s = $('input[name=SalutationID]:checked').val();
        $('input[name=SalutationID_bill][value="'+_s+'"]').prop("checked", true);
    },
    getSummary : function(){
        var $summary = $("#summary");
        var $tabs = $("#tab_content_1, #tab_content_2, #tab_content_3");
        var html = "";

        $tabs.find(">li").each(function(i){
            var $this = $(this);
            if($this.find("h3").length > 0){
                html += "<li><h4>"+$this.find("h3").html()+"</h4></li>";
            }else{
                if($this.find("label").length > 0){
                    var val = "";
                    var $input = $this.find("input");
                    if($input.length > 1){//Checkbox or radio
                        val = $this.find("input:checked").val();
                    } else if($input.length < 1){ //Textarea or Select
                        if($this.find("select").length > 0){
                            val = $this.find("select option:selected").val();
                        } else {
                            val = $this.find("textarea").val();
                        }
                    } else{
                        val = $input.val();
                    }
                    html += "<li><label>"+$this.find("label").html()+"</label><span>"+val+"</span></li>";
                }
            }
        });
        $summary.html(html);
    },
    validateStep : function(step) {
        //TODO: Validierung pro Schritt
        return true;
    }
};
/* HELPER */
var insymaHelper = {
    //Check for real Number    
    isNumber : function(n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    }  
};