import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Admin_OrderListPage extends StatefulWidget {
  final String orderId; // Nhận orderId từ trang trước

  Admin_OrderListPage({required this.orderId}); // Constructor

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
    fetchOrderDetails(); // Gọi hàm tải thông tin chi tiết đơn hàng
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
          'http://192.168.30.145/API/admin/get_order_details.php?id_don_hang=${widget.orderId}',
        ),
      );

      if (response.statusCode == 200) {
        final data = _parseJson(response.body);
        if (data.isNotEmpty) {
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
      final parsed = json.decode(responseBody);
      if (parsed is Map && parsed.containsKey('data')) {
        return parsed;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  // Hàm lấy giá trị từ orderDetails và xử lý triệt để kiểu dữ liệu
  String getFieldValue(dynamic value) {
    if (value == null) return 'Không xác định';
    if (value is String) return value;
    return value.toString();
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
                    _buildDetailRow('Tên sản phẩm', getFieldValue(orderDetails['product_name'])),
                    _buildDetailRow('Sốt', getFieldValue(orderDetails['sauce_name'])),
                    _buildDetailRow('Số lượng', getFieldValue(orderDetails['so_luong'])),
                    _buildDetailRow('Giá sản phẩm', '${getFieldValue(orderDetails['product_price'])} VNĐ'),
                    _buildDetailRow('Tổng giá sản phẩm', '${getFieldValue(orderDetails['total_price'])} VNĐ'),
                    _buildDetailRow('Số nhà', getFieldValue(orderDetails['so_nha'])),
                    _buildDetailRow('Đường', getFieldValue(orderDetails['duong'])),
                    _buildDetailRow('Quận', getFieldValue(orderDetails['quan'])),
                    _buildDetailRow('Thành phố', getFieldValue(orderDetails['thanh_pho'])),
                    _buildDetailRow('Ghi chú', getFieldValue(orderDetails['ghi_chu'])),
                    _buildDetailRow('Ngày tạo', getFieldValue(orderDetails['ngay_tao'])),
                    _buildDetailRow('Ngày thanh toán', getFieldValue(orderDetails['ngay_thanh_toan'])),
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
