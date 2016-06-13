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
    var conf = confirm("Are you sure you want to reboot?");

    if (conf == true) {
        $.ajax({
          type: 'POST',
          url: './scripts/reboot.php',
        });
        document.getElementById('success').innerHTML = 'Pi is rebooting, check back in a minute!';
        return false;
    };
});
