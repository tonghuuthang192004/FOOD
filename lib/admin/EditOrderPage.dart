import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditOrderPage extends StatefulWidget {
  final String orderId;

  EditOrderPage({required this.orderId});

  @override
  _EditOrderPageState createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
  late TextEditingController _addressController;
  late TextEditingController _quantityController;
  int _statusId = 1;  // Default status ID (1 corresponds to 'Đang giao')
  bool isLoading = true;
  bool isUpdating = false; // Track if update is in progress
  String errorMessage = '';

  final Map<int, String> statusMapping = {
    0: 'Đã hủy',
    1: 'Đang giao',
    2: 'Đã giao',
  };

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _quantityController = TextEditingController();
    _fetchOrderDetails(); // Fetch order details when the page is initialized
  }

  // Fetch the current order details to pre-fill the fields
  Future<void> _fetchOrderDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.134.203/API/admin/get_order_details.php?id_don_hang=${widget.orderId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data'].isNotEmpty) {
          final order = data['data'][0]; // Assuming the first object contains the order

          setState(() {
            _addressController.text = order['dia_chi'] ?? '';  // Assign address
            _quantityController.text = order['so_luong'].toString();  // Assign quantity
            _statusId = order['trang_thai'] ?? 1;  // Assign the status ID
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Không tìm thấy đơn hàng với ID ${widget.orderId}.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Lỗi kết nối: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi kết nối: $e';
        isLoading = false;
      });
    }
  }

  // Update order details
  Future<void> _updateOrder() async {
    String address = _addressController.text;
    int quantity = int.tryParse(_quantityController.text) ?? 0;

    // Validate address and quantity
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Địa chỉ không thể để trống!')),
      );
      return;
    }
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số lượng phải lớn hơn 0!')),
      );
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.134.203/API/admin/update_order.php'),
        body: {
          'id_don_hang': widget.orderId,
          'trang_thai': _statusId.toString(),
          'dia_chi': address,
          'so_luong': quantity.toString(),
        },
      );

      final data = json.decode(response.body);

      // Check response status and show the appropriate message
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Cập nhật đơn hàng thành công')), // Show server message
        );

        // Pass updated order data back to previous page
        Navigator.pop(context, {
          'id_don_hang': widget.orderId,
          'dia_chi': address,
          'so_luong': quantity,
          'trang_thai': _statusId,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Lỗi cập nhật đơn hàng')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa thông tin đơn hàng'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Địa chỉ:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Nhập địa chỉ',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Số lượng:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  hintText: 'Nhập số lượng',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Text(
                'Trạng thái:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              DropdownButtonFormField<int>(
                value: _statusId,
                onChanged: (newValue) {
                  setState(() {
                    _statusId = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                items: statusMapping.keys.map((statusId) {
                  return DropdownMenuItem<int>(
                    value: statusId,
                    child: Text(statusMapping[statusId]!),
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              // Updated button section:
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: isUpdating ? null : _updateOrder, // Disable button during update
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Full width button
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: isUpdating
                      ? CircularProgressIndicator(color: Colors.white) // Show loader while updating
                      : Text('Cập nhật'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
