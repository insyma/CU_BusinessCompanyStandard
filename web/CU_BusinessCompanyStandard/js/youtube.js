//Video Stuff
var players = {};

//Check if Youtbue API is needed
var s = document.createElement("script");
s.src = "https://www.youtube.com/iframe_api"; /* Load Player API*/
var before = document.getElementsByTagName("script")[0];
before.parentNode.insertBefore(s, before);

//YOUTUBE API STUFF
function onYouTubeIframeAPIReady() {
    $("iframe[id^='iframe_movie_youtube']").each(function (el, i) {
        //Save the player referenz globaly
        var playerId = $(this).attr("id");
        players[playerId] = new YT.Player(playerId, {
            events: {
                'onStateChange': onPlayerStateChange,
                'onReady': onPlayerReady
            }
        });
    });
}

//YT STATES 
//BUFFERING, CUED, ENDED, PAUSED, PLAYING, UNSTARTED
function onPlayerStateChange(event) {
    var t = event.target, player = players[t.getIframe().id],
        label = t.getVideoData().title + " - ID:" + t.getVideoData().video_id;

    if (event.data == YT.PlayerState.PLAYING) {
        pushDataLayer({
            'event': 'youtube',
            'label': label,
            'action': 'play'
        });

        //save 
        player["interval"] = setInterval(function () {
            var time = t.getDuration() - t.getCurrentTime() <= 1.5 ? 1 : (Math.floor(t.getCurrentTime() / t.getDuration() * 4) / 4).toFixed(2);

            if (!player["lastP"] || time > player["lastP"]) {
                player["lastP"] = time;
                pushDataLayer({
                    event: "youtube",
                    label: label,
                    action: time * 100 + "%"
                });
            }
        }, 1000);
    }
    if (event.data == YT.PlayerState.PAUSED) {
        pushDataLayer({
            'event': 'youtube',
            'label': label,
            'action': 'pause'
        });
        clearInterval(player["interval"]);
    }
}

function getPlayerState(data) {

}

function onPlayerReady(event) {
}

function pushDataLayer(obj) {
    if (typeof dataLayer != "undefined") {
        dataLayer.push(obj);
    }
}