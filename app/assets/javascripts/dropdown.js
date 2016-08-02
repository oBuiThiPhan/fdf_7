$(document).on('turbolinks:load', function() {

  $(function(){
    $('.dropdown').hover(function() {
        $(this).addClass('open');
    },
    function() {
        $(this).removeClass('open');
    });
  });
});
