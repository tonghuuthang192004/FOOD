<?php
header('Content-Type: application/json');

// Kết nối tới cơ sở dữ liệu
include 'connection.php';  // Tệp kết nối cơ sở dữ liệu của bạn

$action = isset($_GET['action']) ? $_GET['action'] : '';

// Kiểm tra xem có hành động nào được chỉ định không
switch ($action) {
    case 'get_user_id':
        getUserId($conn);
        break;
    default:
        echo json_encode(['message' => 'Invalid action']);
        break;
}

// Hàm lấy ID người dùng dựa trên email
function getUserId($conn) {
    if (!isset($_GET['email'])) {
        echo json_encode(['message' => 'Thiếu tham số email']);
        return;
    }

    $email = $_GET['email'];

    // Truy vấn cơ sở dữ liệu để lấy thông tin người dùng theo email
    $query = "SELECT id_nguoi_dung FROM nguoi_dung WHERE email = ?";
    $stmt = $conn->prepare($query);

    if (!$stmt) {
        echo json_encode(['error' => 'SQL Error: ' . $conn->error]);
        return;
    }

    $stmt->bind_param("s", $email);  // Bind email (kiểu chuỗi)
    $stmt->execute();
    $result = $stmt->get_result();

    // Nếu tìm thấy người dùng, trả về id_nguoi_dung
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo json_encode(['id_nguoi_dung' => $row['id_nguoi_dung']]);
    } else {
        // Nếu không tìm thấy người dùng, trả về thông báo lỗi
        echo json_encode(['message' => 'Người dùng không tồn tại']);
    }
}
?>
