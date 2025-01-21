import 'package:flutter/material.dart';
import 'package:onthi/pages/login/login.dart';
import 'package:onthi/registerPage/registerPage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Biến trạng thái để theo dõi việc nhấn nút Get Started
  bool _isStarted = false;

  // Thay đổi trạng thái khi nhấn nút "Get Started"
  void _onGetStarted() {
    setState(() {
      _isStarted = true; // Cập nhật trạng thái khi nhấn nút
    });

    // Mô phỏng hành động chuyển trang hoặc làm một điều gì đó
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Getting Started')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/images1.png'), // Đặt hình ảnh nền
              fit: BoxFit.cover, // Cố định kích thước cho bức ảnh
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _title(),
              SizedBox(height: 100),
              _welcomeText(),
              SizedBox(height: 50),
              // _getStartedButton(),
              SizedBox(height: 20),
              if (_isStarted) _startedText(), // Hiển thị text khi trạng thái đã thay đổi
              SizedBox(height: 50), // Khoảng cách cho các nút
              _registerButton(),
              SizedBox(height: 20),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Title Widget (Logo)
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'd',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        children: [
          TextSpan(
            text: 'ev',
            style: TextStyle(color: Colors.black, fontSize: 40),
          ),
          TextSpan(
            text: 'rnz',
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
        ],
      ),
    );
  }

  // Welcome Text Widget
  Widget _welcomeText() {
    return Text(
      'THT',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Get Started Button
  // Widget _getStartedButton() {
  //   return InkWell(
  //     onTap: _onGetStarted, // Gọi hàm _onGetStarted khi nhấn nút
  //     child: Container(
  //       width: 250,
  //       padding: EdgeInsets.symmetric(vertical: 15),
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(30),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.shade400,
  //             offset: Offset(2, 4),
  //             blurRadius: 6,
  //           ),
  //         ],
  //       ),
  //       child: Text(
  //         'Get Started',
  //         style: TextStyle(fontSize: 18, color: Color(0xffe46b10)),
  //       ),
  //     ),
  //   );
  // }

  // Text hiển thị khi nhấn nút "Get Started"
  Widget _startedText() {
    return Text(
      'You have started!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Register Button
  Widget _registerButton() {
    return InkWell(
      onTap: () {
        // Chuyển đến màn hình đăng ký (chưa thêm logic chuyển trang)
        Navigator.push(context,MaterialPageRoute(builder: (context)=>const RegisterPage()));
      },
      child: Container(
        width: 250,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(2, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          'Register',
          style: TextStyle(fontSize: 18, color: Color(0xffe46b10)),
        ),
      ),
    );
  }

  // Login Button
  Widget _loginButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context)=>const LoginPage()));
      },
      child: Container(
        width: 250,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(2, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 18, color: Color(0xffe46b10)),
        ),
      ),
    );
  }
}
