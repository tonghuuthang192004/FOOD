import 'package:flutter/material.dart';
import '../home/food_page_body.dart';
import '../../pay/payment.dart';
import '../../utils/color.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/exandable_text.dart';

class RecommendFoodDetail extends StatefulWidget {
  const RecommendFoodDetail({ super.key, });


  @override
  _RecommendFoodDetailState createState() => _RecommendFoodDetailState();
}

class _RecommendFoodDetailState extends State<RecommendFoodDetail> {
   // Base price for one item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 70,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Dimensions.radius20),
                        topLeft: Radius.circular(Dimensions.radius20))),
                child: Center(
                  child: Column(
                    children: [
                      BigText(
                        text: "KFC",
                        size: Dimensions.font26,
                      ),
                      BigText(text: "90000")
                    ],
                  ),
                ),
              ),
            ),

            backgroundColor: Colors.amber,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
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
                    margin: EdgeInsets.only(
                        left: Dimensions.width20, right: Dimensions.width20),
                    child: const ExpandableText(
                      text:
                      "Bên cạnh những món ăn truyền thống như gà rán và Bơ-gơ, đến với thị trường Việt Nam, KFC đã chế biến thêm một số món để phục vụ những thức ăn hợp khẩu vị người Việt như: Gà Big‘n Juicy, Gà Giòn Không Xương, Cơm Gà KFC, Bắp Cải Trộn … Một số món mới cũng đã được phát triển và giới thiệu tại thị trường Việt Nam, góp phần làm tăng thêm sự đa dạng trong danh mục thực đơn, như: Bơ-gơ Tôm, Lipton, Bánh Egg Tart."
                          "Năm 1997, KFC đã khai trương nhà hàng đầu tiên tại Thành phố Hồ Chí Minh. Đến nay, hệ thống các nhà hàng của KFC đã phát triển tới hơn 140 nhà hàng, có mặt tại hơn 21 tỉnh/thành phố lớn trên cả nước, sử dụng hơn 3.000 lao động đồng thời cũng tạo thêm nhiều việc làm trong ngành công nghiệp bổ trợ tại Việt Nam.",
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bottom bar with Add to Cart and Checkout buttons
          Container(
            height: Dimensions.bottomHeighBar,
            padding: EdgeInsets.only(
                top: Dimensions.height30,
                bottom: Dimensions.height30,
                left: Dimensions.width20,
                right: Dimensions.width20),
            decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20 * 2),
                    topRight: Radius.circular(Dimensions.radius20 * 2))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add to Cart Button
                GestureDetector(
                  onTap: () {
                    // Implement add to cart functionality here
                    print("Added to cart");
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        top: Dimensions.height10,
                        bottom: Dimensions.height10,
                        left: Dimensions.width20,
                        right: Dimensions.width20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_shopping_cart,
                          color: AppColors.mainColor,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        BigText(
                          text: "Add to Cart",
                          color: AppColors.mainColor,
                        ),
                      ],
                    ),
                  ),
                ),
                // Checkout Button
                GestureDetector(
                  onTap: () {
                    // Navigate to FastFoodPaymentScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FastFoodPaymentScreen()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        top: Dimensions.height10,
                        bottom: Dimensions.height10,
                        left: Dimensions.width20,
                        right: Dimensions.width20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: AppColors.mainColor,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart_checkout,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        BigText(
                          text: "Checkout",
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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




