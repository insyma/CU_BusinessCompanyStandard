var blogFilter = function () {
    return {
        //Setting for blogFilter
        filterSettings: {
            inputId: '',
            outputId: '',
            author: 'all',
            theme: [],
            tag: [],
            urlType: '',
            dateFrom: '',
            dateTo: '',
            language: '',
            pageIndex: 1,
            pageSize: 10,
            jsonUrl: ''
        },

        objectSearch: [],

        //init and filter, genrerate
        init: function (inputSettings) {
            //assign setting
            $.extend(this.filterSettings, inputSettings);

            //Get Object json
            var url = this.filterSettings.jsonUrl;
            this.objectSearch = this.getObjJson(url);

            //get object after filter
            var obj = this.filter(this.objectSearch);

            //generate object
            this.generateHtml(obj);

            this.checkShowNullMessage();
        },

        //Filter by lodash and return object result
        filter: function (objJS) {
            var object = [];

            //get filter object
            var filterCriteria = this.getFilterObj();

            //Filter with Criteria without date
            object = _.filter(objJS.Data, filterCriteria);

            //Filter with Date
            object = this.filterWithDate(object);

            //pagination
            object = this.pagination(object);

            return object;
        },

        //Filter with date input
        filterWithDate: function (object) {
            var tempObject = object;
            var dateFrom = this.filterSettings.dateFrom;
            var dateTo = this.filterSettings.dateTo;

            if ((typeof dateFrom != 'undefined' && dateFrom != '') || (typeof dateTo != 'undefined' && dateTo != '')) {
                tempObject = _.filter(object, function (data) {
                    if (blogFilter.checkInDateRange(data, dateFrom, dateTo)) {
                        return data;
                    }
                });
            }
            return tempObject;
        },

        //event Pagination
        pagination: function (object) {
            var pageIndex = parseInt(this.filterSettings.pageIndex) || 1;
            var pageSize = parseInt(this.filterSettings.pageSize);
            var offset = (pageIndex - 1) * pageSize;
            var paginatedItems = _.rest(object, offset).slice(0, pageSize);
            return paginatedItems;
        },

        //create filter object
        getFilterObj: function () {
            var newObj = {};
            //Author
            if (this.filterSettings.author != 'all') {
                newObj.a = this.filterSettings.author;
            }
            //Theme
            if (this.filterSettings.theme != '') {
                newObj.t1 = this.filterSettings.theme;
            }
            //Tag
            if (this.filterSettings.tag != '') {
                newObj.t2 = this.filterSettings.tag;
            }

            //Url type
            newObj.t = this.filterSettings.urlType;

            return newObj;
        },

        //check allow date when filter
        checkInDateRange: function (data, dateFrom, dateTo) {
            if (parseInt(data['d']) > 0) {
                if ((parseInt(dateFrom) <= parseInt(data['d'])) && (parseInt(data['d']) <= parseInt(dateTo))) {
                    return true;
                }
                else if (dateTo == '' && parseInt(dateFrom) <= parseInt(data['d'])) {
                    return true;
                } else if (dateFrom == '' && parseInt(data['d']) <= parseInt(dateTo)) {
                    return true;
                }
                else {
                    return false;
                }
            }

            return false;
        },

        //get Object Json (generate by data from DB)
        getObjJson: function (url) {
            var obj = {};
            $.ajax({
                type: "GET",
                url: url,
                async: false,
                dataType: "json",
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    obj = (typeof data !== "object") ? JSON.parse(data) : data;
                }, error: function () {
                    console.log('fail');
                }
            });

            return obj;

        },

        //Generate Html
        generateHtml: function (obj) {
            if (typeof this.filterSettings.outputId != 'undefined' && this.filterSettings.outputId != '') {
                for (var i = 0; i < obj.length; i++) {
                    if (typeof obj[i]['u'] != 'undefined' && obj[i]['u'] != '') {
                        this.getHtml(obj[i]['u']);
                    }
                }
            }
        },

        //get html by url html file
        getHtml: function (url, callback) {
            url = this.handleUrl(url);
            self = this;

            $.ajax({
                type: "GET",
                url: url,
                async: false,
                cache: false,
                dataType: "html",
                //contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    //callback(data, callback);
                    var elm = $(self.filterSettings.outputId);
                    elm.append($(data));
                }
            });
        },

        handleUrl: function (url) {
            var protocol = window.location.protocol;

            if (url.indexOf("http") < 0)
                url = protocol + "//" + url;

            return url;
        },

        checkShowNullMessage: function () {
            var elm = $(this.filterSettings.outputId);

            if ($.trim(elm.html()).length > 0) {
                $(this.filterSettings.outputId + '-Empty').addClass("hide");
            } else {
                $(this.filterSettings.outputId + '-Empty').removeClass("hide");
            }
        }
    };
};

//description object json BLog
/*
	{
		entryUrlId	=> eId
		blogEntryId	=> bId
		objPageId   => pId
		name		=> n
		author		=> a
		date		=> d
		theme		=> t1
		tag			=> t2		[array]
		language	=> la
		u 			=> url
		type		=> t
	}
*/
