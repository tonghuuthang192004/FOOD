import 'package:flutter/material.dart';
import '../../FavoriteScreen/FavoriteScreen.dart';
import '../../PromotionPage/PromotionPage.dart';
import '../../cart/cart.dart';
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
  String searchQuery = '';  // Variable to store search query
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Update search query when user types or presses search button
  void _searchProducts(String query) {
    setState(() {
      searchQuery = query;  // Update search query
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with search bar
          Container(
            margin: const EdgeInsets.only(top: 45, bottom: 15),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Header()),  // Search bar
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FoodPageBody(searchQuery: searchQuery),  // Pass search query to FoodPageBody
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),  // Bottom navigation bar
    );
  }

  // Header with search bar
  // Header with a modern search bar and improved avatar design
  Widget Header() {
    return Row(
      children: [
        // Search Bar with more modern design
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              onChanged: _searchProducts,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                prefixIcon: Icon(Icons.search, color: Colors.deepOrange),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),  // Space between the search bar and avatar

        // Avatar with circular background and subtle border
        GestureDetector(
          // onTap: () {
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));  // Navigate to profile page
          // },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.shade100,  // Light background color
              border: Border.all(color: Colors.deepOrange, width: 2),  // Subtle border around the avatar
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                "assets/images/avatar.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }


  // Bottom navigation bar with custom styling
  Widget BottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      onTap: onTapNav,
      backgroundColor: Colors.white,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Khuyến mãi'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Yêu Thích'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Giỏ hàng'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Thông tin cá nhân'),
      ],
    );
  }
  void onTapNav(int index) {
    if(index == 1){
      Navigator.push(context, MaterialPageRoute(builder: (context) => PromotionPage()));
    }
    if(index == 2){
      Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen()));
    }else if(index == 3){
      Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(userId: 1,)));
    }else if (index == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
