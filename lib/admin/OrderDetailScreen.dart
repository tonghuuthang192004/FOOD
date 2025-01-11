import 'package:flutter/material.dart';

import 'Order_List_Screen.dart';
class OrderDetailScreen extends StatelessWidget {
  final Order order;

  OrderDetailScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết đơn hàng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID đơn hàng: ${order.id}"),
            Text("Trạng thái: ${order.status}"),
            Text("Số lượng: ${order.quantity}"),
          ],
        ),
      ),
    );
  }
}
