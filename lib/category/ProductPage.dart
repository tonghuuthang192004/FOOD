import 'package:flutter/material.dart';
class ProductPage extends StatelessWidget {
  final String categoryName;

  const ProductPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Center(
        child: Text(
          'Danh sách sản phẩm của $categoryName',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}