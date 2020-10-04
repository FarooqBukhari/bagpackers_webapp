App.conversation = App.cable.subscriptions.create("ConversationChannel", {

  connected: function() {},
  disconnected: function() {},
    received: function(data) {
        var conversation = $('#conversations-list').find("[data-conversation-id='" + data['conversation_id'] + "']");

        if (data['window'] !== undefined) {
            var conversation_visible = conversation.is(':visible');

            if (conversation_visible) {
                var messages_visible = (conversation).find('.panel-body').is(':visible');

                if (!messages_visible) {
                    conversation.removeClass('panel-default').addClass('panel-success');
                }
                conversation.find('.messages-list').find('ul').append(data['message']);
            }
            else {
                if(conversation.length > 0)
                {
                    var user_box = $('#user-box-'+data['conversation_id']);
                    user_box.addClass('user-box-message');
                    conversation.find('.messages-list').find('ul').append(data['message']);
                }
                else
                {
                    if (window.location.href.indexOf("messages") > -1) {
                        alert("your url contains the name messages");
                        //add code to make it look like the other UI
                    }
                    else {
                        $('#conversations-list').append(data['window']);
                        conversation = $('#conversations-list').find("[data-conversation-id='" + data['conversation_id'] + "']");
                        conversation.find('.panel-body').toggle();
                    }
                }



            }
        }
        else {
            conversation.find('ul').append(data['message']);
        }

        var ul = conversation.find('.commentList');
        var abc = conversation.find('.commentList li:last');

        jQuery(ul).animate({scrollTop: $(ul).scrollTop() + jQuery(abc).offset().top + 30}, "slow");


    },
  speak: function(message) {
    return this.perform('speak', {
      message: message
    });
  }
});

$(document).ready(function() {


    $(document).on('submit', '.new_message', function (e) {
        e.preventDefault();
        var values = $(this).serializeArray();
        App.conversation.speak(values);
        $(this).trigger('reset');

    });

});