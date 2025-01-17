// Rename class in food_page_body.dart
class AppUser {
  final int id;
  final String name;
  final String email;
  final String password;
  final String? avatar;
  final String phoneNumber;
  final bool status;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatar,
    required this.phoneNumber,
    required this.status,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: int.tryParse(json['id_nguoi_dung'].toString()) ?? 0,
      name: json['ten'],
      email: json['email'],
      password: json['mat_khau'],
      avatar: json['avatar'],
      phoneNumber: json['so_dien_thoai'],
      status: json['trang_thai'] == 1,
      createdAt: DateTime.tryParse(json['ngay_tao']) ?? DateTime.now(),
    );
  }
}
