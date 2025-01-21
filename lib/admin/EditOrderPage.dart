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
  late TextEditingController _houseNumberController;
  late TextEditingController _streetController;
  late TextEditingController _districtController;
  late TextEditingController _cityController;
  late TextEditingController _quantityController;
  int _statusId = 1;
  bool isLoading = true;
  bool isUpdating = false;
  String errorMessage = '';

  final Map<int, String> statusMapping = {
    0: 'Đã hủy',
    1: 'Đang giao',
    2: 'Đã giao',
  };

  @override
  void initState() {
    super.initState();
    _houseNumberController = TextEditingController();
    _streetController = TextEditingController();
    _districtController = TextEditingController();
    _cityController = TextEditingController();
    _quantityController = TextEditingController();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.30.145/API/admin/get_order_details.php?id_don_hang=${widget.orderId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          final order = data['data'][0];
          setState(() {
            _houseNumberController.text = order['so_nha'] ?? '';
            _streetController.text = order['duong'] ?? '';
            _districtController.text = order['quan'] ?? '';
            _cityController.text = order['thanh_pho'] ?? '';
            _quantityController.text = order['so_luong'].toString();
            _statusId = order['trang_thai'] ?? 1;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Không tìm thấy đơn hàng với ID ${widget.orderId}';
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

  Future<void> _updateOrder() async {
    String houseNumber = _houseNumberController.text;
    String street = _streetController.text;
    String district = _districtController.text;
    String city = _cityController.text;
    int quantity = int.tryParse(_quantityController.text) ?? 0;

    if (houseNumber.isEmpty ||
        street.isEmpty ||
        district.isEmpty ||
        city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tất cả các trường địa chỉ phải được điền!')),
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
      errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.30.145/API/admin/update_order.php'),
        body: {
          'id_don_hang': widget.orderId,
          'trang_thai': _statusId.toString(),
          'so_nha': houseNumber,
          'duong': street,
          'quan': district,
          'thanh_pho': city,
          'so_luong': quantity.toString(),
        },
      );

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thành công!')),
        );
        Navigator.pop(context, {
          'id_don_hang': widget.orderId,
          'so_nha': houseNumber,
          'duong': street,
          'quan': district,
          'thanh_pho': city,
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
  void dispose() {
    _houseNumberController.dispose();
    _streetController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa thông tin đơn hàng'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _houseNumberController,
              decoration: InputDecoration(
                labelText: 'Số nhà',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _streetController,
              decoration: InputDecoration(
                labelText: 'Đường',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _districtController,
              decoration: InputDecoration(
                labelText: 'Quận',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Thành phố',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Số lượng',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _statusId,
              decoration: InputDecoration(
                labelText: 'Trạng thái',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (newValue) {
                setState(() {
                  _statusId = newValue!;
                });
              },
              items: statusMapping.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isUpdating ? null : _updateOrder,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isUpdating
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Cập nhật',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
