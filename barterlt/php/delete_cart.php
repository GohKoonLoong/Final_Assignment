<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['cartid'])) {
    $cartid = $_POST['cartid'];
    $sqldeletecart = "DELETE FROM `tbl_carts` WHERE `cart_id` = '$cartid'";
    databaseUpdate($sqldeletecart);
}

if (isset($_POST['userid'])) {
    $userid = $_POST['userid'];
    $sqldeleteallcart = "DELETE FROM `tbl_carts` WHERE `user_id` = '$userid'";
    databaseUpdate($sqldeleteallcart);
}

function databaseUpdate($sql) {
    // Include the global $conn inside the function
    global $conn;
    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
