function initBlurMandatory() {
    $('.mandatory').text(labels.mandatory);  

    $(".date-input").blur(function() {
        var spanMessage = $(this).closest(".element-li ").find(".mandatory-datetime");
        if ($(this).val() === "") {
            spanMessage.show();
        } else {
            spanMessage.hide();
        }
    });

    $('.input-text input[type=text]').blur(function() {
        var spanMessage = $(this).closest(".element-li ").find(".mandatory-textbox");
        if ($(this).val() === "") {
            spanMessage.show();
        } else {
            spanMessage.hide();
        }
    });
}

function validationMandatory() {
    var valid = true;

    $(".mandatory").each(function () {
        if($(this).hasClass('mandatory-menu-textbox')) {
            if ($(this).parent().children(".tagsinput ").children(".tagit-choice").length === 0) {
                valid = false;
                $(this).show();
            }
        } else if ($(this).hasClass('mandatory-datetime')) {
            if ($(this).parent().find(".date-input").val() === 0 || $(this).parent().find(".date-input").val() === '') {
                valid = false;
                $(this).show();
            }
        } else if( $(this).hasClass('mandatory-textbox') ) {
            if ($(this).parent().find("input[type=text]").val() === '') {
                valid = false;
                $(this).show();
            }
        }

        if(valid) {
            $(this).hide();
            valid = valid && true;
        }
    });

    return valid;
}
