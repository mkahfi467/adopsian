<?php
header('Content-Type: application/json'); // Tambahkan header ini untuk memastikan respons dalam format JSON

include '../koneksi.php';

// Ekstrak data dari request POST
$id = $_POST['id'] ?? '';

if (empty($id)) {
    echo json_encode([
        'result' => 'error',
        'message' => 'ID tidak diberikan',
    ]);
    exit;
}

$sql = "SELECT * FROM uas_offers WHERE id = ?";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    // Jika statement gagal dipersiapkan
    echo json_encode([
        'result' => 'error',
        'message' => 'Prepare failed: ' . $conn->error,
    ]);
    exit;
}

$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $data = $result->fetch_assoc(); // Ambil satu data saja karena ID unik
    echo json_encode([
        'result' => 'success',
        'data' => $data,
    ]);
} else {
    echo json_encode([
        'result' => 'error',
        'message' => 'Data tidak ditemukan',
    ]);
}

$stmt->close();
$conn->close();
