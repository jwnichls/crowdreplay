// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

$(function () {

	$('#navbar-collapse').on('show.bs.collapse', function () {
		$('#navbar-collapse').addClass("navbar-inverse").removeClass("navbar-default navbar-transparent");
	})

	$('#navbar-collapse').on('hidden.bs.collapse', function () {
		$('#navbar-collapse').addClass("navbar-default navbar-transparent").removeClass("navbar-inverse");
	})

	// Force the footer to the bottom of the page if it ordinarily would be in the middle of the screen
	var docHeight = $(window).height();
	var footerHeight = $('#footer').height();
	var footerTop = $('#footer').position().top + footerHeight;
	
	if (footerTop < docHeight) {
		$('#footer').css('margin-top', (docHeight - footerTop) + 'px');
	}
})
