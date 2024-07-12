<?php
// header("Access-Control-Allow-Origin: *");
// $arr = null;
// $conn = new mysqli("localhost", "flutter_160420043", "ubaya", "flutter_160420043");
// if ($conn->connect_error) {
//     $arr = ["result" => "error", "message" => "unable to connect"];
// }
include '../koneksi.php';

extract($_POST);
// $cari = "%{$_POST['cari']}%";
$sql = "SELECT o.* FROM uas_offers o LEFT JOIN uas_propose p ON o.id = p.offer_id WHERE p.status = 0 || p.offer_id IS NULL";
// $sql = "SELECT o.*
// FROM uas_offers o
// LEFT JOIN uas_propose p ON o.id = p.offer_id
// WHERE p.offer_id IS NULL";
$stmt = $conn->prepare($sql);
// $stmt->bind_param("s", $cari);
$stmt->execute();
$result = $stmt->get_result();
$data = [];
if ($result->num_rows > 0) {
    while ($r = $result->fetch_assoc()) {
        array_push($data, $r);
    }
    $arr = ["result" => "success", "data" => $data];
} else {
    $arr = ["result" => "error", "message" => "sql error: $sql"];
}
echo json_encode($arr);
$stmt->close();
$conn->close();
