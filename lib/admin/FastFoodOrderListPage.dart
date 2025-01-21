import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'EditOrderPage.dart';
import 'OrderDetailPage.dart'; // Import the EditOrderPage

class FastFoodOrderListPage extends StatefulWidget {
  @override
  _FastFoodOrderListPageState createState() => _FastFoodOrderListPageState();
}

class _FastFoodOrderListPageState extends State<FastFoodOrderListPage> {
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedStatus = 'Tất cả';

  // Map trạng thái từ API sang giao diện người dùng
  final Map<int, String> statusMapping = {
    0: 'Đã hủy',
    1: 'Đang giao',
    2: 'Đã giao',
  };

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  /// Lấy danh sách đơn hàng từ API
  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.30.145/API/admin/get_order.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map && data.containsKey('data')) {
          final List<dynamic> ordersData = data['data'];

          setState(() {
            orders = ordersData.map((order) {
              return {
                'orderId': order['id_don_hang']?.toString() ?? 'N/A',
                'productName': order['ten']?.toString() ?? 'Chưa có tên sản phẩm',
                'quantity': order['so_luong'] ?? 0,
                'date': order['ngay_tao']?.toString() ?? 'Không xác định',
                'status': statusMapping[order['trang_thai']] ?? 'Không xác định',
              };
            }).toList();
            applyFilter(); // Áp dụng bộ lọc sau khi nhận dữ liệu
          });
        } else {
          setState(() {
            errorMessage = 'Dữ liệu không hợp lệ từ máy chủ';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Không thể tải dữ liệu. Mã lỗi: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi kết nối: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Áp dụng bộ lọc danh sách đơn hàng theo trạng thái
  void applyFilter() {
    setState(() {
      if (selectedStatus == 'Tất cả') {
        filteredOrders = orders; // Không lọc, hiển thị tất cả
      } else {
        filteredOrders = orders
            .where((order) => order['status'] == selectedStatus)
            .toList();
      }
    });
  }

  /// Hiển thị giao diện danh sách đơn hàng
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đơn hàng'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: selectedStatus,
              dropdownColor: Colors.white,
              items: [
                'Tất cả',
                'Đang giao',
                'Đã giao',
                'Đã hủy',
              ].map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedStatus = newValue!;
                  applyFilter(); // Gọi hàm lọc lại danh sách
                });
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchOrders,
              child: Text('Thử lại'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            ),
          ],
        ),
      )
          : filteredOrders.isEmpty
          ? Center(
        child: Text(
          'Không có đơn hàng nào phù hợp',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return GestureDetector(
            onTap: () {
              if (order['orderId'] == 'N/A') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ID đơn hàng không hợp lệ')),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Admin_OrderListPage(orderId: order['orderId']),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  order['productName'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Số lượng: ${order['quantity']}'),
                    Text('Ngày: ${order['date']}'),
                    Text(
                      'Trạng thái: ${order['status']}',
                      style: TextStyle(
                        color: order['status'] == 'Đã giao'
                            ? Colors.green
                            : order['status'] == 'Đang giao'
                            ? Colors.blue
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    if (order['orderId'] == 'N/A') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ID đơn hàng không hợp lệ')),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditOrderPage(orderId: order['orderId']),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
