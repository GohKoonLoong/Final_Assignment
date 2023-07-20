<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['userid'])){
  $userid = $_POST['userid']; 
  $sqlcard = "SELECT * FROM `tbl_cards` WHERE user_id = $userid";
}

$result = $conn->query($sqlcard);
if ($result->num_rows > 0) {
    $cardlists["cards"] = array();
  while ($row = $result->fetch_assoc()) {
        $cardlist = array();
        $cardlist['bank_name'] = $row['bank_name'];
        $cardlist['card_number'] = $row['card_number'];
        $cardlist['card_expiry'] = $row['card_expiry'];
        $cardlist['card_cvv'] = $row['card_cvv'];
        array_push($cardlists["cards"] ,$cardlist);
    }
    $response = array('status' => 'success', 'data' => $cardlists);
    sendJsonResponse($response);
}else{
     $response = array('status' => 'failed', 'data' => $cardlists);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}