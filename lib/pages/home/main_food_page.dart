import 'package:flutter/material.dart';
import 'package:onthi/utils/color.dart';
import 'package:onthi/utils/dimensions.dart';
import '../ProfilePage/ProfilePage.dart';
import '../home/food_page_body.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});
  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  int _selectedIndex = 0;
  void onTapNav(int index) {
    if (index == 3) { // Check if "Thông tin cá nhân" is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()), // Navigate to ProfilePage
      );

    } else {
      setState(() {
        _selectedIndex = index; // Update the selected index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 45, bottom: 15),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(

                  child: Header(),
                ),
              ],
            ),
          ),

          // Body Section

          Expanded(
            child: SingleChildScrollView(
              child: FoodPageBody(),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigation(),

    );

  }
  Widget Header ()
  {
    return Row(
        children: [
          // Search Bar
          Container(
            height: 50,
            width: 300, // Fixed width for the search bar
            decoration: BoxDecoration(
              color: Colors.white, // White background for search bar
              borderRadius: BorderRadius.circular(30), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3), // Softer shadow
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Tìm kiếm",
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black, // Black search icon
                ),
                contentPadding: EdgeInsets.only(top: 12, left: 20), // Adjust padding for better alignment
              ),
            ),
          ),

          // Spacer to push the avatar image to the right
          SizedBox(width: 20),

          // Avatar Image as a clickable button
          GestureDetector(
            onTap: () {
              // Add your onTap functionality here (e.g. navigate to profile)
            },
            child: Image.asset(
              "assets/images/avatar.png",
              fit: BoxFit.cover,
              width: 50, // Width of the avatar image
              height: 50, // Height of the avatar image (same as the container)
            ),
          ),
        ],
      );
  }

  Widget BottomNavigation()
  {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.mainColor,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: onTapNav,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,size: 30,),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer,size: 30),
          label: 'Khuyến mãi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart,size: 30),
          label: 'Đơn hàng',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person,size: 30),
          label: 'Thông tin cá nhân',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite,size: 30),
          label: 'Yêu Thích',
        ),
      ],
    );
  }
}




