// JavaScript Document

function insyma_tooltipp(param)
{
	var target = "#" + param.elem_id + " " + param.elem_child;
	$(target).hover(
		function () {
			$(param.tooltipp_elem).hide().html(""); 
			$(param.tooltipp_elem).html("<strong>" + $(this).attr("alt") + "</strong><br />" + $(this).attr("longdesc"));
			var pos = $(this).position();
			$(param.tooltipp_elem).css({'top' : pos.top-200 + 'px', 'left' : pos.left - 100 + 'px'}).fadeIn("slow");
			},
		function () {$(param.tooltipp_elem).hide().html("");}
	);
}


