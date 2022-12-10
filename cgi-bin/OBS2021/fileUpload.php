<?php
echo "Hello world";
//      $pass_teamIDX = $_REQUEST['teamIDX'];
//      $pass_eventIDX = $_REQUEST['eventIDX'];
// <!--     //$pass_teamIDX = ; -->
//      $servername = "localhost";
//      $username = "saestars_admin";
//      $password = "admin@saestars.com";
//      $dbName = "saestars_DB";
// try {
//     $dbi = new PDO("mysql:host=$servername;dbname=$dbName", $username, $password);
//     // set the PDO error mode to exception
//     $dbi->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
//      echo "Connected successfully<hr>";
//     }
// catch(PDOException $e)
//     {
//     //echo "Connection failed: " . $e->getMessage();
//     }
// $myPath = '../upload/'.$pass_eventIDX.'/'.$pass_teamIDX.'/';
// if (!is_dir($myPath)) {
//     mkdir("$myPath", 0777, true);
// //     echo "made Directory: $myPath";
// }
// package SAE::Db;
// $dbName = "saestars_DB";
// $dbi = DBI->connect("dbi:mysql:$dbName:localhost:3306", 'saestars_admin', 'admin@saestars.com') || die ("Cannot Connect");


// ------------------------------ UPLOADING REPORT ------------------------------------------------------------------------------------------

//     if (($_FILES["report"]["type"] == 'application/pdf') && ($_FILES["report"]["size"] < 5000000) && (!empty($_FILES["report"]["name"]))) {
//         if ($_FILES["report"]["error"] > 0){
//             echo "Return Code: " . $_FILES["file"]["error"] . "<br/><br/>";
//         } else {
//
//             echo "<span id='success'><b>Design Report Status </b>: <span style=\"color: green\">Uploaded Successfully...!!</span></span><br/>";
//             echo "<b>&nbsp;&nbsp;+File Name:</b> " . $_FILES["report"]["name"];
//             echo " - [" . number_format(($_FILES["report"]["size"] / 1024),2) . " kB] <br>";
//         }
//     } else {
//         if ((!empty($_FILES["report"]["name"]))){
//             echo "<b>Design Report</b>: <span style='color: red;'>Invalid File Type!  (Limited to PDF Files Only) </span><br>";
//         }
//     }
// ------------------------------ UPLOADING TDS ------------------------------------------------------------------------------------------
//     if (($_FILES["tds"]["type"] == 'application/pdf') && ($_FILES["tds"]["size"] < 5000000) && (!empty($_FILES["tds"]["name"]))) {
//         if ($_FILES["tds"]["error"] > 0){
//             echo "Return Code: " . $_FILES["file"]["error"] . "<br/><br/>";
//         } else {
//             $reportName = $_FILES["tds"]["name"];
//             $sourcePath = $_FILES['tds']['tmp_name'];
//             $fileSize   = $_FILES['tds']['size'];
//             $fileType   = $_FILES['tds']['type'];
//
//             $fp      = fopen($sourcePath, 'r');
//             $content = fread($fp, filesize($sourcePath));
//             $content = addslashes($content);
//             fclose($fp);
//             if(!get_magic_quotes_gpc()){
//                 $reportName = addslashes($reportName);
//             }
//             //$reportName = $_FILES["tds"]["name"];
//             $teamIDX = $_REQUEST['teamIDX'];
//             $tdsCode = $_REQUEST['tdsCode'];
//
//             $SQL = "DELETE FROM TB_UPLOAD WHERE ((FK_TEAM_IDX=$teamIDX) AND (TX_LABEL='TX_TDS'))";
//             $delete = $dbi->prepare($SQL);
//             $delete->execute() || die ("could not execute");
//
//             $SQL = "INSERT INTO TB_UPLOAD (TX_SERIAL, TX_FILE, TX_FILENAME, TX_LABEL, TX_TYPE, IN_SIZE, FK_TEAM_IDX, FK_EVENT_IDX)
//                 VALUES ('$tdsCode', '$content', '$reportName', 'TX_TDS', '$fileType', '$fileSize', $pass_teamIDX , $pass_eventIDX ) ";
//             $insert = $dbi->prepare($SQL);
//             $insert->execute() || die ("could not execute");
//             echo "<span id='success'><b>Tech-Data Sheet Status:</b> <span style=\"color: green\">Uploaded Successfully...!!</span></span><br/>";
//             echo "<b>&nbsp;&nbsp;+File Name:</b> " . $_FILES["tds"]["name"];
//             echo " - [" . number_format(($_FILES["tds"]["size"] / 1024),2) . " kB]<br>";
//         }
//     } else {
//         if ((!empty($_FILES["tds"]["name"]))){
//             echo "<b>Tech-Data Sheet</b>: <span style='color: red;'>Invalid File Type!  (Limited to PDF Files Only)</span><br>";
//         }
//     }

// ------------------------------ UPLOADING DRAWING ------------------------------------------------------------------------------------------

//     if (($_FILES["drawing"]["type"] == 'application/pdf') && ($_FILES["drawing"]["size"] < 5000000) && (!empty($_FILES["drawing"]["name"]))) {
//         if ($_FILES["drawing"]["error"] > 0){
//             echo "Return Code: " . $_FILES["file"]["error"] . "<br/><br/>";
//         } else {
//             $reportName = $_FILES["drawing"]["name"];
//             $sourcePath = $_FILES['drawing']['tmp_name'];
//             $fileSize = $_FILES['drawing']['size'];
//             $fileType = $_FILES['drawing']['type'];
//
//             $fp      = fopen($sourcePath, 'r');
//             $content = fread($fp, filesize($sourcePath));
//             $content = addslashes($content);
//             fclose($fp);
//             if(!get_magic_quotes_gpc()){
//                 $reportName = addslashes($reportName);
//             }
//             //$reportName = $_FILES["drawing"]["name"];
//             $teamIDX = $_REQUEST['teamIDX'];
//             $drawingCode = $_REQUEST['drawingCode'];
//
//             //$sourcePath = $_FILES['drawing']['tmp_name']; // Storing source path of the file in a variable
//             //$targetPath = "$myPath/".$_FILES['drawing']['name']; // Target path where file is to be stored
//             //move_uploaded_file($sourcePath,$targetPath) ; // Moving Uploaded file
//
//             $SQL = "DELETE FROM TB_UPLOAD WHERE ((FK_TEAM_IDX=$teamIDX) AND (TX_LABEL='TX_DRAWING'))";
//             $delete = $dbi->prepare($SQL);
//             $delete->execute() || die ("could not execute");
//
//             $SQL = "INSERT INTO TB_UPLOAD (TX_SERIAL, TX_FILE, TX_FILENAME, TX_LABEL, TX_TYPE, IN_SIZE, FK_TEAM_IDX, FK_EVENT_IDX)
//                 VALUES ('$drawingCode', '$content', '$reportName', 'TX_DRAWING', '$fileType', '$fileSize', $pass_teamIDX , $pass_eventIDX ) ";
//             $insert = $dbi->prepare($SQL);
//             $insert->execute() || die ("could not execute");
//             echo "<span id='success'><b>2D Drawing Status:</b> <span style=\"color: green\">Uploaded Successfully...!!</span></span><br/>";
//             echo "<b>&nbsp;&nbsp;+File Name:</b> " . $_FILES["drawing"]["name"];
//             echo " - [" . number_format(($_FILES["drawing"]["size"] / 1024),2) . " kB]<br>";
//         }
//     } else {
//         if ((!empty($_FILES["drawing"]["name"]))){
//             echo "<b>2D Drawing</b>: <span style='color: red;'>Invalid File Type!  (Limited to PDF Files Only)</span><br>";
//         }
//     }
?>
