<?php

$url = $_POST['url'] ;

if (!empty($url)) {
  if (!FILTER_VAR($url, FILTER_VALIDATE_URL) === false) {
    // URL IS VALID

    echo "This is the update." ;
    echo "<br><br>" ;

    echo "The URL was $url" ;

    $newConfig = fopen("/home/pi/fullscreen.sh", "w") or die("Unable to open file!") ;

    $txt = '# start / restart the browser' . PHP_EOL . 'unclutter &' . PHP_EOL . 'matchbox-window-manager &' . PHP_EOL . 'iceweasel ' . $url . ' --display=:1 &' . PHP_EOL . 'sleep 10s' . PHP_EOL ;

    fwrite($newConfig, $txt) ;
    fclose($newConfig) ;

    $kill = shell_exec('sh softboot.sh');
    $reload = shell_exec('sh /home/pi/fullscreen.sh');

  } else {
    // URL IS INVALID
    echo "The URL is not valid. Try again." ;

  }
} else {
  // URL field is empty
  echo "Please enter a URL before submitting." ;
}

?>
