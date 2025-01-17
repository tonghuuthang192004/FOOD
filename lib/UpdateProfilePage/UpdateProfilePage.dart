import 'dart:convert'; // For JSON encoding and decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../shared_preferences/shared_preferences.dart'; // For fetching user data

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();

  // API URL
  final String _apiUrl = "http://192.168.1.9/API/eidtprofile.php"; // Replace with your server URL

  // Function to fetch user data and populate the text fields
  Future<void> _loadUserData() async {
    // Fetch user data from local storage (or shared preferences)
    Map<String, String> userData = await LocalStorage.getUserData();

    // Check if user data is available
    if (userData.isNotEmpty) {
      // Debugging: Print the user data to check the content
      print("User Data: $userData");

      // Populate the text fields with the fetched user data
      _nameController.text = userData['ten'] ?? '';  // 'ten' key for name
      _phoneController.text = userData['so_dien_thoai'] ?? '';  // 'so_dien_thoai' for phone
      _emailController.text = userData['email'] ?? '';  // 'email' for email
      _avatarController.text = userData['avatar'] ?? '';  // 'avatar' for avatar
    } else {
      // If no data is available, print a warning
      print("No user data found.");
    }
  }
  // Function to send the API request for updating profile
  Future<void> _updateProfile() async {
    // Fetch user ID from local storage
    Map<String, String> userData = await LocalStorage.getUserData();
    String userId = userData['id_nguoi_dung'] ?? '';

    String name = _nameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String avatar = _avatarController.text;

    if (name.isEmpty || phone.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin!')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        body: {
          "id_nguoi_dung": userId, // Send the dynamic user ID
          "ten": name,
          "email": email,
          "so_dien_thoai": phone,
          "avatar": avatar,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi server. Vui lòng thử lại!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể kết nối tới server: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();  // Load user data when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật thông tin', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input fields
              _buildTextField("Tên:", "Nhập tên của bạn", _nameController),
              SizedBox(height: 16),
              _buildTextField("Số điện thoại:", "Nhập số điện thoại của bạn", _phoneController),
              SizedBox(height: 16),
              _buildTextField("Email:", "Nhập email của bạn", _emailController),
              SizedBox(height: 16),
              _buildTextField("Avatar:", "Nhập đường dẫn ảnh đại diện", _avatarController),
              SizedBox(height: 30),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  ),
                  child: Text(
                    'Cập nhật',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create text fields
  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
            ),
          ),
        ),
      ],
    );
  }
}
