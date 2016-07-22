$(document).ready(function(){
  $('#new_comment').submit(function(e){
    e.preventDefault();
    var url = $(this).attr('action');
    var method = $(this).attr('method');
    var data = $(this).serializeArray();
    console.log(data);
    $.ajax({
      url: url,
      method: method,
      data: data,
      dataType: 'json',
      success: function(result){
        $('#count-comments').html('(' + result.count_comments + ')');
        $('#comments').prepend(to_html(result));
        $('#comment_content').val('');
        $('#comment-' + result.id).find('.comment-rating').raty({
          readOnly:true,
          score: function() {
            return $(this).attr('data-score');
          },
          path: '/assets/'
        });
      }
    });
  });

  $(document).on('click', '.delete-comment', function(e){
    e.preventDefault();
    var url = $(this).attr('href');
    var id = $(this).attr('data-id');
    $.ajax({
      url: url,
      method: 'delete',
      dataType: 'text',
      success: function(){
        $('#comment-' + id).remove();
      }
      });
  });
});

function to_html(obj){
  var res;
  res += "<li id='comment-"+ obj.id + "'><div class='avatar'>";
  res += "<img src='" + obj.image_url + "' width='30' height='30'></div>";
  res += "<div class='comment-body'><div class='user-name'>";
  res += obj.user_name + "</div><div class='content'>" + obj.content + "</div>";
  res += "<div class='comment-rating' data-score='" + obj.rating + "'></div>";
  res += "<div class='timestamp'>" + obj.time + "</div></div></li>";
  res += "<span class='dropdown pull-right'>";
  res += "<a href='#' class='dropdown-toggle' data-toggle='dropdown'>";
  res += "<b class='caret'></b></a><ul class='dropdown-menu'><li>";
  res += "<a href='/comments/" + obj.id + "' class='delete-comment'";
  res += "data-id='" + obj.id + "' data-confirm='Delete this comment?'>Delete</a></li></ul></span>";
  return res;
}
