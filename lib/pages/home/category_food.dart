import 'package:flutter/material.dart';
import 'package:onthi/utils/dimensions.dart';

class CategoryWidget extends StatelessWidget {
  final Function(String) onCategorySelected;
  final String selectedCategoryId; // Thêm thuộc tính để theo dõi danh mục được chọn

  const CategoryWidget({
    super.key,
    required this.onCategorySelected,
    required this.selectedCategoryId, // Nhận danh mục đã chọn từ bên ngoài
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.height20,
        horizontal: Dimensions.width20,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCategoryItem(context, "assets/images/burger2.png", "ALL", "0"),
            _buildCategoryItem(context, "assets/images/burger2.png", "Gà Rán", "1"),
            _buildCategoryItem(context, "assets/images/images4.png", "Pizza", "2"),
            _buildCategoryItem(context, "assets/images/images5.png", "Burger", "3"),
            _buildCategoryItem(context, "assets/images/images1.png", "Desserts", "4"),
            _buildCategoryItem(context, "assets/images/pizza2.png", "Combo", "5"),
            _buildCategoryItem(context, "assets/images/burger3.png", "Khuyến Mãi", "6"),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String imagePath, String categoryName, String categoryId) {
    bool isSelected = categoryId == selectedCategoryId;  // Kiểm tra xem danh mục này có được chọn hay không

    return GestureDetector(
      onTap: () {
        onCategorySelected(categoryId);  // Gọi phương thức onCategorySelected khi người dùng chọn danh mục
      },
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.width20),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blueAccent : Colors.white, // Đổi màu khi được chọn
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              categoryName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blueAccent : Colors.black, // Thay đổi màu chữ khi được chọn
              ),
            ),
          ],
        ),
      ),
    );
  }
}
