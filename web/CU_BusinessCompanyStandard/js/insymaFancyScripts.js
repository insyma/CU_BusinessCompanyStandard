"use strict"

$(document).ready(function () {

});
var insymaFancyScripts = {
    _createGalleryWithExternalMovies: function (position, aElem) {
    	
    	var li = $("div[data-id='" + aElem + "']").find("a");
    	li.each(function(i){
    		$(this).attr("data-fancybox", "gallery0" + position);
    		$(this).attr("id", "gallery0" + position + "_" + i);
    	})
    	li.fancybox({
    		beforeShow: function( instance, slide ) {
    			//console.log(instance);
    			//console.log($.fancybox.getInstance());
    			var obj = $("#" + slide.opts.$orig.attr("id"));
				if(obj.hasClass("movielink"))
				{
					var content = $("body > .dataprivacy-info.movie");
					var instance01 = $.fancybox.open(content.clone());
		            $(".fancybox-content .btnCancel").on("click", function(){
		               instance01.close();
		               instance.next( 0 );
		                return false;
		            });
		            $(".fancybox-content .btnAccept").on("click", function(){
		                instance01.close();
		                var movie_id = obj.data("movie-id");
				        var width = obj.data("movie-width");
				        var height = obj.data("movie-height");
				        var href = obj.data("href");
				        var htm = "<iframe src='" + href + "' width='" + width+ "px' height='" + height+ "px'></iframe>";
				        instance.setContent(slide, htm);
				        $(".fancybox-content").css({"height":height+ "px", "width":width+ "px"});
				        return true;
		            });
				}
    		},
    		loop : true
    	});
    }
}