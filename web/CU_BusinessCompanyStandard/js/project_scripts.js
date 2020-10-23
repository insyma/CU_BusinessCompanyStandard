var insyma_cookiepolicy_standard = "insyma_cookiepolicy_standard";
var insyma_cookiepolicy_marketing = "insyma_cookiepolicy_marketing";
$(document).ready(function () {
    //********************************************
    // Overlay must be first to grab images before flex clones them
    //********************************************   
    //Default options test dsfdsf
    
    //var options = new Iob_Options;
    
    //Overwrite default options if needed
    /*example:
        options.opacity = 1;
        options.loadingImg = '../img/layout/loading.gif';
    */
    //Get language
    /*
    if (typeof iObLanguage != 'undefined') {
        options.addOptions(iObLanguage);
    }
    Iob = new insymaOverlaybox(options);
    //Pause playing movies [Flash, Vimeo, Youtube] on close in overlaybox
    Iob.onClose(function () {
        if (this.currentType == 'movie') {
            //Flash
            var video = $("#insymaOverlayContent").find("object");
            if (video.length > 0) {
                video.get(0).sendToActionScript("resetAll");
            }
            //Vimeo
            video = $("#insymaOverlayContent").find("iframe[id^='iframe_movie_vimeo']");
            if (video.length > 0) {
                insymaVideo.postMessageVimeo("pause");
            }
            //Youtube
            for (var key in players) {
                if (typeof players[key].pauseVideo == 'function')
                    players[key].pauseVideo();
            }
        }
    });
    */
    //********************************************
    //  Cookie Handling & Info
    //********************************************

    if (!$.cookie(insyma_cookiepolicy_standard)) {
        insymaScripts._getCookiePolicy();
    }
    else
    {
        insymaScripts._setCookiesAndInit();
    }

    //********************************************
    //  Dataprivacy for search
    //********************************************
    var enableSearch = false;
    $("#cse-search-box").on("submit", function () {
        var content = $("body > .dataprivacy-info.search");
        var $this = $(this);
        if (!enableSearch) {
            Dataprivacy.confirm({
                content: content.clone()
            }, function () {
                enableSearch = true;
                $("#cse-search-box").submit();
            });
        }

        return enableSearch;
    });

    var button_holder = $("<div class='button-holder'></div>").appendTo("#detail .part-basic");
    //button_holder.append($(".news-detail-content .button-con"));
    button_holder.append($(".part-shariff"));

    //********************************************
    // Flexslider
    //********************************************   	
    insymaScripts._initFlexsliders();

    //********************************************
    // Mobile Navigationhandling
    //********************************************  
    insymaMobile.initNavigation();
    insymaMobile.createNavigation();
    insymaMobile.positionNavigation();
    $(window).resize(function () {
        insymaMobile.positionNavigation();
    });

    //********************************************
    // Formulare
    //********************************************  
    //Material design 
    //insymaScripts._materialForms();
    // UNIFORM
    $("select, input").uniform({
        fileDefaultText: 'Noch keine Datei ausgewählt',
        fileBtnText: 'Wählen Sie die Datei',
    });
    // Kontaktform Hiddenfields, set class on label
    $("form").find("input[type='hidden']").prev("label").each(function () {
        var html = $(this).html();
        if (html != " " && html != "") {
            $(this).addClass("h3 width100")
        }
    });
    //Disable Zoom for Formfields on IPhone
    $("input[type=text], textarea, select").focus(function () {
        $('head meta[name=viewport]').remove();
        $('head').prepend('<meta name="viewport" content="width=device-width, initial-scale=1.0,  user-scalable=0;" />');
    }).blur(function () {
        $('head meta[name=viewport]').remove();
        $('head').prepend('<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=1;" />');
    });


    //********************************************
    // Language Switch
    // Options: http://www.ixtendo.com/polyglot-language-switcher-2/
    //******************************************** 
    $('.SwitchLanguage').polyglotLanguageSwitcher({
        selectedLang: function () {
            return $('html').attr('lang');
        }
    });

    //********************************************
    // LINK TO TOP with SMOOTHSCROLL
    //******************************************** 
    $('.totop').click(function () {
        $('html, body').animate({ scrollTop: 0 }, 'slow');
        return false;
    });

    //********************************************
    // Video Handling
    //********************************************  
    //HTML5 Video Stuff
    insymaVideo.createHTML5Video();
    //Vimeo
    insymaVideo.initVimeoVideos();
    //Youtube
    insymaVideo.initYoutubeVideos();

    //********************************************
    // Image Handling
    //********************************************  
    insymaScripts._PartBilderliste();
});



//********************************************
// Get URL parameter
// Use: urlParams["preview"]
//********************************************  
var urlParams = {};
(function () {
    var e,
        a = /\+/g,
        r = /([^&=]+)=?([^&]*)/g,
        d = function (s) { return decodeURIComponent(s.replace(a, " ").toLowerCase()); },
        q = window.location.search.substring(1);
    while (e = r.exec(q))
        urlParams[d(e[1])] = d(e[2]);
})();

//Web Stuff
var insymaScripts = {
    //********************************************
    // Set active URL class in preview and live
    // Used in: control_javascript_end.ascx
    //********************************************
    _setActiveUrl: function () {
        if (typeof (curent_page_id) != "undefined") {
            $("a[data-page-id='" + curent_page_id + "']").addClass("activePage").parents("li").show();

        }
        if (typeof (page_path_ids) != "undefined" && page_path_ids.indexOf("~") > -1) {
            var arr_page_path_ids = page_path_ids.split("~");
            for (var i = 0; i < arr_page_path_ids.length; i++) {
                if (arr_page_path_ids[i] != curent_page_id) {
                    $("a[data-page-id='" + arr_page_path_ids[i] + "']").addClass("activeParentPage");
                }
            }
        }
    },
    //********************************************
    // Set Images as background on LI's for better aligment
    //********************************************
    _PartBilderliste: function () {
        $(".part-bilder-liste img, .part-medien-liste img").each(function () {
            var $this = $(this);
            var src = $this.attr("src");
            $this.closest("a").css("background-image", "url('" + src + "')");
        });
    },
    //********************************************
    // Init standard Flexsliders
    //********************************************
    _initFlexsliders: function () {
        //Basic Headerbild
        if ($(".flex-headerbild").attr("data-mode") == "Zufallsbild") {
            $('.flex-headerbild ul.slides').shuffle();
            $('.flex-headerbild ul.slides li').eq(0).show();
        }
        else {
            $('.flex-headerbild').flexslider({
                animation: "fade",
                controlNav: false,
                directionNav: false,
                prevText: "",
                nextText: "",
                slideshowSpeed: 6000,
                animationSpeed: 2000
            });
        }
        //Part: Bilderliste gross mit Loader
        $('.flex-bildergrossliste').flexloader(function () {
            $('.flex-bildergrossliste').flexslider({
                animation: "slide",
                slideshow: false,
                prevText: "",
                nextText: "",
                controlNav: true,
                directionNav: true,
                smoothHeight: true,
                start: function (slider) {
                    insymaScripts._flexsliderArrowPosToImage(slider);
                    $(window).on("resize", function () {
                        insymaScripts._flexsliderArrowPosToImage(slider);
                    });
                },
                after: function (slider) {
                    insymaScripts._flexsliderArrowPosToImage(slider);
                }
            });
        });
        //Part: Bilderliste Blog
        $('.part_bilderthumbliste').flexslider({
            animation: "slide",
            slideshow: false,
            controlNav: true,
            directionNav: true,
            smoothHeight: true
        });
        // INFO:
        // Neuer Slider muss <div class="con-flex FlexFoo"> drumherum haben
    },
    _flexsliderArrowPosToImage: function (slider) {
        var ul = $(slider).find("ul.flex-direction-nav a");
        var img = $(slider).find("li.flex-active-slide img");
        ul.css({ "top": (img.height() / 2) + "px" });
    },
    _materialForms: function () {
		$(".part-formular").addClass("part-formular-material");
        $(".con-form-data").addClass("material");
        $(".con-form-data.material").find(".divCaptcha").closest("li").addClass("li-captcha");
        this._materialFormsCheckOnLoad();
		$(".con-form-data.material").find("input[type=text], textarea, select").each(function () {
			$(this).closest("li").addClass("transform-label");
			$(this).on("focus", function () {
				$(this).closest("li").addClass("focused");
			});
			$(this).on("blur", function () {
				var $this = $(this);
				if ($(this).val() == "") {
					$(this).closest("li").removeClass("focused");
				}
				setTimeout(function () {
					if ($this.hasClass("Validate")) {
						$this.closest("li").addClass("Validate");
					} else {
						$this.closest("li").removeClass("Validate");
					}
				}, 10);
			});
		});
		$(".con-form-data.material").find(".RadioButton,.CheckBox").each(function () {
			$(this).parent("li").addClass("transform-label transform-label-gap-xl focused ");
		});
		$(".con-form-data.material").find("select").each(function () {
			$(this).closest("li").addClass("transform-label transform-label-gap-xl focused");
		});
    },
    _materialFormsCheckOnLoad: function () {
        $(".con-form-data.material").find("input[type=text], textarea").each(function () {
            var $this = $(this);
            if ($(this).val() == "") {
                $(this).closest("li").removeClass("focused");
            } else {
                $(this).closest("li").addClass("focused");
            }
            setTimeout(function () {
                if ($this.hasClass("Validate")) {
                    $this.closest("li").addClass("Validate");
                } else {
                    $this.closest("li").removeClass("Validate");
                }
            }, 10);
        });
    },
    setParts: function (aId, aPart) {
        if (aPart == "basic") {

            var div = $("#" + aId);
            div.find(".action-content-less").hide();
            div.find(".action-content-more").click(function () {
                $this = $(this);
                $this.hide();
                $this.next().show();
                div.find(".con-content-more").slideDown();
            });
            div.find(".action-content-less").click(function () {
                $this = $(this);
                $this.hide();
                $this.prev().show();
                div.find(".con-content-more").slideUp();
            });
        }
    },
    _setOverlayForAccept: function (t, global) {
        var content = $(".inhalt .shariff-info");
        Dataprivacy.confirm({
            content: content.clone()
        }, function () {
            window.open(t, "_blank", "width=600,height=460");
        });
    },
    _getCookiePolicy: function () {
        $.fancybox.open($(".cookieinfo-extended").clone());
        $(".fancybox-content .checked").parent().addClass("checked");
        $(".more-info").on("click", function(){
            $(".startcontent").hide();
            $(".extendedcontent").show();
        });
        $(".back-link").on("click", function(){
            $(".startcontent").show();
            $(".extendedcontent").hide();
        });
        $(".accept-all").on("click", function(){
            insymaScripts._setCookiesAndInit(0,1);
        });
        $(".accept-select").on("click", function(){
            if($("input[name='icb_1']").parent().hasClass("checked") == true)
                insymaScripts._setCookiesAndInit(1,0);
            else
                insymaScripts._setCookiesAndInit(0,0);
        });

        /*$(".cookieinfo").slideDown();
        $(".do-close-cookieinfo").on("click", function () {
            $(this).closest(".cookieinfo").slideUp();
            $.cookie(cookie_policy, "set", { expires: 30, path: '/' });
        });*/
        /*$(".do-hide-cookieinfo").on("click", function () {
            $(this).closest(".ConCookieInfo").slideUp();
        });*/
    },
    _setCookiesAndInit: function(aToDo, aAll)
    {
        if (!$.cookie(insyma_cookiepolicy_standard)) {
            $.cookie(insyma_cookiepolicy_standard, "set", { expires: 30, path: '/' });
        }
        if ($.cookie(insyma_cookiepolicy_marketing)) {
            insymaScripts._gtm(window, document, 'script','dataLayer',gtmid);
        }
        if((typeof(gtmid) != "undefined" && aToDo == 1) || aAll == 1) 
        {
            $.cookie(insyma_cookiepolicy_marketing, "set", { expires: 1, path: '/' });
            insymaScripts._gtm(window, document, 'script','dataLayer',gtmid);
        }
    },
    _gtm: function(w, d, s, l, i) 
    {
        w[l] = w[l] || [];
        w[l].push({
            'gtm.start': new Date().getTime(),
            event: 'gtm.js'
        });
        var f = d.getElementsByTagName(s)[0],
            j = d.createElement(s),
            dl = l != 'dataLayer' ? '&l=' + l : '';
        j.async = true;
        j.src =
            'https://www.googletagmanager.com/gtm.js?id=' + i + dl;
        f.parentNode.insertBefore(j, f);
    }
};

//Mobile Stuff
var insymaMobile = {
    initNavigation: function () {
        $("<div id='mobileNaviHolder'><div id='mobileNaviHolderScroller'></div></div>").insertBefore("#root");
        $(".con-logo").clone().appendTo("#mobileNaviHolderScroller");
        $(".NavMain-open").insertBefore("#mobileNaviHolder");
        $(".NavMain-close").appendTo("#mobileNaviHolderScroller");

        $("#IDNavMain li a").each(function () {
            var $this = $(this);
            //Navigation has Childs
            if ($this.next("ul").length > 0) {
                var span = $("<span class='mobileOnly icon handler-child open-child'></span>");
                if ($this.next("ul").hasClass("visible")) {
                    span.toggleClass("open-child close-child");
                }
                span.on("click", function () {
                    $(this).toggleClass("open-child close-child");
                    $(this).next("ul").slideToggle();
                });
                $this.addClass("has-child").after(span);
            }
        });
    },
    //Create Events and move Navigation 
    createNavigation: function () {
        var $MN_open = $("span.NavMain-open"),
            $MN_close = $("span.NavMain-close");

        //Mainnavigation
        $MN_open.click(function () {
            $("html").addClass("mobileNavigOpen");
            $(this).removeClass("showMobile");
            $MN_close.addClass("showMobile");
        });
        $MN_close.click(function () {
            $("html").removeClass("mobileNavigOpen");
            $(this).removeClass("showMobile");
            $MN_open.addClass("showMobile");
        });

    },
    //Check what to do on resize
    positionNavigation: function () {
        var winW = $(window).width();
        if ($("#size-indikator-tablet").is(":visible")) {
            if ($("#mobileNaviHolderScroller").find("#IDNavMain").length == 0) {
                $("#IDNavMain").appendTo("#mobileNaviHolderScroller");
                $("#IDNavService").appendTo("#mobileNaviHolderScroller");
                $(".con-suche").appendTo("#mobileNaviHolderScroller");
                $(".con-sprache").appendTo("#mobileNaviHolderScroller");
            }
        } else {
            if ($(".NavService #IDNavMain").length == 0) {
                $("#IDNavMain").appendTo("nav.NavMain");
                $("#IDNavService").appendTo("nav.NavService");
                $(".con-suche").insertAfter(".NavService");
                $(".con-sprache").insertAfter(".NavService");
            }
        }
    }
}

//Video Stuff
var players = {};
var insymaVideo = {
    createHTML5Video: function () {
        $("div[id^='cont_html5_']").each(function () {
            var _this = this;
            $(this).find(".playButton").click(function () {
                $(this).hide();
                var video = $(_this).find("video").get(0);
                $(video).show();
                video.play();
            });
        });
    },
    pauseAllFlashVideos: function (currentMovieId) {
        var videos = document.getElementsByTagName("object");
        for (i = 0; i < videos.length; i++) {
            videos[i].sendToActionScript("resetAll");
        }
        document.getElementById(currentMovieId).sendToActionScript("play");
    },

    //Vimeo
    _isVimeoPaused: true,
    initVimeoVideos: function () {
        var content = $("body > .dataprivacy-info.movie");
        $(document.body).on("click", "*[data-movie-type='vimeo']", function () {
            var $this = $(this);
            $.fancybox.open(content.clone());
            $(".fancybox-content .btnCancel").on("click", function(){
                $.fancybox.close();
            });
            $(".fancybox-content .btnAccept").on("click", function(){
                $.fancybox.close();
                insymaVideo.createVimeoVideo($this);
                /*Check if Youtbue API is needed
                if ($('iframe[id^="iframe_movie_vimeo"]').length > 0) {
                    window.addEventListener ? window.addEventListener('message', this.handleMessageVimeo, false) : window.attachEvent('onmessage', this.handleMessageVimeo, false);
                }*/
            });
            
        });


        
    },
    createVimeoVideo: function (obj) {
        var movie_id = obj.data("movie-id");
        var width = obj.data("width");
        var height = obj.data("height");
        var href = obj.data("href");
        $.fancybox.open({
            //settings
            'type': 'iframe',
            'width': width,
            'height': height,
            'src': href
        });
        
        /*var iframe = $('<iframe />', {
            id: 'vimeo_player_' + movie_id,
            src: 'https://player.vimeo.com/video/' + movie_id + "?color=999&api=1&autoplay=1",
            style: 'display:none',
            load: function () {
                $(this).show();
            }
        });
        var holder = $("<div class='movie-holder'><div class='ratio' style='padding-top:" + (height / width) * 100 + "%'></div></div>")
        holder.prepend(iframe);
        obj.replaceWith(holder);*/
    },
    // Handle messages received from the player
    handleMessageVimeo: function (e) {
        var data;
        try { data = JSON.parse(e.data); } catch (e) { return false; }
        switch (data.event) {
            case 'ready': insymaVideo.vimeoOnReady(); break;
            case 'play': insymaVideo.vimeoOnPlay(data); break;
            case 'pause': insymaVideo.vimeoOnPause(data); break;
        }
    },
    postMessageVimeo: function (action, value) {
        var data = { method: action }, url;
        var $f = $('iframe[id^="iframe_movie_vimeo"]');
        if (value) { data.value = value; }
        $f.each(function (i, el) {
            url = $(el).attr('src').split('?')[0];
            el.contentWindow.postMessage(JSON.stringify(data), url);
        });
    },
    postSingleMessageVimeo: function (action, player_id) {
        var data = { method: action }, url;
        url = $("#" + player_id).attr('src').split('?')[0];
        $("#" + player_id).get(0).contentWindow.postMessage(JSON.stringify(data), url);
    },
    pauseAllVimeoVideos: function (player_id) {
        var data = { method: 'pause' };
        var $f = $('iframe[id^="iframe_movie_vimeo"]');
        $f.each(function (i, el) {
            if (player_id != $(el).attr("id")) {
                var url = $(el).attr('src').split('?')[0];
                el.contentWindow.postMessage(JSON.stringify(data), url);
            }
        });
    },
    vimeoOnReady: function () {
        insymaVideo.postMessageVimeo('addEventListener', 'play');
        insymaVideo.postMessageVimeo('addEventListener', 'pause');
        insymaVideo._isVimeoPaused = true;
    },
    vimeoOnPlay: function (data) {
        insymaVideo.pauseAllVimeoVideos(data.player_id);
        insymaVideo._isVimeoPaused = false;
    },
    vimeoOnPause: function (data) {
        insymaVideo._isVimeoPaused = true;
    },
    createVIMEOSplashscreen: function (vimeoId) {
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = "https://vimeo.com/api/v2/video/" + vimeoId + ".json?callback=insymaVideo.showVimeoSplashScreen";
        $("#vimeoimg-" + vimeoId).before(script);
    },
    showVimeoSplashScreen: function (data) {
        var id_img = "#vimeo-" + data[0].id;
        if ($("#vimeoimg-" + data[0].id).attr("src") == "") { //Set image if there is no custom image defined
            $("#vimeoimg-" + data[0].id).attr('src', data[0].thumbnail_large);
            $("#vimeoimg-" + data[0].id).closest("a").css('background-image', "url(" + data[0].thumbnail_large) + ");";
        }
    },
    //YOUTUBE
    initYoutubeVideos: function () {

        var content = $("body > .dataprivacy-info.movie");
        $(document.body).on("click", "*[data-movie-type='youtube']", function () {
            var $this = $(this);
            $.fancybox.open(content.clone());
            $(".fancybox-content .btnCancel").on("click", function(){
                $.fancybox.close();
            });
            $(".fancybox-content .btnAccept").on("click", function(){
                $.fancybox.close();
                insymaVideo.createYoutubeVideo($this);
                //Check if Youtbue API is needed
                if ($("iframe[id^='iframe_movie_youtube']").length > 0) {
                    var s = document.createElement("script");
                    s.src = "https://www.youtube.com/iframe_api"; /* Load Player API*/
                    var before = document.getElementsByTagName("script")[0];
                    before.parentNode.insertBefore(s, before);
                }
            });
            
        });
        
    },
    createYoutubeVideo: function (obj) {
        

        var movie_id = obj.data("movie-id");
        var width = obj.data("width");
        var height = obj.data("height");
        var href = obj.data("href");
        console.log(href)
        $.fancybox.open({
            //settings
            'type': 'iframe',
            'width': width,
            'height': height,
            'src': href
        });
    }
};

//jQuery Erweiterungen
//-> Flexslider Loader
$.fn.flexloader = function (flexslider) {
    var $this = $(this);
    $this.addClass("flexLoading");
    $(window).on("load", function () {
        $this.removeClass("flexLoading");
        flexslider();
    });
};
