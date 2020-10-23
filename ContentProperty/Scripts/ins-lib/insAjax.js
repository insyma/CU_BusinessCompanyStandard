
var InsAjax = {};

(function () {

    //context: object will passed return to callback function to keep data.                 
    this.Get = function (url, successCallback, errorCallback, async, waitingText, context) {
        
        if (async == null)
            async = false;

        $.ajax({
            type: 'GET',
            url: url,
            contentType: 'application/json; charset=utf-8',
            async: async,
            //displayLoading: true,
            //messageLoading: waitingText,
            dataType: 'json',
            success: function (data) {                
                if (typeof (successCallback) == "function")
                    successCallback(data, context);
            },
            error: function (xhr, status, error) {
                var err = {
                    Xhr: xhr,
                    Status: status,
                    Error: error
                };

                if (typeof (errorCallback) == "function")
                    errorCallback(err, context);
            }
        });
    };

    this.Post = function (url, dataPost, successCallback, errorCallback, async, waitingText, context) {
        if (async == null)
            async = false;
        
        $.ajax({
            type: 'POST',
            url: url,
            data: JSON.stringify(dataPost),
            contentType: 'application/json; charset=utf-8',
            async: async,
            dataType: 'json',
            //displayLoading: true,
            //messageLoading: waitingText,
            success: function (data) {
                if (typeof (successCallback) == "function")
                    successCallback(data, context);
            },
            error: function (xhr, status, error) {
                var err = {
                    Xhr: xhr,
                    Status: status,
                    Error: error
                };

                if (typeof (errorCallback) == "function")
                    errorCallback(err, context);
            }
        });
    };

}).apply(InsAjax);