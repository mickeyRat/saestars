<?php
    //  $pass_teamIDX = $_REQUEST['teamIDX'];
    //  $pass_eventIDX = $_REQUEST['eventIDX'];
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
    $txKeys = $_GET["fileID"];
    echo $txKeys;
    $SQL = "SELECT * FROM TB_UPLOAD WHERE TX_KEYS=:txKeys";
    $select = $dbi->prepare($SQL);
    $select->bindValue(':txKeys', $txKeys);
    $select->execute() || die ("could not execute");
    $result = $select->fetch();
    $file = "./".$result ["TX_FOLDER"];
    $filename = $result ["TX_FILENAME"];
    $type = $result ["TX_TYPE"];

    header('Content-type: '.$type);
    echo "<title>$filename</title>";
    header('Content-Disposition: inline; filename="'.$filename.'"');
    header('Content-Transfer-Encoding: binary');
    header('Content-Length: ' . filesize($file));
    header('Accept-Ranges: bytes');
    @readfile($file);

?>
