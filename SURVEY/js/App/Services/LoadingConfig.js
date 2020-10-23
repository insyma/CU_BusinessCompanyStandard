app.config(function ($httpProvider) {

    $httpProvider.responseInterceptors.push(function ($q) {
        return function (promise) {
            return promise.then(function (response) {
                // Do nothing
                $(".overlay-loading, .modal-loading").fadeOut(1500);
                return response;
            }, function (response) {
                $(".overlay-loading, .modal-loading").hide();

                if (response.status == 401) {
                    window.top.location.reload(true);
                } else {
                    DisplayLoadPanel("");
                    DisplayErrorPanel(response.data.ExceptionMessage);
                }

                return $q.reject(response);
            });
        };
    });

    $httpProvider.defaults.transformRequest.push(function (data, headersGetter) {
        $(".overlay-loading, .modal-loading").show();
        return data;
    });

    $httpProvider.defaults.transformResponse.unshift(function (data) {
        if (data == "null") {
            return null;
        }

        return data;
    });

    function HideLoaderWithTimeout() {
        $(".overlay-loading, .modal-loading").hide();
    }
})