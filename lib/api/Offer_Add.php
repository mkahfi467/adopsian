<?php
include '../koneksi.php'; // Sertakan file koneksi database

// Ekstrak data dari request POST
extract($_POST);
$user_id = $_POST['user_id'];
$nama_binatang = $_POST['nama_binatang'];
$jenis_hewan = $_POST['jenis_hewan'];
$keterangan = $_POST['keterangan'];

$sql = "INSERT INTO uas_offers (user_id, nama_binatang, jenis_hewan, keterangan) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    // Jika statement gagal dipersiapkan
    $arr = ["result" => "error", "message" => "Prepare failed: " . $conn->error];
} else {
    $stmt->bind_param("isss", $user_id, $nama_binatang, $jenis_hewan, $keterangan);
    if ($stmt->execute()) {
        $arr = ["result" => "success", "message" => "Add offer berhasil"];
    } else {
        $arr = ["result" => "error", "message" => "Execute failed: " . $stmt->error];
    }
    $stmt->close();
}

$conn->close();

header('Content-Type: application/json');
echo json_encode($arr);
