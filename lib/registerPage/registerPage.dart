import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../pages/login/login.dart';
import '../widgets/background_login_register.dart';

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

  // Form validation methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@gmail.com')) {
      return 'Email must end with @gmail.com';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number must be numeric';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  Future<void> dangky() async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse("http://192.168.30.75/API/user/sigup.php");

      try {
        var response = await http.post(url, body: {
          'ten': _tenController.text,
          'email': _emailController.text,
          'mat_khau': _matKhauController.text,
          'so_dien_thoai': _soDienThoaiController.text,
          'trang_thai': '1',
          'ngay_tao': DateTime.now().toIso8601String(),
        });


        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data["success"] == true) {
            Fluttertoast.showToast(
              msg: "Registration successful!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          } else {
            Fluttertoast.showToast(
              msg: data['message'] ?? 'An error occurred',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Server error: ${response.statusCode}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print("Error: $e");
        Fluttertoast.showToast(
          msg: 'Registration successful!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Please fill in all fields correctly.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
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
                  'Register'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _tenController,
                      validator: validateName,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _soDienThoaiController,
                      keyboardType: TextInputType.number,
                      validator: validatePhone,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      validator: validateEmail,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _matKhauController,
                      obscureText: true,
                      validator: validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        dangky();



                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: LinearGradient(
                            colors: [Color.fromARGB(255, 255, 136, 34), Color.fromARGB(255, 255, 177, 41)],
                          ),
                        ),
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?', style: TextStyle(color: Colors.black)),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    ),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
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
