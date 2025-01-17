<?php
header('Content-Type: application/json');
header('Content-Type: application/json; charset=utf-8');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Check connection
include 'connection.php';

$action = isset($_GET['action']) ? $_GET['action'] : '';

switch ($action) {
    case 'add_to_cart':
        addToCart($conn);
        break;
    case 'update_quantity':
        updateQuantity($conn);
        break;
    case 'delete_from_cart':
        deleteFromCart($conn);
        break;
    case 'get_product_list':
        getProductList($conn);
        break;
    case 'get_cart_items':
        getCartItems($conn);
        break;
    default:
        echo json_encode(['message' => 'Invalid action']);
        break;
}
function getProductList($conn)
{
    // Lấy danh sách sản phẩm có thể thêm vào giỏ hàng kèm theo ảnh sản phẩm
    $stmt = $conn->prepare(" SELECT sp.id_san_pham, sp.ten AS product_name, sp.gia, sp.mo_ta, 
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
function getCartItems($conn)
{
    if (!isset($_GET['id_nguoi_dung'])) {
        echo json_encode(['message' => 'Thiếu tham số id_nguoi_dung']);
        return;
    }

    $id_nguoi_dung = $_GET['id_nguoi_dung'];


    $query = " SELECT c.id_san_pham, p.ten, c.so_luong, p.gia, ha.hinh_anh AS image_url
        FROM cart c
        JOIN san_pham p ON c.id_san_pham = p.id_san_pham
        LEFT JOIN hinh_anh_san_pham ha ON p.id_san_pham = ha.id_san_pham
        WHERE c.id_nguoi_dung = ?
    ";

    $stmt = $conn->prepare($query);
    
    if (!$stmt) {
        echo json_encode(['error' => 'SQL Error: ' . $conn->error]);
        return;
    }

    $stmt->bind_param("i", $id_nguoi_dung);  // Bind the parameter to ensure it's an integer
    $stmt->execute();
    $result = $stmt->get_result();
    
    $cartItems = [];
    while ($row = $result->fetch_assoc()) {
        $cartItems[] = $row;
    }

    echo json_encode($cartItems);
}

function addToCart($conn)
{
    if (!isset($_POST['id_nguoi_dung']) || !isset($_POST['id_san_pham']) || !isset($_POST['so_luong'])) {
        echo json_encode(['message' => 'Thiếu tham số yêu cầu']);
        return;
    }

    $id_nguoi_dung = $_POST['id_nguoi_dung'];
    $id_san_pham = $_POST['id_san_pham'];
    $so_luong = $_POST['so_luong'];

    // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng hay chưa
    $stmt = $conn->prepare("SELECT * FROM cart WHERE id_nguoi_dung = ? AND id_san_pham = ?");
    $stmt->bind_param("ii", $id_nguoi_dung, $id_san_pham);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Sản phẩm đã tồn tại, cập nhật số lượng
        $stmt = $conn->prepare("UPDATE cart SET so_luong = so_luong + ? WHERE id_nguoi_dung = ? AND id_san_pham = ?");
        $stmt->bind_param("iii", $so_luong, $id_nguoi_dung, $id_san_pham);
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Sản phẩm đã được thêm vào giỏ hàng']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Lỗi khi cập nhật giỏ hàng']);
        }
    } else {
        // Sản phẩm chưa tồn tại, thêm mới vào giỏ hàng
        $stmt = $conn->prepare("INSERT INTO cart (id_nguoi_dung, id_san_pham, so_luong) VALUES (?, ?, ?)");
        $stmt->bind_param("iii", $id_nguoi_dung, $id_san_pham, $so_luong);
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Sản phẩm đã được thêm vào giỏ hàng']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Lỗi khi thêm sản phẩm vào giỏ hàng']);
        }
    }
}

function updateQuantity($conn)
{
    if (!isset($_POST['id_nguoi_dung']) || !isset($_POST['id_san_pham']) || !isset($_POST['so_luong'])) {
        echo json_encode(['message' => 'Thiếu tham số yêu cầu']);
        return;
    }

    $id_nguoi_dung = $_POST['id_nguoi_dung'];
    $id_san_pham = $_POST['id_san_pham'];
    $so_luong = $_POST['so_luong'];

    // Cập nhật số lượng sản phẩm trong giỏ hàng
    $stmt = $conn->prepare("UPDATE cart SET so_luong = ? WHERE id_nguoi_dung = ? AND id_san_pham = ?");
    $stmt->bind_param("iii", $so_luong, $id_nguoi_dung, $id_san_pham);
    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Số lượng sản phẩm đã được cập nhật']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Lỗi khi cập nhật số lượng sản phẩm']);
    }
}

function deleteFromCart($conn)
{
    if (!isset($_POST['id_nguoi_dung']) || !isset($_POST['id_san_pham'])) {
        echo json_encode(['message' => 'Thiếu tham số yêu cầu']);
        return;
    }

    $id_nguoi_dung = $_POST['id_nguoi_dung'];
    $id_san_pham = $_POST['id_san_pham'];

    // Xóa sản phẩm khỏi giỏ hàng
    $stmt = $conn->prepare("DELETE FROM cart WHERE id_nguoi_dung = ? AND id_san_pham = ?");
    $stmt->bind_param("ii", $id_nguoi_dung, $id_san_pham);
    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Sản phẩm đã được xóa khỏi giỏ hàng']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Lỗi khi xóa sản phẩm khỏi giỏ hàng']);
    }
}
?>
