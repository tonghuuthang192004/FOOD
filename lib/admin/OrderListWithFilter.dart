import 'package:flutter/material.dart';

import 'OrderDetailScreen.dart';
import 'Order_List_Screen.dart';
class OrderListWithFilter extends StatefulWidget {
  @override
  _OrderListWithFilterState createState() => _OrderListWithFilterState();
}

class _OrderListWithFilterState extends State<OrderListWithFilter> {
  List<Order> orders = [
    Order(id: 1, status: "Pending", quantity: 2),
    Order(id: 2, status: "Completed", quantity: 1),
    // Thêm đơn hàng khác
  ];

  String selectedStatus = "All";

  @override
  Widget build(BuildContext context) {
    List<Order> filteredOrders = selectedStatus == "All"
        ? orders
        : orders.where((order) => order.status == selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Lọc theo trạng thái đơn")),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedStatus,
            items: ["All", "Pending", "Completed"]
                .map((status) => DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedStatus = value!;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
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
          ),
        ],
      ),
    );
  }
}

