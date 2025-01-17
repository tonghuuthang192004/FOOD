<?php
// Định nghĩa thông tin kết nối cơ sở dữ liệu
include 'connection.php';
// Tạo kết nối

// Lấy ID người dùng từ tham số query string (nếu có)
$user_id = isset($_GET['user_id']) ?1:$_GET['user_id'] ;// Mặc định lấy người dùng có id = 1

// Truy vấn thông tin người dùng từ cơ sở dữ liệu
$sql = "SELECT id_nguoi_dung, ten, email, mat_khau, avatar, so_dien_thoai, trang_thai, ngay_tao FROM nguoi_dung WHERE id_nguoi_dung = $user_id";
$result = $conn->query($sql);

// Kiểm tra và trả về kết quả
if ($result->num_rows > 0) {
    // Lấy dữ liệu người dùng
    $user = $result->fetch_assoc();
    // Trả về dữ liệu dưới dạng JSON
    echo json_encode($user);
} else {
    echo json_encode(['message' => 'User not found']);
}

// Đóng kết nối
$conn->close();
?>
