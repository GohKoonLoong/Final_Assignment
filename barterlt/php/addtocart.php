<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$itemid = $_POST['item_id'];
$cartprice = $_POST['cart_price'];
$cartqty = $_POST['cart_qty'];
$userid = $_POST['userid'];
$uploaderid = $_POST['uploaderid'];

$checkitemid = "SELECT * FROM `tbl_carts` WHERE `user_id` = '$userid' AND  `item_id` = '$itemid'";
$resultqty = $conn->query($checkitemid);
$numresult = $resultqty->num_rows;
if ($numresult > 0) {
	$sql = "UPDATE `tbl_carts` SET `cart_qty`= (cart_qty + $cartqty),`cart_price`= (cart_price+$cartprice) WHERE `user_id` = '$userid' AND  `item_id` = '$item_id'";
}else{
	$sql = "INSERT INTO `tbl_carts`(`item_id`, `cart_price`, `cart_qty`, `user_id`, `uploader_id`) VALUES ('$itemid','$cartprice','$cartqty','$userid','$uploaderid')";
}

if ($conn->query($sql) === TRUE) {
		$response = array('status' => 'success', 'data' => $sql);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => $sql);
		sendJsonResponse($response);
	}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>