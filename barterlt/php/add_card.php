<?php 
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null );
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$carduserid = $_POST['userid'];
$bankName = $_POST['bankName'];
$cardNumber = $_POST['cardNumber'];
$cardExpiry = $_POST['cardExpiry'];
$cardCVV = sha1($_POST['cardCVV']);

$sqlinsert = "INSERT INTO `tbl_cards`(`user_id`, `bank_name`, `card_number`, `card_expiry`, `card_cvv`) VALUES ('$carduserid','$bankName','$cardNumber','$cardExpiry','$cardCVV')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success' , 'data' => $sqlinsert);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => $sqlinsert);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>