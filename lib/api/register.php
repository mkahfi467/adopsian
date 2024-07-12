<?php
// header("Access-Control-Allow-Origin: *"); // Komentar jika tidak dibutuhkan

include '../koneksi.php'; // Sertakan file koneksi database

// Ekstrak data dari request POST
extract($_POST);

if (isset($name) && isset($username) && isset($password)) { // Periksa kelengkapan data

    // Cek username yang sama sebelum insert data
    $sqlCheck = "SELECT * FROM uas_users WHERE username = ?";
    $stmtCheck = $conn->prepare($sqlCheck);
    $stmtCheck->bind_param("s", $username);
    $stmtCheck->execute();
    $resultCheck = $stmtCheck->get_result();

    if ($resultCheck->num_rows > 0) {
        // Username sudah ada, registrasi gagal
        $arr = ["result" => "error", "message" => "Username sudah ada"];
        echo json_encode($arr);
        exit; // Hentikan proses selanjutnya
    }

    // Username belum ada, lanjutkan insert data
    $sql = "INSERT INTO uas_users (name, username, password) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sss", $name, $username, $password);

    if ($stmt->execute()) {
        $arr = ["result" => "success", "message" => "Registrasi berhasil"];
    } else {
        $arr = ["result" => "error", "message" => "Registrasi gagal: " . $conn->error];
    }

    // Tutup statement dan koneksi database
    $stmt->close();
    $stmtCheck->close();
    $conn->close();
} else {
    $arr = ["result" => "error", "message" => "Data tidak lengkap"];
}

echo json_encode($arr);
