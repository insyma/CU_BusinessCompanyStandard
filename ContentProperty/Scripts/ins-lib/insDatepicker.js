
function InsDatepicker(newOptions) {
    var _this = this;

    this.Options = $.extend(true, {
        dateFormat: "dd.mm.yy",
        altFormat: "dd.mm.yy"
    }, newOptions);

    this.InitDatepickerByBrowserRegion = function (cssDateSelector, cssTimeSelector) {
        var arrLangKey = ["de", "fr", "it", "", "es"];
        var cssDate = $.trim(cssDateSelector);
        var cssTime = (cssTimeSelector != null) ? $.trim(cssTimeSelector) : ""; 
        var currentLangId = 0;

        if (cssDate.indexOf(".") < 0)
            cssDate = "." + cssDate;
        
        if (cssTime != "" && cssTime.indexOf(".") < 0)
            cssTime = "." + cssTime;

        var $selector = $(cssDate);

        if ($selector != null) {
            $selector.datepicker("destroy");

            var userLang = navigator.language || navigator.userLanguage;
            userLang = (userLang != null && userLang != "") ? userLang.substring(0, 2) : arrLangKey[currentLangId];
            userLang = (userLang == "en") ? "" : userLang;
            $selector.datepicker($.datepicker.regional[userLang]);

            if (userLang == "de") {
                _this.Options.dateFormat = "dd.mm.yy";
                _this.Options.altFormat = "dd.mm.yy";
            } else {
                _this.Options.dateFormat = "dd/mm/yy";
                _this.Options.altFormat = "dd/mm/yy";
            }

            $selector.datepicker("option", _this.Options);

            //setDate
            $selector.each(function () {
                setIsoDatepicker($(this));
            });

            if (cssTime != null && cssTime != "") {
                $selector.datepicker('option',
                    'onSelect',
                    function(d, i) {

                        if (d !== i.lastVal) {
                            var day = new Date(),
                                h = (day.getHours() < 10 ? '0' : '') + day.getHours(),
                                m = (day.getMinutes() < 10 ? '0' : '') + day.getMinutes();

                            $(this).parent().parent(".date-div").next().find(cssTime).val(h + " : " + m);

                            $selector.change();
                        }
                    });
            } else {
                $selector.datepicker('option',
                    'onSelect',
                    function (d, i) {
                        if (d !== i.lastVal) {
                            $selector.change();
                        }
                    });
            }

            $(".icon-datepicker ").click(function () {
                $(this).prev(cssDate).datepicker().focus();
            });                        
        }
    };
    
    function setIsoDatepicker($datepicker) {
        if ($datepicker != null && $datepicker.length > 0) {
            var isoDate = $datepicker.data("value").split("-");

            if (isoDate != null && isoDate.length > 2) {
                var year = $.isNumeric(isoDate[0]) ? parseInt(isoDate[0]) : 0;
                var month = $.isNumeric(isoDate[1]) ? parseInt(isoDate[1]) : 0;
                var day = $.isNumeric(isoDate[2]) ? parseInt(isoDate[2]) : 0;

                if (year > 0 && month > 0 && day > 0) {
                    var date = new Date(year, month - 1, day);
                    $datepicker.datepicker("setDate", date);
                }
            }

            $datepicker.removeAttr("data-value");
        }
    }
}