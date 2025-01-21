// import 'package:flutter/material.dart';
//
// import '../pages/food/food_detail.dart'; // Đảm bảo bạn đã nhập đúng trang FoodDetail
//
// import '../pay/payment.dart'; // Đảm bảo bạn nhập đúng trang FastFoodPaymentScreen
//
// class ProductBottomSheetPage extends StatefulWidget {
//   const ProductBottomSheetPage({super.key});
//
//   @override
//   _ProductBottomSheetPageState createState() => _ProductBottomSheetPageState();
// }
//
// class _ProductBottomSheetPageState extends State<ProductBottomSheetPage> {
//   int quantity = 1; // Số lượng mặc định
//   List<String> selectedSauces = []; // Lưu các sốt được chọn
//   final double unitPrice = 100000; // Giá 1 sản phẩm
//
//   // Danh sách các loại sốt
//   final List<String> sauces = ['Ketchup', 'Mayonnaise', 'Barbecue', 'Mustard'];
//
//   @override
//   void initState() {
//     super.initState();
//     // Hiển thị BottomSheet ngay khi trang được mở
//     Future.delayed(Duration.zero, () {
//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,  // Đảm bảo BottomSheet có thể thay đổi chiều cao tùy vào nội dung
//         backgroundColor: Colors.white, // Đặt màu nền là trắng cho phần còn lại phía sau
//         builder: (context) {
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => RecommendFoodDetail()));
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Hình ảnh và thông tin sản phẩm
//                   Row(
//                     children: [
//                       // Hình ảnh sản phẩm
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Image.asset(
//                           'assets/images/images1.png', // Đảm bảo bạn có hình ảnh này trong assets
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       SizedBox(width: 16),
//                       // Thông tin tên và giá
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Product Name',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'Price: ${unitPrice.toStringAsFixed(0)} VND',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//
//                   // Số lượng và nút tăng giảm
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Quantity',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.remove),
//                             onPressed: () {
//                               if (quantity > 1) {
//                                 setState(() {
//                                   quantity--;  // Giảm số lượng
//                                 });
//                               }
//                             },
//                           ),
//                           Text(
//                             '$quantity',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.add),
//                             onPressed: () {
//                               setState(() {
//                                 quantity++;  // Tăng số lượng
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//
//                   // Chọn sốt theo checkbox
//                   Text(
//                     'Sauce',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   ...sauces.map((sauce) {
//                     return CheckboxListTile(
//                       title: Text(sauce),
//                       value: selectedSauces.contains(sauce),
//                       onChanged: (bool? value) {
//                         setState(() {
//                           if (value == true) {
//                             selectedSauces.add(sauce);  // Thêm sốt vào danh sách
//                           } else {
//                             selectedSauces.remove(sauce);  // Xóa sốt khỏi danh sách
//                           }
//                         });
//                       },
//                     );
//                   }).toList(),
//                   SizedBox(height: 16),
//
//                   // Hiển thị tổng tiền
//                   Text(
//                     'Total Price: ${(unitPrice * quantity).toStringAsFixed(0)} VND',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//
//                   // Nút mua
//                   ElevatedButton(
//                     onPressed: () {
//                       // Xử lý khi nhấn nút mua
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text(
//                             'Bought $quantity x Product Name with ${selectedSauces.join(', ')} sauce(s)\nTotal: ${(unitPrice * quantity).toStringAsFixed(0)} VND'),
//                       ));
//                       Navigator.pop(context); // Đóng BottomSheet
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => FastFoodPaymentScreen()),
//                       ); // Điều hướng đến màn hình thanh toán
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepOrange,
//                       padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
//                       minimumSize: Size(double.infinity, 60),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: Text(
//                       'Buy Now',
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(), // Không cần hiển thị nội dung nào trong body
//       ),
//     );
//   }
// }
