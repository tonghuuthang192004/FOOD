<?php
header('Content-Type: application/json');
include('connection.php');

try {
    // Lấy dữ liệu JSON từ body của request
    $data = json_decode(file_get_contents("php://input"), true);

    // Kiểm tra các thông tin cần thiết có được gửi không
    if (isset($data['user_id'], $data['payment_method'], $data['user_email'], $data['address'], $data['phone'], $data['cart_items'], $data['total_amount'])) {
        // Lấy dữ liệu từ request
        $userId = $data['user_id'];
        $paymentMethod = $data['payment_method'];
        $userEmail = $data['user_email'];
        $address = json_decode($data['address'], true);  // Ensure address is decoded into an array
        $phone = $data['phone'];
        $cartItems = $data['cart_items'];
        $totalAmount = $data['total_amount'];

        // Tạo mã giao dịch duy nhất
        $transactionCode = 'GD' . time();
        
        // Chuyển địa chỉ thành chuỗi JSON nếu cần thiết
        $addressJson = json_encode($address);

        // Tạo giao dịch mới
        $transactionMessage = 'Thanh toán đơn hàng';

        // Câu lệnh SQL để tạo giao dịch
        $transactionQuery = "INSERT INTO giao_dich (id_nguoi_dung, email, dia_chi, dien_thoai, so_tien, so_giao_dich, thong_diep, trang_thai, phuong_thuc_thanh_toan, ngay_tao) 
                             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        $stmt = $conn->prepare($transactionQuery);

        // Kiểm tra xem câu lệnh SQL có thành công không
        if ($stmt === false) {
            echo json_encode(['status' => 'error', 'message' => 'Lỗi chuẩn bị câu lệnh SQL.']);
            exit;
        }

        // Bind các tham số vào câu lệnh SQL (chú ý kiểm tra NULL)
        $status = "1";  // Trạng thái "Đang chờ"
        $stmt->bind_param('isssdssss', $userId, $userEmail, $addressJson, $phone, $totalAmount, $transactionCode, $transactionMessage, $status, $paymentMethod);

        // Thực thi câu lệnh và lấy id giao dịch vừa tạo
        $stmt->execute();
        $transactionId = $stmt->insert_id;

        // Kiểm tra xem giao dịch có được tạo thành công không
        if ($transactionId) {
            // Câu lệnh SQL để tạo đơn hàng
            $orderQuery = "INSERT INTO don_hang (id_nguoi_dung, id_giao_dich, trang_thai, ghi_chu, phuong_thuc_thanh_toan, trang_thai_thanh_toan, ngay_tao, gia, so_nha, duong, quan, thanh_pho) 
                           VALUES (?, ?, 1, ?, ?, 1, NOW(), ?, ?, ?, ?, ?)";
            $stmt = $conn->prepare($orderQuery);

            // Kiểm tra xem câu lệnh SQL có thành công không
            if ($stmt === false) {
                echo json_encode(['status' => 'error', 'message' => 'Lỗi chuẩn bị câu lệnh SQL cho đơn hàng.']);
                exit;
            }

            // Kiểm tra ghi chú có tồn tại không, nếu không có thì sử dụng NULL
            $note = isset($data['note']) ? $data['note'] : NULL; // Ghi chú, có thể là null

            // Gắn các tham số vào câu lệnh SQL
            $stmt->bind_param('iissdssss', $userId, $transactionId, $note, $paymentMethod, $totalAmount, $address['so_nha'], $address['duong'], $address['quan'], $address['thanh_pho']);

            // Thực thi câu lệnh và lấy id đơn hàng vừa tạo
            $stmt->execute();
            $orderId = $stmt->insert_id;

            // Kiểm tra nếu đơn hàng được tạo thành công
            if ($orderId) {
                // Thêm chi tiết đơn hàng
                foreach ($cartItems as $item) {
                    $itemQuery = "INSERT INTO chi_tiet_don_hang (id_don_hang, id_san_pham, ghi_chu, so_luong, gia) 
                                  VALUES (?, ?, ?, ?, ?)";
                    $stmt = $conn->prepare($itemQuery);

                    // Gắn các tham số vào câu lệnh SQL
                    $stmt->bind_param('iisii', $orderId, $item['id_san_pham'], $item['ghi_chu'], $item['so_luong'], $item['gia']);
                    
                    // Thực thi câu lệnh
                    $stmt->execute();
                }

                // Trả về thông báo thành công
                echo json_encode(['status' => 'success', 'message' => 'Thanh toán thành công!']);
            } else {
                // Trả về thông báo lỗi nếu không thể tạo đơn hàng
                echo json_encode(['status' => 'error', 'message' => 'Không thể tạo đơn hàng.']);
            }
        } else {
            // Trả về thông báo lỗi nếu không thể tạo giao dịch
            echo json_encode(['status' => 'error', 'message' => 'Không thể tạo giao dịch.']);
        }
    } else {
        // Trả về thông báo thiếu dữ liệu
        echo json_encode(['status' => 'error', 'message' => 'Thiếu dữ liệu cần thiết!']);
    }
} catch (Exception $e) {
    // Trả về thông báo lỗi nếu có ngoại lệ
    echo json_encode(['status' => 'error', 'message' => 'Đã xảy ra lỗi: ' . $e->getMessage()]);
}

// Đóng kết nối
$conn->close();
?>
