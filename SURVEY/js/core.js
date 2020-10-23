$(document).off("click", ".expList h2");

$(document).on("click", ".expList h2", function (event) {
    var heightPart1;
    var heightPart2;

    if (this == event.target) {
        $(this).toggleClass('expanded');

        $(this).nextAll().toggle('medium', function () {
            // Animation complete.
            heightPart1 = $("#part1").height();
            heightPart2 = $("#part2").height();
            if (heightPart1 > heightPart2) {
                $("#part3").css('clear', 'both');

            }
            else {
                $("#part3").css('clear', 'none');

            }
        });
    }

    return false;
});


function prepareList() {
    $('.expList').find('h2').addClass('collapsed');
    //.nextUntil("#saveToolbar").hide();  
};
jQuery(document).ready(function ($) {
    prepareList();
    $(document).bind("ajaxSend", function () {
        $("body").append("<div class=\"overlay-loading\"></div>" +
            "<div class=\"modal-loading \">" +
            "<span class=\"icon-spinner spinner spinner-steps green \"></span><p>Loading...</p>" +
            "</div>");
    }).bind("ajaxComplete", function () {
        $("div.overlay-loading").remove();
        $("div.modal-loading").remove();

    });
    $(".inputHover").hover(
	function () {
	    $(this).parent().addClass("cu-hover");
	},
	function () {
	    $(this).parent().removeClass("cu-hover");
	}
  );


    /*
    $("#validityPeriodFrom, #validityPeriodTo").hover(
    function () {
    $("#validityPeriod").addClass("cu-hoverBackground");
    },
    function () {
    $("#validityPeriod").removeClass("cu-hoverBackground");
    }
    );
    */
    $(".child-header").hover(
	function () {
	    $($(this).attr('parent-header')).addClass("cu-hoverBackground");
	},
	function () {
	    $($(this).attr('parent-header')).removeClass("cu-hoverBackground");
	}
  );

    $(".inputHover").focus(function () {
        $(this).parent().addClass("cu-searchFocus");
    });

    $(".inputHover").blur(function () {
        $(this).parent().removeClass("cu-searchFocus");
    });

    $(".inputSearchImage").hover(function () {
        $(this).addClass("cu-searchImgSpanHoverHighlight");
        $(this).parent().addClass("cu-searchHover");
    },
  function () {
      $(this).removeClass("cu-searchImgSpanHoverHighlight");
      $(this).parent().removeClass("cu-searchHover");
  });


    $("#RichText_inplacerte").focus(function () {
        $(this).css("outline", "none");
    });
});