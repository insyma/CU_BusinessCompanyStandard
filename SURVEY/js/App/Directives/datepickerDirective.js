function datepickerDirective() {
    return {
        // Enforce the angularJS default of restricting the directive to
        // attributes only
        restrict: 'A',
        // Always use along with an ng-model
        require: '?ngModel',

        link: function (scope, element, attrs, ngModel) {
            if (!ngModel) return;
            var optionsObj = {};
            optionsObj.dateFormat = 'dd.mm.yy';
            var updateModel = function (dateTxt) {
                scope.$apply(function () {
                    // Call the internal AngularJS helper to
                    // update the two-way binding
                    var parts = dateTxt.split('.');
                    ngModel.$setViewValue(new Date(Date.UTC(parts[2], parts[1] - 1, parts[0])));
                });
            };
            optionsObj.onSelect = function (dateTxt, picker) {
                updateModel(dateTxt);
                if (scope.select) {
                    scope.$apply(function () {
                        scope.select({ date: dateTxt });
                    });
                }
            };
            ngModel.$render = function () {
                // Use the AngularJS internal 'binding-specific' variable
                if (ngModel.$viewValue) {
                    var ngdate = ngModel.$viewValue;
                    var arrdate = ngdate.split('T');
                    var strDate = arrdate[0].split('-');
                    var newDate = new Date(Date.UTC(strDate[0], strDate[1] - 1, strDate[2]));
                    
                    element.datepicker('setDate', newDate);
                }
                else {
                    element.datepicker('setDate', null);
                }
            };
            element.datepicker(optionsObj);
        }
    };
}

