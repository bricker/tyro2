$(function() {
	// Tokenizer
	$(".user_tokens").tokenInput("/cp/users/search.json", {
		crossDomain: false,
		prePopulate: $(".user_tokens").data("pre"),
		hintText: 'Start typing a name to find a DJ...'
	});
	
	$(".noob_tokens").tokenInput("/cp/users/search.json?role=noob", {
		crossDomain: false,
		prePopulate: $(".noob_tokens").data("pre"),
		hintText: 'Start typing a name to find a Noob...'
	});
	
	$(".show_tokens").tokenInput("/cp/shows/search.json", {
		crossDomain: false,
		prePopulate: $(".show_tokens").data("pre"),
		hintText: 'Start typing a title to find a Show...'
	});
});