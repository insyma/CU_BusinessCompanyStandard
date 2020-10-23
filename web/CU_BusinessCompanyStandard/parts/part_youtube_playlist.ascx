<%@ Control Language="VB" Inherits="Insyma.ContentUpdate.CUControl" %>
<script runat="server">
	
</script>

<script src="../js/moment-with-locales.min.js"></script>
<script src="https://apis.google.com/js/platform.js"></script>

<div class="part part-youtube-playlist">
    <script type="text/javascript">
        var ytPlayerList = {};
        var request = [];
    </script>
    <CU:CUObjectSet Name="part_youtube_playlist_list" runat="server">
        <ItemTemplate>
            <CU:CUField Name="part_youtube_playlist_title" runat="server" Tag="h3"  tagclass="h3 item-title" />
            <div id='YT_player_<CU:CUField name="part_youtube_playlist_id" runat="server" />' class="yt_player"></div>
            <div id='YT_channel_<CU:CUField name="part_youtube_playlist_id" runat="server" />' class="flexslider yt_playlist"></div>

            <script type="text/javascript">
                ytPlayerList['<CU:CUField name="part_youtube_playlist_id" runat="server" />'] = {
                    id: '<CU:CUField name="part_youtube_playlist_id" runat="server" />',
                    ConId: '<%# DataBinder.Eval(Container.DataItem, "id") %>',
                    loadFirst: '<CU:CUField name="part_youtube_playlist_firstvid" runat="server" />',
                    max: '<CU:CUField name="part_youtube_playlist_maxitems" runat="server" />',
                    loadMore: '<CU:CUField name="part_youtube_playlist_loadmore" runat="server" />',
                    loadMoreTxt: '<CU:CUField name="part_youtube_playlist_labelloadmore" runat="server" />'
                };
            </script>
        </ItemTemplate>
    </CU:CUObjectSet>

    <script type="text/javascript">
        var resizeTimeout;
        $(window).on("resize", function () {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(function () {
                $(".flexslider").each(function () {
                    $(this).resize();   
                });
            }, 100);
        });

        function init() {
            gapi.client.setApiKey('AIzaSyD-y_hlP5VnG87XxHvQHxcs_bsbmN0gDYo');
            gapi.client.load('youtube', 'v3').then(makeRequest);
        }
        function makeRequest() {
            for (key in ytPlayerList) {
                if (ytPlayerList.hasOwnProperty(key)) {
                    request[key] = gapi.client.youtube.playlistItems.list({
                        part: 'contentDetails, snippet',
                        playlistId: key,
                        maxResults: ytPlayerList[key].max == "" ? 15 : ytPlayerList[key].max
                    });
                    request[key].then(function (response) {
                        var resp = response;
                        var vid_ids = [];
                        for (var i = 0; i < resp.result.items.length; i++) {
                            vid_ids.push(resp.result.items[i].contentDetails.videoId);
                        }
                        var requestData = gapi.client.youtube.videos.list({
                            part: 'snippet, contentDetails, statistics',
                            id: vid_ids.join(",")
                        });

                        requestData.then(function (response) {
                            var res = response.result.items;
                            var PL_id = resp.result.items[0].snippet.playlistId;
                            //check for settings to load first item as video
                            if (res.length > 0 && ytPlayerList[PL_id].loadFirst != "") {
                                drawVideoPlayer(res[0].id, PL_id, false);
                            }
                            appendResults(resp.result, res, PL_id);
                        }, function (reason) {
                            console.log('Error: ' + reason.result.error.message);
                        });
                    });
                }
            }
        }

        function requestVideoPlaylist(playlistId, pageToken) {
            var request = gapi.client.youtube.playlistItems.list({
                part: 'contentDetails, snippet',
                playlistId: playlistId,
                maxResults: ytPlayerList[playlistId].max == "" ? 15 : ytPlayerList[playlistId].max,
                pageToken: pageToken
            });
            request.then(function (response) {
                var resp = response;
                var vid_ids = [];
                for (var i = 0; i < resp.result.items.length; i++) {
                    vid_ids.push(resp.result.items[i].contentDetails.videoId);
                }
                var requestData = gapi.client.youtube.videos.list({
                    part: 'snippet, contentDetails, statistics',
                    id: vid_ids.join(",")
                });

                requestData.then(function (response) {
                    var res = response.result.items;
                    var PL_id = resp.result.items[0].snippet.playlistId;
                    loadMoreResults(resp.result, res, PL_id);
                }, function (reason) {
                    console.log('Error: ' + reason.result.error.message);
                });
            });
        }

        function appendResults(res, data, identifier) {
            var $base = $("#YT_channel_" + identifier);
            var html = "<ul class='slides'>";
            for (i = 0; i < data.length; i++) {
                html += getVideoItem(data[i], identifier);
            }
            html += getLoadMoreLink(res, identifier);
            html += "</ul>";

            //Append and init flexslider
            $base.append(html);
            $base.flexslider({
                animation: "slide",
                animationLoop: false,
                slideshow: false,
                itemWidth: 130,
                itemMargin: 10,
                controlNav: false,
                directionNav: true,
                prevText: "",
                nextText: "",
                added: function (slider) {
                    slider.count = slider.find('.slides li').length;
                    $("#YT_channel_" + identifier).resize();
                    slider.flexAnimate(slider.currentSlide)
                }
            });
        }

        function loadMoreResults(res, data, identifier) {
            var $base = $("#YT_channel_" + identifier);
            var html = '';
            for (i = 0; i < data.length; i++) {
                html = getVideoItem(data[i], identifier);
                //Add every slide! Maybe bad performance, but flexslider works that way
                $base.data("flexslider").addSlide($(html));
            }
            html = getLoadMoreLink(res, identifier);
            $base.data("flexslider").addSlide($(html));
        }

        function getVideoItem(data, identifier) {
            var html = '';
            //Some time settings
            moment.locale("de");
            var dur = moment.duration(data.contentDetails.duration).asMilliseconds();
            //Build content
            html += "<li>";
            html += "<a href=\"javascript:drawVideoPlayer('" + data.id + "', '" + identifier + "', true);\">";
            html += "<div class='YT_img' id='movielink_" + data.id + "' data-movie='" + data.id + "' data-content-id='" + data.id + "'>";
            html += "<img src='https://img.youtube.com/vi/" + data.id + "/mqdefault.jpg' alt='' />";
            html += "<span class='duration'>" + moment.utc(dur).format("HH:mm:ss") + "</span>";
            html += "</div>";
            html += "<p class='title'>" + data.snippet.title + "</p>";
            html += "</a>";
            html += "<p class='channelTitle'>von " + data.snippet.channelTitle + "</p>";
            html += "<p class='viewCount'>" + data.statistics.viewCount + " Aufrufe</p>";
            html += "<p class='timeSince'>" + moment(data.snippet.publishedAt, "YYYYMMDD").fromNow() + "</p>";
            html += "</li>";

            return html;
        }

        function getLoadMoreLink(res, identifier) {
            //.lastVideo class marks where the last slide was
            var $base = $("#YT_channel_" + identifier);
            $base.find(".lastVideo").removeClass("lastVideo");
            $base.find(".loadMore").prev("li").addClass("lastVideo");
            $base.find(".loadMore").remove();

            //Check if there is more content to load and if enabled in settings
            if (res.nextPageToken != undefined && ytPlayerList[identifier].loadMore != "") {
                return "<li class='loadMore'><a href=\"javascript:requestVideoPlaylist('" + identifier + "', '" + res.nextPageToken + "');\">" + ytPlayerList[identifier].loadMoreTxt + "</a></li>";
            } else {
                return "";
            }
        }
        //Draw palyer and insert into DOM
        function drawVideoPlayer(id, identifier, scrollToTop) {
            var html = "";
            html += "<div id='overlayMovie_" + id + "' class='overlayMovie'>";
            html += "<div class='movie-holder'>";
            html += "<iframe id='iframe_movie_youtube_" + id + "' class='youtube' title='YouTube' width='600' height='400' src='https://www.youtube.com/embed/" + id + "?enablejsapi=1&rel=0' frameborder='0' allowfullscreen></iframe>";
            html += "<div class='ratio' style='padding-top:66.6666666666667%'></div>";
            html += "</div>";
            html += "</div>";
            $("#YT_player_" + identifier).html(html);
            if (scrollToTop) {
                $('html, body').animate({ scrollTop: $("#YT_player_" + identifier).offset().top }, 'slow');
            }
        }
        function getYTDuration(duration) {
            var arr = duration.match(/(\d+)(?=[MHS])/ig) || [];
            var res = arr.map(function (item) {
                if (item.length < 2) return '0' + item;
                return item;
            }).join(':');
            return res;
        }
    </script>
    <script src="https://apis.google.com/js/client.js?onload=init"></script>
</div>
