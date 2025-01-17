import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/dimensions.dart';
import '../../utils/color.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_column.dart';
import '../../widgets/big_text.dart';
import '../../widgets/exandable_text.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../../pages/./home/./food_page_body.dart';
import '../.././User.dart';
class PopularFoodDetail extends StatefulWidget {
  final Product product;
  PopularFoodDetail({Key? key, required this.product}) : super(key: key);
  @override
  _PopularFoodDetailState createState() => _PopularFoodDetailState();
}

class _PopularFoodDetailState extends State<PopularFoodDetail> {
  String message = "";

  // Thêm sản phẩm vào giỏ hàng
  Future<void> _addToCart() async {
    try {
      Map<String, String> userData = await LocalStorage.getUserData();
      String userId = userData['id_nguoi_dung'] ?? '';

      if (userId.isEmpty) {
        // Hiển thị thông báo nếu người dùng chưa đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Người dùng chưa đăng nhập!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Gửi yêu cầu HTTP tới API
      final response = await http.post(
        Uri.parse('http://192.168.1.9/API/cart.php?action=add_to_cart'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'id_nguoi_dung':userId,
          'id_san_pham': widget.product.id.toString(),
          'so_luong': '1',
        },
      );

      // Xử lý phản hồi từ API
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
          content: Text("Không thể kết nối tới máy chủ. Vui lòng thử lại sau."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
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
          // Ảnh sản phẩm
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
                  fit: BoxFit.cover,
                ),
              ),
            ),

          ),
          Positioned(
            top: 40,  // Điều chỉnh vị trí của icon back từ trên xuống
            left: 10,  // Điều chỉnh vị trí của icon back từ trái sang
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);  // Quay lại trang trước
              },
            ),
          ),

          Positioned(
            top: 40,  // Điều chỉnh vị trí của icon yêu thích từ trên xuống
            right: 10,  // Điều chỉnh vị trí của icon yêu thích từ phải sang
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.white, size: 30),
              onPressed: () {
                // Xử lý sự kiện khi nhấn vào icon yêu thích
                // Bạn có thể thêm logic thay đổi trạng thái yêu thích ở đây
              },
            ),
          ),


          // Nội dung chi tiết sản phẩm
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: Dimensions.popularFoodImage - 20,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius20),
                  topLeft: Radius.circular(Dimensions.radius20),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(text: widget.product.name, size: Dimensions.font26),
                      BigText(text: "\$${widget.product.price}", size: Dimensions.font26),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  AppColumn(),
                  SizedBox(height: Dimensions.height20),
                  BigText(text: "Giới thiệu sản phẩm"),
                  SizedBox(height: Dimensions.height10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ExpandableText(text: widget.product.description),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Thanh điều hướng dưới cùng
      bottomNavigationBar: Container(
        height: Dimensions.bottomHeighBar,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height30,
        ),
        decoration: BoxDecoration(
          color: AppColors.buttonBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius20 * 2),
            topRight: Radius.circular(Dimensions.radius20 * 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nút thêm vào giỏ hàng
            InkWell(
              onTap: _addToCart,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_shopping_cart, color: AppColors.mainColor),
                    SizedBox(width: 10),
                    BigText(text: "ADD TO CART", color: AppColors.mainColor),
                  ],
                ),
              ),
            ),

            // Nút checkout
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: AppColors.mainColor,
                ),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart_checkout, color: Colors.white),
                    SizedBox(width: 10),
                    BigText(text: "Checkout", color: Colors.white),
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
