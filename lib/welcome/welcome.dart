import 'package:flutter/material.dart';

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
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xfffbb448), Color(0xffe46b10)], // Gradient background
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
              _getStartedButton(),
              SizedBox(height: 20),
              if (_isStarted) _startedText(), // Hiển thị text khi trạng thái đã thay đổi
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
      'Welcome to the app!\nGet started now.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Get Started Button
  Widget _getStartedButton() {
    return InkWell(
      onTap: _onGetStarted, // Gọi hàm _onGetStarted khi nhấn nút
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
          'Get Started',
          style: TextStyle(fontSize: 18, color: Color(0xffe46b10)),
        ),
      ),
    );
  }

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
}
