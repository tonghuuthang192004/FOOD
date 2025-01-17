
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {


  CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  String message = '';

  final String apiUrl = "http://192.168.1.9/API/cart.php";

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  // Hàm tải giỏ hàng từ API
  Future<void> _loadCartItems() async {
    Map<String, String> userData = await LocalStorage.getUserData();
    String userId = userData['id_nguoi_dung'] ?? '';
    try {
      final response = await http.get(Uri.parse("$apiUrl?action=get_cart_items&id_nguoi_dung=${userId}"));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        print("Cart Items: $data");  // Log cart data

        setState(() {
          cartItems = data.map((item) => Map<String, dynamic>.from(item)).toList();
        });
      } else {
        setState(() {
          message = 'Lỗi khi tải giỏ hàng';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Lỗi kết nối: $e';
      });
    }
  }

  // Hàm cập nhật số lượng sản phẩm trong giỏ
  Future<void> _updateQuantity(int productId, int quantity) async {
    try {
      Map<String, String> userData = await LocalStorage.getUserData();
      String userId = userData['id_nguoi_dung'] ?? '';
      final response = await http.post(
        Uri.parse("$apiUrl?action=update_quantity"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'id_nguoi_dung':userId ,
          'id_san_pham': productId.toString(),
          'so_luong': quantity.toString(),
        },
      );
      final result = json.decode(response.body);
      setState(() {
        message = result['message'] ?? 'Lỗi khi cập nhật số lượng';
      });
      _loadCartItems();
    } catch (e) {
      setState(() {
        message = 'Lỗi kết nối: $e';
      });
    }
  }

  // Hàm xóa sản phẩm khỏi giỏ
  Future<void> _removeFromCart(int productId) async {
    try {
      Map<String, String> userData = await LocalStorage.getUserData();
      String userId = userData['id_nguoi_dung'] ?? '';

      final response = await http.post(
        Uri.parse("$apiUrl?action=delete_from_cart"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'id_nguoi_dung':userId ,
          'id_san_pham': productId.toString(),
        },
      );
      final result = json.decode(response.body);
      setState(() {
        message = result['message'] ?? 'Lỗi khi xóa sản phẩm khỏi giỏ hàng';
      });
      _loadCartItems();
    } catch (e) {
      setState(() {
        message = 'Lỗi kết nối: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = cartItems.fold(0, (sum, item) => sum + double.parse(item['gia']) * item['so_luong']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng của tôi'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(color: message.contains('Lỗi') ? Colors.red : Colors.green, fontSize: 16),
              ),
            SizedBox(height: 10),
            Expanded(
              child: cartItems.isEmpty
                  ? Center(child: Text('Giỏ hàng trống'))
                  : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              item['image_url'],  // Corrected key to 'image_url'
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['ten'],
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${item['gia']} VND',
                                  style: TextStyle(fontSize: 14, color: Colors.deepOrange),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove, color: Colors.deepOrange),
                                      onPressed: () => _updateQuantity(item['id_san_pham'], item['so_luong'] - 1),
                                    ),
                                    Text(
                                      '${item['so_luong']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add, color: Colors.deepOrange),
                                      onPressed: () => _updateQuantity(item['id_san_pham'], item['so_luong'] + 1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeFromCart(item['id_san_pham']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng cộng:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                  Text(
                    '$totalAmount VND',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý thanh toán
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Thanh toán',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
