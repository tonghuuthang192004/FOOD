import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String selectedStatus;
  final Function(String) filterOrders;

  FilterButton({required this.selectedStatus, required this.filterOrders});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => filterOrders('Tất cả'),
            child: Text('Tất cả'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: selectedStatus == 'Tất cả' ? Colors.orange : Colors.grey.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 5,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () => filterOrders('Đã giao'),
            child: Text('Đã giao'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: selectedStatus == 'Đã giao' ? Colors.green : Colors.grey.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 5,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () => filterOrders('Đang giao'),
            child: Text('Đang giao'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: selectedStatus == 'Đang giao' ? Colors.blue : Colors.grey.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 5,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () => filterOrders('Đã hủy'),
            child: Text('Đã hủy'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: selectedStatus == 'Đã hủy' ? Colors.red : Colors.grey.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 5,
            ),
          ),
        ),
      ],
    );
  }
}
