import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final Function(Map<String, dynamic>) viewOrderDetails;
  final Function(Map<String, dynamic>) updateOrder;

  OrderCard({
    required this.order,
    required this.viewOrderDetails,
    required this.updateOrder,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = order['price'] * order['quantity'];
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                order['image'],
                width: 90,
                height: 90,
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tổng giá: ${totalPrice.toString()}đ',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ngày mua: ${order['date']}',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Trạng thái: ${order['status']}',
                    style: TextStyle(
                      color: order['status'] == 'Đã giao'
                          ? Colors.green
                          : order['status'] == 'Đang giao'
                          ? Colors.blue
                          : Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.deepOrange),
              onPressed: () => viewOrderDetails(order),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => updateOrder(order),
            ),
          ],
        ),
      ),
    );
  }
}
