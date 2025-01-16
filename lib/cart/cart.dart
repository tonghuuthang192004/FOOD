import 'package:flutter/material.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Ragu Delight (Khoai Tây Xốt Bò + Coca)',
      'price': 86350,
      'image': 'assets/images/images1.png',
      'quantity': 1
    },
    {
      'name': 'Spicy Chicken Fries (Khoai Tây Gà Xốt Cay + Coca)',
      'price': 97550,
      'image': 'assets/images/images1.png',
      'quantity': 1
    },
    {
      'name': 'Love Mac & Cheese (Double Mac & Cheese)',
      'price': 148790,
      'image': 'assets/images/images1.png',
      'quantity': 1
    },
  ];

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Tính tổng giá trị giỏ hàng
    double totalAmount = cartItems.fold(0, (sum, item) => sum + item['price'] * item['quantity']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng của tôi',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepOrange, // Màu cam deep
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final totalPrice = item['price'] * item['quantity'];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            item['image'],
                            width: screenWidth * 0.2, // Chiều rộng hình ảnh ~20% màn hình
                            height: screenWidth * 0.2,
                            fit: BoxFit.cover, // Đảm bảo không bị vỡ pixel
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${totalPrice}đ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.deepOrange, // Màu cam deep cho giá
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, color: Colors.deepOrange),
                                    onPressed: () => decreaseQuantity(index),
                                  ),
                                  Text(
                                    '${item['quantity']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, color: Colors.deepOrange),
                                    onPressed: () => increaseQuantity(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Tổng giá trị giỏ hàng
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng cộng:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange, // Màu cam deep cho tổng cộng
                  ),
                ),
                Text(
                  '${totalAmount}đ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Màu đỏ cho tổng tiền
                  ),
                ),
              ],
            ),
          ),
          // Nút thanh toán đẹp hơn
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Xử lý thanh toán
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange, // Màu cam deep cho nút
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bo tròn góc nút
                ),
                elevation: 10, // Tạo bóng đổ cho nút
                shadowColor: Colors.deepOrange.withOpacity(0.5), // Màu bóng đổ
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
