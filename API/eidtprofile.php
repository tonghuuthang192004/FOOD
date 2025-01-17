<?php
// Include database connection file
include 'connection.php';

// Set the content type as JSON
header('Content-Type: application/json');

// Get the PUT data
parse_str(file_get_contents("php://input"), $data);

// Retrieve the user's ID (assuming the ID is passed in the URL)
$user_id = isset($data['id_nguoi_dung']) ? (int)$data['id_nguoi_dung'] : 0;
$ten = isset($data['ten']) ? $data['ten'] : '';
$email = isset($data['email']) ? $data['email'] : '';
$so_dien_thoai = isset($data['so_dien_thoai']) ? $data['so_dien_thoai'] : '';

// Check if required fields are provided
if (!$user_id || !$ten || !$email || !$so_dien_thoai) {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    exit();
}

// Sanitize the input to prevent SQL injection
$ten = $conn->real_escape_string($ten);
$email = $conn->real_escape_string($email);
$so_dien_thoai = $conn->real_escape_string($so_dien_thoai);

// Update query
$sql = "UPDATE nguoi_dung SET ten = '$ten', email = '$email', so_dien_thoai = '$so_dien_thoai' WHERE id_nguoi_dung = $user_id";

// Execute the query
if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success", "message" => "User information updated successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error updating user: " . $conn->error]);
}

// Close connection
$conn->close();
?>
