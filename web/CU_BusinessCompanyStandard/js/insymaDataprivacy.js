/**
 * @author MGUM
 * @copyright insyma AG
 * @projectDescription insyma Overlaybox for Dataprivacy
 * @version 1.1
 */
var insymaDataprivacy_Options = (function () {
    function insymaDataprivacy_Options() {
        this.opacity = 0.7;
        this.closeOnOverlay = true;
        this.width = 400;
        this.height = "auto";
        this.maxHeight = 600;
        this.maxWidth = 800;
        this.minHeight = 200;
        this.minWidth = 200;
        this.boxMarginTopBot = 50;
        this.boxMarginLeftRight = 20;
        this.resizeDelay = 10; //Determinates how often the Overlay is resized, when the window resizes
    }
    insymaDataprivacy_Options.prototype.addOptions = function (o) {
        for (var key in o) {
            this[key] = o[key];
        }
    }
    return insymaDataprivacy_Options;
})();

var insymaDataprivacy = (function () {
    //Constructor
    function insymaDataprivacy(o) {
        this.options = o;
        this.allContent = [];
        this.currentItem = 0;
        this.currentAlbum = "content";
        this.currentType = "content";
        this.callbackOnClose = [];
        this.isOpen = false;
        this.timeOut;
        this.init();
    }

    insymaDataprivacy.prototype.init = function () {
        this.buildObjects();
        this.initActions();
    }

    insymaDataprivacy.prototype.buildObjects = function () {
        $('<div>', { id: 'insymaDataprivacy' }).appendTo(document.body);
        $('<div>', { id: 'insymaDataprivacyHolder' }).append(
            $('<div>', { id: 'insymaDataprivacyInner' }).append(
                $('<div>', { id: 'insymaDataprivacyContent' }),
                $('<span>', { 'class': 'icon itemLB close' })
            )
        ).appendTo(document.body);
    }

    insymaDataprivacy.prototype.initActions = function () {
        var _this = this;
        var _o = $('#insymaDataprivacyInner');

        //Close overlay on shadow click
        if (this.options.closeOnOverlay) {
            $('#insymaDataprivacy, #insymaDataprivacyHolder').css('cursor', 'pointer').on('click', function (e) {
                if (e.target.id == "insymaDataprivacyHolder" || e.target.id == "insymaDataprivacy") {
                    _this.close();
                }
            });
        }

        _o.find('.close').on('click', function () {
            _this.close();
        });
    }

    insymaDataprivacy.prototype.confirm = function (settings, callbackConfirm, callbackDecline) {
        var __this = this;
        __this.openContent(settings);
        $(document.body).off("click", ".btnAccept");
        $(document.body).off("click", ".btnCancel");
        $(document.body).on("click", ".btnAccept", function () {
            if (typeof callbackConfirm === "function") {
                callbackConfirm();
            }
            __this.close();
        });
        $(document.body).on("click", ".btnCancel", function () {
            if (typeof callbackDecline === "function") {
                callbackDecline();
            }
            __this.close();
        });
    }

    insymaDataprivacy.prototype.openContent = function (options) {
        /* For individual Content
         * options.content -> URL or Selector
         * options.type -> iframe or content
         * options.w
         * options.h
         */
        var _this = this;
        var _holder = $("#insymaDataprivacyHolder");
        var _cont = $('#insymaDataprivacyContent');
        _cont.html("");

        if (options.class !== "") {
            _holder.addClass(options.class);
        }

        //Content
        _cont.html(options.content.show());
        var width = _this.options.width;
        var height = _this.options.height;

        if (typeof options === "object") {
            if (typeof options.w !== "undefined") {
                width = options.w;
            }
            if (typeof options.h !== "undefined") {
                height = options.h;
            }
        }
        _this.allContent[_this.currentAlbum] = [];
        _this.allContent[_this.currentAlbum].push({
            'type': _this.currentType,
            'height': height,
            'width': width
        });
        
        $(window).on("resize", function () {
            var tm;
            clearTimeout(tm);
            tm = setTimeout(function () {
                _this.resizeOverlybox();
                _this.resizeContainer();
            }, _this.options.resizeDelay);
        });
        _this.openOverlay();
        _this.open();
        _this.resizeContainer();
    }

    insymaDataprivacy.prototype.resizeOverlybox = function () {
        $('#insymaDataprivacy').width($(window).width()).height($('#insymaDataprivacy').height() - 100).height($(document).height());
    }

    insymaDataprivacy.prototype.resizeContainer = function () {
        //Enable Mobile View 
        if (this.options.mobileView) {
            var regExp = new RegExp(this.options.mobileFor, "i");
            if (regExp.test(navigator.userAgent)) {
                if (window.orientation != 0) {
                    return this.mobileView();
                } else {
                    $("#sSize").hide();
                }
            }
        }

        var _this = this;
        var _type = _this.allContent[_this.currentAlbum][_this.currentItem].type;
        var winH = $(window).height();
        var winW = $(window).width();
        var _holder = $("#insymaDataprivacyHolder");
        var _cont = $('#insymaDataprivacyContent');
        var _inner = $('#insymaDataprivacyInner');
        var _tCont = $("#insymaDataprivacyInner .textcont");

        var isContFloated = (_tCont.css("float") == "left" || _tCont.css("float") == "right") ? true : false;
        var titleH = _inner.find('.descspan').outerHeight(true);
        var pH = parseInt(_inner.css("padding-top")) + parseInt(_inner.css("padding-bottom")) + (!isContFloated && _tCont.is(":visible") ? _tCont.outerHeight(true) : 0);
        var pW = parseInt(_inner.css("padding-left")) + parseInt(_inner.css("padding-right")) + (isContFloated && _tCont.is(":visible") ? _tCont.outerWidth(true) : 0);

        //Calc
        var hPadAndT = titleH + pH;
        var wpW = winW - _this.options.boxMarginLeftRight - pW;
        var wpH = winH - _this.options.boxMarginTopBot - titleH - pH;

        _holder.removeClass("mobile");
        $("#iob-image").css({ "max-width": "" });

        _inner.css("max-width", _this.allContent[_this.currentAlbum][_this.currentItem].width);
        var contH = _this.allContent[_this.currentAlbum][_this.currentItem].height;
        if (parseInt(_this.allContent[_this.currentAlbum][_this.currentItem].height) > winH) {
            contH = wpH;
        }
        else {
            contH = _this.allContent[_this.currentAlbum][_this.currentItem].height
        }

        _cont.css("height", contH);
        _holder.css("margin-top", (_holder.outerHeight() / 2) * -1);
    }

    insymaDataprivacy.prototype.enableKeyboardNav = function () {
        var _this = this;
        $(document).on("keydown", function (e) {
            if (e.keyCode == 27) {
                _this.close();
            }
            e.preventDefault();
        });
    }

    insymaDataprivacy.prototype.disableKeyboardNav = function () {
        $(document).off("keydown");
    }

    insymaDataprivacy.prototype.openOverlay = function () {
        var _this = this;
        $('#insymaDataprivacy').addClass("show");
    }

    insymaDataprivacy.prototype.open = function () {
        var _this = this;
        _this.isOpen = true;
        $('#insymaDataprivacyHolder').addClass("show");
    }

    insymaDataprivacy.prototype.close = function () {
        var _this = this;
        var deferred = $.Deferred();

        $("#insymaDataprivacy").attr("class", "");
        $("#insymaDataprivacyContent").attr("class", "");
        $("#insymaDataprivacyHolder").attr("class", "").css("margin-top", "");
        $(this).hide();
        _this.isOpen = false;
        setTimeout(function () {
            deferred.resolve();
        }, 100);

        _this.disableKeyboardNav();
        $(window).off("resize", this.resizeOverlybox);
        $(window).off("resize", this.resizeContainer);

        //Callbacks
        for (var key in _this.callbackOnClose) {
            _this.callbackOnClose[key].call(this);
        }

        return deferred.promise();
    }

    insymaDataprivacy.prototype.onClose = function (callback) {
        if (callback && typeof callback == "function")
            this.callbackOnClose.push(callback);
    }

    return insymaDataprivacy;
})();

var Dataprivacy = null;
$(document).ready(function () {
    var options = new insymaDataprivacy_Options();
    Dataprivacy = new insymaDataprivacy(options);
});

