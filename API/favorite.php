<?php
header('Content-Type: application/json');
header('Content-Type: application/json; charset=utf-8');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");


include 'connection.php';

$action = isset($_GET['action']) ? $_GET['action'] : '';

switch ($action) {
    
    case 'add_to_favorites':
        addToFavorites($conn);
        break;
    case 'delete_from_favorites':
        deleteFromFavorites($conn);
        break;
    case 'get_favorite_items':
        getFavoriteItems($conn);
        break;
    default:
        echo json_encode(['message' => 'Invalid action']);
        break;
}

// Lấy danh sách sản phẩm có thể thêm vào giỏ hàng kèm theo ảnh sản phẩm
function getProductList($conn) {
    $stmt = $conn->prepare(" 
        SELECT sp.id_san_pham, sp.ten AS product_name, sp.gia, sp.mo_ta, 
               ha.hinh_anh AS image_url
        FROM san_pham sp
        LEFT JOIN hinh_anh_san_pham ha ON sp.id_san_pham = ha.id_san_pham
    ");
    $stmt->execute();
    $result = $stmt->get_result();

    $products = [];
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }

    echo json_encode($products);
}

// Lấy danh sách sản phẩm yêu thích của người dùng
function getFavoriteItems($conn) {
    if (!isset($_GET['id_nguoi_dung'])) {
        echo json_encode(['message' => 'Thiếu tham số id_nguoi_dung']);
        return;
    }

    $id_nguoi_dung = $_GET['id_nguoi_dung'];

    $query = " 
        SELECT yt.id_san_pham, sp.ten, sp.gia, ha.hinh_anh AS image_url
        FROM yeu_thich yt
        JOIN san_pham sp ON yt.id_san_pham = sp.id_san_pham
        LEFT JOIN hinh_anh_san_pham ha ON sp.id_san_pham = ha.id_san_pham
        WHERE yt.id_nguoi_dung = ?
    ";

    $stmt = $conn->prepare($query);
    
    if (!$stmt) {
        echo json_encode(['error' => 'SQL Error: ' . $conn->error]);
        return;
    }

    $stmt->bind_param("i", $id_nguoi_dung);  // Bind the parameter to ensure it's an integer
    $stmt->execute();
    $result = $stmt->get_result();

    $favoriteItems = [];
    while ($row = $result->fetch_assoc()) {
        $favoriteItems[] = $row;
    }

    echo json_encode($favoriteItems);
}

// Thêm sản phẩm vào yêu thích
function addToFavorites($conn) {
    if (!isset($_POST['id_nguoi_dung']) || !isset($_POST['id_san_pham'])) {
        echo json_encode(['message' => 'Thiếu tham số yêu cầu']);
        return;
    }

    $id_nguoi_dung = $_POST['id_nguoi_dung'];
    $id_san_pham = $_POST['id_san_pham'];

    // Kiểm tra xem sản phẩm đã tồn tại trong danh sách yêu thích chưa
    $stmt = $conn->prepare("SELECT * FROM yeu_thich WHERE id_nguoi_dung = ? AND id_san_pham = ?");
    $stmt->bind_param("ii", $id_nguoi_dung, $id_san_pham);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode(['status' => 'error', 'message' => 'Sản phẩm đã có trong danh sách yêu thích']);
    } else {
        // Thêm sản phẩm vào bảng yeu_thich
        $stmt = $conn->prepare("INSERT INTO yeu_thich (id_nguoi_dung, id_san_pham) VALUES (?, ?)");
        $stmt->bind_param("ii", $id_nguoi_dung, $id_san_pham);
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Sản phẩm đã được thêm vào yêu thích']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Lỗi khi thêm sản phẩm vào yêu thích']);
        }
    }
}

// Xóa sản phẩm khỏi danh sách yêu thích
function deleteFromFavorites($conn) {
    if (!isset($_POST['id_nguoi_dung']) || !isset($_POST['id_san_pham'])) {
        echo json_encode(['message' => 'Thiếu tham số yêu cầu']);
        return;
    }

    $id_nguoi_dung = $_POST['id_nguoi_dung'];
    $id_san_pham = $_POST['id_san_pham'];

    // Xóa sản phẩm khỏi danh sách yêu thích
    $stmt = $conn->prepare("DELETE FROM yeu_thich WHERE id_nguoi_dung = ? AND id_san_pham = ?");
    $stmt->bind_param("ii", $id_nguoi_dung, $id_san_pham);
    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Sản phẩm đã được xóa khỏi danh sách yêu thích']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Lỗi khi xóa sản phẩm khỏi danh sách yêu thích']);
    }
}
?>
