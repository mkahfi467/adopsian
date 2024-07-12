<?php
// header('Content-Type: application/json');

include '../koneksi.php';

// Extract data from POST request
$id = $_POST['id'] ?? '';
$nama_binatang = $_POST['nama_binatang'] ?? '';
$jenis_hewan = $_POST['jenis_hewan'] ?? '';
$keterangan = $_POST['keterangan'] ?? '';

if (empty($id) || empty($nama_binatang) || empty($jenis_hewan) || empty($keterangan)) {
    echo json_encode([
        'result' => 'error',
        'message' => 'All fields are required',
    ]);
    exit;
}

$sql = "UPDATE uas_offers SET nama_binatang = ?, jenis_hewan = ?, keterangan = ? WHERE id = ?";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    // If statement preparation failed
    echo json_encode([
        'result' => 'error',
        'message' => 'Prepare failed: ' . $conn->error,
    ]);
    exit;
}

$stmt->bind_param("sssi", $nama_binatang, $jenis_hewan, $keterangan, $id);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode([
        'result' => 'success',
        'message' => 'Offer updated successfully',
    ]);
} else {
    echo json_encode([
        'result' => 'error',
        'message' => 'Failed to update offer or no changes made',
    ]);
}

$stmt->close();
$conn->close();
