/**
 * @author MGUM
 * @copyright insyma AG
 * @projectDescription insyma Overlaybox
 * @version 1.2
 */
var Iob_Options = (function() {
    function Iob_Options() {
        this.loadingImg = '../img/layout/loading.gif';
        this.opacity = .3;
        this.playDuration = 2000; // 2sec
        this.closeOnOverlay = true;
        this.maxHeight = 600;
        this.maxWidth = 800;
        this.minHeight = 200;
        this.minWidth = 200;
        this.boxMarginTopBot = 50;
        this.boxMarginLeftRight = 20;
        this.resizeDelay = 10; //Determinates how often the Overlay is resized, when the window resizes
        this.showCounter = true;
        this.mobileView = true;
        this.mobileFor = "iPhone|Android"; //Android|webOS|iPhone|iPad|iPod|BlackBerry
        this.container = ".insymaNewThumbs, .insymaImgListThumbs, .insymaNewProdThumbs, .part_movie, .insymaImgThumbs";
        this.selects = {
            img     :   ["a.imagelink","a.imagelinks"], 
            movie   :   ["a.movielink"],
            content :   []
        };
    }
    Iob_Options.prototype.addOptions = function(o) {
        for(var key in o){
            this[key] = o[key];
        }
    }
    return Iob_Options;
})();
    
var insymaOverlaybox = (function() {
    //Konstruktor
    function insymaOverlaybox(o) {
        this.options = o;
        this.allContent = [];
        this.currentItem = 0;
        this.currentAlbum = 0;
        this.currentType = "";
        this.callbackOnClose = [];
        this.imgSize = [];
        this.isPlaying = false;

        this.timeOut;
        this.init();
    }

    insymaOverlaybox.prototype.init = function() {
        this.grabStuff();
        this.buildObjects();
        this.initActions();
    }
    
    insymaOverlaybox.prototype.grabStuff = function() {
        //Init and grab all Stuff
        var _this = this;
        var $album = $(_this.options.container);
        var _search = _this.options.selects;
        var _movies = "";
        var _links = "";

        for(a=0; a<$album.length; a++){
            _links = $($album[a]).find(_search.img.join(","));
            _movies = $($album[a]).find(_search.movie.join(","));
            _this.allContent[a] = [];

            //Get Images
            for(i=0; i<_links.length; i++){
                $link = $(_links[i]);
                $link.attr({"id": "il_"+a+"_"+i, "data-id":i, "data-album":a});
                _this.allContent[a].push({
                    'type' : 'img',
                    'src': $link.attr('href'),
                    'title':((typeof $link.attr("title") == "undefined" || $link.attr("title")=="") ? $link.find('img').attr('alt') : $link.attr("title"))
                });
            }
            //Get Movies
            for(i=0; i<_movies.length; i++){
                $movie = $(_movies[i]);
                $movie.attr({ "data-id":i, "data-album":a});
                _this.allContent[a].push({
                    'type' : 'movie',
                    //'src': $movie.attr('href'), 
                    'title':$movie.attr("title"),
                    'content': $("#overlayMovie_"+$movie.attr("data-content-id")).find("div.movie-holder")
                });
            }
        }

        $(document.body).on('click', _this.options.selects.img.concat(_this.options.selects.movie).toString(), function(e) {
            _this.start($(e.currentTarget));
            return false;
        });
    }
    
    insymaOverlaybox.prototype.buildObjects = function() {
        $('<div>',{ id : 'insymaOverlay'}).append('<span id="insymaOverlayLoading" style="display:;"><img src="'+this.options.loadingImg+'" /></span>').hide().appendTo(document.body);                
        $('<div>',{ id : 'insymaOverlayHolder'}).hide().append(
            $('<div>',{ id : 'insymaOverlayInner'}).append(
                $('<div>',{ id : 'insymaOverlayContent'}),
				$('<ol>',{'class' : 'LB'}),
                $('<span>',{'class' : 'icon LB close', 'title' : this.options.labelClose}),
                $('<span>',{'class' : 'icon LB prev', 'title' : this.options.labelPrev}),
                $('<span>',{'class' : 'icon LB next', 'title' : this.options.labelNext}),
                $('<span>',{'class' : 'icon LB play', 'title' : this.options.labelPlay}),
                $('<span>',{'class' : 'icon LB stop', 'title' : this.options.labelStop}),
                $('<div>',{'class' : 'LB textcont'}).hide(),
                $('<span>',{'class' : 'LB countspan'}),
                $('<span>',{'class' : 'LB descspan'}).hide(),
                $('</ol>')
            )
        ).appendTo(document.body);
    }
    
    insymaOverlaybox.prototype.initActions = function() {
        var _this = this;
        var _o = $('#insymaOverlayInner');
        if(this.options.closeOnOverlay) {
            $('#insymaOverlay, #insymaOverlayHolder').css('cursor','pointer').on('click', function(e){
                if(e.target.id == "insymaOverlayHolder" || e.target.id == "insymaOverlay"){
                    _this.close();
                }
            });
        }

        _o.find('.close').on('click', function(){
            _this.close();
        });
        _o.find('.prev').on('click', function(){
            _this.stopAll();
            _this.currentItem--;
            _this.checkCurrentImg(_this.currentItem);
            _this.showImg();
        });
        _o.find('.next').on('click', function(){
            _this.stopAll();
            _this.currentItem++;
            _this.checkCurrentImg(_this.currentItem);
            _this.showImg();
        });
        _o.find('.play').on('click', function(){
            _this.playAll();
        });
        _o.find('.stop').hide().on('click', function(){
            _this.stopAll();
        });
    }
    
    insymaOverlaybox.prototype.start = function($obj) {
        var _this = this;
        _this.currentItem = parseInt($($obj).attr("data-id"));
        _this.currentAlbum = $($obj).attr("data-album");
        _this.currentType = _this.allContent[_this.currentAlbum][_this.currentItem].type;
        _this.enableKeyboardNav();
        _this.openOverlay(); 
        switch(_this.currentType){
            case 'img' : _this.showImg(); break;
            case 'movie' : _this.showMovie(); break;
        }
        $(window).on("resize", function(){
            var tm;
            clearTimeout(tm);
            tm = setTimeout(function(){
                _this.resizeOverlybox();
                _this.resizeContainer();
            }, _this.options.resizeDelay);
        });
    }
    
    insymaOverlaybox.prototype.showMovie = function() {
        var _this = this;
        var _cont = $('#insymaOverlayContent');
        _cont.html(_this.allContent[_this.currentAlbum][_this.currentItem].content);
        _this.open();
        _this.setNavigation();
        _this.resizeContainer();
        _this.setTitle();
    }
    
    insymaOverlaybox.prototype.showImg = function() {
        var _this = this, $img, src = _this.allContent[_this.currentAlbum][_this.currentItem].src;
        var _cont = $('#insymaOverlayContent');

        _cont.html("");
        if($("#iob-image").length < 1){
            $img = $("<img id='iob-image' />").appendTo(_cont);
        }
        else $img = $("#iob-image");

        if(_this.allContent[_this.currentAlbum][_this.currentItem].content !== ""){
            $("#insymaOverlayInner .textcont").html(_this.allContent[_this.currentAlbum][_this.currentItem].content).show();
        }else{
            $("#insymaOverlayInner .textcont").html("").hide();
        }
        var loader = new Image;
        loader.onload = function() {
            _this.imgSize = {
                w: loader.width, 
                h: loader.height
            };
            $img.attr('src', src);
            _this.open();
            return _this.resizeContainer();
        };
        loader.src = src;
        _this.setNavigation();
        _this.preloadNext();
        _this.setTitle();
    }
    
    insymaOverlaybox.prototype.openContent = function(options) {
    /* For individual Content
     * options.content -> URL or Selector
     * options.type -> iframe or content
     * options.w
     * options.h
     */
        var _this = this;
        var _cont = $('#insymaOverlayContent');
            _cont.html("");
            _cont.removeClass("content").removeClass("iframe");
        if(options.type === "iframe"){
            _this.currentAlbum = "iframe";
            _this.currentItem = 0;
            _this.currentType = "iframe";
            _cont.addClass("iframe");
            _cont.html('<div class="iframe-holder"><iframe width="700" scrolling="auto" height="600" frameborder="0" src="'+options.content+'" /><div class="ratio" style="padding-top:84.57%"></div></div>');
            _this.allContent[_this.currentAlbum] = [];
            _this.allContent[_this.currentAlbum].push({
                'type' : _this.currentType
            });
        }
        if(options.type === "content"){
            _this.currentAlbum = "content";
            _this.currentItem = 0;
            _this.currentType = "content";
            _cont.addClass("content");
            _cont.append(options.content.show());
            var width = _this.maxWidth;
            var height = _this.maxHeight;
            if(typeof options === "object"){
                if(typeof options.w !== undefined){
                    width = options.w;
                }
                if(typeof options.h !== undefined){
                    height = options.h;
                }
            }
            _this.allContent[_this.currentAlbum] = [];
            _this.allContent[_this.currentAlbum].push({
                'type' : _this.currentType,
                'height' : height,
                'width' : width
            });
        }
        $(window).on("resize", function(){
            var tm;
            clearTimeout(tm);
            tm = setTimeout(function(){
                _this.resizeOverlybox();
                _this.resizeContainer();
            }, _this.options.resizeDelay);
        });
        _this.open();
        _this.setNavigation();
        _this.resizeContainer();
        _this.setTitle();
    }
    
    insymaOverlaybox.prototype.resizeOverlybox = function() {
        $('#insymaOverlay').width($(window).width()).height($('#insymaOverlay').height()-100).height($(document).height());
    }
    
    insymaOverlaybox.prototype.mobileView = function() {
        //Special View for Landscape on Mobile Devices
        //Still in BETA
        var _this = this, wpHM, _holder = $("#insymaOverlayHolder"), _cont = $('#insymaOverlayContent'), _inner = $('#insymaOverlayInner'), _tCont = $("#insymaOverlayInner .textcont"), titleH = _inner.find('.descspan').outerHeight(true);
        var isContFloated = (_tCont.css("float")=="left" || _tCont.css("float")=="right") ? true : false;
        var pH = _inner.outerHeight(true) - _inner.height() + (!isContFloated && _tCont.is(":visible") ? _tCont.outerHeight(true) : 0);
        var pW = (_inner.outerWidth(true) - _inner.width()) + (isContFloated && _tCont.is(":visible") ? _tCont.outerWidth(true) : 0);

        _holder.css({"margin-top":""});
        _inner.css({"max-width":""});
        _cont.css({"height":""});
        $("#iob-image").css({"width":""});

        if(window.orientation == 0){
            wpHM = window.innerHeight - titleH - pH - 20;
            wpWM = window.innerWidth - pW - 20;
            _cont.find("img").css("max-width", _inner.width())
        }
        else{
            wpHM = window.innerHeight - titleH - pH - 10;
            wpWM = window.innerWidth - pW - 20;
        }

        _holder.addClass("mobile");
        _cont.css({"max-height":wpHM});
        _tCont.appendTo(_cont);

        if($("#sTop").length < 1)
            _cont.append("<div id='sTop' class='shadow-top'></div>")
        if($("#sBot").length < 1)
            _cont.append("<div id='sBot' class='shadow-bot'></div>")
        if($("#sSize").length < 1){
            _inner.append("<span id='sSize' class='icon resize'></span>")
            $("#sSize").click(function(){
                if($(this).hasClass("resize")){
                    if(window.orientation == 0){
                        _cont.find("img").css("max-width", _cont.width())
                        if(_cont.find("img").width() < _cont.find("img").height())
                             _cont.find("img").css("max-height", _cont.height())
                    }
                    else{
                        _cont.find("img").css("max-height", _cont.height())
                    }
                    $("#sTop, #sBot").hide();
                    $(this).removeClass("resize").addClass("size");
                }else{
                    _cont.find("img").css("max-width", _inner.width())
                    _cont.find("img").css("max-height", "none")
                    $("#sBot").show()  ;
                    $(this).removeClass("size").addClass("resize");  
                }
            });
        }else{
            $("#sSize").show()
        }

        //if(_cont.scrollHeight > 0){
        if(_this.imgSize.h > parseInt(_cont.css("max-height"))){
            $("#sTop").width(_inner.width()).css("top", parseInt(_cont.position().top)+5).hide();
            $("#sBot").width(_inner.width()).css("top", parseInt(wpHM + parseInt(_cont.position().top))-1);
        }else{
            $("#sTop").fadeOut();
            $("#sBot").fadeOut()
        }
        _cont.scroll(function(e){
            if(e.target.scrollTop == 0) $("#sTop").hide();
            if(e.target.scrollTop > 0 && e.target.scrollTop < e.target.scrollHeight - e.target.offsetHeight){
                $("#sTop").fadeIn();
                $("#sBot").fadeIn();
            }
            if(e.target.scrollTop == e.target.scrollHeight - e.target.offsetHeight) $("#sBot").hide();
        })
        return false;
    }
    
    insymaOverlaybox.prototype.resizeContainer = function() {
        //Enable Mobile View 
        if(this.options.mobileView){
            var regExp = new RegExp(this.options.mobileFor,"i");
            if( regExp.test(navigator.userAgent) ) {
                if(window.orientation != 0){
                    return this.mobileView();  
                }
            }
        }

        var _this = this;
        var _type = _this.allContent[_this.currentAlbum][_this.currentItem].type;
        var winH = $(window).height();
        var winW = $(window).width();
        var _holder = $("#insymaOverlayHolder");
        var _cont = $('#insymaOverlayContent');
        var _inner = $('#insymaOverlayInner');
        var _tCont = $("#insymaOverlayInner .textcont");

        var isContFloated = (_tCont.css("float")=="left" || _tCont.css("float")=="right") ? true : false;
        var titleH = _inner.find('.descspan').outerHeight(true);
        var pH = parseInt(_inner.css("padding-top")) +  parseInt(_inner.css("padding-bottom")) + (!isContFloated && _tCont.is(":visible") ? _tCont.outerHeight(true) : 0);
        var pW = parseInt(_inner.css("padding-left")) +  parseInt(_inner.css("padding-right")) + (isContFloated && _tCont.is(":visible") ? _tCont.outerWidth(true) : 0);

        //Calc
        var hPadAndT = titleH + pH;
        var wpW = winW - _this.options.boxMarginLeftRight - pW;
        var wpH = winH - _this.options.boxMarginTopBot - titleH - pH;
        var nw = ((_this.imgSize.w * wpH) / _this.imgSize.h);
        var nh = (_this.imgSize.h * wpW) / _this.imgSize.w;

        _holder.removeClass("mobile");
        $("#iob-image").css({"max-width":""});
         $("#sBot, #sTop, #sSize").hide();


        if(_type == 'movie'){
            var vidWidth = _cont.find("iframe").length > 0 ? parseInt(_cont.find("iframe").attr("width")) : parseInt(_cont.find("object").attr("width"));
            _inner.css("max-width", vidWidth);
            _cont.css("height","auto");
        }
        else if(_type == 'content'){
            _inner.css("max-width", _this.allContent[_this.currentAlbum][_this.currentItem].width);
            var contH = _this.allContent[_this.currentAlbum][_this.currentItem].height;
            if(parseInt(_this.allContent[_this.currentAlbum][_this.currentItem].height) > winH){
                contH = wpH;
            }
            else {
                contH = _this.allContent[_this.currentAlbum][_this.currentItem].height
            }

            _cont.css("height",contH);
        }
        else{
            _cont.css("max-width","100%");
            if(_this.imgSize.h > _this.imgSize.w){
                //Portrait 
                if(_this.imgSize.h + hPadAndT + _this.options.boxMarginTopBot > winH){ 
                    _cont.css("height",wpH);
                    _inner.css("max-width", nw + pW);
                    if(nw + pW + _this.options.boxMarginLeftRight > winW){
                        _cont.css("height",nh);
                        _inner.css("max-width", wpW);
                    }
                }else{
                    _cont.css("height",_this.imgSize.h);
                    _inner.css("max-width", _this.imgSize.w + pW);
                    if(_this.imgSize.w + pW + _this.options.boxMarginLeftRight > winW){
                        _cont.css("height",nh);
                        _inner.css("max-width", wpW);
                    }
                }
            } else if(_this.imgSize.h === _this.imgSize.w){
                //Quadrat
                if(_this.imgSize.w + pW + _this.options.boxMarginLeftRight > winW){ 
                    _cont.css("height", wpW);
                    _inner.css("max-width", wpW + pW);
                }
                if(_this.imgSize.h + hPadAndT + _this.options.boxMarginTopBot  < winH){
                    if(_this.imgSize.w < winW){ 
                        _cont.css("height",_this.imgSize.h);
                        _cont.css("max-width",_this.imgSize.w);
                        _inner.css("max-width", _this.imgSize.h + pW);
                    }
                } else {
                    _cont.css("height","auto");
                    _inner.css("max-width", nw + pW);
                }
            }
            else{
                //Landscape
                if(_this.imgSize.h + hPadAndT + _this.options.boxMarginTopBot > winH){
                    if(nh + hPadAndT + _this.options.boxMarginTopBot > winH){
                        _cont.css("height", wpH);
                        _inner.css("max-width", nw + pW);
                    }else{
                        _inner.css("max-width", wpW + pW);
                        _cont.css("height", nh);
                    }
                }else{
                    _cont.css("height", _this.imgSize.h);
                    _inner.css("max-width", wpW)
                    if(_this.imgSize.w + pW + _this.options.boxMarginLeftRight < winW){ 
                        _inner.css("max-width", _this.imgSize.w + pW)
                    }else{
                        _inner.css("max-width", wpW + pW);
                        _cont.css("height", nh);
                    }
                }
            }
            //Ausrichten
            $("#iob-image").width(_this.imgSize.w);
        }
        _holder.css("margin-top", (_holder.outerHeight()/2)*-1);
    }
    
    insymaOverlaybox.prototype.setTitle = function() {
        var _this = this, text = _this.allContent[_this.currentAlbum][_this.currentItem].title, _titel = $('#insymaOverlayInner').find('.descspan');
        (text !== "" && typeof text !== "undefined") ? _titel.html(_this.allContent[_this.currentAlbum][_this.currentItem].title).show() : _titel.hide();
    }
    
    insymaOverlaybox.prototype.setCounter = function() {
        if(this.options.showCounter){
            var _this = this, _counter = $('#insymaOverlayInner').find('.countspan');
            _counter.show();
            _counter.html(_this.options.labelImage+" "+ (_this.currentItem+1) +" "+_this.options.labelFrom+" "+(_this.allContent[_this.currentAlbum].length));
        }
    }
    
    insymaOverlaybox.prototype.setNavigation = function() {
        var _this = this;
        var _inner = $('#insymaOverlayInner');
        if(_this.allContent[_this.currentAlbum].length == 1){ 
            _inner.find('.prev, .next, .play, .stop, .countspan').hide();
        }else{
            _this.setCounter();
            _inner.find('.prev, .next').show();
            if(_this.isPlaying) {
                _inner.find('.play').hide();
                _inner.find('.stop').show();
            } else{
                _inner.find('.play').show();
                _inner.find('.stop').hide();
            }
        }
    }
    
    insymaOverlaybox.prototype.playAll = function() {
        var _this = this;
        _this.isPlaying = true;
        _this.setNavigation();

        _this.timeOut = setTimeout(function(){
            if(_this.currentItem >= _this.allContent[_this.currentAlbum].length-1){ _this.currentItem = -1 }
            _this.currentItem++;
            _this.showImg();
            _this.playAll();
        }, _this.options.playDuration);

    }
    
    insymaOverlaybox.prototype.stopAll = function() {
        var _this = this;
        _this.isPlaying = false;
        if(_this.timeOut) clearTimeout(_this.timeOut);
        _this.setNavigation();
    }
    
    insymaOverlaybox.prototype.preloadNext = function() {
        var _this = this, pn, pv;
        if (_this.currentItem < _this.allContent[_this.currentAlbum].length-1) {
            pn = new Image;
            pn.src = _this.allContent[_this.currentAlbum][_this.currentItem + 1].src;
        }
        if (_this.currentItem > 0) {
            pv = new Image;
            pv.src = _this.allContent[_this.currentAlbum][_this.currentItem - 1].src;
        }
    }
    
    insymaOverlaybox.prototype.checkCurrentImg = function(i) {
        var _this = this;
        if(i>_this.allContent[_this.currentAlbum].length-1){
            _this.currentItem = 0;
        }else if(i<0){
            _this.currentItem = _this.allContent[_this.currentAlbum].length-1;
        }else{
            _this.currentItem = i;
        }
    }
    
    insymaOverlaybox.prototype.enableKeyboardNav = function() {
        var _this = this;
        $(document).on("keydown", function(e){
            if(e.keyCode == 39 && _this.allContent[_this.currentAlbum].length > 1){
                _this.stopAll();
                _this.currentItem++;
                _this.checkCurrentImg(_this.currentItem);
                _this.showImg();
            }
            if(e.keyCode == 37 && _this.allContent[_this.currentAlbum].length > 1){
                _this.stopAll();
                _this.currentItem--;
                _this.checkCurrentImg(_this.currentItem);
                _this.showImg();
            }
            if(e.keyCode == 27){
                _this.stopAll();
                _this.close();
            }
            if(e.keyCode == 32 && _this.allContent[_this.currentAlbum].length > 1){
                if(_this.isPlaying){
                    _this.stopAll();
                } else {
                    _this.playAll();
                }
                return false;   
            }
            if(e.keyCode == 32 && _this.currentType == "movie"){
                // Play, pause videos with space
                var $iframe = $("#insymaOverlayContent").find("iframe");
                if($iframe.length > 0){
                    var id = $iframe.attr("id");
                    if($iframe.hasClass("youtube")){
                        (players[id].getPlayerState() == -1 || players[id].getPlayerState() == 2) ? players[id].playVideo() : players[id].pauseVideo();
                    }
                    if($iframe.hasClass("vimeo")){
                        insymaVideo._isVimeoPaused ? insymaVideo.postSingleMessageVimeo("play", id) : insymaVideo.postSingleMessageVimeo("pause", id);
                    }
                }else{
                    //Flash
                }
            }
            e.preventDefault();
        });
    }
    
    insymaOverlaybox.prototype.disableKeyboardNav = function() {
        $(document).off("keydown");
    }
    
    insymaOverlaybox.prototype.openOverlay = function() {
        var _this = this;
         $('#insymaOverlayLoading').show();
         $('#insymaOverlay').width($(document).width()).height($(document).height()).show().animate({'opacity':_this.options.opacity}, 600);
    }
    
    insymaOverlaybox.prototype.open = function() {
        var _this = this;
        $('#insymaOverlayLoading').hide();
        $('#insymaOverlayHolder').show().animate({
            'opacity':1
        }, 600);
    }
    
    insymaOverlaybox.prototype.close = function() {
        var _this = this;
        _this.stopAll();
        $('#insymaOverlay, #insymaOverlayHolder').animate({
            'opacity':0
        }, 600, function(){
            $(this).hide()
        });
        _this.disableKeyboardNav();
        $(window).off("resize", this.resizeOverlybox);
        $(window).off("resize", this.resizeContainer);

        //Callbacks
        for(var key in _this.callbackOnClose){
            _this.callbackOnClose[key].call(this);
        }
    }
    
    insymaOverlaybox.prototype.onClose = function(callback) {
        if(callback && typeof callback == "function")
            this.callbackOnClose.push(callback);
    }

    return insymaOverlaybox;
})();
    
   


// Extend jQuery for custom [show/hide] with class
jQuery.fn.cShow = function() {
    var o = $(this[0]); 
    o.addClass("iob-show").removeClass("iob-hide");
};
jQuery.fn.cHide = function() {
    var o = $(this[0]);
    o.addClass("iob-hide").removeClass("iob-show");
};