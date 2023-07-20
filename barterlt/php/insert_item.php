<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$item_name = $_POST['itemname'];
$item_desc = $_POST['itemdesc'];
$item_type = $_POST['type'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
// Decode the JSON string of images
$images = json_decode($_POST['images']);
$item_interested = $_POST['itemInterested'];
$market_value = $_POST['marketValue'];
$numofimages = $_POST['numofimages'];

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`,`item_name`, `item_desc`, `item_type`,`item_lat`, `item_long`, `item_state`, `item_locality`,`images_num`,`item_interested`,`market_value`) VALUES ('$userid','$item_name','$item_desc','$item_type','$latitude','$longitude','$state','$locality', '$numofimages','$item_interested','$market_value')";

if ($conn->query($sqlinsert) === TRUE) {
    $lastInsertId = mysqli_insert_id($conn);
    $index = 1;
    foreach ($images as $base64Image) {
        $imageData = base64_decode($base64Image);
        $filename = $lastInsertId . '.' . $index;
        $path = '../assets/items/' . $filename . '.png';
        file_put_contents($path, $imageData);
        $index++;
    }
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => $sqlinsert);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

