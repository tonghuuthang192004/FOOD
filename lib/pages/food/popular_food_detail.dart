import 'package:flutter/material.dart';
import 'package:onthi/utils/dimensions.dart';
import 'package:onthi/widgets/app_icon.dart';

import '../../utils/color.dart';
import '../../widgets/app_column.dart';
import '../../widgets/big_text.dart';
import '../../widgets/exandable_text.dart';
import '../home/main_food_page.dart'; // Import your MainFoodPage

class PopularFoodDetail extends StatefulWidget {
  const PopularFoodDetail({super.key});

  @override
  _PopularFoodDetailState createState() => _PopularFoodDetailState();
}

class _PopularFoodDetailState extends State<PopularFoodDetail> {
  int _quantity = 0;
  double _price = 10.0; // Base price

  // Method to update the quantity and price
  void _updateQuantity(int value) {
    setState(() {
      _quantity += value;
      if (_quantity < 0) _quantity = 0; // Prevent negative quantity
      _price = 10.0 * _quantity; // Update price based on quantity
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.popularFoodImage,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/images1.png"),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: Dimensions.popularFoodImage - 20,
              child: Container(
                  padding: EdgeInsets.only(
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      top: Dimensions.height20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Dimensions.radius20),
                          topLeft: Radius.circular(Dimensions.radius20)),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppColumn(
                        text: "Chinese Side",
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      BigText(text: "Introduce"),
                      Expanded(
                          child: SingleChildScrollView(
                              child: ExpandableText(
                                text:
                                "KFC là một trong những chuỗi cửa hàng thức ăn nhanh đầu tiên mở rộng thị phần quốc tế, với nhiều cửa hàng ở Canada, Vương quốc Anh, Mexico và Jamaica vào giữa những năm 60. Trong suốt thập niên 70 và 80, KFC phải trải qua nhiều sự thay đổi về chủ quyền sở hữu công ty hoặc gặp nhiều khó khăn trong việc kinh doanh nhà hàng. Đầu những năm 70, KFC được bán cho Heublein, trước khi sang nhượng lại cho PepsiCo ,Sản phẩm gốc của KFC là những miếng gà rán truyền thống Original Recipe, được khám phá bởi Sanders với Công thức 11 loại thảo mộc và gia vị. Công thức đó đến nay vẫn là một bí mật thương mại. Những phần gà lớn sẽ được phục vụ trong một chiếc xô gà - đã trở thành một điểm nhấn đặc biệt của nhà hàng kể từ khi giới thiệu lần đầu tiên bởi Pete Harman vào năm 1957.",
                              ))),
                    ],
                  ))),
        ],
      ),
      // bottomNavigationBar
      bottomNavigationBar: Container(
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
                // Navigate back to MainFoodPage
                Navigator.pop(context);
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
    );
  }
}