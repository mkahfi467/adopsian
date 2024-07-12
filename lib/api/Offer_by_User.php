<?php
include '../koneksi.php';

extract($_POST);
$user_id = "{$_POST['user_id']}";
$sql = "SELECT * from uas_offers o WHERE o.user_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $user_id);
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
