import 'package:flutter/material.dart';
import 'OrderDetailPage.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final List<Map<String, dynamic>> allOrders = [
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
    {
      'orderId': 'ORD004',
      'productName': 'Vegan Burger (Burger Chay + Nước Cam)',
      'quantity': 1,
      'price': 120000,
      'date': '2025-01-15',
      'status': 'Đã hủy',
      'image': 'assets/images/images2.png',
    },
  ];

  List<Map<String, dynamic>> filteredOrders = [];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    filteredOrders = allOrders; // Default display all orders
  }

  void filterOrders(String? status) {
    setState(() {
      selectedStatus = status;
      if (status == null || status == 'Tất cả') {
        filteredOrders = allOrders; // Show all orders if "All" is selected
      } else {
        filteredOrders = allOrders
            .where((order) => order['status'] == status)
            .toList(); // Filter based on selected status
      }
    });
  }

  void cancelOrder(int index) {
    setState(() {
      filteredOrders[index]['status'] = 'Đã hủy'; // Cancel the order
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add gradient to the AppBar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Đơn hàng của tôi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Row with 4 columns for status filtering (Including "Đã hủy")
          Row(
            children: [
              // Column 1: Tất cả (All Orders)
              Expanded(
                child: GestureDetector(
                  onTap: () => filterOrders('Tất cả'),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: selectedStatus == 'Tất cả' ? Colors.orange : Colors.grey[200],
                    child: Center(
                      child: Text(
                        'Tất cả',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedStatus == 'Tất cả' ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Column 2: Đã giao (Delivered)
              Expanded(
                child: GestureDetector(
                  onTap: () => filterOrders('Đã giao'),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: selectedStatus == 'Đã giao' ? Colors.green : Colors.grey[200],
                    child: Center(
                      child: Text(
                        'Đã giao',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedStatus == 'Đã giao' ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Column 3: Đang giao (In Progress)
              Expanded(
                child: GestureDetector(
                  onTap: () => filterOrders('Đang giao'),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: selectedStatus == 'Đang giao' ? Colors.orangeAccent : Colors.grey[200],
                    child: Center(
                      child: Text(
                        'Đang giao',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedStatus == 'Đang giao' ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Column 4: Đã hủy (Cancelled)
              Expanded(
                child: GestureDetector(
                  onTap: () => filterOrders('Đã hủy'),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: selectedStatus == 'Đã hủy' ? Colors.red : Colors.grey[200],
                    child: Center(
                      child: Text(
                        'Đã hủy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedStatus == 'Đã hủy' ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // List of filtered orders
          filteredOrders.isEmpty
              ? Center(child: Text('Không có đơn hàng nào để hiển thị'))
              : Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
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
                              Text(
                                'Tổng giá: ${order['price'] * order['quantity']}đ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Trạng thái: ${order['status']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: order['status'] == 'Đã giao'
                                      ? Colors.green
                                      : order['status'] == 'Đã hủy'
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Button to view order details
                        IconButton(
                          icon: Icon(Icons.arrow_forward, color: Colors.deepOrange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailPage(order: order),
                              ),
                            );
                          },
                        ),
                        // Button to cancel the order
                        if (order['status'] != 'Đã hủy') ...[
                          IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Xác nhận hủy đơn hàng'),
                                  content: Text(
                                      'Bạn có chắc chắn muốn hủy đơn hàng này không?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        cancelOrder(index); // Cancel the order
                                        Navigator.pop(context);
                                      },
                                      child: Text('Xác nhận'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
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
