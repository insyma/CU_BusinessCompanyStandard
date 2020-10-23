
var OverlayLoading = {};

(function () {

    this.Show = function (message) {
        var msg = (message == null) ? "" : message;

        $("body").append("<div class=\"overlay-loading\"></div>" +
                        "<div class=\"modal-loading \">" +
                        "<span class=\"icon-spinner spinner spinner-steps green \"></span>" +
                        "<p class=\"message-loading\">" + msg + "</p>" +
                        "</div>");
    };

    this.Hide = function () {
        $("div.overlay-loading").fadeOut(500).remove();
        $("div.modal-loading").fadeOut(500).remove();
    };
}).apply(OverlayLoading);

/*******************************************/
(function ($) {
    $.QueryString = (function(a) {
        if (a == "") return {};
        var b = {};
        for (var i = 0; i < a.length; ++i) {
            var p = a[i].split('=');
            if (p.length != 2) continue;
            b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
        }
        return b;
    })(window.location.search.substr(1).split('&'));
})(jQuery);