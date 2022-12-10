<?php
     $servername = "localhost";
     $username = "saestars_admin";
     $password = "admin@saestars.com";
     $dbName = "saestars_DB";
try {
    $dbi = new PDO("mysql:host=$servername;dbname=$dbName", $username, $password);
    // set the PDO error mode to exception
    $dbi->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
     //echo "Connected successfully<hr>";
    }
catch(PDOException $e)
    {
    //echo "Connection failed: " . $e->getMessage();
    }
?>
