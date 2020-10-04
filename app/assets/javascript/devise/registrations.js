//= require theme_files/jquery-3.2.1.min.js
//= require theme_files/bootstrap.min.js
//= require theme_files/main.js
//= require theme_files/preloader.js
$(document).ready(function(){
    $("#profileImage").click(function(e) {
        $("#user_profile_picture").click();
    });

    function fasterPreview( uploader ) {
        if ( uploader.files && uploader.files[0] ){
            $('#profileImage').attr('src',
                window.URL.createObjectURL(uploader.files[0]) );
        }
    }

    $("#user_profile_picture").change(function(){
        fasterPreview( this );
    });

});