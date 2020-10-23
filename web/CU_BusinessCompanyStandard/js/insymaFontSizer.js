// fONT(rE)sIZER
function setCookie(name,value,days) {
	if (days)
	{
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}
function getCookie(name) {
	if(document.cookie) {
		var cookies = document.cookie.split(";");
		for(var i = 0;i<cookies.length;i++) {
			if(cookies[i].split("=")[0] == " insyma_fontsize" || cookies[i].split("=")[0] == "insyma_fontsize"){
				var fontSize = cookies[i].split("=")[1];
				resizeFont(fontSize);
			}
		}
	}
}
function resizeFont(size) {
	document.body.style.fontSize =  size+"%";
	setCookie("insyma_fontsize", size, 10);
}


var insymaFontSizer = {
    init:function() {
		var originalFontSize = 1;
		var currentFontSize = 1;

    	var plus = document.getElementById("up");
		var minus = document.getElementById("down");
		var wrapper = document.body;
		getCookie("insyma_fontsize");
		
		if (wrapper.nodeName == "BODY") {
			if (wrapper.style.fontSize == "") {
				if (insymaUtil.cssjs("check", plus, "p_inactive")) {
					insymaUtil.cssjs("swap", plus, "p_inactive", "p_active");
				}
			} 
		}
		plus.onclick = function() {
			if (wrapper.nodeName == "BODY") {				
				if (insymaUtil.cssjs("check", plus, "p_active")) {
					currentFontSize = currentFontSize + 0.1;
					var fs = Math.round(currentFontSize*Math.pow(10,1))/Math.pow(10,1) + "em";
					wrapper.style.fontSize=fs;	
				} 
				if (wrapper.style.fontSize == "1.2em") {
					if (insymaUtil.cssjs("check", plus, "p_active")) {
						insymaUtil.cssjs("swap", plus, "p_active", "p_inactive");
					}
				} else {
					if (insymaUtil.cssjs("check", plus, "p_inactive")) {
						insymaUtil.cssjs("swap", plus, "p_inactive", "p_active");
					}
				} 
				if (wrapper.style.fontSize >= "1.0em") {
					if (insymaUtil.cssjs("check", minus, "m_inactive")) {
						insymaUtil.cssjs("swap", minus, "m_inactive", "m_active");
					}	
				} else {
					if (insymaUtil.cssjs("check", minus, "m_active")) {
						insymaUtil.cssjs("swap", minus, "m_active", "m_inactive");
					}	
				}
				setCookie("insyma_fontsize",currentFontSize,10)
			}
		}
		
		minus.onclick = function() {
			if (wrapper.nodeName == "BODY") {
				if (insymaUtil.cssjs("check", minus, "m_active")) {
					currentFontSize = currentFontSize - 0.1;
					var fs = Math.round(currentFontSize*Math.pow(10,1))/Math.pow(10,1) + "em";
					wrapper.style.fontSize=fs;
				}
				if ((wrapper.style.fontSize == "0.8em") || (wrapper.style.fontSize == "")) {
					if (insymaUtil.cssjs("check", minus, "m_active")) {
							insymaUtil.cssjs("swap", minus, "m_active", "m_inactive");
					}
				} else {
					if (insymaUtil.cssjs("check", minus, "m_inactive")) {
						insymaUtil.cssjs("swap", minus, "m_inactive", "m_active");
					}
				} 
				if (wrapper.style.fontSize == "1.2em") {
					if (insymaUtil.cssjs("check", plus, "p_active")) {
						insymaUtil.cssjs("swap", plus, "p_active", "p_inactive");
					}
				} else {
					if (insymaUtil.cssjs("check", plus, "p_inactive")) {
						insymaUtil.cssjs("swap", plus, "p_inactive", "p_active");
					}
				}
				setCookie("insyma_fontsize",currentFontSize,10)
			}
		}
		
		/*resetnow.onclick = function() {
			if (wrapper.nodeName == "DIV") {
				currentFontSize = originalFontSize;
				var fs = originalFontSize + "em";
				wrapper.style.fontSize=fs;	
			}
		}*/
    }
}
insymaUtil.addEvent(window, "load", insymaFontSizer.init, false);