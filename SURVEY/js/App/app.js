var app = angular.module('app', ['ngResource', 'angularTreeviewCheckbox', 'SurveyResources', '$strap.directives', 'ngSanitize']);
app.directive("datepicker", datepickerDirective);
app.directive("ngExpand", ngExpandDirective);
app.directive("wysiwyg", wysiwygDirective);
app.directive("fileupload", fileUploadDirective);

app.config(['$httpProvider', function ($httpProvider) {
    $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest';
} ]);

app.factory("config", function () {
    return { pageSize: 20 };
});