// ------------------------------------------------------------
// --- Everything below here is LIVE.
// ------------------------------------------------------------

// When the form submits (clicking update or pressing enter)
$('#urlForm').submit(function() {
  $.ajax({
    data: $(this).serialize(),
    type: $(this).attr('method'),
    url: $(this).attr('action'),
    success: function(response) {
      $('#success').html(response);
    }
  });
  return false;
});

// When the reboot button is clicked.
$('#reboot').click(function(){
  $.ajax({
    type: 'POST',
    url: './scripts/reboot.php',
    success: function(response) {
      $('#success').html(response);
    }
  });
  return false;
});

// ------------------------------------------------------------
// --- Everything below here is TEST.
// ------------------------------------------------------------

// $('#create').submit(function() { // catch the forms submit event
//   $.ajax({ // create the AJAX call
//     data: $(this).serialize(), // get the form data
//     type: $(this).attr('method'), // GET or POST
//     url: $(this).attr('action'), // the file to call on submit
//     success: function(response) { // on success
//       $('#created').html(response); // update the DIV
//     }
//   });
//   return false; // cancel the original event to prevent the form submitting
// });

// ------------------------------------------------------------
// --- Everything below here is SAVED!
// ------------------------------------------------------------

// $('#urlForm').submit(function() {
//   $.ajax({
//     data: $(this).serialize(),
//     type: $(this).attr('method'),
//     url: $(this).attr('action'),
//     success: function(response) {
//       $('#success').html(response);
//     }
//   });
//   return false;
// });
