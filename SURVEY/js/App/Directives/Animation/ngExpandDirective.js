function ngExpandDirective($timeout) {
    return {
        // Enforce the angularJS default of restricting the directive to
        // attributes only
        restrict: 'A',

        link: function (scope, element, attrs) {
            scope.$watch(attrs.isExpanded, function (newValue, oldValue) {
                if (typeof newValue == "undefined") {
                    element.children().hide();
                }
                else {
                    if (newValue) {
                        element.children().show('medium');
                    }
                    else {
                        element.children().hide('medium');
                    }
                }
            });
        }
    };
}