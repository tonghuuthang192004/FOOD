import 'package:flutter/material.dart';
import 'food_page_body.dart';
import '../../utils/dimensions.dart';
import '../../utils/color.dart';
import '../ProfilePage/ProfilePage.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  int _selectedIndex = 0;
  String searchQuery = '';  // Đây là biến lưu trữ truy vấn tìm kiếm
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Cập nhật truy vấn tìm kiếm khi người dùng nhập hoặc nhấn nút tìm kiếm
  void _searchProducts(String query) {
    setState(() {
      searchQuery = query;  // Cập nhật truy vấn tìm kiếm
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header với ô tìm kiếm
          Container(
            margin: const EdgeInsets.only(top: 45, bottom: 15),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Header()),  // Ô tìm kiếm
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FoodPageBody(searchQuery: searchQuery),  // Truyền truy vấn tìm kiếm vào FoodPageBody
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),  // Thanh điều hướng dưới
    );
  }

  // Header gồm ô tìm kiếm
  Widget Header() {
    return Row(
      children: [
        Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            onChanged: _searchProducts,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
        ),
        SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));  // Chuyển đến trang thông tin cá nhân
          },
          child: Image.asset("assets/images/avatar.png", fit: BoxFit.cover, width: 50, height: 50),
        ),
      ],
    );
  }

  // Thanh điều hướng dưới
  Widget BottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.mainColor,
      unselectedItemColor: Colors.grey,
      onTap: onTapNav,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Khuyến mãi'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Đơn hàng'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Thông tin cá nhân'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Yêu Thích'),
      ],
    );
  }

  void onTapNav(int index) {
    if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
