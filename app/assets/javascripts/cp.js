//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require fullcalendar
//= require tokenizer
//= require jquery.confirm
//= require jquery.tokeninput
//= require jquery.tagsinput
//= require jquery.spin
//= require spinner_settings

$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  }
});

$(function() { 
	$(document).ready(function() {
		
		/***************** Clickable Divs **************/
		var block = $(".linked");
   	block.click(function(){
      	window.location = $(this).find("a:first").attr("href")
   	});
   	block.addClass("clickable");
    block.hover(function(){
       window.status = $(this).find("a:first").attr("href")
    }, function(){
       window.status = ""
    });

		$('a.lightbox').lightBox(); // lightbox
		
	 /*************** TOPICS / MESSAGES **********************************/
	
	 $('#topic-list .topic .info').click(function() { // Topic divs are clickable
			window.location = $(this).find('.title a').attr('href');
		});
		
		// Tyro-Code. Uses functios from Rangy Text (textinputs_jquery.js). Only for textarea - does not populate buttons. Check base_helper for rendering.
		$('#tyro-code #bold').click(function() { // OPTIMIZE Dry up Tyro Code
			$('#reply-box textarea').surroundSelectedText('[b]', '[/b]');
		});
		
		$('#tyro-code #italic').click(function() {
			$('#reply-box textarea').surroundSelectedText('[i]', '[/i]');
		});
		
		$('#tyro-code #underline').click(function() {
			$('#reply-box textarea').surroundSelectedText('[u]', '[/u]');
		});
		
		$('#tyro-code #color').click(function() {
			$('#reply-box textarea').surroundSelectedText('[color=BLUE]', '[/color]');
		});
		
		$('#tyro-code #size').click(function() {
			$('#reply-box textarea').surroundSelectedText('[size=10]', '[/size]');
		});
		
		$('#tyro-code #image').click(function() {
			$('#reply-box textarea').surroundSelectedText('[image]IMAGE URL', '[/image]');
		});
		
		$('#tyro-code #link').click(function() {
			$('#reply-box textarea').surroundSelectedText('[link url=URL]LINK TITLE', '[/link]');
		});
		
		$('#tyro-code #quote').click(function() {
			$('#reply-box textarea').surroundSelectedText('[quote who=NAME]', '[/quote]');
		});
		
		// for "quote" link in messages
		$('.message .quote').click(function() {
			$('#reply-box textarea').surroundSelectedText("[quote who="+$(this).data('who')+"]"+$(this).data('message')+"[/quote]", "");
		});
		
		/********* SMILIES *************************************************/
		
		var smilies = { // This is only for the text area. Does not populate div dropdown. Also check base_helper for rendering these smilies.
			happy: ':-)', // OPTIMIZE Dry up Smilies.
			sad: ':-(',
			angry: '>:-(',
			tongue: ':-P',
			wink: ';-)',
			grin: ':-D',
			cool: '8-)',
			blush: ':-[',
			rolleyes: ':roll:',
			neutral: ':-|',
			undecided: ':-/'
		}
		$.each(smilies, function(key, value) {
			$('#smilies-list #'+key).click(function() {
				$('#reply-box textarea').surroundSelectedText(value,'');
			});
		});
		
		/******** DATEPICKER and handling date fields ****************/
		
		$('.datepicker').live('focus', function() { // initialize DatePicker
			$(this).datepicker({
			      beforeShow: function(){
			           setTimeout(function(){
			               $(".ui-datepicker").css("z-index", 99999);
			           }, 10); 
			      }
			});
		});
		
		$('.start_date').live('blur', function() { // fill in ends_at with starts_at date
			$('.end_date').val(this.value);
		});
		
		/******* calendar ajax callbacks ***********/
		$('#event-dialog form').live('ajax:beforeSend', function() {
			$('#event-dialog #schedule_event_submit').hide();
			$('#event-dialog .loading-submit').show().spin(smallSpinner);
		}).live('ajax:error', function() {
			$('#event-dialog .alert').html('There was an error.').show();
		}).live('ajax:complete', function() {
			$('#event-dialog #schedule_event_submit').show();
			$('#event-dialog .loading-submit').hide().spin(false);
		});
		
		$('#recur-form').submit(function() {
			$(this).find("input[type=submit]").hide();
			$(this).find('.loading-submit').show().spin(smallSpinner);
		});
		
	});
});