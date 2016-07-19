$(document).ready(function(){
  $('form.form-suggest').on('submit',function(event){
    event.preventDefault();
    var url = $(this).attr('action');
    var id = $(this).attr('data_id');
    $.ajax({
      url: url,
      type: 'PUT',
      data: {id: id},
      dataType: 'JSON',
      cache: false,
      success: function(result){
        if(result[0].status == 'done')
        {
          $('#' + result[0].id +'-accept')
            .html('<span class="glyphicon glyphicon-ok ok"></span>');
        }
      }
    })
  })
});

