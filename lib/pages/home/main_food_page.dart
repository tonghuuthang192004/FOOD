import 'dart:convert';
import '../ProfilePage/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../FavoriteScreen/FavoriteScreen.dart';
import '../../PromotionPage/PromotionPage.dart';
import '../../cart/cart.dart';
import '../../shared_preferences/shared_preferences.dart';
import 'food_page_body.dart';
import '../../utils/dimensions.dart';
import '../../utils/color.dart';
import '../ProfilePage/ProfilePage.dart';
import 'package:http/http.dart' as http;



Future<int?> fetchUserId(String email) async {
  const String apiUrl = 'http://192.168.30.145/API/getuserID.php?action=get_user_id';

  final Uri uri = Uri.parse('$apiUrl&email=$email');

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('id_nguoi_dung')) {
        return responseData['id_nguoi_dung'];
      } else {
        throw Exception(responseData['message'] ?? 'User not found');
      }
    } else {
      throw Exception('Failed to load user ID: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error fetching user ID: $e');
    return null;
  }
}
class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  int? userId; // Variable to store the user ID

  int _selectedIndex = 0;
  String searchQuery = ''; // Variable to store search query
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchUserIdFromAPI();
  }
  Future<void> fetchUserIdFromAPI() async {
    const String email = 'user@example.com'; // Replace with a dynamic email if needed
    final int? fetchedUserId = await fetchUserId(email);

    if (fetchedUserId != null) {
      setState(() {
        userId = fetchedUserId;
      });
    } else {
      print('Failed to fetch user ID');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  // Update search query when user types or presses search button
  void _searchProducts(String query) {
    setState(() {
      searchQuery = query; // Update search query
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
                Expanded(child: Header()), // Search bar
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FoodPageBody(
                  searchQuery:
                      searchQuery), // Pass search query to FoodPageBody
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(), // Bottom navigation bar
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
          ),
        ),
        SizedBox(width: 20), // Space between the search bar and avatar

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
              color: Colors.orange.shade100,
              // Light background color
              border: Border.all(color: Colors.deepOrange, width: 2),
              // Subtle border around the avatar
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
        BottomNavigationBarItem(
            icon: Icon(Icons.local_offer), label: 'Khuyến mãi'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Yêu Thích'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), label: 'Giỏ hàng'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'Thông tin cá nhân'),
      ],
    );
  }

  void onTapNav(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PromotionPage()));
    }
    if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FavoriteScreen()));
    } else if (index == 3) {
      Map<String, String> userData = await LocalStorage.getUserData();
      String userId = userData['id_nguoi_dung'] ?? '';
        // Điều hướng tới CartPage và truyền userId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(),
          ),
        );

    } else if (index == 4) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

