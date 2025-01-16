import 'package:flutter/material.dart';

import '../MyOrdersPage/OrderDetailPage.dart';
import 'filter_button.dart';
import 'order_card.dart';


class AdminOrderPage extends StatefulWidget {
  @override
  _AdminOrderPageState createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  final List<Map<String, dynamic>> orders = [
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

  List<Map<String, dynamic>> filteredOrders = [];
  String selectedStatus = 'Tất cả';

  @override
  void initState() {
    super.initState();
    filteredOrders = orders; // Initially show all orders
  }

  void filterOrders(String status) {
    setState(() {
      selectedStatus = status;
      if (status == 'Tất cả') {
        filteredOrders = orders;
      } else {
        filteredOrders = orders
            .where((order) => order['status'] == status)
            .toList();
      }
    });
  }

  void viewOrderDetails(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailPage(order: order),
      ),
    );
  }

  void updateOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cập nhật đơn hàng',
          style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                initialValue: order['quantity'].toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Số lượng',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  order['quantity'] = int.tryParse(value) ?? order['quantity'];
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: order['status'],
                onChanged: (String? newStatus) {
                  setState(() {
                    order['status'] = newStatus ?? order['status'];
                  });
                },
                items: ['Đã giao', 'Đang giao', 'Đã hủy'].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Hủy', style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: Text('Cập nhật', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilterButton(
              selectedStatus: selectedStatus,
              filterOrders: filterOrders,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return OrderCard(
                  order: order,
                  viewOrderDetails: viewOrderDetails,
                  updateOrder: updateOrder,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}