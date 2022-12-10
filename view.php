<?php
     $pass_teamIDX = $_REQUEST['teamIDX'];
     $pass_eventIDX = $_REQUEST['eventIDX'];
    //$pass_teamIDX = ;
     $servername = "localhost";
     $username = "saestars_admin";
     $password = "admin@saestars.com";
    //  $dbName = "saestars_PROD";
     $dbName = "saestars_DEV2";
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
    $txKeys = $_GET["doc"];
    $SQL = "SELECT * FROM TB_UPLOAD WHERE TX_KEYS=:txKeys";
    $select = $dbi->prepare($SQL);
    $select->bindValue(':txKeys', $txKeys);
    $select->execute() || die ("could not execute");
    $result = $select->fetch();
    $fileName = $result ["TX_FILENAME"];
    $file = $result ["BL_FILE"];
    $mime= $result ["TX_TYPE"];
    header("Content-type: ".$mime);
//     header('Content-disposition: attachment; filename="'.$fileName .'"'); // Only for Download Only
     echo $file;
?>