import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // To toggle password visibility
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đổi mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Current Password Field
            TextFormField(
              obscureText: _obscureCurrentPassword,
              decoration: InputDecoration(
                labelText: 'Mật khẩu hiện tại',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrentPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // New Password Field
            TextFormField(
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNewPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm New Password Field
            TextFormField(
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu mới',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Change Password Button
            ElevatedButton(
              onPressed: () {
                // Add password change functionality here
              },
              child: const Text('Đổi mật khẩu'),
            ),
          ],
        ),
      ),
    );
  }
}
