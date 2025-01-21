<?php
header('Content-Type: application/json; charset=utf-8');  // Ensure UTF-8 encoding
include '../connection.php';

// Check if the required fields are provided
if (!isset($_POST['id_don_hang'], $_POST['trang_thai'], $_POST['so_nha'], $_POST['duong'], $_POST['quan'], $_POST['thanh_pho'], $_POST['so_luong'])) {
    echo json_encode(['status' => 'error', 'message' => 'Thiếu tham số cần thiết']);
    exit();
}

// Sanitize and validate input
$id_don_hang = intval($_POST['id_don_hang']);  // Sanitize ID as integer
$trang_thai = $_POST['trang_thai'];  // Trang thái is string, so no need to sanitize further unless you expect non-numeric characters
$so_nha = trim($_POST['so_nha']);  // Trim spaces for the house number
$duong = trim($_POST['duong']);  // Trim spaces for the street
$quan = trim($_POST['quan']);  // Trim spaces for the district
$thanh_pho = trim($_POST['thanh_pho']);  // Trim spaces for the city
$so_luong = intval($_POST['so_luong']);  // Ensure 'so_luong' is an integer

// Ensure 'so_luong' is valid
if ($so_luong <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Số lượng phải lớn hơn 0']);
    exit();
}

// Validate 'trang_thai' to ensure it's a valid value (accepting both strings and integers)
if (!in_array($trang_thai, ['0', '1', '2'], true)) {
    echo json_encode(['status' => 'error', 'message' => 'Trạng thái không hợp lệ']);
    exit();
}

// Prepare the SQL statement to update the order information (don_hang - address and status)
$sql_don_hang = " UPDATE don_hang 
    SET so_nha = ?, duong = ?, quan = ?, thanh_pho = ?, trang_thai = ?
    WHERE id_don_hang = ?
";

// Prepare and execute the query for don_hang
$stmt_don_hang = $conn->prepare($sql_don_hang);
if ($stmt_don_hang === false) {
    echo json_encode(['status' => 'error', 'message' => 'Lỗi câu lệnh SQL (don_hang): ' . $conn->error]);
    exit();
}

// Bind the parameters for don_hang: "s" for string, "i" for integer
$stmt_don_hang->bind_param("ssssii", $so_nha, $duong, $quan, $thanh_pho, $trang_thai, $id_don_hang);

// Execute the query for don_hang
$execute_result_don_hang = $stmt_don_hang->execute();
if (!$execute_result_don_hang) {
    echo json_encode(['status' => 'error', 'message' => 'Lỗi cập nhật đơn hàng: ' . $stmt_don_hang->error]);
    exit();
}

// Prepare the SQL statement to update the order details (chi_tiet_don_hang - quantity)
$sql_chi_tiet = " UPDATE chi_tiet_don_hang 
    SET so_luong = ? 
    WHERE id_don_hang = ?
";

// Prepare and execute the query for chi_tiet_don_hang
$stmt_chi_tiet = $conn->prepare($sql_chi_tiet);
if ($stmt_chi_tiet === false) {
    echo json_encode(['status' => 'error', 'message' => 'Lỗi câu lệnh SQL (chi_tiet_don_hang): ' . $conn->error]);
    exit();
}

// Bind the parameters for chi_tiet_don_hang: "i" for integer
$stmt_chi_tiet->bind_param("ii", $so_luong, $id_don_hang);

// Execute the query for chi_tiet_don_hang
$execute_result_chi_tiet = $stmt_chi_tiet->execute();
if (!$execute_result_chi_tiet) {
    echo json_encode(['status' => 'error', 'message' => 'Lỗi cập nhật chi tiết đơn hàng: ' . $stmt_chi_tiet->error]);
    exit();
}

// Success message
echo json_encode(['status' => 'success', 'message' => 'Cập nhật đơn hàng thành công']);

// Close the statements and connection
$stmt_don_hang->close();
$stmt_chi_tiet->close();
$conn->close();
?>
