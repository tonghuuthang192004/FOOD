import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/login/login.dart'; // Ensure the correct path to your LoginPage

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Function to call API to change password
  Future<void> changePassword(String email, String currentPassword, String newPassword, String confirmPassword, BuildContext context) async {
    // URL của API PHP
    final String url = 'http://192.168.1.9/API/changePassword.php';  // Thay đổi URL theo đường dẫn API của bạn

    // Tạo một Map dữ liệu để gửi
    Map<String, String> data = {
      'email': email,
      'current_password': currentPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };

    // Gửi yêu cầu POST tới API PHP
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data), // Mã hóa dữ liệu thành JSON
      );

      // Kiểm tra mã trạng thái trả về
      if (response.statusCode == 200) {
        // Nếu thành công, giải mã dữ liệu trả về từ server
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          // Hiển thị thông báo thành công
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mật khẩu đã được thay đổi thành công.')),
          );
        } else {
          // Hiển thị thông báo lỗi từ API (ví dụ: không đúng email hoặc mật khẩu sai)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${responseData['message']}')),
          );
        }
      } else {
        // Thông báo lỗi khi không thể kết nối tới server
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: Không thể kết nối tới server.')),
        );
      }
    } catch (e) {
      // Thông báo lỗi nếu có sự cố trong quá trình gửi yêu cầu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Change Password'),
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                Fluttertoast.showToast(msg: "Trợ giúp", gravity: ToastGravity.BOTTOM);
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Fluttertoast.showToast(msg: "Cài đặt", gravity: ToastGravity.BOTTOM);
              },
            ),
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/images3.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: Column(
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email, color: Colors.deepOrange),
                              labelText: 'Vui Lòng Nhập Email',
                              labelStyle: TextStyle(color: Colors.deepOrange),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: currentPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.deepOrange),
                              labelText: 'Mật khẩu hiện tại',
                              labelStyle: TextStyle(color: Colors.deepOrange),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: newPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.deepOrange),
                              labelText: 'Mật khẩu mới',
                              labelStyle: TextStyle(color: Colors.deepOrange),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.deepOrange),
                              labelText: 'Nhập lại mật khẩu mới',
                              labelStyle: TextStyle(color: Colors.deepOrange),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: (){
                      String email = emailController.text;
                      String currentPassword = currentPasswordController.text;
                      String newPassword = newPasswordController.text;
                      String confirmPassword = confirmPasswordController.text;

                      // Kiểm tra xem mật khẩu mới có khớp với mật khẩu xác nhận không
                      if (newPassword != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Mật khẩu mới và mật khẩu xác nhận không khớp!')),
                        );
                        return;
                      }

                      // Gọi hàm đổi mật khẩu và truyền context
                      changePassword(email, currentPassword, newPassword, confirmPassword, context);

                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 55.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepOrange,
                            Colors.orangeAccent,
                          ],
                        ),
                      ),
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey.shade300),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        child: Text(
                          'Login Now',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
