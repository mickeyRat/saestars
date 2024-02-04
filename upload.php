<?php
// Connecting to the Database;
$servername = "localhost";
$dbName = "saestars_DEV2";
// $dbName = "saestars_PROD";
$username = "saestars_admin";
$password = "admin@saestars.com";

try {
    $dbi = new PDO("mysql:host=$servername;dbname=$dbName", $username, $password);
    // set the PDO error mode to exception
    $dbi->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }
catch(PDOException $e)
    {
        echo "Connection failed: " . $e->getMessage();
    }
// A list of permitted file extensions
$allowed = array('png', 'jpg', 'gif','zip','pdf');
$allowed_tds = array('tds', 'technical_data_sheet', 'tech_data_sheet', 'data_sheet');
$allowed_drawing= array('drawing', 'drawing', 'drw', '2D-drawing', '2D_drawing', '2D_drawings');
$allowed_report = array('design_report', 'design');
$permitted_chars = '0123456789abcdefghijklmnopqrstuvwxyz';

// Getting Event Location from selection
$eventIDX=$_REQUEST['EVENT_LOCATION'];
$SQL = "SELECT IN_YEAR FROM TB_EVENT WHERE PK_EVENT_IDX=:eventIDX";
$select = $dbi->prepare($SQL);
$select->bindValue(':eventIDX', $eventIDX);
$select->execute();
$row = $select->fetch();


// $debugfile = fopen("debug.txt", "a");

// Building Team Number and Team IDX Reference
$SQL = "SELECT PK_TEAM_IDX, IN_NUMBER FROM TB_TEAM WHERE FK_EVENT_IDX=:eventIDX";
$select = $dbi->prepare($SQL);
$select->bindValue(':eventIDX', $eventIDX);
$select->execute();
$TEAM = array();
foreach ($select as $team){
    $TEAM[$team['IN_NUMBER']] = $team['PK_TEAM_IDX'];
}


$total = count($_FILES['upl']['name']);
// fwrite($debugfile, $total."\n");
// // Deleting the previously uploaded Document
$SQL = "DELETE FROM TB_UPLOAD WHERE (FK_TEAM_IDX=:eTeamIDX AND TX_PAPER=:ePaper)";
$delete = $dbi->prepare( $SQL );

// // $SQL = "INSERT INTO TB_UPLOAD ( FK_TEAM_IDX, FK_EVENT_IDX, TX_FILENAME) VALUES (?, ?, ?)";
$SQL = "INSERT INTO TB_UPLOAD ( FK_TEAM_IDX, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER, IN_NUMBER ) 
    VALUES (:eTeamIDX, :eEventIDX, :eKeys, :eFileName, :eType, :ePaper, :eInPaper, :eFile, :eInNumber)";
$insert = $dbi->prepare( $SQL );


$debugfile = fopen("debug.txt", "a");
if(isset($_FILES['upl'])  && $_FILES['upl']['error'] == 0){
    
    // Stripping the name of file and grabbing the team number
    $fileName = str_replace(array('(',')','{','}','#'),'-',$_FILES['upl']['name']);
    preg_match('/--(\d+)--/', $fileName, $teamNumber);
    $teamNumber = (int)$teamNumber[1];
    
    // Cross refrencing the team number with the Team Index Key in the Database
    $teamIDX = $TEAM[$teamNumber]; 
    
    // If Folder does not exist, create a folder and give permission to write to folder
    $folder = "uploads/".$row['IN_YEAR']."/$eventIDX/".$teamNumber;
    if (!file_exists($folder)) {mkdir($folder, 0777, true);} 
    // if (!file_exists($folder)) {mkdir($folder, 0777, true);}
    

    //
    if (strpos(strtolower($fileName), 'design_report')>0 || strpos(strtolower($fileName), 'technical_design_report' )>0){ // Change the fileName to lower case and find the position of 
        $newFileName = "Team_".$teamNumber."_Design_Report";
    } else if ( strpos(strtolower($fileName), 'tech_data_sheet')>0 || strpos(strtolower($fileName), 'data_sheet')>0 || strpos(strtolower($fileName), 'technical_data_sheet')>0) {
        $newFileName = "Team_".$teamNumber."_TDS";
    } else if ( strpos(strtolower($fileName), 'drawings')>0 ) {
        $newFileName = "Team_".$teamNumber."_Drawing";
    } else {
        $newFileName = "Team_Unknown_Drawing";
    }
    
    // Establish the new Path for the file location
    $newFilePath = $folder."/".$newFileName;
    // $newFilePath = $folder."/".$fileName;
    
    // Upload and move the file to the target location $newFilePath
    if(move_uploaded_file($_FILES['upl']['tmp_name'], $newFilePath)){
        $tempPath = $_FILES['upl']['tmp_name'];
        fwrite($debugfile, "Successfull uploaded ".$_FILES['upl']['tmp_name']." & moved to ".$newFilePath."\n");
        
    // Creating a Unique Key for Cryptic Reference in the URL when the file is read.
        // $keys = generateRandomString();
        
    // $encrypted = random_bytes(5);;


    if (strpos(strtolower($fileName), 'design_report')>0 || strpos(strtolower($fileName), 'technical_design_report' )>0){ // Change the fileName to lower case and find the position of 'design_report'.  If greater than 1, it exist in the file.
        $PAPER = "Design Report";
        $inPaper = 1;
    } else if ( strpos(strtolower($fileName), 'tech_data_sheet')>0 || strpos(strtolower($fileName), 'data_sheet')>0 || strpos(strtolower($fileName), 'technical_data_sheet')>0) {
        $PAPER = "TDS";
        $inPaper = 2;
    } else if ( strpos(strtolower($fileName), 'drawings')>0 ) {
        $PAPER = "Drawing";
        $inPaper = 3;
    } else {
        $PAPER = "Unknown";
        $paper = "unknown";
        $inPaper = 0;
    }

        $insert->bindParam(':eTeamIDX',$teamIDX);
        $insert->bindParam(':eEventIDX',$eventIDX);
        $insert->bindParam(':eKeys',$_FILES['upl']['tmp_name']);
        $insert->bindParam(':eFileName',$newFileName);
        // $insert->bindParam(':eFileName',$fileName);
        $insert->bindParam(':eType',$_FILES['upl']['type']);
        $insert->bindParam(':ePaper',$PAPER);
        $insert->bindParam(':eInPaper',$inPaper);
        $insert->bindParam(':eFile',$newFilePath);
        $insert->bindParam(':eInNumber',$teamNumber);
        $insert->execute()  || die ("could not execute");
        
    }
    
    // fwrite($debugfile, "filename=".$fileName."\n");
}
fclose($debugfile);

    // foreach($_FILES['upl'] as $keys => $values){
        // $fileName = $_FILES['upl']['name'];
        // if(move_uploaded_file($_FILES['file']['tmp_name'][$keys], 'uploads/' . $values)){
        //     $fileData .= '<img src="uploads/'.$values.'" class="thumbnail" />';
        //     $query = "INSERT INTO uploads (file_name, upload_time)VALUES('".$fileName."','".date("Y-m-d H:i:s")."')";
        //     mysqli_query($con, $query);
        // }
    // }


// if(isset($_FILES['upl']) && $_FILES['upl']['error'] == 0){
// // for( $i=0 ; $i < $total ; $i++ ) {
// 	$extension = pathinfo($_FILES['upl']['name'], PATHINFO_EXTENSION);
//     $newFilePath = '';
// 	if(!in_array(strtolower($extension), $allowed)){
// 		echo '{"status":"error"}';
// 		exit;
// 	}
// 	$tmpFilePath = $_FILES['upl']['tmp_name'];
//     $name = $_FILES['upl']['name'];
//     $type = $_FILES['upl']['type'];

//     // fwrite($debugfile, $tmpFilePath."\n");
//     // fwrite($debugfile, $name."\n");
//     // fwrite($debugfile, $type."\n");


//     // Geting the Team IDX from the team Number
//     // preg_match('/\(#(\d+)\)/', $name, $inNumber);
//     preg_match('/\#(\d+)/', $name, $teamNumber);
    
    
    
//     // $teamIDX =1;
//     // $sourcePath = $_FILES['upl']['tmp_name'][$i];
//     if (strpos(strtolower($name), 'design_report') ){
//         $PAPER = "Design Report";
//         $paper = "design_Report";
//         $inPaper = 1;
//     } else if ( strpos(strtolower($name), 'tech_data_sheet') || strpos(strtolower($name), 'data_sheet')) {
//         $PAPER = "TDS";
//         $paper = "tech_data_sheet";
//         $inPaper = 2;
//     } else if ( strpos(strtolower($name), 'drawings') ) {
//         $PAPER = "Drawing";
//         $paper = "drawing";
//         $inPaper = 3;
//     } else {
//         $PAPER = "Unknown";
//         $paper = "unknown";
//         $inPaper = 0;
//     }

//     $teamNumber = (int)$teamNumber[1];
//     $teamIDX = $TEAM[$teamNumber];
    
//     fwrite($debugfile, $teamNumber."\n");
//     fwrite($debugfile, $teamIDX."\n");
    
//     $delete->bindParam(':eTeamIDX', $teamIDX );
//     $delete->bindParam(':ePaper', $PAPER );
//     $delete->execute();
    
//     $folder = "uploads/".$row['IN_YEAR']."/$eventIDX/".$teamNumber;
    
//     if (!file_exists($folder)) {
//         mkdir($folder, 0777, true);
//     }

    
//     // Saving files to Database
//     $permitted_chars = '0123456789abcdefghijklmnopqrstuvwxyz';
//     // $keys = substr(str_shuffle($permitted_chars), 0, 16);
//     $keys = str_shuffle($permitted_chars);


//     // $newFilePath = $folder."/".$teamNumber."-".$paper.".pdf";
//     // $filename = trim($_FILES['upl']['name'],'{)');

//     $filename = str_replace(array('(',')','{','}','#'),'-',$_FILES['upl']['name']);

//     // $filename = preg_match('/[\{\(\)]/', '_', $_FILES['upl']['name'], -1, $count);
//     // fwrite($debugfile, $filename."\n");
//     $newFilePath = $folder."/".$filename;
    
    
    

//     // fwrite($debugfile, $tmpFilePath."\n");
//     // fwrite($debugfile, $newFilePath."\n");
    
//     if(move_uploaded_file($tmpFilePath, $newFilePath)) {

//     }
//             // :eEventIDX, :eKeys, :eFileName, :eType, :ePaper, :eFile
//         $insert->bindParam(':eTeamIDX',$teamIDX);
//         $insert->bindParam(':eEventIDX',$eventIDX);
//         $insert->bindParam(':eKeys',$keys);
//         $insert->bindParam(':eFileName',$name);
//         $insert->bindParam(':eType',$type);
//         $insert->bindParam(':ePaper',$PAPER);
//         $insert->bindParam(':eInPaper',$inPaper);
//         $insert->bindParam(':eFile',$newFilePath);
//         $insert->bindParam(':eInNumber',$teamNumber);
//         $insert->execute()  || die ("could not execute");
// }
// // fwrite($debugfile, "\n\n");

// // fclose($debugfile);

// echo '{"status":"error"}';
// exit;
function generateRandomString($length = 24) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

?>