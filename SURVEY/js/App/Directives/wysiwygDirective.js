function wysiwygDirective($timeout) {
    return {
        // Enforce the angularJS default of restricting the directive to
        // attributes only
        restrict: 'EA',
        require: '?ngModel',
        replace: true,

        template: "<iframe />",
        link: function (scope, element, attrs, ngModel) {
            if (!ngModel) return;

            //element.load(function () {
            //    $(this).contents().find("iframe").load(function () {
            //        var headson = $(this).contents().find("head");
            //        headson.append($("<link/>", { rel: "stylesheet", href: APP_ROOT + "Content/site.css", type: "text/css" }));
            //    });
            //});

            ngModel.$render = function () {
                // Use the AngularJS internal 'binding-specific' variable

                element.load(function () {
                    if (ngModel.$viewValue) {
                        getIframeDocument(element[0]).settext(ngModel.$viewValue);
                    }
                });
            };
        }
    }
}