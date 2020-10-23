app.directive("paginator", function () {
    return {
        // Enforce the angularJS default of restricting the directive to
        // attributes only
        restrict: 'EA',
        replace: true,
        scope: {
            totalrecord: "=totalrecord",
            pagesize: "=pagesize",
            currentPage: "=currentpage",
            identifier: "@identifier"
        },
        templateUrl: APP_ROOT + "SurveyGeneral/Paginator",
        link: function (scope, element, attrs, ngModel) {
            var range = function (start, end) {
                var ret = [];
                if (!end) {
                    end = start;
                    start = 0;
                }
                for (var i = start; i < end; i++) {
                    ret.push(i);
                }
                return ret;
            };

            scope.pages = [];

            scope.$watch("totalrecord", function (newValue, OldValue, scope) {
                if (newValue >= 0) {
                    var totalpage = Math.ceil(newValue / scope.pagesize);
                    scope.pages = range(totalpage);
                }
            });

            scope.setPage = function (page) {
                if (this.currentPage != page) {
                    scope.$emit("pageIndexChanged", page);
                }
            }

            scope.firstPage = function () {
                if (this.currentPage != 0) {
                    scope.$emit("pageIndexChanged", 0);
                }
            }

            scope.prevPage = function () {
                if (this.currentPage > 0) {
                    scope.$emit("pageIndexChanged", this.currentPage - 1);
                }
            }

            scope.nextPage = function () {
                if (this.currentPage < this.pages.length - 1) {
                    scope.$emit("pageIndexChanged", this.currentPage + 1);
                }
            }

            scope.lastPage = function () {
                if (this.currentPage < this.pages.length - 1) {
                    scope.$emit("pageIndexChanged", this.pages.length - 1);
                }
            }
        }
    };
});