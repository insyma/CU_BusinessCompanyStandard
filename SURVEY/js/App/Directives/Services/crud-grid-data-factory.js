app.factory('crudGridDataFactory', ['$http', '$resource', function ($http, $resource) {
    return function (type, langid, currentPage, itemsPerPage, sortDirection, sortBy, where) {
        var params = { id: '@id' };
        
        if (langid != undefined) {
            params.language = langid;
        }
        
        if (currentPage != undefined) { params.currentPage = currentPage; }
        if (itemsPerPage != undefined) params.itemsPerPage = itemsPerPage;
        if (sortDirection != undefined) params.sortDirection = sortDirection;
        if (sortBy != undefined) params.sortBy = sortBy;
        if (where != undefined) params.where = where;
        
        //if (type == 'producttype') {
        //    return $resource('../api/specificationtype/:id',
        //            params,
        //            { 'update': { method: 'PUT' } },
        //            { 'query': { method: 'GET', isArray: false } }
        //        );
        //}
        
        return $resource(APP_ROOT + 'api/' + type + '/:id',
                    params,
                    { 'update': { method: 'PUT' } },
                    { 'query': { method: 'GET', isArray: false } }
                );
    };
}]);