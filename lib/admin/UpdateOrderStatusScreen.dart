import 'package:flutter/material.dart';

import 'Order_List_Screen.dart';
class UpdateOrderStatusScreen extends StatefulWidget {
  final Order order;

  UpdateOrderStatusScreen({required this.order});

  @override
  _UpdateOrderStatusScreenState createState() =>
      _UpdateOrderStatusScreenState();
}

class _UpdateOrderStatusScreenState extends State<UpdateOrderStatusScreen> {
  String? selectedStatus;
  int? updatedQuantity;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.status;
    updatedQuantity = widget.order.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cập nhật đơn hàng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(labelText: "Trạng thái đơn"),
                items: ["Pending", "Completed"]
                    .map((status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
              ),
              TextFormField(
                initialValue: updatedQuantity.toString(),
                decoration: InputDecoration(labelText: "Số lượng"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  updatedQuantity = int.tryParse(value);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Xử lý cập nhật trạng thái và số lượng đơn hàng ở đây
                  setState(() {
                    widget.order.status = selectedStatus!;
                    widget.order.quantity = updatedQuantity!;
                  });
                  Navigator.pop(context);
                },
                child: Text("Cập nhật"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
