<?php
header('Content-Type: application/json');

// Cấu hình kết nối cơ sở dữ liệu
include 'connection.php';

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// Xử lý các phương thức HTTP (GET và POST)
$method = $_SERVER['REQUEST_METHOD'];

// API để load và lọc đơn hàng
if ($method == 'GET') {
    // Lọc đơn hàng theo trạng thái nếu có tham số 'status'
    $status = isset($_GET['status']) ? $_GET['status'] : '';  // Lấy trạng thái từ GET request
    
    // Câu lệnh SQL cơ bản để lọc đơn hàng
    $sql = "SELECT * FROM don_hang";  // Không lọc theo trạng thái mặc định

    // Thêm điều kiện lọc nếu có trạng thái
    if ($status && in_array($status, ['Đang chờ', 'Đã giao', 'Đã hủy'])) {
        if ($status == 'Đang chờ') {
            $sql .= " WHERE trang_thai = 1";  // Trạng thái 1 - Đang chờ
        } elseif ($status == 'Đã giao') {
            $sql .= " WHERE trang_thai = 2";  // Trạng thái 2 - Đã giao
        } elseif ($status == 'Đã hủy') {
            $sql .= " WHERE trang_thai = 0";  // Trạng thái 0 - Đã hủy
        }
    }

    if ($stmt = $conn->prepare($sql)) {
        $stmt->execute();
        $result = $stmt->get_result();
        $orders = [];

        // Lấy kết quả và chuyển đổi thành mảng
        while ($row = $result->fetch_assoc()) {
            $orders[] = $row;
        }

        // Trả về kết quả dưới dạng JSON
        echo json_encode($orders);

        $stmt->close();
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error preparing statement: ' . $conn->error]);
    }
}

// API để hủy đơn hàng
if ($method == 'POST' && isset($_POST['action']) && $_POST['action'] == 'cancel') {
    // Lấy ID đơn hàng từ request
    $orderId = isset($_POST['order_id']) ? $_POST['order_id'] : null;

    if ($orderId) {
        // Cập nhật trạng thái đơn hàng thành "Đã hủy"
        $sql = "UPDATE don_hang SET trang_thai = 0 WHERE id_don_hang = ?";

        if ($stmt = $conn->prepare($sql)) {
            // Liên kết tham số và thực thi câu lệnh
            $stmt->bind_param('i', $orderId); // 'i' là kiểu dữ liệu integer
            $stmt->execute();

            if ($stmt->affected_rows > 0) {
                echo json_encode(['status' => 'success', 'message' => 'Đơn hàng đã được hủy']);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Không tìm thấy đơn hàng để hủy']);
            }

            $stmt->close();
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Error preparing statement: ' . $conn->error]);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Không tìm thấy ID đơn hàng']);
    }
}

$conn->close();
?>
