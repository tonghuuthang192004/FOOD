import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../../registerPage/registerPage.dart';
import '../../widgets/background_login_register.dart';
import '../home/main_food_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future login() async {
    var url = Uri.parse("http://192.168.1.7/API/user/login.php"); // Đảm bảo đúng URL API
    var response = await http.post(url, body: {
      "email": emailController.text,
      "mat_khau": passwordController.text,
    });

    var data = json.decode(response.body);
    if (data == "Success") {
      Fluttertoast.showToast(
        msg: "Đăng nhập thành công!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Chuyển hướng đến trang chính sau khi đăng nhập thành công
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainFoodPage()), // Đảm bảo rằng bạn đã tạo MainFoodPage
      );
    } else {
      Fluttertoast.showToast(
        msg: "Đăng nhập thất bại! Kiểm tra lại thông tin.",
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
      resizeToAvoidBottomInset: false,
      body: BackGround(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot your password?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  padding: EdgeInsets.all(0),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80.0),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 136, 34),
                        Color.fromARGB(255, 255, 177, 41),
                      ],
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterPage(),
                      ),
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
