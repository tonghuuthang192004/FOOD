<?php
header('Content-Type: application/json; charset=utf-8');  // Đảm bảo trả về dữ liệu với mã hóa UTF-8

// Kết nối với cơ sở dữ liệu
include '../connection.php'; 

// Lấy tham số 'id_don_hang' từ query string
$id_don_hang = isset($_GET['id_don_hang']) ? $_GET['id_don_hang'] : null;

// Câu truy vấn SQL để lấy thông tin chi tiết đơn hàng cùng với sản phẩm và giao dịch
$sql = "  SELECT 
        dh.id_don_hang, 
        sp.ten AS product_name, 
        sp.ten_sot AS sauce_name, 
        sp.gia_sot AS sauce_price, 
        ctdh.so_luong, 
        ctdh.gia AS product_price, 
        (ctdh.so_luong * ctdh.gia) AS total_price, 
        dh.so_nha, 
        dh.duong, 
        dh.quan, 
        dh.thanh_pho,
        dh.ghi_chu, 
        dh.trang_thai, 
        dh.ngay_tao, 
        dh.ngay_thanh_toan
    FROM don_hang dh
    JOIN giao_dich gd ON dh.id_giao_dich = gd.id_giao_dich
    JOIN chi_tiet_don_hang ctdh ON dh.id_don_hang = ctdh.id_don_hang
    JOIN san_pham sp ON ctdh.id_san_pham = sp.id_san_pham
    WHERE dh.trang_thai IN (0, 1, 2)
";

// Nếu có tham số 'id_don_hang', thêm điều kiện lọc
if ($id_don_hang) {
    $sql .= " AND dh.id_don_hang = ?"; 
}

$stmt = $conn->prepare($sql);

// Nếu có tham số 'id_don_hang', truyền tham số vào câu truy vấn
if ($id_don_hang) {
    $stmt->bind_param("i", $id_don_hang);  // "i" là kiểu dữ liệu Integer
}

$stmt->execute();
$result = $stmt->get_result();

$orders = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Xử lý từng đơn hàng
        $order = array(
            "id_don_hang" => $row["id_don_hang"],
            "product_name" => $row["product_name"],
            "sauce_name" => $row["sauce_name"],
            "so_luong" => (int)$row["so_luong"], // Chuyển số lượng thành số nguyên
            "product_price" => (float)$row["product_price"], // Giá sản phẩm
            "total_price" => (float)$row["total_price"], // Tổng giá
            "so_nha" => $row["so_nha"],  // Địa chỉ số nhà
            "duong" => $row["duong"],    // Địa chỉ đường
            "quan" => $row["quan"],      // Địa chỉ quận
            "thanh_pho" => $row["thanh_pho"],  // Địa chỉ thành phố
            "ghi_chu" => $row["ghi_chu"],
            "trang_thai" => (int)$row["trang_thai"], // Trạng thái
            "ngay_tao" => $row["ngay_tao"],
            "ngay_thanh_toan" => $row["ngay_thanh_toan"],
        );
        array_push($orders, $order);
    }

    // Trả về dữ liệu JSON với thông tin chi tiết đơn hàng
    echo json_encode(array("data" => $orders), JSON_UNESCAPED_UNICODE);
} else {
    // Trả về thông báo nếu không tìm thấy đơn hàng
    echo json_encode(array("message" => "Không tìm thấy đơn hàng"), JSON_UNESCAPED_UNICODE);
}

// Đóng kết nối
$stmt->close();
$conn->close();
?>
