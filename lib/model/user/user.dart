class User {
  int ?id_nguoi_dung;
  String ?ten;
  String email;
  String mat_khau;
  String so_dien_thoai;
  int trang_thai;
  DateTime ngay_tao;

  User(this.id_nguoi_dung, this.ten, this.email, this.mat_khau,
      this.so_dien_thoai, this.trang_thai, this.ngay_tao);
  Map<String, dynamic> toJson() => {
    'id_nguoi_dung': id_nguoi_dung.toString(),
    'ten': ten,
    'email': email,
    'mat_khau': mat_khau,
    'so_dien_thoai': so_dien_thoai,
    'trang_thai': trang_thai.toString(), // Cần gửi giá trị thực tế
    'ngay_tao': ngay_tao.toIso8601String(), // Sử dụng ISO format cho DateTime
  };
}
