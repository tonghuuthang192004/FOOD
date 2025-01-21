<?php
header('Content-Type:application/json');
include 'connection.php';

// Get parameters from request
$search_query = isset($_GET['search_query']) ? $_GET['search_query'] : '';
$category_id = isset($_GET['id_danh_muc']) ? $_GET['id_danh_muc'] : '';

// Build SQL query
$sql = "SELECT sp.id_san_pham, sp.ten as product_name, sp.gia, sp.mo_ta, sp.ten_sot, sp.mo_ta_sot, sp.gia_sot, sp.trang_thai, 
        dm.ten as category_name, ha.hinh_anh
        FROM san_pham sp
        JOIN danh_muc dm ON sp.id_danh_muc = dm.id_danh_muc
        LEFT JOIN hinh_anh_san_pham ha ON sp.id_san_pham = ha.id_san_pham
        WHERE sp.trang_thai = 1";

// Add search query condition if exists
if ($search_query != '') {
    $sql .= " AND sp.ten LIKE '%$search_query%' AND sp.gia LIKE '%$search_query%' ";
}

// Add category filter if exists
if ($category_id != '') {
    $sql .= " AND sp.id_danh_muc = $category_id";
}

$result = $conn->query($sql);

$products = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $product = array(
            "id_san_pham" => $row["id_san_pham"],
            "product_name" => $row["product_name"],
            "price" => number_format($row["gia"], 2, '.', ''),
            "description" => $row["mo_ta"],
            "sauce_name" => $row["ten_sot"],
            "sauce_description" => $row["mo_ta_sot"],
            "sauce_price" => number_format($row["gia_sot"], 2, '.', ''),
            "category_name" => $row["category_name"],
            "image_url" => $row["hinh_anh"] // Added image URL from the new table
        );
        array_push($products, $product);
    }
    echo json_encode($products);
} else {
    echo json_encode(array("message" => "No products found"));
}

$conn->close();
?>
