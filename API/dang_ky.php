<?php
header('Content-Type: application/json');

include 'connection.php';

// Kiểm tra và nhận giá trị từ POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $ten = isset($_POST['ten']) ? $_POST['ten'] : null;
    $email = isset($_POST['email']) ? $_POST['email'] : null;
    $mat_khau = isset($_POST['mat_khau']) ? md5($_POST['mat_khau']) : null; // Mã hóa mật khẩu
    $so_dien_thoai = isset($_POST['so_dien_thoai']) ? $_POST['so_dien_thoai'] : null;
    $trang_thai = isset($_POST['trang_thai']) ? $_POST['trang_thai'] : 'active';
    $ngay_tao = isset($_POST['ngay_tao']) ? $_POST['ngay_tao'] : null;

    // Kiểm tra nếu các trường không được nhập
    if (empty($ten) || empty($email) || empty($mat_khau) || empty($so_dien_thoai)) {
        echo json_encode(array("success" => false, "message" => "All fields are required"));
        exit;
    }

    // Kiểm tra số điện thoại đã tồn tại
    $sqlCheckPhone = "SELECT * FROM nguoi_dung WHERE so_dien_thoai = '$so_dien_thoai'";
    $resultPhone = $conn->query($sqlCheckPhone);
    if ($resultPhone->num_rows > 0) {
        echo json_encode(array("success" => false, "message" => "Phone number already exists"));
        exit;
    }

    // Kiểm tra email đã tồn tại
    $sqlCheckEmail = "SELECT * FROM nguoi_dung WHERE email = '$email'";
    $resultEmail = $conn->query($sqlCheckEmail);
    if ($resultEmail->num_rows > 0) {
        echo json_encode(array("success" => false, "message" => "Email already exists"));
        exit;
    }

    // Nếu không có số điện thoại hoặc email trùng, thực hiện đăng ký
    $sqlQuery = "INSERT INTO nguoi_dung (ten, email, mat_khau, so_dien_thoai, trang_thai, ngay_tao) 
    VALUES ('$ten', '$email', '$mat_khau', '$so_dien_thoai', '$trang_thai', '$ngay_tao')";

    $res = $conn->query($sqlQuery);
    if ($res) {
        echo json_encode(array("success" => true));  // Đăng ký thành công
    } else {
        echo json_encode(array("success" => false, "message" => "Registration failed. Please try again."));
    }
}
?>
