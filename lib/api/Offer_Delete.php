<?php
include '../koneksi.php';

extract($_POST);
$id = $_POST['id'];

$sql = "DELETE FROM uas_offers WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    $arr = ["result" => "success", "message" => "Offer deleted successfully"];
} else {
    $arr = ["result" => "error", "message" => "Failed to delete offer"];
}

echo json_encode($arr);
$stmt->close();
$conn->close();
