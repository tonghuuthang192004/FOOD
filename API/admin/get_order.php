<?php
header('Content-Type: application/json; charset=utf-8');  // Đảm bảo trả về JSON UTF-8

include '../connection.php'; // Đảm bảo tệp kết nối đúng

$status = isset($_GET['trang_thai']) ? intval($_GET['trang_thai']) : null; // Nhận tham số trạng thái (nếu có)

$sql = " SELECT 
        dh.id_don_hang AS id_don_hang,
        sp.ten AS product_name,
        ctdh.so_luong AS so_luong,
        dh.ngay_tao AS ngay_tao,
        dh.trang_thai AS trang_thai
    FROM don_hang dh
    JOIN giao_dich gd ON dh.id_giao_dich = gd.id_giao_dich
    JOIN chi_tiet_don_hang ctdh ON dh.id_don_hang = ctdh.id_don_hang
    JOIN san_pham sp ON ctdh.id_san_pham = sp.id_san_pham
";

// Nếu có tham số 'trang_thai', thêm điều kiện lọc
if ($status !== null) {
    $sql .= " WHERE dh.trang_thai = ?";
}

try {
    $stmt = $conn->prepare($sql);
    if ($status !== null) {
        $stmt->bind_param("i", $status);
    }

    $stmt->execute();
    $result = $stmt->get_result();

    $orders = [];
    while ($row = $result->fetch_assoc()) {
        $orders[] = [
            "id_don_hang" => $row["id_don_hang"],
            "ten" => $row["product_name"], // Đảm bảo khớp với mã Flutter
            "so_luong" => $row["so_luong"],
            "ngay_tao" => $row["ngay_tao"],
            "trang_thai" => $row["trang_thai"],
        ];
    }

    echo json_encode(["data" => $orders], JSON_UNESCAPED_UNICODE);
} catch (Exception $e) {
    echo json_encode(["message" => "Error: " . $e->getMessage()], JSON_UNESCAPED_UNICODE);
} finally {
    $stmt->close();
    $conn->close();
}
?>
