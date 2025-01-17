<?php
// Cấu hình kết nối đến cơ sở dữ liệu
include 'connection.php';

// Chuyển nội dung yêu cầu thành JSON
header('Content-Type: application/json');

// Truy vấn lấy thông tin người dùng
$sql = "SELECT id_nguoi_dung, ten, email, mat_khau, avatar, so_dien_thoai, trang_thai, ngay_tao FROM nguoi_dung";
$result = $conn->query($sql);

// Kiểm tra kết quả truy vấn
if ($result->num_rows > 0) {
    // Lưu trữ kết quả vào mảng
    $users = array();
    
    while($row = $result->fetch_assoc()) {
        // Thêm mỗi người dùng vào mảng
        $users[] = array(
            'id_nguoi_dung' => $row['id_nguoi_dung'],
            'ten' => $row['ten'],
            'email' => $row['email'],
            'mat_khau' => $row['mat_khau'],
            'avatar' => $row['avatar'],
            'so_dien_thoai' => $row['so_dien_thoai'],
            'trang_thai' => $row['trang_thai'],
            'ngay_tao' => $row['ngay_tao'],
        );
    }

    // Trả về dữ liệu người dùng dưới dạng JSON
    echo json_encode($users);
} else {
    echo json_encode(array("message" => "Không có người dùng"));
}

// Đóng kết nối
$conn->close();
?>
