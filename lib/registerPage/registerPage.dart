import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../pages/login/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _tenController = TextEditingController();
  final _emailController = TextEditingController();
  final _matKhauController = TextEditingController();
  final _soDienThoaiController = TextEditingController();

  bool _isPasswordVisible = false; // Boolean to toggle password visibility

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    } else if (value.length < 8) {
      return 'Tên người dùng phải có ít nhất 8 ký tự';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).*$').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một ký tự viết hoa và một ký tự đặc biệt ';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Kiểm tra số điện thoại chỉ chứa các ký tự số';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@gmail.com') && !value.contains('@yahoo.com')) {
      return 'Email must contain @gmail.com or @yahoo.com';
    }
    return null;
  }

  // Hàm gửi dữ liệu đăng ký đến server PHP
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final String ten = _tenController.text;
      final String email = _emailController.text;
      final String matKhau = _matKhauController.text;
      final String soDienThoai = _soDienThoaiController.text;
      final String trangThai = 'active';
      final String ngayTao = DateTime.now().toIso8601String();

      // Gửi HTTP POST request đến API PHP
      final response = await http.post(
        Uri.parse('http://192.168.1.9/API/dang_ky.php'),  // Địa chỉ của file PHP trên server của bạn
        body: {
          'ten': ten,
          'email': email,
          'mat_khau': matKhau,
          'so_dien_thoai': soDienThoai,
          'trang_thai': trangThai,
          'ngay_tao': ngayTao,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          Fluttertoast.showToast(msg: 'Account created successfully!');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          Fluttertoast.showToast(msg: responseData['message'] ?? 'Registration failed. Please try again.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server error. Please try again later.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/images1.png'), // Đổi thành hình ảnh của bạn
            fit: BoxFit.cover, // Sử dụng BoxFit.cover để ảnh phủ toàn bộ
            alignment: Alignment.center,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Sign up to get started!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // Thêm độ mờ cho background bên trong container
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
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _tenController,
                          validator: validateName,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person, color: Colors.deepOrange),
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.deepOrange),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _soDienThoaiController,
                          keyboardType: TextInputType.number,
                          validator: validatePhone,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone, color: Colors.deepOrange),
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(color: Colors.deepOrange),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          validator: validateEmail,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email, color: Colors.deepOrange),
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.deepOrange),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _matKhauController,
                          obscureText: !_isPasswordVisible, // Toggling password visibility
                          validator: validatePassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.deepOrange),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.deepOrange),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.deepOrange,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _registerUser, // Gọi hàm đăng ký
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 55.0,
                    width: size.width * 0.85,
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
                      'SIGN UP',
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
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
    );
  }
}
