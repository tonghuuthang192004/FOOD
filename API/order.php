<?php
// Thiết lập kết nối cơ sở dữ liệu
include 'connection.php';

// Cấu trúc của hàm trả về dữ liệu dưới dạng JSON
function sendResponse($status, $message, $data = null) {
    echo json_encode(array(
        'status' => $status,
        'message' => $message,
        'data' => $data
    ));
}

// 1. Xem chi tiết đơn hàng
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['order_id'])) {
    $orderId = $_GET['order_id'];
    
    $sql = "SELECT * FROM don_hang WHERE id_don_hang = '$orderId'";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $order = $result->fetch_assoc();
        
        // Lấy chi tiết sản phẩm trong đơn hàng
        $orderDetails = array();
        $sqlDetails = "SELECT * FROM chi_tiet_don_hang WHERE id_don_hang = '$orderId'";
        $detailsResult = $conn->query($sqlDetails);
        
        while ($detail = $detailsResult->fetch_assoc()) {
            $product = array(
                'san_pham_ten' => $detail['id_san_pham'],
                'so_luong' => $detail['so_luong'],
                'gia' => $detail['gia']
            );
            array_push($orderDetails, $product);
        }

        sendResponse(200, "Thành công", array('order' => $order, 'details' => $orderDetails));
    } else {
        sendResponse(404, "Không tìm thấy đơn hàng.");
    }
}

// 2. Lọc đơn hàng theo trạng thái
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['status'])) {
    $status = $_GET['status'];
    
    $sql = "SELECT * FROM don_hang WHERE trang_thai = '$status'";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $orders = array();
        while ($order = $result->fetch_assoc()) {
            array_push($orders, $order);
        }
        sendResponse(200, "Thành công", array('orders' => $orders));
    } else {
        sendResponse(404, "Không tìm thấy đơn hàng theo trạng thái này.");
    }
}

// 3. Xem danh sách đơn hàng của người dùng
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['user_id'])) {
    $userId = $_GET['user_id'];
    
    $sql = "SELECT * FROM don_hang WHERE id_nguoi_dung = '$userId'";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $orders = array();
        while ($order = $result->fetch_assoc()) {
            array_push($orders, $order);
        }
        sendResponse(200, "Thành công", array('orders' => $orders));
    } else {
        sendResponse(404, "Không tìm thấy đơn hàng của người dùng này.");
    }
}

// 4. Hủy đơn hàng nếu chưa duyệt
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['order_id'])) {
    $orderId = $_POST['order_id'];
    
    // Kiểm tra trạng thái của đơn hàng
    $sql = "SELECT * FROM don_hang WHERE id_don_hang = '$orderId'";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $order = $result->fetch_assoc();
        
        if ($order['trang_thai'] == 1) { // Chưa duyệt
            // Cập nhật trạng thái đơn hàng thành "hủy"
            $sqlUpdate = "UPDATE don_hang SET trang_thai = 0 WHERE id_don_hang = '$orderId'";
            if ($conn->query($sqlUpdate) === TRUE) {
                sendResponse(200, "Đơn hàng đã bị hủy.");
            } else {
                sendResponse(500, "Có lỗi khi hủy đơn hàng.");
            }
        } else {
            sendResponse(400, "Đơn hàng đã duyệt, không thể hủy.");
        }
    } else {
        sendResponse(404, "Không tìm thấy đơn hàng.");
    }
}

$conn->close();
?>
