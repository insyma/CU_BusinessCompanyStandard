function downloadPDF() {
    var directDownload = true;

    var fileUrl = pdfDownloadURL + "?file=" +  pathTo + '.pdf';

    if(!directDownload) {
        var encryptedFileName = encryptedFileName || '';
        if(encryptedFileName != '')
            fileUrl = pdfDownloadURL + "?&isEncrypted=true&file=" +  encryptedFileName;

        if (docId != 0)
            fileUrl = "GetFile.ashx?obj=" + objFileId;
        window.location = fileUrl;
    } else {
		var fileUrl = pathTo + '.pdf';
		window.location = fileUrl;
		/*
        //Creating new link node.
    	var link = document.createElement('a');
    	link.href = fileUrl;
    	link.target="_blank";

    	//Dispatching click event.
    	if (document.createEvent) {
    		var e = document.createEvent('MouseEvents');
    		e.initEvent('click' ,true ,true);
    		link.dispatchEvent(e);
    		return true;
    	}
		*/
    }
}

var viewerConfig = {
    localeDirectory: 'js/viewer_lib/locale/',
    jsDirectory: 'js/viewer_lib/',

    Scale: 1,
    ZoomTransition: 'easeOut',
    ZoomTime: 0.5,
    ZoomInterval: 0.1,
    FitPageOnLoad: false,
    FitWidthOnLoad: false,
    AutoAdjustPrintSize: true,
    PrintPaperAsBitmap: false,
    FullScreenAsMaxWindow: false,
    ProgressiveLoading: false,
    MinZoomSize: 0.3,
    MaxZoomSize: 5,
    SearchMatchAll: true,
    InitViewMode: 'Zine',
    RenderingOrder: 'html5,flash',
    StartAtPage: 1,

    ViewModeToolsVisible: true,
    ZoomToolsVisible: true,
    NavToolsVisible: true,
    CursorToolsVisible: true,
    SearchToolsVisible: true,

    UIConfig: 'js/viewer_lib/UIConfig_Default-WithoutBoth.xml',
    noPrint: false,

    WMode: 'transparent',

    key: '@3d520b8c7466d1d0a44$2dff4055c28f2f576b6',

    localeChain: 'de_DE'
};

$(document).ready(function() {
    if( typeof(resourcePath.NoConficCheck)!='undefined' && resourcePath.NoConficCheck==true)  {
        loadFlexpaper(viewerConfig);
    } else {
        $.ajax({
            url: pdfConfigURL + '?objid=' + objFileId,
            contentType: "application/json; charset=utf-8",
            type: "POST",
            dataType: 'jsonp',
            crossDomain: true,

            success: loadFlexpaper,

            error: function(err){
                viewerConfig = $.extend(viewerConfig, resourcePath);
                $('#documentViewer').FlexPaperViewer( { config: viewerConfig } );
            }
        });
    }
});

function loadFlexpaper(data) {
    var buttonConfig = data;
    var uiconfig = "js/viewer_lib/UIConfig_Default";
    var noPrint = false;

    if(buttonConfig.download === '' && buttonConfig.print === '') {
        uiconfig += "-WithoutBoth";
        noPrint = true;
    } else if(buttonConfig.download === '1' && buttonConfig.print === '') {
        uiconfig += "-WithDownload";
        noPrint = true;
    } else if(buttonConfig.print === '1' && buttonConfig.download === '') {
        uiconfig += "-WithPrint";
        noPrint = false;
    }

    uiconfig += '.xml';

    viewerConfig = $.extend(viewerConfig, resourcePath);
    viewerConfig.UIConfig = uiconfig;
    viewerConfig.noPrint = noPrint;

    $('#documentViewer').FlexPaperViewer({ config: viewerConfig });
}