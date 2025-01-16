import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  // Danh sách các đơn hàng đã mua
  final List<Map<String, dynamic>> orderHistory = [
    {
      'orderId': 'ORD001',
      'productName': 'Ragu Delight (Khoai Tây Xốt Bò + Coca)',
      'quantity': 1,
      'price': 86350,
      'date': '2025-01-10',
      'status': 'Đã giao',
      'image': 'assets/images/images1.png',
    },
    {
      'orderId': 'ORD002',
      'productName': 'Spicy Chicken Fries (Khoai Tây Gà Xốt Cay + Coca)',
      'quantity': 2,
      'price': 97550,
      'date': '2025-01-12',
      'status': 'Đang giao',
      'image': 'assets/images/images1.png',
    },
    {
      'orderId': 'ORD003',
      'productName': 'Love Mac & Cheese (Double Mac & Cheese)',
      'quantity': 1,
      'price': 148790,
      'date': '2025-01-14',
      'status': 'Đã giao',
      'image': 'assets/images/images1.png',
    },
  ];

  // List to store filtered orders based on search query
  List<Map<String, dynamic>> filteredOrders = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredOrders = orderHistory; // Default show all orders
  }

  // Method to filter orders based on search query
  void filterOrders(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredOrders = orderHistory; // Show all orders if query is empty
      } else {
        filteredOrders = orderHistory
            .where((order) => order['productName']
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList(); // Filter based on product name
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch sử mua hàng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange, // Màu cam deep
      ),
      body: Column(
        children: [
          // Search bar below the AppBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterOrders(value); // Filter orders as user types
              },
              decoration: InputDecoration(
                labelText: 'Tìm kiếm sản phẩm...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Display filtered orders
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                final totalPrice = order['price'] * order['quantity'];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Hình ảnh sản phẩm
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            order['image'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tên sản phẩm
                              Text(
                                order['productName'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              // Tổng giá
                              Text(
                                'Tổng giá: ${totalPrice.toString()}đ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Ngày mua
                              Text(
                                'Ngày mua: ${order['date']}',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              // Trạng thái đơn hàng
                              Text(
                                'Trạng thái: ${order['status']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: order['status'] == 'Đã giao'
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
