import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = 'Nguyễn anh Tùng'; // Initial value for name
  String _email = 'example@example.com'; // Initial value for email
  String _phone = '0123456789'; // Initial value for phone number
  String _address = '123 Main St, HCMC'; // Initial value for address

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa thông tin cá nhân')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name field
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Tên',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  setState(() {
                    _name = value ?? _name;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên của bạn';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email field
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  setState(() {
                    _email = value ?? _email;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email của bạn';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Vui lòng nhập email hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone field
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  setState(() {
                    _phone = value ?? _phone;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại của bạn';
                  }
                  if (value.length != 10) {
                    return 'Số điện thoại phải có 10 chữ số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address field
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  setState(() {
                    _address = value ?? _address;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ của bạn';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Save button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    // Handle saving the profile data here, e.g., update user in the database
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thông tin đã được cập nhật')),
                    );
                  }
                },
                child: const Text('Lưu thông tin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
