app.factory('notificationFactory', function () {
    return {
        success: function () {
            //toastr.success("Success");
            console.log("Success");
        },
        error: function (text) {
            //toastr.error(text, "Error");
            console.log("Error: " + text);
        }
    };
});