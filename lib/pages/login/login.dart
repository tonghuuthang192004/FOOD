import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../registerPage/registerPage.dart';
import '../home/main_food_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String kn = "192.168.1.9";  // Địa chỉ IP của server
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Hàm đăng nhập
  Future login() async {
    try {
      var url = Uri.parse("http://$kn/API/login.php");
      var response = await http.post(url, body: {
        "email": emailController.text,
        "mat_khau": passwordController.text,
      });

      var data = json.decode(response.body);

      if (data['status'] == "success") {
        // Kiểm tra xem 'id_nguoi_dung' có trong phản hồi từ server không
        if (data['id_nguoi_dung'] != null) {
          // Lưu user_id vào SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('id_nguoi_dung', data['id_nguoi_dung'].toString());  // Lưu user_id
          await prefs.setString('name', data['ten']);  // Lưu tên người dùng
          await prefs.setString('email', emailController.text);  // Lưu email người dùng

          // Kiểm tra lại xem dữ liệu đã được lưu thành công chưa
          String? userId = prefs.getString('id_nguoi_dung');
          String? userName = prefs.getString('name');

          // In ra thông tin kiểm tra
          if (userId != null && userId.isNotEmpty) {
            print("ID người dùng lưu thành công: $userId");
          } else {
            print("Lưu ID người dùng thất bại");
          }

          if (userName != null && userName.isNotEmpty) {
            print("Tên người dùng lưu thành công: $userName");
          } else {
            print("Lưu tên người dùng thất bại");
          }

          Fluttertoast.showToast(
            msg: "Đăng nhập thành công!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainFoodPage()),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Đăng nhập thất bại! Không tìm thấy ID người dùng.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Đăng nhập thất bại! Kiểm tra lại thông tin.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print("Đã xảy ra lỗi khi kết nối với server: $e");
      Fluttertoast.showToast(
        msg: "Đã xảy ra lỗi khi kết nối với server: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/burger3.png'), // Thay bằng hình nền của bạn
              fit: BoxFit.fitHeight,
              alignment: Alignment.center
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.6), // Lớp phủ mờ để làm rõ nội dung
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(height: 30),
                    Card(
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email, color: Colors.orangeAccent),
                                labelText: 'Email',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock, color: Colors.orangeAccent),
                                labelText: 'Password',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            colors: [Colors.orangeAccent, Colors.deepOrange],
                          ),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterPage()),
                          ),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
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
      ),
    );
  }
}
