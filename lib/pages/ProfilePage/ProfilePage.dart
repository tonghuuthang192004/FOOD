import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_preferences/shared_preferences.dart';  // Đảm bảo import đúng LocalStorage

import '../../ChangePasswordPage/ChangePasswordPage.dart';
import '../../MyOrdersPage/MyOrdersPage.dart';
import '../../OrderHistoryPage/OrderHistoryPage.dart';
import '../../UpdateProfilePage/UpdateProfilePage.dart';
import '../login/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();  // Tải thông tin người dùng khi khởi tạo
  }

  // Lấy dữ liệu người dùng từ SharedPreferences
  Future<void> _loadUserData() async {
    Map<String, String> userData = await LocalStorage.getUserData();
    if (userData.isNotEmpty) {
      setState(() {
        _nameController.text = userData['email'] ?? '';  // Cập nhật tên người dùng
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Avatar ở giữa trang
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage("assets/images/avatar.png"), // Avatar mặc định
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 20),

            // Tên người dùng
            Center(
              child: Text(
                ' ${_nameController.text}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Các nút chức năng
            _ProfileOption(
              icon: Icons.history,
              title: 'Lịch sử mua hàng',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryPage()),
                );
              },
            ),
            const SizedBox(height: 20),

            _ProfileOption(
              icon: Icons.shopping_cart,
              title: 'Đơn hàng của tôi',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyOrdersPage()),
                );
              },
            ),
            const SizedBox(height: 20),

            _ProfileOption(
              icon: Icons.lock,
              title: 'Đổi mật khẩu',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
            ),
            const SizedBox(height: 20),

            _ProfileOption(
              icon: Icons.edit,
              title: 'Cập nhật thông tin',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                );
              },
            ),
            const SizedBox(height: 20),

            _ProfileOption(
              icon: Icons.exit_to_app,
              title: 'Đăng xuất',
              onPressed: () {
                // Thực hiện hành động đăng xuất
                Fluttertoast.showToast(
                  msg: "Đăng xuất thành công!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xFFFB8C00), backgroundColor: Colors.white, // Màu cam deep cho text và icon
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.deepOrange, width: 2),
        ),
        elevation: 5, // Tạo độ nổi cho nút
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange), // Màu cam deep cho icon
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.deepOrange, // Màu cam deep cho text
            ),
          ),
        ],
      ),
    );
  }
}
