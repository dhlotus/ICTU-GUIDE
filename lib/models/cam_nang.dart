import 'package:cloud_firestore/cloud_firestore.dart'; // Nhớ thêm dòng này

/// Model Cẩm nang - Lưu trữ thông tin bài viết hướng dẫn cho sinh viên
class CamNang {
  /// ID duy nhất của bài viết
  final String id;

  /// Tiêu đề bài viết
  final String tieuDe;

  /// Nội dung chi tiết của bài viết
  final String noiDung;

  /// Đường dẫn ảnh đại diện
  final String? hinhAnh;

  /// Thời gian tạo bài viết
  final DateTime ngayTao;

  /// Lượt xem
  final int luotXem;
  /// Danh mục bài viết (Đào tạo, Học phí, Sự kiện, Khác...)
  final String? danhMuc;

  /// Constructor
  CamNang({
    required this.id,
    required this.tieuDe,
    required this.noiDung,
    this.hinhAnh,
    required this.ngayTao,
    this.luotXem = 0,
    this.danhMuc,
  });

  /// Tạo mới (dùng khi chưa có ID)
  CamNang.create({
    required String tieuDe,
    required String noiDung,
    String? hinhAnh,
    String? danhMuc,
  }) : this(
    id: '',  // Sẽ được Firebase tự sinh
    tieuDe: tieuDe,
    noiDung: noiDung,
    hinhAnh: hinhAnh,
    ngayTao: DateTime.now(),
    luotXem: 0,
    danhMuc: danhMuc,
  );

  /// Chuyển đổi từ Map thành CamNang
  factory CamNang.fromMap(Map<String, dynamic> map, String documentId) {
    // Xử lý ngayTao
    DateTime ngayTao;
    if (map['ngayTao'] is Timestamp) {
      ngayTao = (map['ngayTao'] as Timestamp).toDate();
    } else if (map['ngayTao'] is String) {
      ngayTao = DateTime.tryParse(map['ngayTao']) ?? DateTime.now();
    } else {
      ngayTao = DateTime.now();
    }

    return CamNang(
      id: documentId,
      tieuDe: map['tieuDe'] ?? '',
      noiDung: map['noiDung'] ?? '',
      hinhAnh: map['hinhAnh'],
      ngayTao: ngayTao,
      luotXem: map['luotXem'] ?? 0,
      danhMuc: map['danhMuc'], // --- Lấy dữ liệu danhMuc từ Firestore ---
    );
  }

  /// Chuyển đổi từ CamNang thành Map
  Map<String, dynamic> toMap() {
    return {
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'hinhAnh': hinhAnh,
      'ngayTao': ngayTao.toIso8601String(),
      'luotXem': luotXem,
      'danhMuc': danhMuc, // --- Lưu dữ liệu danhMuc lên Firestore ---
    };
  }
}