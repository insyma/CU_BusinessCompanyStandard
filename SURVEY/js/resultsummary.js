$(document).ready(function () {
    $('#pageThankyou,#pageThankyouNoFill,.wkButton,.counter').hide();
    $("input,textarea").prop("disabled", true);

    // https://plugins.jquery.com/autogrow/
    var optsAutoGrow = {
        animate: false
        , onInitialize: true
        , fixMinHeight: false
    };
    $('textarea').css("min-height","20px").autogrow(optsAutoGrow);

});
