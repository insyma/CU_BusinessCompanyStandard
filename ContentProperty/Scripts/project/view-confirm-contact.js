var viewConfirmContact = {
    config: {
        partClass: '',
        rootUrl: '',
        pageIndex: 0,
        pageSize: 10,
        objId: 0,
        urlPath: "",
        clientId: 0,
        languageId: 0
    },

    init: function (inputConfig) {
        $.extend(viewConfirmContact.config, inputConfig);
        viewConfirmContact.regEvent();

        //viewConfirmContact.load();
    },

    regEvent: function() {
        var $rootElm = $(viewConfirmContact.config.partClass);

        $('#btnShowMoreVCContact', $rootElm).click(function() {
            viewConfirmContact.config.pageIndex = parseInt(viewConfirmContact.config.pageIndex) + 1;
            viewConfirmContact.load();
        });

        $('.part-header', $rootElm).off("click").on("click", function () {
            var $partContent = $('.part-content', $rootElm);
            
            var $action = $('.part-action', $rootElm);
            if ($partContent.is(":visible"))
                $action.show();
            else
                $action.hide();

            if ($partContent.find("ul[data-contact-id]").length === 0)
                viewConfirmContact.load();
        });

        $('.icon-refresh', $rootElm).off("click").on("click", function () {
            viewConfirmContact.syncUserAccess($rootElm);
        });
    },

    syncUserAccess: function ($rootElm) {
        var url = viewConfirmContact.config.urlPath + 'Tool/Sync.ashx?action=SyncUserAccess&objId=' + viewConfirmContact.config.objId;
        $.ajax({
            type: 'GET',            
            url: url,
            contentType: 'application/json; charset=utf-8',
            cache: false,
            async: false,
            messageLoading: "",
            displayLoading: true
        }).done(function (result) {
            if (result === "true" || result === true) {
                $('#ul-view-confirm-contact', $rootElm).find("ul[data-contact-id]").remove();
                viewConfirmContact.config.pageIndex = 0;
                viewConfirmContact.load();
            }
        }).fail(function () {
            console.log('syncUserAccess fail');
        });
    },

    load: function() {
        var dataPost = viewConfirmContact.handling.generateDataPost();
        var url = viewConfirmContact.config.rootUrl + 'Home/ViewConfirmResult';

        $.ajax({
            type: 'POST',
            data: JSON.stringify(dataPost),
            url: url,
            contentType: 'application/json; charset=utf-8',
            cache: false,
            async: false
        }).done(function (result) {

            if (typeof result !== 'undefined' && result !== '') {
                var $rootElm = $(viewConfirmContact.config.partClass);

                var $list = $('#ul-view-confirm-contact', $rootElm);
                $list.append(result);

                //Check show-more
                var hasNext = viewConfirmContact.handling.checkHasNext($list);
                if (hasNext)
                    $('#btnShowMoreVCContact', $rootElm).show();
                else {
                    $('#btnShowMoreVCContact', $rootElm).hide();
                }
		ContentProperty.SetContentHeight();
            }
            
        }).fail(function () {
            console.log('Get from action fail');
        });
    },

    handling: {
        generateDataPost : function() {
            return obj = {
                ObjId: viewConfirmContact.config.objId,
                ClientId: viewConfirmContact.config.clientId,
                LanguageId: viewConfirmContact.config.languageId,
                PageIndex : viewConfirmContact.config.pageIndex,
                PageSize: viewConfirmContact.config.pageSize
            };
        },
        checkHasNext: function($elmSelector) {
            var pageIndex = parseInt(viewConfirmContact.config.pageIndex);
            var pageSize = parseInt(viewConfirmContact.config.pageSize);
            var total = $elmSelector.find('ul').siblings().last().data('total');

            if (typeof total === "undefined" || total === "") return false;
            
            if (((pageIndex + 1) * pageSize) < parseInt(total))
                return true;

            return false;
        }
    }

};