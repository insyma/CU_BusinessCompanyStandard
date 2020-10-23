var marker;
var map;
var infowindow;
var directionDisplay;
var directionsService = null;
var ix = 0;
var aSv = "";
var bounds = null;
var myLatlng = null;
var insymaMapV3 = {
    _isMapList: false,
    _scriptAPILoaded: false,
    _mapOptions: null,
    _initScriptAPI: function (mapoptions, isMapList) {
        this._mapOptions = mapoptions;
        this._isMapList = isMapList;
        //Check if API is loaded
        if (!this._scriptAPILoaded) {
            var s = document.createElement("script");
            s.src = MAP_API + "&callback=insymaMapV3.initialize";
            s.id = "MAP_API";
            var before = document.getElementsByTagName("script")[0];
            before.parentNode.insertBefore(s, before);
        } else {
            if (isMapList) {
                this._initMapList(mapoptions);
            } else {
                this._initMap(mapoptions);
            }
        }
    },
    initialize: function () {
        bounds = new google.maps.LatLngBounds();
        if (this._isMapList) {
            this._initMapList(this._mapOptions);
        } else {
            this._initMap(this._mapOptions);
        }
    },
	_initMap: function(mapoptions)
    {
			var controls = true;
			if(mapoptions.controls == "True")
				controls = false;
			var myLatlng = new google.maps.LatLng(parseFloat(mapoptions.lat), parseFloat(mapoptions.lng));
			var image = mapoptions.icon;
			var myOptions = {
			  	zoom: 14,
			  	center: myLatlng,
			   	styles: getColors(mapoptions.cscheme),
			   	disableDefaultUI: controls
			};
			var contentstring = mapoptions.content;
			if(mapoptions.StreetView != "")
				contentstring = '<div id="sw_content" style="width:300px;height:300px;"></div>';
			map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
			insymaMapV3._setType(mapoptions.type, map)
			infowindow = new google.maps.InfoWindow({
				content: contentstring				
			});

			marker = new google.maps.Marker({
			  position: myLatlng, 
			  map: map, 
			  title: "Standort",
			  icon: image
		  	});   
			google.maps.event.addListener(marker, 'click', function() {
			  infowindow.open(map,marker);
			});

			if(mapoptions.StreetView != "")
				insymaMapV3._setStreetViewInMarker();

			
    },
    
	_initMapList: function(mapoptions)
    {
        console.log(mapoptions);
			var controls = true;
			var aData = mapoptions.data;
			if(mapoptions.controls == "True")
				controls = false;
			var myLatlng = new google.maps.LatLng(aData[0]['lat'], aData[0]['lng']);
			var myOptions = {
			  	zoom: 14,
			  	center: myLatlng,
			   	styles: getColors(mapoptions.cscheme),
			   	disableDefaultUI: controls
			};
			map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
			insymaMapV3._setType(mapoptions.type, map);
			insymaMapV3._setMarkers(map, aData, mapoptions.icon);
			map.fitBounds(bounds);
		},


	
	_setMarkers: function(map, markers, aImg)
	{
		infowindow = null;
		for (var i in markers) {
	            var sites = markers[i];
	            var html = "";
	            if(sites["name"] != ""){html += "<h4>" + sites["name"] + "</h4>";}
				html += "<p>" + sites["addr"] + "</p>";
				//html += "<p>" + sites["plz"] + "</p>";
				//html += "<img src='" + sites["img"] + "' alt='" + sites["name"] + "' width='100' /><br /><a href='" + sites["link"] + "' title='" + sites["name"] + "'>Details</a>";            
				insymaMapV3._add_marker(sites["lat"], sites["lng"], sites["name"], html, aImg);
	        }
	},
	
	_add_marker: function(lat,lng,title,box_html, aImg) {
	    var contentstring = box_html;
		if(aSv != "")
			contentstring = '<div id="sw_content" style="width:300px;height:300px;"></div>';
	   	var marker = new google.maps.Marker({
	          position: new google.maps.LatLng(lat,lng),
	          map: map,
	          title: title,
	          icon: aImg
        });
      
	   	bounds.extend(marker.position);
	    marker.info = new google.maps.InfoWindow({
	  		content: contentstring
		});
	    google.maps.event.addListener(marker, 'click', function() {
		  marker.info.open(map, marker);
		});
	    return marker;
	  },
	 
	
	_calcRoute: function() {
        
        var start = document.getElementById('start').value;
        var end = document.getElementById('end').value;
        var selectedMode = document.getElementById("mode").value;

        if (start == "") {
            document.getElementById('start').parentElement.className = "Validate";
            return false;
        } else {
            document.getElementById('start').parentElement.className = "";
        }


        var html = "<div id='directionsPanelOverlay' class='part part-directions-panel'></div>";
        var options = {
            type: 'content',
            content: $(html),
            class: 'content',
            w: '1000px',
            h: 'auto'
        };
        $("div#insymaOverlayContent").html("");
        Iob.openOverlay();
        Iob.openContent(options);

 		directionsDisplay = new google.maps.DirectionsRenderer();
        var request = {
            origin:start,
            destination:end,
            travelMode: google.maps.DirectionsTravelMode[selectedMode]
        };

        directionsService = new google.maps.DirectionsService();
        directionsService.route(request, function(response, status) {
          if (status == google.maps.DirectionsStatus.OK) {
            document.getElementById("directionsPanel").innerHTML = "";
            directionsDisplay.setDirections(response);
          }
        });
        directionsDisplay.setMap(map);
        directionsDisplay.setPanel(document.getElementById("directionsPanelOverlay"));
        $("html, body").animate({ scrollTop:0}, "slow");
    },
    _setFormVal: function(aId)
    {
      	$('.route_form').show();
      	var li = $("#map_li_" + aId)
      	$('#end').val(li.find("li.strasse").text() + "+" + li.find(".plz").text() + "+" + li.find(".ort").text());
    },
    _setType: function(aType, aMap)
    {
    	switch(aType)
    	{
    		case "ROADMAP":
    			aMap.setMapTypeId(google.maps.MapTypeId.ROADMAP);
    			break;
    		case "SATELLITE":
    			aMap.setMapTypeId(google.maps.MapTypeId.SATELLITE);
    			break;
    		case "HYBRID":
    			aMap.setMapTypeId(google.maps.MapTypeId.HYBRID);
    			break;
    		case "TERRAIN":
    			aMap.setMapTypeId(google.maps.MapTypeId.TERRAIN);
    			break;
    		default:
    			aMap.setMapTypeId(google.maps.MapTypeId.ROADMAP);
    		
    	}

    },
    _setStreetViewInMarker: function()
    {
    	var sview = null;
		google.maps.event.addListener(infowindow, 'domready', function() {
		if (sview != null) 
		{
			sview.unbind("position");
			sview.setVisible(false);
		}
		sview = new google.maps.StreetViewPanorama(document.getElementById("sw_content"), {
			navigationControl: true,
			navigationControlOptions: {style: google.maps.NavigationControlStyle.ANDROID},
			enableCloseButton: false,
			addressControl: false,
			linksControl: false
		});
		sview.bindTo("position", marker);
		sview.setVisible(true);
		});
    },
    _showRoutePlanner: function(aElem)
    {
    	var conEl = "con_" + aElem;
    	var routeEl = "route_" + aElem;
    	$("#" + conEl + " #end").val($("#" + conEl + " li.strasse").text() + ' ' + $("#" + conEl + " span.plz").text() + ' ' + $("#" + conEl + " span.ort").text());
    	$("html, body").animate({ scrollTop:($("#" + routeEl).offset().top)}, "slow");
    	$("#" + routeEl).show( 'slow' );
    }
}


function getColors(aId)
{
	switch(aId)
    	{
    		case "normal":
    			return false;
    		case "ultralight":
    			return [
				    {"featureType": "water","elementType": "geometry","stylers": [    {"color": "#e9e9e9"},{"lightness": 17}]
				    },
				    {"featureType": "landscape","elementType": "geometry","stylers": [{"color": "#f5f5f5"},{"lightness": 20}]
	    			},
	    			{"featureType": "road.highway","elementType": "geometry.fill","stylers": [{"color": "#ffffff"},{"lightness": 17}]
	    			},
	    			{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#ffffff"},{"lightness": 29},{"weight": 0.2}]
	    			},
	    			{"featureType": "road.arterial","elementType": "geometry","stylers": [{"color": "#ffffff"},{"lightness": 18}]
	    			},
	    			{"featureType": "road.local","elementType": "geometry","stylers": [{"color": "#ffffff"},{"lightness": 16}]
	    			},
	    			{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#f5f5f5"},{"lightness": 21}]
				    },
				    {"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#dedede"},{"lightness": 21}]
				    },
				    {"elementType": "labels.text.stroke","stylers": [{"visibility": "on"},{"color": "#ffffff"},{"lightness": 16}]
				    },
				    {"elementType": "labels.text.fill","stylers": [{"saturation": 36},{"color": "#333333"},{"lightness": 40}]
				    },
				    {"elementType": "labels.icon","stylers": [{"visibility": "off"}]
				    },
				    {"featureType": "transit","elementType": "geometry","stylers": [{"color": "#f2f2f2"},{"lightness": 19}]
				    },
				    {"featureType": "administrative","elementType": "geometry.fill","stylers": [{"color": "#fefefe"},	{"lightness": 20}]
				    },
				    {"featureType": "administrative","elementType": "geometry.stroke","stylers": [{"color": "#fefefe"},{"lightness": 17},{"weight": 1.2}]
	    			}
				]
    		case "bluewater":
    			return [
				    {"featureType": "administrative","elementType": "labels.text.fill","stylers": [{"color": "#444444"}]
				    },
				    {"featureType": "landscape","elementType": "all","stylers": [{"color": "#f2f2f2"}]
				    },
				    {"featureType": "poi","elementType": "all","stylers": [{"visibility": "off"}]
				    },
				    {"featureType": "road","elementType": "all","stylers": [{"saturation": -100},{"lightness": 45}]
				    },
				    {"featureType": "road.highway","elementType": "all","stylers": [{"visibility": "simplified"}]
				    },
				    {"featureType": "road.arterial","elementType": "labels.icon","stylers": [{"visibility": "off"}]
				    },
				    {"featureType": "transit","elementType": "all","stylers": [{"visibility": "off"}]
				    },
				    {"featureType": "water","elementType": "all","stylers": [{"color": "#46bcec"},{"visibility": "on"}]
				    }
				]
    		case "midnight":
    			return [
				    {"featureType": "all","elementType": "labels.text.fill","stylers": [{"color": "#ffffff"}]
				    },
				    {"featureType": "all","elementType": "labels.text.stroke","stylers": [{"color": "#000000"},{"lightness": 13}]
				    },
				    {"featureType": "administrative","elementType": "geometry.fill","stylers": [{"color": "#000000"}]
				    },
				    {"featureType": "administrative","elementType": "geometry.stroke","stylers": [{"color": "#144b53"},{"lightness": 14},{"weight": 1.4}]
				    },
				    {"featureType": "landscape","elementType": "all","stylers": [{"color": "#08304b"}]
				    },
				    {"featureType": "poi","elementType": "geometry","stylers": [{"color": "#0c4152"},{"lightness": 5}]
				    },
				    {"featureType": "road.highway","elementType": "geometry.fill","stylers": [{"color": "#000000"}]
				    },
				    {"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#0b434f"},{"lightness": 25}]
				    },
				    {"featureType": "road.arterial","elementType": "geometry.fill","stylers": [{"color": "#000000"}]
				    },
				    {"featureType": "road.arterial","elementType": "geometry.stroke","stylers": [{"color": "#0b3d51"},{"lightness": 16}]
				    },
				    {"featureType": "road.local","elementType": "geometry","stylers": [{"color": "#000000"}]
				    },
				    {"featureType": "transit","elementType": "all","stylers": [{"color": "#146474"}]
				    },
				    {"featureType": "water","elementType": "all","stylers": [{"color": "#021019"}]
				    }
				]
    		case "dawn":
    			return [
				    {"featureType": "administrative","elementType": "all","stylers": [{"visibility": "on"},{"lightness": 33}]
					},
					{"featureType": "landscape","elementType": "all","stylers": [{"color": "#f2e5d4"}]
					},
					{"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#c5dac6"}]
					},
					{"featureType": "poi.park","elementType": "labels","stylers": [{"visibility": "on"},{"lightness": 20}]
					},
					{"featureType": "road","elementType": "all","stylers": [{"lightness": 20}]
					},
					{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#c5c6c6"}]
					},
					{"featureType": "road.arterial","elementType": "geometry","stylers": [{"color": "#e4d7c6"}]
					},
					{"featureType": "road.local","elementType": "geometry","stylers": [{"color": "#fbfaf7"}]
					},
					{"featureType": "water","elementType": "all","stylers": [{"visibility": "on"},{"color": "#acbcc9"}]
					}
				]	
    		case "icy":
    			return [
				    {"stylers": [{"hue": "#2c3e50"},{"saturation": 250}]
					},
					{"featureType": "road","elementType": "geometry","stylers": [{"lightness": 50},{"visibility": "simplified"}]
					},
					{"featureType": "road","elementType": "labels","stylers": [{"visibility": "off"}]}
				]
			case "red":
				return [
					{"stylers":[{"hue":"#dd0d0d"}]
					},
					{"featureType":"road","elementType":"labels","stylers":[{"visibility":"off"}]
					},
					{"featureType":"road","elementType":"geometry","stylers":[{"lightness":100},{"visibility":"simplified"}]}
				]
    	}




	return 	[
		{"featureType":"water","elementType":"all","stylers":[{"color":"#191970"}]},
			{
    			"featureType": "poi.business",
    			"stylers": [
      				{ "hue": "#ff1a00" }
    			]
  			},{
    			"featureType": "road.arterial",
    			"stylers": [
      				{ "hue": "#ff0033" }
    			]
  			},{
    			"featureType": "landscape",
    			"stylers": [
      				{ "color": "#808080" }
    			]
  			},{
  		}
					
	]
}