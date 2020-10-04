// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require user_feed/modernizr-3.6.0.min.js
//= require user_feed/jquery-3.3.1.min.js
//= require user_feed/popper.min.js
//= require user_feed/bootstrap.min.js
//= require user_feed/slick.min.js
//= require user_feed/nice-select.min.js
//= require user_feed/plyr.min.js
// = require user_feed/perfect-scrollbar.min.js
// = require user_feed/lightgallery-all.min.js
// = require user_feed/imagesloaded.pkgd.min.js
// = require user_feed/isotope.pkgd.min.js
//= require user_feed/main.js
//= require_self

$(document).ready(function() {

    $('#new_comment').submit(function() {
        $('#comment_text').val($('#comment-text').text());
        $('#comment-text').html('');
    });
  if ($(".pagination").size() > 0) {
    $(".pagination").hide();
    $("#endless-scroll").removeClass("hidden");
    $(window).bindWithDelay("scroll", function() {
      var url = $("a.next_page").attr("href");
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $.getScript(url);
      }
    }, 150);
  }

  $('.input-mentionable').atwho({
    at: '@',
    data: $('#mentionable-data').data('content'),
    insertTpl: '<a href="/users/${id}">${name}</a>',
    displayTpl: '<li data-id="${id}"><span>${name}</span></li>',
    limit: 15
  });

  $('#new_post').submit(function() {
    $('#post_content').val($('#post-content').html());
    $('#post-content').html('');
  });


});
