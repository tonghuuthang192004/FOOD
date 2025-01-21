import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../shared_preferences/shared_preferences.dart';

// Class mô tả đơn hàng
class Order {
  final String orderId;
  final String productName;
  final int quantity;
  final double price; // Thay đổi kiểu giá trị thành double
  final String date;
  late final String status;
  final String address;
  final String paymentMethod;

  Order({
    required this.orderId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.date,
    required this.status,
    required this.address,
    required this.paymentMethod,
  });
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['id_don_hang'].toString(),
      productName: json['ghi_chu'] ?? 'Sản phẩm không xác định', // Default value if 'ghi_chu' is null
      quantity: 1, // Default quantity as 1
      price: json['gia'] != null ? double.tryParse(json['gia'].toString()) ?? 0.0 : 0.0, // Handle null or invalid price
      date: json['ngay_tao'] ?? 'Ngày không xác định', // Default if 'ngay_tao' is null
      status: json['trang_thai'] == 1 ? 'Đang chờ' : 'Đã giao', // Default to 'Đã giao' for non-1 status
      address: '${json['so_nha'] ?? ''} ${json['duong'] ?? ''}, ${json['quan'] ?? ''}, ${json['thanh_pho'] ?? ''}', // Default empty string for address parts
      paymentMethod: json['phuong_thuc_thanh_toan'] ?? 'Chưa xác định', // Default if 'phuong_thuc_thanh_toan' is null
    );
  }
}

// Class API để tương tác với server
class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Hàm lấy danh sách đơn hàng
  Future<List<Order>> fetchOrders(String? status) async {
    // Cung cấp giá trị mặc định cho status nếu nó là null
    String finalStatus = status ?? 'Tất cả';

    final uri = Uri.parse('$baseUrl/order.php?status=$finalStatus');
    final response = await http.get(uri);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // Để xem dữ liệu trả về

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Fetched orders: $data'); // In ra dữ liệu đơn hàng
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // Hàm hủy đơn hàng
  Future<void> cancelOrder(int orderId) async {
    final uri = Uri.parse('$baseUrl/order.php');

    final response = await http.post(uri, body: {
      'action': 'cancel',
      'order_id': orderId.toString(),
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel order');
    }
  }
}

// Màn hình đơn hàng
class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final ApiService apiService = ApiService(baseUrl: 'http://192.168.1.9/API/');
  List<Order> orders = [];
  List<Order> filteredOrders = [];
  String? selectedStatus;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();  // Load user data when page is initialized
    fetchOrders(); // Load orders when screen is opened
  }

  // Hàm để lấy thông tin người dùng
  void _loadUserData() async {
    Map<String, String> userData = await LocalStorage.getUserData();
    setState(() {
      userId = userData['id_nguoi_dung'] ?? '';
    });

    if (userId.isEmpty) {
      print('User ID không hợp lệ');
      throw Exception('User ID không hợp lệ');
    } else {
      print('User ID loaded successfully: $userId');
    }
  }

  // Hàm lấy danh sách đơn hàng
  void fetchOrders([String? status]) async {
    try {
      String finalStatus = status ?? 'Tất cả';
      final ordersList = await apiService.fetchOrders(finalStatus);
      setState(() {
        orders = ordersList;
        filteredOrders = ordersList;
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  // Hàm lọc đơn hàng theo trạng thái
  void filterOrders(String? status) {
    setState(() {
      selectedStatus = status;
      if (status == null || status == 'Tất cả') {
        filteredOrders = orders;
      } else {
        filteredOrders = orders.where((order) => order.status == status).toList();
      }
    });
  }

  // Hàm hủy đơn hàng
  void cancelOrder(int orderId, int index) async {
    try {
      await apiService.cancelOrder(orderId);
      setState(() {
        filteredOrders[index].status = 'Đã hủy'; // Cập nhật trạng thái đơn hàng
      });
    } catch (e) {
      print('Error cancelling order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng của tôi'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => filterOrders('Tất cả'),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: selectedStatus == 'Tất cả' ? Colors.orange : Colors.grey[200],
                    child: Center(child: Text('Tất cả')),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => filterOrders('Đang chờ'),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: selectedStatus == 'Đang chờ' ? Colors.orange : Colors.grey[200],
                    child: Center(child: Text('Đang chờ')),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => filterOrders('Đã giao'),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: selectedStatus == 'Đã giao' ? Colors.orange : Colors.grey[200],
                    child: Center(child: Text('Đã giao')),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => filterOrders('Đã hủy'),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: selectedStatus == 'Đã hủy' ? Colors.orange : Colors.grey[200],
                    child: Center(child: Text('Đã hủy')),
                  ),
                ),
              ),
            ],
          ),
          filteredOrders.isEmpty
              ? Center(child: Text('Không có đơn hàng nào để hiển thị'))
              : Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return Card(
                  child: ListTile(
                    title: Text(order.productName),
                    subtitle: Text('Trạng thái: ${order.status}\nĐịa chỉ: ${order.address}\nThanh toán: ${order.paymentMethod}'),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: order.status != 'Đã hủy'
                          ? () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Xác nhận hủy đơn hàng'),
                          content: Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () {
                                cancelOrder(int.parse(order.orderId), index);
                                Navigator.pop(context);
                              },
                              child: Text('Xác nhận'),
                            ),
                          ],
                        ),
                      )
                          : null,
                    ),
                    onTap: () {
                      // Navigate to order detail page if implemented
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Giả lập LocalStorage (cần thay thế bằng phương thức thực tế của bạn)
