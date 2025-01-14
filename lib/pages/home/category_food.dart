// import 'package:flutter/material.dart';
// import '../../utils/dimensions.dart';
//
// class CategoryWidget extends StatefulWidget {
//   final Function(String) onCategorySelected; // Callback để gửi categoryName khi chọn danh mục
//
//   const CategoryWidget({super.key, required this.onCategorySelected});
//
//   @override
//   State<CategoryWidget> createState() => _CategoryWidgetState();
// }
//
// class _CategoryWidgetState extends State<CategoryWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(
//         vertical: Dimensions.height20,
//         horizontal: Dimensions.width20,
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,  // Enable horizontal scrolling
//         child: Row(
//           children: [
//             _buildCategoryItem(context, "assets/images/images3.png", "Burgers"),
//             _buildCategoryItem(context, "assets/images/images4.png", "Pizza"),
//             _buildCategoryItem(context, "assets/images/images5.png", "Drinks"),
//             _buildCategoryItem(context, "assets/images/pizza1.png", "Desserts"),
//             _buildCategoryItem(context, "assets/images/pizza2.png", "Combo"),
//             _buildCategoryItem(context, "assets/images/burger3.png", "Khuyến Mãi"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Function to build a category item
//   Widget _buildCategoryItem(BuildContext context, String imagePath, String categoryName) {
//     return GestureDetector(
//       onTap: () {
//         // Gọi hàm callback khi người dùng chọn một danh mục
//         widget.onCategorySelected(categoryName);
//       },
//       child: Padding(
//         padding: EdgeInsets.only(right: Dimensions.width20),
//         child: Column(
//           children: [
//             Container(
//               width: 70,
//               height: 70,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//                 image: DecorationImage(
//                   image: AssetImage(imagePath),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: 12),
//             Text(
//               categoryName,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
