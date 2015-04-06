$(document).on('change', '.btn-file :file', function() {
  var input = $(this),
    numFiles = input.get(0).files ? input.get(0).files.length : 1,
    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
  input.trigger('fileselect', [numFiles, label]);
});

$(document).ready( function() {
  $('.btn-file :file').on('fileselect', function(event, numFiles, label) {
    $('#resource_file_text').val(label);
  });

  $('img').lazyload({threshold: 200});

  $('.resource-close').click(function() {
    var href = $(this).attr('data-href');
    $('#destroyModal a').attr('href', href);
    $('#destroyModal').modal('show');
  });

  $('#filter-select').change(function() {
    set_query_string();
  });
});

function update_group(checked, id, group_id) {
  $.ajax({
    url: "/resources/"+id+'/update_group',
    type: "POST",
    data: {'group_id' : group_id, 'checked' : checked},
    dataType: "html"
  });
}
