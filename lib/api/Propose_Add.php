<?php
include '../koneksi.php';

$user_id = $_POST['user_id'];
$offer_id = $_POST['offer_id'];
$pesan = $_POST['pesan'];

$sql = "INSERT INTO uas_propose (user_id, offer_id, pesan, status) VALUES (?, ?, ?, 0)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("iis", $user_id, $offer_id, $pesan);
$stmt->execute();

$response = ["result" => "success"];
echo json_encode($response);

$stmt->close();
$conn->close();
?>
