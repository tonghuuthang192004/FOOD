<?php
include 'connection.php';

$email = $_POST['email'];
$password = $_POST['mat_khau'];

// Kiểm tra xem email và mật khẩu có được gửi lên hay không
if (empty($email) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Vui lòng điền đầy đủ thông tin."]);
    exit;
}

// Sử dụng prepared statement để tránh SQL Injection
$sql = "SELECT * FROM nguoi_dung WHERE email = ?"; 
$stmt = mysqli_prepare($conn, $sql);
if ($stmt === false) {
    echo json_encode(["status" => "error", "message" => "Lỗi truy vấn cơ sở dữ liệu."]); // Thông báo lỗi cụ thể hơn
    exit;
}

// Bind param cho email
mysqli_stmt_bind_param($stmt, "s", $email);

// Thực thi truy vấn
mysqli_stmt_execute($stmt);

// Lấy kết quả truy vấn
$result = mysqli_stmt_get_result($stmt);
$count = mysqli_num_rows($result);

if ($count == 1) {
    $row = mysqli_fetch_assoc($result);
    $hashed_password_input = md5($password); // Băm mật khẩu người dùng bằng MD5

    if ($hashed_password_input == $row['mat_khau']) { // So sánh hai MD5 hash
        // Nếu mật khẩu đúng, trả về id_nguoi_dung và thông tin người dùng
        echo json_encode([
            "status" => "success",
            "message" => "Đăng nhập thành công!",
            "id_nguoi_dung" => $row['id_nguoi_dung'], // Trả về id_nguoi_dung
            "ten" => $row['ten'], // Trả về tên người dùng
            "email" => $row['email'], // Trả về email người dùng
            "avatar" => $row['avatar'], // Trả về avatar người dùng (nếu có)
            "so_dien_thoai" => $row['so_dien_thoai'] // Trả về số điện thoại người dùng (nếu có)
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Sai mật khẩu."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Không tìm thấy người dùng với email này."]);
}

mysqli_stmt_close($stmt);
mysqli_close($conn);
?>
