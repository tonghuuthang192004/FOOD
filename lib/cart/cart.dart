
import 'package:flutter/material.dart';

import '../pages/home/main_food_page.dart';

// Ensure this import is correct based on your file structure.

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng của tôi'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final totalPrice = item['price'] * item['quantity'];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                            color: Colors.red,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => decreaseQuantity(index),
                            ),
                            Text(
                              '${item['quantity']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => increaseQuantity(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.black),
                        onPressed: () => removeItem(index),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
