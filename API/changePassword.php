<?php
header('Content-Type: application/json');
header('Content-Type: application/json; charset=utf-8');

include 'connection.php';  // Cấu hình kết nối cơ sở dữ liệu

// Lấy dữ liệu từ POST
$data = json_decode(file_get_contents("php://input"), true);

// Kiểm tra nếu không có dữ liệu hoặc JSON không hợp lệ
if ($data === null) {
    echo json_encode(["status" => "error", "message" => "Dữ liệu không hợp lệ hoặc không được gửi."]);
    exit;
}

$username = isset($data['email']) ? $data['email'] : null;
$password = isset($data['current_password']) ? $data['current_password'] : null;
$newpassword = isset($data['new_password']) ? $data['new_password'] : null;
$confirmnewpassword = isset($data['confirm_password']) ? $data['confirm_password'] : null;

// Kiểm tra xem có điền đủ thông tin không
if (empty($username) || empty($password) || empty($newpassword) || empty($confirmnewpassword)) {
    echo json_encode(["status" => "error", "message" => "Vui lòng điền đầy đủ thông tin."]);
    exit;
}

// Kiểm tra mật khẩu mới và mật khẩu xác nhận có khớp không
if ($newpassword !== $confirmnewpassword) {
    echo json_encode(["status" => "error", "message" => "Mật khẩu mới và xác nhận mật khẩu không khớp."]);
    exit;
}

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Kết nối cơ sở dữ liệu thất bại: " . $conn->connect_error]));
}

// Truy vấn để lấy mật khẩu từ cơ sở dữ liệu
$query = "SELECT mat_khau FROM nguoi_dung WHERE email = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $username);
$stmt->execute();
$stmt->store_result();

// Kiểm tra nếu email tồn tại
if ($stmt->num_rows == 0) {
    echo json_encode(["status" => "error", "message" => "Tên đăng nhập không tồn tại."]);
    exit;
}

// Lấy mật khẩu hiện tại từ cơ sở dữ liệu
$stmt->bind_result($db_password);
$stmt->fetch();

if (!preg_match('/[A-Z]/', $newpassword)) {
    echo json_encode(["status" => "error", "message" => "Mật khẩu mới phải chứa ít nhất một ký tự viết hoa."]);
    exit;
}

if (!preg_match('/[\W_]/', $newpassword)) { // kiểm tra ký tự đặc biệt (chữ cái không phải là chữ và số)
    echo json_encode(["status" => "error", "message" => "Mật khẩu mới phải chứa ít nhất một ký tự đặc biệt."]);
    exit;
}
// Kiểm tra mật khẩu hiện tại nhập vào có đúng không (so sánh với mật khẩu đã mã hóa MD5)
if (md5($password) !== $db_password) {
    echo json_encode(["status" => "error", "message" => "Mật khẩu hiện tại không đúng."]);
    exit;
}

// Mã hóa mật khẩu mới (MD5)
$new_password_hashed = md5($newpassword);

// Cập nhật mật khẩu mới vào cơ sở dữ liệu
$update_query = "UPDATE nguoi_dung SET mat_khau = ? WHERE email = ?";
$update_stmt = $conn->prepare($update_query);
$update_stmt->bind_param("ss", $new_password_hashed, $username);
$update_stmt->execute();

// Kiểm tra xem có cập nhật thành công không
if ($update_stmt->affected_rows > 0) {
    echo json_encode(["status" => "success", "message" => "Mật khẩu đã được thay đổi thành công."]);
} else {
    echo json_encode(["status" => "error", "message" => "Đã có lỗi xảy ra khi thay đổi mật khẩu."]);
}

// Đóng kết nối
$stmt->close();
$update_stmt->close();
$conn->close();
?>
