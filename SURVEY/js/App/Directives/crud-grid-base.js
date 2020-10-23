app.directive('crudGridBase', function () {
    return {
        controller: ['$scope', '$filter', function ($scope, $filter) {
            // init
            $scope.sortingOrder = 'Id';
            $scope.reverse = true;
            $scope.filter = null;

            $scope.itemsPerPage = 5;
            $scope.currentPage = 1;

            $scope.range = function (start, end) {
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

            $scope.setData = function (data) {

                if (data == undefined && ($scope.items == null || $scope.items == undefined)) {
                    return;
                }

                $scope.items = data;

                var totalfloor = 0;
                if (data.length > 0) {
                    var total = data[0].TotalRow / $scope.itemsPerPage;
                    totalfloor = Math.floor(total);
                    if (total > totalfloor)
                        totalfloor = totalfloor + 1;
                }

                $scope.totalPages = totalfloor;
            };

            $scope.setPage = function () {

                if ($scope.currentPage == this.n + 1)
                    return;

                $scope.currentPage = this.n + 1;
                $scope.getData(null);
            };

            $scope.prevPage = function () {

                if ($scope.currentPage > 0) {
                    $scope.currentPage--;
                }

                $scope.getData();
            };

            $scope.nextPage = function () {

                if ($scope.currentPage < $scope.totalPages) {
                    $scope.currentPage++;
                }

                $scope.getData();
            };

            $scope.firstPage = function () {
                if ($scope.currentPage > 1) {
                    $scope.currentPage = 1;
                }

                $scope.getData();
            };

            $scope.lastPage = function () {
                console.log($scope.totalPages);

                if ($scope.currentPage < $scope.totalPages) {
                    $scope.currentPage = $scope.totalPages;
                }
                console.log($scope.currentPage);

                $scope.getData();
            };

            // functions have been describe process the data for display

            // change sorting order
            $scope.sort_by = function (newSortingOrder) {
                if ($scope.sortingOrder == '') {
                    $scope.sortingOrder = newSortingOrder;
                }

                if ($scope.sortingOrder == newSortingOrder) {
                    $scope.reverse = !$scope.reverse;
                }

                $scope.sortingOrder = newSortingOrder;

                $('th span.tablesort').each(function () {
                    // icon reset
                    $(this).removeClass('sortasc').removeClass('sortdesc');
                });

                if ($scope.reverse)
                    $('th.' + newSortingOrder + ' span').addClass('sortdesc');
                else
                    $('th.' + newSortingOrder + ' span').addClass('sortasc');

                $scope.getData();
            };

            $scope.isFilter = false;
            $scope.sign = "+";

            $scope.toggleFilter = function () {
                //console.log($scope.isFilter);
                $scope.isFilter = !$scope.isFilter;
                $scope.sign = ($scope.isFilter) ? "-" : "+";

                if ($scope.isFilter == false) {
                    $scope.query = undefined;
                    $scope.getData();
                }
            };

            $scope.search = function () {
                $scope.getData();
            };
        } ]
    };
});