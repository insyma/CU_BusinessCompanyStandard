$(document).ready(function () {

});

var insymaContentlist = {
	_loadContentList: function (aParams) {
        var langpath = "";
        if (aParams.LangPath == "")
            langpath = "deu/"
        else
            langpath = aParams.LangPath;
        if(aParams.Preview == "True")
            langpath = "../" + langpath;
        else
            langpath = aParams.LivePath + langpath;

        var json = insymaContentlist._getData(langpath + "contentlist.json");

        var html = "";

        if (typeof json.Data == "undefined") return false;

        for (var i = 0; i < json.Data.length; i++) {

            var object = json.Data[i];
            var vis0 = false;
            var vis1 = false;
            var vis2 = false;
            var vis3 = false;
            var vis4 = false;
            var vis5 = false;
            if (object.Types == "")
                vis0 = true;
            else if (object.Types.indexOf(aParams.Types) > -1 || aParams.Types == "")
                vis0 = true;
            if (object.Tags == "")
                vis1 = true;
            else if (object.Tags.indexOf(aParams.Tags) > -1 || aParams.Tags == "")
                vis1 = true;
            if (object.Themes == "")
                vis2 = true;
            else if (object.Themes.indexOf(aParams.Themes) > -1 || aParams.Themes == "")
                vis2 = true;
            if (object.Origin == "")
                vis4 = true;
            else if (object.Origin.indexOf(aParams.Origin) > -1 || aParams.Origin == "")
                vis4 = true;
            
            vis5 = true;
            

            if (object.Types == "News") {
                $now = new Date();
                if (object.DateValidTo != "") {

                    var arr_at = new Array();
                    arr_at = object.DateValidTo.split(".");
                    $d = new Date(arr_at[2], parseInt(arr_at[1]) - 1, arr_at[0]);

                    if (aParams.Archive == "" && $now < $d) {
                        vis3 = true;
                    }
                    if (aParams.Archive != "" && $now > $d)
                        vis3 = true;
                }
                else if (object.Types == "News" && aParams.Archive == "") {
                    vis3 = true;
                }
            }
            
            var sortvalue = ""; //nach was sortieren?(DateContent, DateValidTo, DateValidFrom, DateAppointmentFrom, DateAppointmentTo)
            var sortorder = ""; //Richtung(ASC, DESC)
            var sorting = "";   //Wert
            if(aParams.Sorting != "")
            {
                if(aParams.Sorting.indexOf(" ") > -1)
                {
                    sortvalue = aParams.Sorting.split(" ")[0];
                    sortorder = aParams.Sorting.split(" ")[1];
                }
                var arr_sort = new Array();
                if(object[sortvalue] != "")
                {
                    arr_sort = object[sortvalue].split(".");
                    var mon = parseInt(arr_sort[1]) - 1;
                    if(mon < 10)
                        mon = "0" + mon;
                    sorting = arr_sort[2] + "-" + mon + "-" + arr_sort[0];
                }
                else
                {
                    sorting = "9999-99-99"; // wird bei Datum(yyyy-dd-MM) die nächste Zeit das hoechste sein
                }
            }
            
            //console.log(object.title + "::::" + vis0 + "&&" + vis1 + "&&" + vis2 + "&&" + vis3 + "&&" + vis4 + "&&" + vis5)
            var art = "div";
            var css = "card card-linked"
            
            if (vis0 == true && vis1 == true && vis2 == true && vis3 == true && vis4 == true && vis5 == true) {
                var uri = object.URL_Live_Snippet;
                if(aParams.Preview == "True")
                    uri = object.URL_Prev_Snippet;

                $.ajax({
                    type: "GET",
                    url: uri,
                    async: false,
                    dataType: "text",
                    contentType: 'application/text; charset=utf-8',
                    success: function (data) {
                        html += "<" + art + " class='" + css + "' data-val='" + sorting + "'>" + data + "</" + art + ">";
                    }, error: function () {
                        console.log('fail Include');
                    }
                });
            }
        }
        $("." + aParams.elem + " .ConListEntries").html(html);
        
        $("." + aParams.elem + " .ConListEntries .content-property-empty").each(function(){
            $(this).parent().parent().remove();
        })
        
        insymaContentlist._setContentListSorting(aParams, sortorder);
        insymaContentlist._setContentListNumbers(aParams);


    },
    _setContentListSorting: function(aParams, sortorder)
    {
        var el = $("." + aParams.elem);
        var lis = el.find("div.ConListEntries").children();
        lis.tsort({ attr: 'data-val', order: sortorder});
    },
    _setContentListNumbers: function(aParams)
    {
        if(aParams.PageSize != "0" && aParams.PageSize != "")
        {
            var el = $("." + aParams.elem);
            var lis = el.find("div.ConListEntries").children();
            lis.each(function(i){
                if(i >= parseInt(aParams.PageSize))
                    $(this).hide();
            })
        }
    },
    _setContentListLogic: function (aParams) {
        
        if (typeof hideDom !== 'undefined') {
            hideDom.hideList('div.pageContentList', '.ConListEntries', 'li[data-obj-id]');
        }
        $(".PartEvents .iconmore").click(function () {
            $(this).hide().next().show();
            $(this).parent().next().show();
        });
        $(".PartEvents .iconless").click(function () {
            $(this).hide().prev().show();
            $(this).parent().next().hide();
        });

        var el = $("." + aParams.elem);
        var lis = el.find("ul.ConListEntries").children();
        if (aParams.archive != "")
            $("div.pager").prev("a").hide();
        var imgpath = ""
        if(document.URL.indexOf("test.contentupdate.net") > -1)
        {
            imgpath = "/Gebaeudetechnik_BLAG"
        }
        if (el.children("ul").hasClass("list-news") || el.children("ul").hasClass("list-jobs")) 
        {
            lis.each(function (i) {
                $this = $(this);
                var dt = $this.find(".con-time").attr("datetime");
                if (typeof (dt) != "undefined")
                    $this.attr("data-time", dt.replace(/-/g, ""));
                else
                    $this.attr("data-time", "00000000");
                var img = $this.find("figure").eq(0);
                var _img = img.css("background-image");
                if(typeof(_img) != "undefined")
                {
                    img.css("background-image", _img.replace("https://test.contentupdate.net", imgpath));
                }
            });
            if (aParams.archive == "") {
                lis.tsort({ attr: 'data-time', order: 'desc' });
            }
            else {
                lis.tsort({ attr: 'data-time', order: 'asc' });
                el.find("button").hide();
            }
        }
        else if(el.find("div.cards-con-news").length > 0 || el.find("div.cards-con-jobs").length > 0)
        {
            lis = el.find("div.ConListEntries").children();
            lis.each(function (i) {
                $this = $(this);
                var dt = $this.find(".con-time").attr("datetime");
                /*if (typeof (dt) != "undefined")
                    dt = dt.split(".").reverse().join("");*/
                if (typeof (dt) != "undefined")
                    $this.attr("data-time", dt.replace(/-/g, ""));
                else
                    $this.attr("data-time", "00000000");
                //$this.attr("data-loc", $this.find(".Item-Location").text());
                //$this.attr("data-reg", $this.find(".Item-Title").children("small").text());
            });
            if (aParams.archive == "") {
                lis.tsort({ attr: 'data-time', order: 'desc' });
            }
            else {
                lis.tsort({ attr: 'data-time', order: 'asc' });
                el.find("button").hide();
            }
        }
        
        if (aParams.backv != "" && el.children("div").hasClass("EventsKalender") == false) {
            lis.each(function () {
                var htm = "<span class='Item-Action'>";
                if ($(this).children("div.ItemGallery").length > 0)
                    htm += "<a class='icon icon-gallery' href='" + $(this).attr("data-link") + "' title=''></a>";

                htm += "<a class='icon icon-detailpage' href='" + $(this).attr("data-link") + "' title=''></a></span>";
                $(this).find(".iconmore").hide();
                $(htm).insertAfter($(this).find(".iconless").html(htm));
            });
        }
        if (aParams.count != "") {
            // insymaScripts._setContentListPaging(aParams,el, lis)
        }
        $(".ConAnmeldung").click(function () {
            $div = $('<div>');
            var _id = $(this).attr("data-id");
            var _mail = $(this).attr("data-mail");
            $this = $(this).parents("li").eq(0);
            $div.load($(this).attr("data-uri"), function () {
                var options = {
                    type: 'content',
                    class: 'content',
                    content: $($div),
                    w: '800px',
                    h: 'auto'
                };
                $("div#insymaOverlayContent").html("");
                Iob.openOverlay();
                Iob.openContent(options);
                $("html, body").animate({ scrollTop: 100 }, "slow");
                $textarea = $("#insymaOverlayContent").find("textarea").eq(0);
                var htm = $this.find(".Item-Time").text() + "\n";
                htm += $this.find(".Item-Title > small").text().replace("<br>", "\n") + "\n";
                htm += $this.find(".Item-Title > span").text().replace("<br>", "\n") + "\n";
                $textarea.val(htm);
                htm = "<input type='hidden' name='SaveToList' value='" + _id + "' />";
                htm += "<input type='hidden' name='Recipient' value='" + insymaUtil.decodeMail(_mail.replace(/__/g, ".").replace(/--/g, "@")).replace("_L", "") + "' />";
                $(htm).insertBefore("#Message");
                $("select, input").not(".noUniform").uniform();
            });
        });
        var span = $("div.ConListSorting > span");
        $("div.ConListSorting > span.Item-Time").click(function () {
            lis.tsort({ attr: 'data-time' });
            span.removeClass("active");
            $(this).addClass("active");
        });
        $("div.ConListSorting > span.Item-Location").click(function () {
            lis.tsort({ attr: 'data-loc' });
            span.removeClass("active");
            $(this).addClass("active");
        });
        $("div.ConListSorting > span.Item-Title").click(function () {
            lis.tsort({ attr: 'data-reg' });
            span.removeClass("active");
            $(this).addClass("active");
        });

        Iob.grabStuff();

        $(".icon-gallery").on("click", function (e) {
            $(this).closest(".Item-Header").nextAll(".ItemGallery").find(".imagelink:first").click();
            e.preventDefault();
            return false;
        });
    },

    _setContentListPaging: function (aParams, el, lis) {
        var c = parseInt(aParams.count);
        var ul = el.find("ul.ConListEntries");
        lis.each(function (i) {
            if (i >= c && c != 0)
                $(this).hide();
            $(this).attr("data-count", Math.ceil((i + 1) / c))
        });
        var anz = lis.length;
        var erg = Math.ceil(anz / c);
        if (anz > c) {
            var htm = "";
            for (var i = 1; i <= erg; i++) {
                var css = "";
                if (i == 1)
                    css = "current";
                htm += "<a class='" + css + "' href='Javascript:void(0)' data-page='" + i + "'>" + i + "</a>"
                if (i < erg)
                    htm += "<span> | </span>";
            }
            el.find(".pagecount").html(htm);
            insymaScripts._displayPrevs(1, erg, el)
            var span = $("span.pagecount > a");
            span.click(function () {
                $this = $(this);
                if ($this.hasClass("current") == false) {
                    span.removeClass("current");
                    $(this).addClass("current");
                    ul.children().hide();
                    ul.children("li[data-count='" + $this.attr("data-page") + "']").show();
                    insymaScripts._displayPrevs(parseInt($this.attr("data-page")), erg, el)
                    insymaScripts._displayNexts(parseInt($this.attr("data-page")), erg, el)
                }
            });
            el.find(".pager").children("a").click(function () {
                insymaScripts._switchPaging($(this), erg, span, ul, el);
            });
        }
        else {
            $(".pager").hide();
        }

    },
    _switchPaging: function (aEl, aMax, aSpan, ul, el) {
        var curr = parseInt($(".current").attr("data-page"));
        if (aEl.hasClass("first")) {
            curr = 1;
        }
        if (aEl.hasClass("prev")) {
            if (curr > 1)
                curr = curr - 1;
        }
        if (aEl.hasClass("next")) {
            if (curr < aMax)
                curr = curr + 1;
        }
        if (aEl.hasClass("last")) {
            curr = aMax;
        }
        aSpan.removeClass("current");
        $("span.pagecount").children("a[data-page='" + curr + "']").addClass("current");
        ul.children().hide();
        ul.children("li[data-count='" + curr + "']").show();
        insymaScripts._displayPrevs(parseInt(curr), aMax, el);
        insymaScripts._displayNexts(parseInt(curr), aMax, el);
    },
    _displayPrevs: function (aId, aMax, aEl) {
        if (aId == 1) {
            aEl.find(".icon-fast_rewind").hide();
            aEl.find(".icon-skip_previous").hide();
        }
        else {
            aEl.find(".icon-fast_rewind").show();
            aEl.find(".icon-skip_previous").show();
        }
    },
    _displayNexts: function (aId, aMax, aEl) {
        if (aId == aMax) {
            aEl.find(".icon-fast_forward").hide();
            aEl.find(".icon-skip_next").hide();
        }
        else {
            aEl.find(".icon-fast_forward").show();
            aEl.find(".icon-skip_next").show();
        }
    },
    _getData: function (aURI) {

        var obj = {};
        $.ajax({
            type: "GET",
            url: aURI,
            async: false,
            dataType: "json",
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
                obj = (typeof data !== "object") ? JSON.parse(data) : data;
            }, error: function () {
                console.log('fail PJSON');
            }
        });

        return obj;

    }

}