import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  final Map<String, dynamic> order;

  OrderDetailPage({required this.order});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Map<String, dynamic> order;

  @override
  void initState() {
    super.initState();
    order = widget.order; // Lấy thông tin đơn hàng từ widget
  }

  @override
  Widget build(BuildContext context) {
    // Chuyển đổi giá trị từ int sang double khi cần thiết
    double totalPrice = (order['price'] * order['quantity']).toDouble(); // Tổng giá trị đơn hàng (kiểu double)

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết đơn hàng',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange, // Màu cam deep
        elevation: 0,
        iconTheme: IconThemeData(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh sản phẩm
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  order['image'],
                  width: double.infinity, // Đảm bảo sử dụng kiểu double
                  height: 250.0, // Đảm bảo sử dụng kiểu double
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),

              // Tên sản phẩm
              Text(
                order['productName'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),

              // Số lượng sản phẩm
              _buildInfoRow('Số lượng:', order['quantity'].toString(), Colors.black),
              SizedBox(height: 8),

              // Tổng giá
              _buildInfoRow('Tổng giá:', '$totalPrice đ', Colors.red),
              SizedBox(height: 16),

              // Ngày mua
              _buildInfoRow('Ngày mua:', order['date'], Colors.black54),
              SizedBox(height: 16),

              // Trạng thái đơn hàng
              _buildStatusRow('Trạng thái:', order['status']),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm xây dựng các dòng thông tin (ví dụ Số lượng, Tổng giá)
  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // Hàm xây dựng trạng thái đơn hàng
  Widget _buildStatusRow(String label, String status) {
    Color statusColor = status == 'Đã giao'
        ? Colors.green
        : status == 'Đang giao'
        ? Colors.orange
        : Colors.red;

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 8),
        Text(
          status,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: statusColor,
          ),
        ),
      ],
    );
  }
}
