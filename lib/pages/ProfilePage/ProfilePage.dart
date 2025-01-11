import 'package:flutter/material.dart';
import 'package:onthi/pages/login/login.dart';

import '../../ChangePasswordPage/ChangePasswordPage.dart';
import '../../EditProfilePage/EditProfilePage.dart';
import '../../signup/signin_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: Colors.orange, // Customize as per your theme
      ),
      body: ListView(
        children: [
          // Editable field for name
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Tên người dùng'),
            subtitle: const Text('Nguyễn Thanh Tùng'), // You can replace this with dynamic data
            onTap: () {
              // Navigate to edit profile page
            },
          ),
          const Divider(),

          // History purchase
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Lịch sử mua hàng'),
            onTap: () {
              // Navigate to the purchase history page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PurchaseHistoryPage()),
              );
            },
          ),
          const Divider(),

          // Change password
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Đổi mật khẩu'),
            onTap: () {
              // Navigate to change password page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
              );
            },
          ),
          const Divider(),

          // Edit personal information
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Chỉnh sửa thông tin cá nhân'),
            onTap: () {
              // Navigate to edit profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfilePage()),
              );
            },
          ),
          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Đăng xuất'),
            onTap: () {
              // Navigate to SignInScreen and remove all previous screens
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) =>  LoginPage()),
                    (Route<dynamic> route) => false, // This removes all previous routes
              );
            },
          )
        ],
      ),
    );
  }
}

// Placeholder pages for navigation
class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử mua hàng')),
      body: const Center(child: Text('Lịch sử mua hàng sẽ được hiển thị ở đây.')),
    );
  }
}




