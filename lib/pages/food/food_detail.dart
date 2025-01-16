import 'package:flutter/material.dart';
import '../../FavoriteScreen/FavoriteScreen.dart';
import '../../ProductBottomSheetPage/ProductBottomSheetPage.dart';
import '../home/food_page_body.dart';
import '../../pay/payment.dart';
import '../../utils/color.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/exandable_text.dart';


class RecommendFoodDetail extends StatefulWidget {
  const RecommendFoodDetail({super.key});

  @override
  _RecommendFoodDetailState createState() => _RecommendFoodDetailState();
}

class _RecommendFoodDetailState extends State<RecommendFoodDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 70,
            actions: [
              IconButton(
                onPressed: () {
                  // Điều hướng đến trang yêu thích
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite, color: Colors.white),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "KFC",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "90,000 VND",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.deepOrange,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/images1.png",
                fit: BoxFit.cover,
                width: double.maxFinite,
              ),
            ),
            pinned: true,
            expandedHeight: 300,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Bên cạnh những món ăn truyền thống như gà rán và Bơ-gơ, đến với thị trường Việt Nam, KFC đã chế biến thêm một số món để phục vụ những thức ăn hợp khẩu vị người Việt như: Gà Big‘n Juicy, Gà Giòn Không Xương, Cơm Gà KFC, Bắp Cải Trộn … Một số món mới cũng đã được phát triển và giới thiệu tại thị trường Việt Nam, góp phần làm tăng thêm sự đa dạng trong danh mục thực đơn, như: Bơ-gơ Tôm, Lipton, Bánh Egg Tart.\n\n"
                          "Năm 1997, KFC đã khai trương nhà hàng đầu tiên tại Thành phố Hồ Chí Minh. Đến nay, hệ thống các nhà hàng của KFC đã phát triển tới hơn 140 nhà hàng, có mặt tại hơn 21 tỉnh/thành phố lớn trên cả nước, sử dụng hơn 3.000 lao động đồng thời cũng tạo thêm nhiều việc làm trong ngành công nghiệp bổ trợ tại Việt Nam.",
                      style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.deepOrange[50],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Add to Cart Button
            GestureDetector(
              onTap: () {
                print("Added to cart");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductBottomSheetPage()), // Chuyển đến ProductBottomSheetPage
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.deepOrange,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Checkout Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductBottomSheetPage()), // Chuyển đến ProductBottomSheetPage
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_checkout,
                      color: Colors.deepOrange,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Checkout",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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





// class ProductDetailPage extends StatelessWidget {
//   final Product product;
//
//   ProductDetailPage({required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product.name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (product.imageUrl?.isNotEmpty ?? false)
//               Image.network(product.imageUrl!),
//             SizedBox(height: 16),
//             Text(
//               product.name,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Category: ${product.categoryName}',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Price: \$${product.price}',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 8),
//             Text(
//               product.description,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Add to cart logic
//                 // You can add to cart logic here if needed
//               },
//               child: Text('Add to Cart'),
//             ),
//             SizedBox(height: 8),
//             if (product.sauceName.isNotEmpty)
//               Text('Sauce: ${product.sauceName}', style: TextStyle(fontSize: 16)),
//             if (product.sauceDescription.isNotEmpty)
//               Text('Description: ${product.sauceDescription}', style: TextStyle(fontSize: 16)),
//             if (product.saucePrice > 0)
//               Text('Sauce Price: \$${product.saucePrice}', style: TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }
// }




