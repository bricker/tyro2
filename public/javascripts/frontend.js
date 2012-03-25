// OPTIMIZE This file is gross, it really needs to be cleaned up.


//HEADER//
function slideSwitch() {
    var $active = $('#slideshow img.active');

    if ( $active.length == 0 ) $active = $('#slideshow img:last');

    var $next =  $active.next().length ? $active.next()
        : $('#slideshow img:first');

    $active.addClass('last-active');

    $next.css({opacity: 0.0})
        .addClass('active')
        .animate({opacity: 1.0}, 4000, function() {
            $active.removeClass('active last-active');
        });
}

$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  }
});

$.fn.spin = function(opts) { //allows jquery for spinner
  this.each(function() {
    var $this = $(this),
        data = $this.data();

    if (data.spinner) {
      data.spinner.stop();
      delete data.spinner;
    }
    if (opts !== false) {
      data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin(this);
    }
  });
  return this;
};

var bigSpinner = {
  lines: 12,
  length: 20, 
  width: 6, 
  radius: 27, 
  color: '#fff', 
  speed: 1,
  trail: 60, 
  shadow: true 
};

var smallSpinner = {
  lines: 12, 
  length: 7, 
  width: 4,
  radius: 10,
  color: '#fff', 
  speed: 1, 
  trail: 60, 
  shadow: false
};

var minnerSpinner = {
  lines: 10, 
  length: 3, 
  width: 2,
  radius: 5,
  color: '#fff', 
  speed: 1, 
  trail: 60, 
  shadow: false
};

function goToFirst() {
	var firstTab = $('#show .sub-nav a:first');
	firstTab.addClass('active');
	$('#show #contents div'+firstTab.attr('href')+'-content').removeClass('hidden');
};

function getSinglePlaylist(playlist) { // dry these two getPlaylist functions up.
	var currentEventId = playlist.attr('data-schedule-event-id');
	$.ajax({
	  url: "/shows/update_playlist.js",
	  data: { schedule_event_id: currentEventId },
	  dataType: "script",
		beforeSend: function() {
			$('.playlist.refresh-single .playlist-group').spin(smallSpinner);
		},
		complete: function() {
			$('.playlist.refresh-single .playlist-group').spin(false);
		}
	});
};

function getPlaylist(eventId) {
	$.ajax({
	  url: "/update_playlist.js",
		data: { current_event_id: eventId },
	  dataType: "script",
		beforeSend: function() {
			$('#'+eventId+' .playlist.refresh .entries').spin(smallSpinner);
		},
		complete: function() {
			$('#'+eventId+' .playlist.refresh .entries').spin(false);
		}
	});
};

function getCurrentEvents() {
	$.ajax({
	  url: "/update_current_events.js",
	  dataType: "script"//,
		//beforeSend: function() {
		//	$('#current-events').spin(smallSpinner);
		//},
		//complete: function() {
		//	$('#current-events').spin(false);
		//}
	});
}

function getNextEvent() {
	$.ajax({
	  url: "/update_next_event.js",
	  dataType: "script"
	});
}

$(document).ready(function() {		
	
	/****** show page ********/	
	requestedSection = window.location.hash;
	if(requestedSection == "") {
		goToFirst();
	} else {
		activeTab = $('#show .sub-nav a[href="'+requestedSection+'"]');
		if(activeTab.length > 0) {
			$('#show #contents div'+activeTab.attr('href')+'-content').removeClass('hidden');
			activeTab.addClass('active');
		} else {
			goToFirst();
		};
	};
		
	$("#show .sub-nav a").click(function(event) {
		$("#show .sub-nav a.active").removeClass('active');
		$(this).addClass('active');
		$("#show #contents>div").addClass('hidden');
		$('#show #contents div'+$(this).attr('href')+'-content').removeClass('hidden');
	});

	 /********* lightbox & tabs ***********/
		if($('a.lightbox').length > 0) $('a.lightbox').lightBox();

	/****** playlist *******/
	$('.playlist .playlist-header').click(function() {
		$(this).next('.playlist-group').toggle();
	});
	
	$('.playlist-group:first').show(); // open the first one on page load
	
  if ($(".playlist.refresh-single").length > 0) setInterval("getSinglePlaylist($('.playlist.refresh-single'))", 30000); // this gets full playlist for one event...
  //if ($(".playlist.refresh").length > 0) {
	//	$(".playlist.refresh").each(function(i) {
	//		setInterval("getPlaylist($(this).attr('data-current-event-id'))", 30000);
	//	});
	//} // this gets limited playlist for any event...
	
	if ($("#current-events").length) setInterval("getCurrentEvents()", 30000); // 30 seconds refresh current events
	if ($("#next-event").length) setInterval("getNextEvent()", 30000); // 30 seconds refresh next event
	
	/******** other ******/
	$('#birn-logo').click(function() { // birn logo link in the header
		window.location = '/';
	});
	
	$('a.webcam').click(function(event) { // webcam links
		event.preventDefault();
		window.open('/livecam/' + $(this).attr('id'), 'livecam', 'width=400,height=400');
	});
	
	$('.stream-link, .listen-link').click(function(event) {
		event.preventDefault();
		var channel = $(this).attr('data-channel');
		if(channel == "undefined") channel = "";
		var popUp = window.open('/stream/' + channel, 'stream', 'width=600,height=200,scrollbars=yes');
		if (popUp == null || typeof(popUp)=='undefined') {
			window.location = '/stream/' + channel;
		} else {
			popUp.focus();
		}
	});
	
	setInterval( "slideSwitch()", 20000 ); // header image slideshow
	
	var channelDescription = $('#channel-description'); // show/hide channel descriptions in the header and stream buttons
	$('#nav #buttons a').hover(function() {
		$(this).animate({backgroundColor: '#666', color: '#ffffff'}, 200);
		$(channelDescription).html($(this).attr('data-description'))
	}, function() {
		$(this).animate({backgroundColor: '#222', color: '#edf6cf'}, 200);
	});
	
	$('#nav nav').hover(function() { // fades in the description div.
		$(channelDescription).fadeIn(200);
	}, function() {
		$(channelDescription).fadeOut(200);
		setTimeout(function() {
			$(channelDescription).empty();
		}, 200);
	});
	
	var block = $(".linked"); // linked divs
 	block.click(function(){
			if($(this).hasClass('last-link')) {
				var link = "a:last";
			} else {
				var link = "a:first";
			};
    	window.location = $(this).find(link).attr("href")
 	});
 	block.addClass("clickable");
  block.hover(function(){
     window.status = $(this).find("a:first").attr("href")
  }, function(){
     window.status = ""
  })
});
