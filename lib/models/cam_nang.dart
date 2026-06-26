import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// Constructor
  CamNang({
    required this.id,
    required this.tieuDe,
    required this.noiDung,
    this.hinhAnh,
    required this.ngayTao,
    this.luotXem = 0,
  });

  /// Tạo mới (dùng khi chưa có ID)
  CamNang.create({
    required String tieuDe,
    required String noiDung,
    String? hinhAnh,
  }) : this(
    id: '',  // Sẽ được Firebase tự sinh
    tieuDe: tieuDe,
    noiDung: noiDung,
    hinhAnh: hinhAnh,
    ngayTao: DateTime.now(),
    luotXem: 0,
  );

  /// Chuyển đổi từ Map thành CamNang
  factory CamNang.fromMap(Map<String, dynamic> map, String documentId) {
    // Xử lý ngayTao: Nếu là Timestamp từ Firebase thì lấy toDate(), còn nếu là String thì parse
    DateTime ngayTao;
    if (map['ngayTao'] is Timestamp) {
      ngayTao = (map['ngayTao'] as Timestamp).toDate();
    } else if (map['ngayTao'] is String) {
      ngayTao = DateTime.tryParse(map['ngayTao']) ?? DateTime.now();
    } else {
      ngayTao = DateTime.now(); // Fallback an toàn
    }

    return CamNang(
      id: documentId,
      tieuDe: map['tieuDe'] ?? '',
      noiDung: map['noiDung'] ?? '',
      hinhAnh: map['hinhAnh'],
      ngayTao: ngayTao, // Dùng biến ngayTao đã xử lý ở trên
      luotXem: map['luotXem'] ?? 0,
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
    };
  }
}