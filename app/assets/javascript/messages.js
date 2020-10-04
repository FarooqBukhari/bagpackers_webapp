//= require theme_files/jquery-3.2.1.min.js
//= require theme_files/bootstrap.min.js
//= require theme_files/main.js
//= require theme_files/preloader.js
$(document).ready(function() {

    $('.tabs > li').on('click',function () {
        $(this).removeClass('user-box-message');
        var ref = $(this).attr("id");
        var con_id = ref.substr(ref.lastIndexOf('-')+1);
        var conversation = $('#conversations-list').find("[data-conversation-id='" + con_id + "']");
        var ul = conversation.find('.commentList');
        var abc = conversation.find('.commentList li:last');

        jQuery(ul).animate({scrollTop: 1000000 + 30}, "slow");
    });

});
