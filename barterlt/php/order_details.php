<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");


$orderbill = $_POST['orderbill'];
$itemid = $_POST['itemid'];
$orderpaid = $_POST['orderpaid'];
$userid = $_POST['userid'];
$uploaderid = $_POST['uploaderid'];
$orderstatus = $_POST['orderstatus'];


$sqlinsert = "INSERT INTO `tbl_orders`(`order_bill`,`item_id`, `order_paid`, `user_id`,`uploader_id`, `order_status`) VALUES ('$orderbill','$itemid','$orderpaid','$userid','$uploaderid','$orderstatus')";

$sqldeleteitem = "DELETE FROM `tbl_items` WHERE `item_id` = '$itemid'";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => $sqlinsert);
    sendJsonResponse($response);
}
$conn->query($sqldeleteitem);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

