<?php
// header("Access-Control-Allow-Origin: *");
// $arr = null;
// $conn = new mysqli("localhost", "flutter_160420043", "ubaya", "flutter_160420043");
// if ($conn->connect_error) {
//     $arr = ["result" => "error", "message" => "unable to connect"];
// }
include '../koneksi.php';

extract($_POST);
$sql = "SELECT * FROM uas_users WHERE username=? AND password=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $username, $password);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows > 0) {
    $r = mysqli_fetch_assoc($result);
    $arr = ["result" => "success", "username" => $r['username'], "id" => $r['id']];
} else {
    $arr = ["result" => "error", "message" => "sql error: $sql"];
}
echo json_encode($arr);
$stmt->close();
$conn->close();
