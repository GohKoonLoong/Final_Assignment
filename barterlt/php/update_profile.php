<?php
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null );
    sendJsonResponse($response);
    die();
}


include_once("dbconnect.php");


$userid = $_POST['userid'];
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$newpassword = sha1($_POST['newpassword']);


$sqlupdate = "UPDATE tbl_users 
              SET user_name = '$name', 
                  user_phone = '$phone', 
                  user_email = '$email', 
                  user_password = '$newpassword' 
              WHERE user_id = '$userid'";




if ($conn->query($sqlupdate) === TRUE) {
    $response = array('status' => 'success' , 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}