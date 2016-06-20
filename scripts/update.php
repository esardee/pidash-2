<?php

$url = $_POST['url'] ;

if (!empty($url)) {
  if (!FILTER_VAR($url, FILTER_VALIDATE_URL) === false) {
    // URL IS VALID

    echo "This is the update." ;
    echo "<br><br>" ;

    echo "The URL was $url" ;

    $newConfig = fopen("/home/pi/dashboard.sh", "w") or die("Unable to open file!") ;

    $txt = '# start / restart the browser' . PHP_EOL . 'chromium-browser --display=:0 --noerrdialogs --no-first-run --kiosk ' . $url . ' --incognito' . PHP_EOL ;

    fwrite($newConfig, $txt) ;
    fclose($newConfig) ;

    $kill = shell_exec('sh killchrome.sh');

    $reload = shell_exec('sh /home/pi/dashboard.sh');

  } else {
    // URL IS INVALID
    echo "The URL is not valid. Try again." ;

  }
} else {
  // URL field is empty
  echo "Please enter a URL before submitting." ;
}

?>
