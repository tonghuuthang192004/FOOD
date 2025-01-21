import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../shared_preferences/shared_preferences.dart';

class FastFoodPaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  FastFoodPaymentScreen({required this.cartItems});

  @override
  _FastFoodPaymentScreenState createState() => _FastFoodPaymentScreenState();
}

class _FastFoodPaymentScreenState extends State<FastFoodPaymentScreen> {
  String _selectedPaymentMethod = 'Credit Card';
  final TextEditingController _addressController = TextEditingController();
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  // Tính tổng giá trị đơn hàng
  void _calculateTotal() {
    _totalAmount = widget.cartItems.fold(0.0, (sum, item) {
      double price = double.parse(item['gia'].toString());
      int quantity = int.parse(item['so_luong'].toString());
      return sum + price * quantity;
    });
  }

  // Hàm gửi dữ liệu thanh toán đến API
  Future<void> _submitPayment() async {
    if (_addressController.text.trim().isEmpty) {
      _showErrorDialog('Địa chỉ không được để trống.');
      return;
    }

    if (widget.cartItems.isEmpty) {
      _showErrorDialog('Giỏ hàng trống. Vui lòng thêm sản phẩm.');
      return;
    }

    try {
      // Hiển thị loading khi đang xử lý thanh toán
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Lấy dữ liệu người dùng từ shared preferences
      Map<String, String> userData = await LocalStorage.getUserData();
      String userId = userData['id_nguoi_dung'] ?? '';

      if (userId.isEmpty) {
        throw Exception('Không tìm thấy ID người dùng');
      }

      double totalAmount = _totalAmount + 3.00; // Phí vận chuyển cố định

      Map<String, dynamic> requestBody = {
        'user_id': userId,
        'payment_method': _selectedPaymentMethod,
        'user_email': userData['email'] ?? 'user@example.com',
        'address': _addressController.text.trim(),
        'phone': userData['phone'] ?? '0987654321',
        'cart_items': widget.cartItems,
        'total_amount': totalAmount
      };

      final response = await http.post(
        Uri.parse("http://192.168.1.9/API/checkout.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Kiểm tra phản hồi từ API
      if (response.statusCode == 200) {
        try {
          // Nếu phản hồi là JSON hợp lệ
          final result = json.decode(response.body.toString());
          if (result['status'] == 'success') {
            // Đóng loading dialog
            Navigator.pop(context); // Đóng dialog loading
            _showSuccessDialog(result['message']);
          } else {
            // Đóng loading dialog
            Navigator.pop(context); // Đóng dialog loading
            _showErrorDialog('Lỗi từ server: ${result['message']}');
          }
        } catch (e) {
          // Lỗi giải mã JSON
          Navigator.pop(context); // Đóng dialog loading
          _showErrorDialog('Phản hồi không hợp lệ từ server:\n${response.body}');
        }
      } else {
        Navigator.pop(context); // Đóng dialog loading
        _showErrorDialog('Lỗi kết nối đến server. Mã trạng thái: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.pop(context); // Đóng dialog loading
      _showErrorDialog('Không thể kết nối đến máy chủ. Vui lòng thử lại sau.\nChi tiết lỗi: ${e.toString()}');
    }
  }

  // Hiển thị thông báo lỗi
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Hiển thị thông báo thành công và quay lại trang giỏ hàng (cart screen)
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thanh toán thành công'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            SizedBox(height: 10),
            Text('Cảm ơn bạn đã mua sắm tại cửa hàng của chúng tôi!'),
            SizedBox(height: 10),
            Text('Thông tin đơn hàng:'),
            SizedBox(height: 5),
            Text('Mã đơn hàng: ${DateTime.now().millisecondsSinceEpoch}', style: TextStyle(fontStyle: FontStyle.italic)),
            Text('Tổng thanh toán: \$${(_totalAmount + 3.00).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              Navigator.pop(context); // Quay về trang giỏ hàng (cart screen)
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double shippingFee = 3.00;
    double totalPayment = _totalAmount + shippingFee;

    return Scaffold(
      appBar: AppBar(
        title: Text('Fast Food Payment'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              // Danh sách sản phẩm
              ...widget.cartItems.map((item) {
                return buildOrderItem(
                  item['ten'],
                  item['so_luong'],
                  double.parse(item['gia']),
                  item['image_url'],
                );
              }).toList(),
              Divider(thickness: 1, color: Colors.grey[300]),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ giao hàng',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('Tổng thanh toán: \$${totalPayment.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Confirm Payment', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderItem(String name, int quantity, double price, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(imagePath, width: 50, height: 50, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text('$name x$quantity', style: TextStyle(fontSize: 16)),
          ),
          Text('\$${(quantity * price).toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
