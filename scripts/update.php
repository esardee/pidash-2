<?php

$url = $_POST['url'] ;

if (!empty($url)) {
  if (!FILTER_VAR($url, FILTER_VALIDATE_URL) === false) {
    // URL IS VALID

    echo "This is the update." ;
    echo "<br><br>" ;

    echo "The URL was $url" ;

    $newConfig = fopen("fullscreen.sh", "w") or die("Unable to open file!") ;

    $txt = 'unclutter &' . PHP_EOL . 'matchbox-window-manager &' . PHP_EOL . 'iceweasel ' . $url . ' --display=:0 &' . PHP_EOL . 'sleep 10s' . PHP_EOL ;

    fwrite($newConfig, $txt) ;
    fclose($newConfig) ;

    // $configdrop = shell_exec('configdump.sh');

    // $restart = shell_exec('softboot.sh');

  } else {
    // URL IS INVALID

    echo "The URL is not valid. Try again." ;

  }
} else {
  // URL field is empty

  echo "Please enter a URL before submitting." ;
}

?>
