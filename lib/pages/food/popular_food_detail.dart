import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onthi/utils/dimensions.dart';
import 'package:onthi/widgets/app_icon.dart';
import 'dart:convert';

import '../../utils/color.dart';
import '../../widgets/app_column.dart';
import '../../widgets/big_text.dart';
import '../../widgets/exandable_text.dart';
import '../home/food_page_body.dart';

class PopularFoodDetail extends StatefulWidget {
  final Product product;
  const PopularFoodDetail({Key? key, required this.product}) : super(key: key);

  @override
  _PopularFoodDetailState createState() => _PopularFoodDetailState();
}

class _PopularFoodDetailState extends State<PopularFoodDetail> {
  String message = "";

  // Thêm sản phẩm vào giỏ hàng
  Future<void> _addToCart() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.9/API/cart.php?action=add_to_cart'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'id_nguoi_dung': '1', // ID người dùng, có thể thay đổi
          'id_san_pham': widget.product.id.toString(),
          'so_luong': '1', // Giả sử là 1 sản phẩm, có thể thay đổi nếu cần
        },
      );

      final result = json.decode(response.body);
      if (response.statusCode == 200 && result['status'] == 'success') {
        setState(() {
          message = result['message'] ?? 'Sản phẩm đã được thêm vào giỏ hàng';
        });

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sản phẩm đã được thêm vào giỏ hàng!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          message = 'Lỗi khi thêm sản phẩm vào giỏ hàng';
        });

        // Hiển thị thông báo thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi khi thêm sản phẩm vào giỏ hàng!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        message = 'Lỗi kết nối: $e';
      });

      // Hiển thị thông báo lỗi kết nối
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi kết nối: $e"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
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
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: widget.product.imageUrl != null
                          ? NetworkImage(widget.product.imageUrl!)
                          : AssetImage("assets/images/image1.png") as ImageProvider,
                      fit: BoxFit.cover)
              ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BigText(text: widget.product.name, size: Dimensions.font26),
                          BigText(text: widget.product.price.toString(), size: Dimensions.font26)
                        ],
                      ),

                      AppColumn(),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      BigText(text: "Introduce"),
                      Expanded(
                          child: SingleChildScrollView(
                              child: ExpandableText(
                                  text: widget.product.description
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

            // Add to Cart Button with InkWell for effect
            InkWell(
              onTap: _addToCart,
              onHover: (isHovered) {
                setState(() {
                  message = isHovered ? "Hovering on Add to Cart" : "";
                });
              },
              splashColor: Colors.green,
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
            // Checkout Button with InkWell for effect
            InkWell(
              onTap: () {
                // Navigate back to MainFoodPage
                Navigator.pop(context);
              },
              splashColor: Colors.blue,
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
