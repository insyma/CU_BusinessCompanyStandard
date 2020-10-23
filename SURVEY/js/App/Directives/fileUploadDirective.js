function fileUploadDirective() {
    return {
        restrict: 'A',
        scope: {
            done: '&',
            progress: '&'
        },
        link: function (scope, element, attrs) {

            var optionsObj = {
                dataType: 'json',
                replaceFileInput: false,
                autoUpload: false
            };

            if (attrs.done) {
                optionsObj.done = function () {
                    scope.$apply(function () {
                        scope.done({ e: e, data: data });
                    });
                };
            };

            if (attrs.progress) {
                optionsObj.progress = function (e, data) {
                    scope.$apply(function () {
                        scope.progress({ e: e, data: data });
                    });
                }
            };

            optionsObj.add = function (e, data) {
                if (!(eval(attrs.filetypes)).test(data.files[0].name)) {
                    alert("You can only select an image");
                    element.val("");
                }
                else {
                    element[0].fileData = data;
                }
            };

            element.fileupload(optionsObj);
        }
    };
}