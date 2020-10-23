// Insyma Basic Packed
var insymaUtil = {
    firstSib: function (obj) {
        var temp = obj.parentNode.firstChild;
        while(temp.nodeType != 1 && temp.nextSibling != null) {
            temp = temp.nextSibling;
        }
        return (temp.nodeType == 1) ? temp : false;
    },
    lastSib: function (obj) {
        var temp = obj.parentNode.lastChild;
        while(temp.nodeType != 1 && temp.previousSibling != null) {
            temp = temp.previousSibling;
        }
        return (temp.nodeType == 1) ? temp : false;
    },
    closestSib: function (obj, direction) {
        var temp;
        if(direction == -1 && obj.previousSibling != null) {
            temp = obj.previousSibling;
            while(temp.nodeType != 1 && temp.previousSibling != null) {
                temp = temp.previousSibling;
            }
        } else if(direction == 1 && obj.nextSibling != null) {
            temp = obj.nextSibling;
            while(temp.nodeType != 1 && temp.nextSibling != null) {
                temp = temp.nextSibling;
            }
        }
        return (temp.nodeType == 1) ? temp : false;
    },
    elmByClass: function (tagName, cName) {
        var el = document.getElementsByTagName(tagName);
        var els = new Array();
        if(cName) {
            for(var i = 0; i < el.length; i++) {
                if(insymaUtil.cssjs("check", el[i], cName)) {
                    els.push(el[i]);
                }
            }
        } else {
            for(var j = 0; j < el.length; j++) {
                els.push(el[j]);
            }
        }
        return els;
    },
    createElm: function (obj, attr, txt, append) {
        var temp = document.createElement(obj);
        if(attr) {
            insymaUtil.setAttr(temp, attr);
        }
        if(txt) {
            insymaUtil.setText(temp, txt);
            if(obj == "a") {
                insymaUtil.setAttr(temp, {
                    title: txt
                });
            }
        }
        if(append) {
            append.appendChild(temp);
        }
        return temp;
    },
    getText: function (node) {
        if(!node.hasChildNodes()) {
            return false;
        }
        var reg = /^\s+$/;
        var tempObj = node.firstChild;
        while(tempObj.nodeType != 3 && tempObj.nextSibling != null || reg.test(tempObj.nodeValue)) {
            tempObj = tempObj.nextSibling;
        }
        return tempObj.nodeType == 3 ? tempObj.nodeValue : false;
    },
    setText: function (obj, txt) {
        try  {
            if(obj.firstChild == null) {
                obj.appendChild(document.createTextNode(txt));
            } else {
                if(obj.firstChild.nodeType == 3) {
                    obj.removeChild(obj.firstChild);
                }
                obj.appendChild(document.createTextNode(txt));
            }
        } catch (e) {
        }
    },
    setAttr: function (obj, attr) {
        for(var i in attr) {
            if(/class/i.test(i)) {
                insymaUtil.cssjs("add", obj, attr[i]);
            } else {
                obj.setAttribute(i, attr[i]);
            }
        }
    },
    cssjs: function (a, o, c1, c2) {
        switch(a) {
            case 'swap':
                o.className = !insymaUtil.cssjs('check', o, c1) ? o.className.replace(c2, c1) : o.className.replace(c1, c2);
                break;
            case 'add':
                if(!insymaUtil.cssjs('check', o, c1)) {
                    o.className += o.className ? ' ' + c1 : c1;
                }
                break;
            case 'remove':
                if(insymaUtil.cssjs('check', o, c1)) {
                    var rep = o.className.match(' ' + c1) ? ' ' + c1 : c1;
                    o.className = o.className.replace(rep, '');
                }
                break;
            case 'check':
                var found = false;
                var temparray = o.className.split(' ');
                for(var i = 0; i < temparray.length; i++) {
                    if(temparray[i] == c1) {
                        found = true;
                    }
                }
                return found;
                break;
        }
    },
    getQuerystring: function (query) {
        if(document.location.search.indexOf(query) > 0) {
            var querystring = document.location.search;
            var pairs = querystring.substring(1).split("&");
            for(var i = 0; i < pairs.length; i++) {
                var varName = pairs[i].split('=')[0];
                var varValue = pairs[i].split('=')[1];
                if(varName == query) {
                    if(typeof (varValue) != 'undefined') {
                        return varValue;
                    } else {
                        return true;
                    }
                }
            }
        } else {
            return false;
        }
    },
    setQuerystring: function (query, qValue) {
        if(document.location.search.indexOf("?") > -1) {
            if(insymaUtil.getQuerystring(query)) {
                if(insymaUtil.getQuerystring(query) != true) {
                    return document.location.href.replace(query + "=" + insymaUtil.getQuerystring(query), query + "=" + qValue);
                } else {
                    return document.location.href.replace(query, query + "=" + qValue);
                }
            } else {
                if(document.location.href.indexOf("#") > -1) {
                    return document.location.href.split("#")[0] + "&" + query + "=" + qValue;
                } else {
                    return document.location + "&" + query + "=" + qValue;
                }
            }
        } else {
            if(document.location.href.indexOf("#") > -1) {
                return document.location.href.split("#")[0] + "?" + query + "=" + qValue;
            } else {
                return document.location + "?" + query + "=" + qValue;
            }
        }
    },
    getPageSize: function () {
        var xScroll, yScroll;
        if(window.innerHeight && window.scrollMaxY) {
            xScroll = window.innerWidth + window.scrollMaxX;
            yScroll = window.innerHeight + window.scrollMaxY;
        } else if(document.body.scrollHeight > document.body.offsetHeight) {
            xScroll = document.body.scrollWidth;
            yScroll = document.body.scrollHeight;
        } else {
            xScroll = document.body.offsetWidth;
            yScroll = document.body.offsetHeight;
        }
        var windowWidth, windowHeight;
        if(self.innerHeight) {
            if(document.documentElement.clientWidth) {
                windowWidth = document.documentElement.clientWidth;
            } else {
                windowWidth = self.innerWidth;
            }
            windowHeight = self.innerHeight;
        } else if(document.documentElement && document.documentElement.clientHeight) {
            windowWidth = document.documentElement.clientWidth;
            windowHeight = document.documentElement.clientHeight;
        } else if(document.body) {
            windowWidth = document.body.clientWidth;
            windowHeight = document.body.clientHeight;
        }
        if(yScroll < windowHeight) {
            pageHeight = windowHeight;
        } else {
            pageHeight = yScroll;
        }
        if(xScroll < windowWidth) {
            pageWidth = xScroll;
        } else {
            pageWidth = windowWidth;
        }
        arrayPageSize = new Array(pageWidth, pageHeight, windowWidth, windowHeight);
        return arrayPageSize;
    },
    pause: function (ms) {
        var date = new Date();
        curDate = null;
        do {
            var curDate = new Date();
        }while(curDate - date < ms);
    },
    mailDecoder: function () {
        var atags = document.getElementsByTagName("a");
        var decoded = "";
        for(var i = 0; i < atags.length; i++) {            
            if (!atags[i].hasAttribute("href")){
                continue;
            }
            var hrefA = atags[i].getAttribute("href").replace(/%20/g, " ")
                                .replace(/%3Cspan/g,"").replace(/\/span%3E/g,"");
            
            if(hrefA.indexOf("L_") > -1) {
                if(!hrefA.match(/L_[a-z0-9_-]+--[a-z0-9_-]+/)) {
                    continue;
                }
                
                var link = hrefA.substring(hrefA.indexOf("L_")+2);
                link = link.replace("<span class='encoding_mail'>", "");
                link = link.replace("</span>", "");
                link = link.replace(/__/g, ".").replace(/--/g, "@");
                decoded = insymaUtil.decodeMail(link);
                if(atags[i].innerHTML.indexOf("L_") > -1 && atags[i].innerHTML.indexOf("L_") < 2) {
                    atags[i].innerHTML = decoded;
                }
                if(atags[i].title.indexOf("L_") > -1) {
                    atags[i].title = decoded;
                }
                atags[i].href = 'mailto:' + decoded;
            }
            
            if (hrefA.indexOf("P_") > -1) {
                var link = hrefA.substring(hrefA.indexOf("P_") + 2).replace(/%20/g," ");
                decoded = insymaUtil.decodePhone(link);
                
                if (atags[i].innerHTML.indexOf("P_") > -1 && atags[i].innerHTML.indexOf("P_") < 2) {
                    atags[i].innerHTML = decoded;
                }
                if (atags[i].title.indexOf("P_") > -1) {
                    atags[i].title = decoded;
                }
                atags[i].href = 'tel:' + decoded;
            }
        }
        var spantags = insymaUtil.elmByClass('span', 'encoding_mail');
        for(var i = 0; i < spantags.length; i++) {
            if(spantags[i].innerHTML.indexOf("L_") > -1) {
                var link = spantags[i].innerHTML.substring(spantags[i].innerHTML.indexOf("L_") + 2);
                link = link.replace(/__/g, ".").replace(/--/g, "@");
                decoded = insymaUtil.decodeMail(link);
                spantags[i].innerHTML = decoded;
            }
        }
        
        spantags = insymaUtil.elmByClass('span', 'encoding_phone');
        for (var i = 0; i < spantags.length; i++) {
            if (spantags[i].innerHTML.indexOf("P_") > -1) {
                var link = spantags[i].innerHTML.substring(spantags[i].innerHTML.indexOf("P_") + 2).replace(/%20/g," ");
                decoded = insymaUtil.decodePhone(link);
                spantags[i].innerHTML = decoded;
            }
        }
    },
    decodeMail: function (adresse) {
        var result = "";
        var chr;
        for(var i = 0; i < adresse.length; i++) {
            chr = adresse.charAt(i);
            result = chr + result;
        }
        return result;
    },
    decodePhone: function (phone) {
        var result = "";
        var chr;
        for (var i = 0; i < phone.length; i++) {
            chr = phone.charCodeAt(i);

            if (/[A-Z]/.test(phone.charAt(i))) {
                chr = chr - 17;
            }

            result += String.fromCharCode(chr);
        }
        return result;
    },
    addEvent: function (elm, evType, fn, useCapture) {
        if(elm.addEventListener) {
            elm.addEventListener(evType, fn, useCapture);
            return true;
        } else if(elm.attachEvent) {
            var r = elm.attachEvent('on' + evType, fn);
            return r;
        } else {
            elm['on' + evType] = fn;
        }
    }
};
insymaUtil.addEvent(window, "load", insymaUtil.mailDecoder, false);
// // Formular Test (MUFC 2006)
// Alle Abtestungen geben bei NULL true zurueck

//
// Modified by SIB.Hao - 24.06.2010
//

function AllTrim(str) {
    return str.replace(/^\s+|\s+$/g, '');
}

function ValidateEmail(field) {
	if (AllTrim(field.value) != ""){
		return(/^([a-zA-Z0-9_\-\&\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9_\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/i.test(field.value));
	} else {
		return (true);
	}
}

function ValidateDigits(field) {
	field.value = field.value.replace(/\s/g, "");
	return(/^\d*$/i.test(field.value));
}

function ValidateIntegers(field) {
	return(/^[-+]?\d*$/i.test(AllTrim(field.value)));
}

function ValidateDecimal(field) {
    var val = AllTrim(field.value);
    if(val == null || val == "")
		return true;
	
	return(/^[-+]?\d+(\.\d{1,2})?$/i.test(val));
}

function ValidateCurrency(field) {
    var val = AllTrim(field.value);
    if(val == null || val == "")
		return true;
	
    return(/^[-+]?\d+([.,]\d{1,2})?$/i.test(val));
}

function ValidatePhone(field) {
	if (AllTrim(field.value) != ""){
		field.value = field.value.replace(/[\.\'\-,]/g, " ");
		return(/^(0|\+)?([0-9 \/\(\)]){3,20}$/i.test(field.value));
		//return(/^[+]?\d+[\s]?[\d+]?[\s]?[\d+]?[\s]?[\d+]?[\s]?[\d+]?[\s]?[\d+]?[\s]?$/i.test(field.value));
	} else {
		return(true);
	}
}


function ValidateDate(field) {
	var val = AllTrim(field.value);
    if(val == null || val == "")
		return true;
	
    return(/^([0]?[1-9]|[1|2][0-9]|[3][0|1])[\.]([0]?[1-9]|[1][0-2])[\.]([0-9]{4}|[0-9]{2})$/i.test(val));
}

function ValidateRadio(field,fieldCount) {
	var isOK = false;
	for (i=0;i<fieldCount;i++){
		if (field[i].checked==true){
			isOK = true;
		}
	}
	return(isOK);
}


/**
 * @author MURA
 * @copyright insyma AG
 * @projectDescription insyma JavaScript Library FormValidation Module
 * @version 1.0 
 * 
 */
var insymaFormValidation = {
	config:{
		// Alle Klassennamen für LI-Tags
		validationClasses: [
			"validate", 		// für normale Validierung
			"validateRadio", 	// für Radiobuttons
			"validateMail", 	// für E-Mail-Feld
			"validateDecimal", 	// für Dezimalzahlen
			"validatePhone", 	// für Telefonnummer
			"validateCurrency",	// für Währung
			"validateDigits", 	// für positive Ganzzahlen
			"validateIntegers", // für positive und negative Ganzzahlen
			"validateDate"		// für Datumsfeld
		],
		// Alle Validierungstexte
		validationTexts: [
			"Bitte füllen Sie das Feld [label] aus!",					// für normale Validierung
			"Bitte wählen Sie eines der Felder [label] aus!",			// für Radiobuttons
			"Bitte geben Sie eine korrekte E-Mail an!",					// für E-Mail-Feld
			"Das Feld [label] darf nur aus Dezimalzahlen bestehen!",	// für Dezimalzahlen
			"Bitte geben Sie eine korrekte Nummer an!",					// für Telefonnummer
			"Bitte geben Sie eine korrekte Währung an!",				// für Währung
			"Das Feld [label] darf nur aus positiven Zahlen bestehen!",	// für positive Ganzzahlen
			"Das Feld [label] darf nur aus Zahlen bestehen!",			// für positive und negative Ganzzahlen
			"Bitte wählen Sie ein gültiges Datum!"					// für Datumsfeld
		],
		
		formValidationClass: "insymaFormValidation",
		validationTag: "strong",
		validationTagClass: "validation",
		validationFalseClass: "notvalid",
		
		ThanksUrlVar: "thanks",
		ThanksContainerId: "thanks",
		hideClass: "hide"
	},
	init:function() {
		var formConfig = insymaFormValidation.config;
		var formContainer = insymaUtil.elmByClass("div", formConfig.formValidationClass);
		//var forms = insymaUtil.elmByClass("form", formConfig.formValidationClass);
		for (var i = 0; i < formContainer.length; i++) {
			var conForm = formContainer[i].getElementsByTagName("form")[0];
			//forms[i].onsubmit = function() {
			if (typeof(conForm) != 'undefined' && conForm != null) {
				conForm.onsubmit = function(){
					var valElms = this.getElementsByTagName("li");
					var valid = true;
					for (var x = 0; x < valElms.length; x++) {
						var valFields = valElms[x].getElementsByTagName("input");
						var valLabel = valElms[x].getElementsByTagName("label")[0];
						var valTags = valElms[x].getElementsByTagName(formConfig.validationTag);
						for (var z = 0; z < valTags.length; z++) {
							if (insymaUtil.cssjs("check", valTags[z], formConfig.validationTagClass)) {
								valElms[x].removeChild(valTags[z]);
							}
						}
						insymaUtil.cssjs("remove", valElms[x], formConfig.validationFalseClass);
						if (valFields.length == 0) {
							continue;
						}
						else 
							if (valFields.length > 1 && insymaUtil.cssjs("check", valElms[x], formConfig.validationClasses[1])) {
								if (!insymaFormValidation.validateRadio(valFields, valFields.length)) {
									var valText = formConfig.validationTexts[1].replace("[label]", insymaUtil.getText(valLabel));
									insymaUtil.createElm(formConfig.validationTag, {
										className: formConfig.validationTagClass
									}, valText, valElms[x]);
									insymaUtil.cssjs("add", valElms[x], formConfig.validationFalseClass);
									valid = false;
								}
							}
							else {
								var valField = valFields[0];
								for (var y = 0; y < formConfig.validationClasses.length; y++) {
									if (insymaUtil.cssjs("check", valElms[x], formConfig.validationClasses[y])) {
										if (valField.value == "") {
											var valText = formConfig.validationTexts[0].replace("[label]", insymaUtil.getText(valLabel));
											insymaUtil.createElm(formConfig.validationTag, {
												className: formConfig.validationTagClass
											}, valText, valElms[x]);
											insymaUtil.cssjs("add", valElms[x], formConfig.validationFalseClass);
											valid = false;
											break;
										}
										else {
											var fieldValid = true;
											switch (y) {
												case 2:
													fieldValid = insymaFormValidation.validateEmail(valField);
													break;
												case 3:
													fieldValid = insymaFormValidation.validateDecimal(valField);
													break;
												case 4:
													fieldValid = insymaFormValidation.validatePhone(valField);
													break;
												case 5:
													fieldValid = insymaFormValidation.validateCurrency(valField);
													break;
												case 6:
													fieldValid = insymaFormValidation.validateDigits(valField);
													break;
												case 7:
													fieldValid = insymaFormValidation.validateIntegers(valField);
													break;
												case 8:
													fieldValid = insymaFormValidation.validateDate(valField);
													break;
											}
											if (!fieldValid) {
												var valText = formConfig.validationTexts[y].replace("[label]", insymaUtil.getText(valLabel));
												insymaUtil.createElm(formConfig.validationTag, {
													className: formConfig.validationTagClass
												}, valText, valElms[x]);
												insymaUtil.cssjs("add", valElms[x], formConfig.validationFalseClass);
												valid = false;
											}
											break;
										}
									}
								}
							}
					}
					return valid;
				}
			}
		}
		if (insymaUtil.getQuerystring(insymaFormValidation.config.ThanksUrlVar) != false) {
			var thankMessage = document.getElementById(insymaFormValidation.config.ThanksContainerId)
			try {
				insymaUtil.cssjs("remove", thankMessage, insymaFormValidation.config.hideClass);				
			} catch(e){	
			}
		}
	},
	validateEmail:function(field) {
		return ValidateEmail(field);
	},
		
	validateDigits: function(field){
		return ValidateDigits(field);
	},
	
	validateIntegers:function(field) {
		return ValidateIntegers(field);
	},

	validateDecimal:function(field) {
		return ValidateDecimal(field);
	},

	validatePhone:function(field) {
		return ValidatePhone(field);
	},

	validateCurrency:function(field) {
		return ValidateCurrency(field);
	},
	
	validateDate:function(field) {
		return ValidateDate(field);
	},

	validateRadio:function(field,fieldCount) {
		return ValidateRadio(field, fieldCount);
	}
};
insymaUtil.addEvent(window,'load',insymaFormValidation.init,false);