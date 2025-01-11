import 'package:flutter/material.dart';


class FastFoodPaymentScreen extends StatefulWidget {
  @override
  _FastFoodPaymentScreenState createState() => _FastFoodPaymentScreenState();
}

class _FastFoodPaymentScreenState extends State<FastFoodPaymentScreen> {
  String _selectedPaymentMethod = 'Credit Card';
  final double subTotal = 24.50; // Giá tạm tính các món ăn
  final double shippingFee = 3.00; // Phí giao hàng
  final TextEditingController _addressController = TextEditingController(); // Controller để lấy dữ liệu địa chỉ

  @override
  Widget build(BuildContext context) {
    double totalPayment = subTotal + shippingFee;

    return Scaffold(
      appBar: AppBar(
        title: Text('Fast Food Payment'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 1,
        leading: Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView( // Sử dụng SingleChildScrollView để thêm khả năng cuộn
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần nhập địa chỉ giao hàng
              Text(
                'Shipping Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Enter your shipping address',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
              ),
              SizedBox(height: 20),
              // Phần hiển thị các món ăn đã chọn
              Text(
                'Your Order',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              buildOrderItem('Burger', 2, 5.00, 'assets/images/images1.png'), // Sửa đường dẫn đến ảnh
              buildOrderItem('Fries', 1, 3.00, 'assets/images/images1.png'), // Sửa đường dẫn đến ảnh
              buildOrderItem('Coke', 1, 2.50, 'assets/images/images1.png'), // Sửa đường dẫn đến ảnh
              SizedBox(height: 20),
              // Chọn phương thức thanh toán
              Text(
                'Payment Method',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              buildPaymentOption(
                'Credit Card',
                Icons.credit_card,
                isSelected: _selectedPaymentMethod == 'Credit Card',
              ),
              buildPaymentOption(
                'Paypal',
                Icons.account_balance_wallet,
                isSelected: _selectedPaymentMethod == 'Paypal',
              ),
              buildPaymentOption(
                'Cash on Delivery',
                Icons.money,
                isSelected: _selectedPaymentMethod == 'Cash on Delivery',
              ),
              SizedBox(height: 20),
              // Hiển thị tổng tiền
              buildSummaryRow('Sub-Total', '\$${subTotal.toStringAsFixed(2)}'),
              buildSummaryRow('Shipping Fee', '\$${shippingFee.toStringAsFixed(2)}'),
              Divider(),
              buildSummaryRow(
                'Total Payment',
                '\$${totalPayment.toStringAsFixed(2)}',
                isTotal: true,
              ),
              SizedBox(height: 20),
              // Nút xác nhận thanh toán
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý logic thanh toán
                    print('Payment method: $_selectedPaymentMethod');
                    print('Shipping Address: ${_addressController.text}');
                    print('Total Payment: \$${totalPayment.toStringAsFixed(2)}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Confirm Payment',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget để hiển thị một món ăn trong đơn hàng (kèm hình ảnh)
  Widget buildOrderItem(String name, int quantity, double price, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 50, // Kích thước hình ảnh
            height: 50,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$name x$quantity',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Text(
            '\$${(quantity * price).toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Widget để hiển thị tùy chọn thanh toán
  Widget buildPaymentOption(String method, IconData icon, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: Colors.orange),
            SizedBox(width: 10),
            Expanded(child: Text(method)),
            Icon(icon, color: Colors.orange, size: 30),
          ],
        ),
      ),
    );
  }

  // Widget để hiển thị dòng tổng kết tiền
  Widget buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: isTotal ? 18 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              color: isTotal ? Colors.red : Colors.black,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
