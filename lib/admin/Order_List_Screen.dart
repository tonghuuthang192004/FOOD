import 'package:flutter/material.dart';

import 'OrderDetailScreen.dart';
class OrderListScreen extends StatelessWidget {
  final List<Order> orders = [
    Order(id: 1, status: "Pending", quantity: 2),
    Order(id: 2, status: "Completed", quantity: 1),
    // Thêm các đơn hàng khác
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách đơn")),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text("Đơn hàng #${order.id}"),
            subtitle: Text("Trạng thái: ${order.status}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(order: order),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Order {
  final int id;
  late final String status;
  late final int quantity;

  Order({required this.id, required this.status, required this.quantity});
}
