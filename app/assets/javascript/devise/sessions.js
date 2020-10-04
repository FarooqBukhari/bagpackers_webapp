//= require theme_files/jquery-3.2.1.min.js
//= require theme_files/bootstrap.min.js
//= require theme_files/main.js
//= require theme_files/preloader.js

$(document).ready(function() {
    $(".reveal").on('click', function () {
        var $pwd = $(".pwd");
        if ($pwd.attr('type') === 'password') {
            $pwd.attr('type', 'text');
        } else {
            $pwd.attr('type', 'password');
        }
    });
});