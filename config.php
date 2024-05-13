<?php 

    $server = "localhost";
    $username = "root";
    $password = "";
    $dbname = "my_db";

    $conn = new mysqli($server, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
        die("connect failed!<br>Reason: " . $conn->connect_error);
    } // else echo "connected!";

?>
