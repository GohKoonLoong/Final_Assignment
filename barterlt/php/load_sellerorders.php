<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['uploaderid'])){
    $uploaderid = $_POST['uploaderid']; 
    $sqlcart = "SELECT * FROM `tbl_orders` WHERE uploader_id = '$uploaderid'";
}
//`order_id`, `order_bill`, `order_paid`, `buyer_id`, `seller_id`, `order_date`, `order_status`

$result = $conn->query($sqlcart);
if ($result->num_rows > 0) {
    $orderitems["orders"] = array();
    while ($row = $result->fetch_assoc()) {
        $orderlist = array();
        $orderlist['order_id'] = $row['order_id'];
        $orderlist['order_bill'] = $row['order_bill'];
        $orderlist['order_paid'] = $row['order_paid'];
        $orderlist['user_id'] = $row['user_id'];
        $orderlist['uploader_id'] = $row['uploader_id'];
        $orderlist['order_date'] = $row['order_date'];
        $orderlist['order_status'] = $row['order_status'];
        array_push($orderitems["orders"] ,$orderlist);
    }
    $response = array('status' => 'success', 'data' => $orderitems);
    sendJsonResponse($response);
}else{
     $response = array('status' => 'failed', 'data' => $sqlcart);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}