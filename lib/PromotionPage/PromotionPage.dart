import 'package:flutter/material.dart';
import '../ProductBottomSheetPage/ProductBottomSheetPage.dart';
import '../pages/food/food_detail.dart';

class PromotionPage extends StatefulWidget {
  @override
  _PromotionPageState createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  // Danh sách các sản phẩm khuyến mãi
  final List<Map<String, dynamic>> promotionItems = [
    {
      'name': 'Ragu Delight (Khoai Tây Xốt Bò + Coca)',
      'price': 86350,
      'oldPrice': 100000, // Giá gốc để hiển thị giảm giá
      'image': 'assets/images/images1.png',
      'discount': 0.15, // 15% giảm giá
    },
    {
      'name': 'Spicy Chicken Fries (Khoai Tây Gà Xốt Cay + Coca)',
      'price': 97550,
      'oldPrice': 110000,
      'image': 'assets/images/images1.png',
      'discount': 0.2, // 20% giảm giá
    },
    {
      'name': 'Love Mac & Cheese (Double Mac & Cheese)',
      'price': 148790,
      'oldPrice': 170000,
      'image': 'assets/images/images1.png',
      'discount': 0.12, // 12% giảm giá
    },
  ];

  // Danh sách sản phẩm sau khi lọc
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = promotionItems; // Mặc định hiển thị tất cả sản phẩm
  }

  // Hàm lọc sản phẩm theo tên
  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = promotionItems; // Hiển thị tất cả sản phẩm khi không có từ khóa tìm kiếm
      });
    } else {
      setState(() {
        filteredItems = promotionItems
            .where((item) =>
            item['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  // Hàm để mở trang chi tiết sản phẩm
  void _openProductDetails(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendFoodDetail(),
      ),
    );
  }

  // Hàm để mở ProductBottomSheetPage
  void _openBottomSheet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductBottomSheetPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khuyến mãi sản phẩm', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange, // Màu cam deep
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm nằm dưới AppBar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterSearchResults,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm sản phẩm',
                prefixIcon: Icon(Icons.search, color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),
          ),
          // Danh sách sản phẩm sau khi lọc
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final discountedPrice = item['price'] - (item['price'] * item['discount']);

                return GestureDetector(
                  onTap: () => _openProductDetails(item), // Navigate on tap
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Hình ảnh sản phẩm
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              item['image'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tên sản phẩm
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
                                // Giá gốc và giá giảm
                                Row(
                                  children: [
                                    Text(
                                      '${item['oldPrice']}đ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${discountedPrice.toStringAsFixed(0)}đ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red, // Màu đỏ cho giá giảm
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                // Phần trăm giảm giá
                                Text(
                                  'Giảm ${((item['discount'] * 100)).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Nút mua hàng
                          IconButton(
                            icon: Icon(Icons.shopping_cart, color: Colors.deepOrange),
                            onPressed: _openBottomSheet, // Navigate to ProductBottomSheetPage
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
