import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Admin_OrderListPage extends StatefulWidget {
  final String orderId;

  Admin_OrderListPage({required this.orderId});

  @override
  _Admin_OrderListPageState createState() => _Admin_OrderListPageState();
}

class _Admin_OrderListPageState extends State<Admin_OrderListPage> {
  Map<String, dynamic> orderDetails = {}; // Chi tiết đơn hàng
  bool isLoading = true; // Biến để theo dõi trạng thái tải dữ liệu
  String errorMessage = ''; // Thông báo lỗi nếu có

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  // Hàm để gọi API PHP và lấy thông tin chi tiết đơn hàng
  Future<void> fetchOrderDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = ''; // Reset error message
    });

    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.134.203/API/admin/get_order_details.php?id_don_hang=${widget.orderId}',
        ),
      );

      // Log the response status and body for debugging
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = _parseJson(response.body);
        if (data!.isNotEmpty) {
          setState(() {
            orderDetails = data['data'].isNotEmpty ? data['data'][0] : {};
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

  // Hàm phân tích dữ liệu JSON, tách riêng để dễ kiểm soát lỗi
  Map _parseJson(String responseBody) {
    try {
      // Log the response to ensure it's valid JSON
      debugPrint('Response: $responseBody');

      final parsed = json.decode(responseBody);
      if (parsed is Map && parsed.containsKey('data')) {
        return parsed;
      } else {
        debugPrint('Unexpected JSON structure: $parsed');
        return {};
      }
    } catch (e) {
      debugPrint('Lỗi phân tích JSON: $e');
      return {};
    }
  }

  // Hàm lấy giá trị từ orderDetails và xử lý triệt để kiểu dữ liệu
  String getFieldValue(dynamic value) {
    if (value == null) return 'Không xác định'; // Handle null
    if (value is String) return value;          // Return if already String
    return value.toString();                    // Convert int/double to String
  }

  // Hàm xây dựng hàng chi tiết (label và value)
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm xây dựng hàng trạng thái đơn hàng (label và value)
  Widget _buildStatusRow() {
    String orderStatus = getFieldValue(orderDetails['trang_thai']); // Trạng thái đơn hàng
    String statusText = 'Chưa xác định'; // Mặc định
    Color statusColor = Colors.red; // Màu sắc trạng thái

    // Thay đổi thông điệp và màu sắc dựa trên trạng thái đơn hàng
    if (orderStatus == '1') {
      statusText = 'Đang giao';
      statusColor = Colors.amber;
    } else if (orderStatus == '2') {
      statusText = 'Đã giao';
      statusColor = Colors.green;
    } else if (orderStatus == '0') {
      statusText = 'Đã hủy';
      statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Trạng thái:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          Expanded(
            child: Text(
              statusText,
              textAlign: TextAlign.right,
              style: TextStyle(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 10,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã đơn hàng: ${getFieldValue(orderDetails['id_don_hang'])}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(height: 10),
                    _buildStatusRow(),  // Hiển thị trạng thái đơn hàng
                    _buildDetailRow(
                      'Tên sản phẩm',
                      getFieldValue(orderDetails['product_name']),
                    ),
                    _buildDetailRow(
                      'Sốt',
                      getFieldValue(orderDetails['sauce_name']),
                    ),
                    _buildDetailRow(
                      'Số lượng',
                      getFieldValue(orderDetails['so_luong']),
                    ),
                    _buildDetailRow(
                      'Giá sản phẩm',
                      '${getFieldValue(orderDetails['product_price'])} VNĐ',
                    ),
                    _buildDetailRow(
                      'Tổng giá sản phẩm',
                      '${getFieldValue(orderDetails['total_price'])} VNĐ',
                    ),
                    _buildDetailRow(
                      'Địa chỉ',
                      getFieldValue(orderDetails['dia_chi']),
                    ),
                    _buildDetailRow(
                      'Ghi chú',
                      getFieldValue(orderDetails['ghi_chu']),
                    ),
                    _buildDetailRow(
                      'Ngày tạo',
                      getFieldValue(orderDetails['ngay_tao']),
                    ),
                    _buildDetailRow(
                      'Ngày thanh toán',
                      getFieldValue(orderDetails['ngay_thanh_toan']),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
