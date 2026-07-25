import 'package:cloud_firestore/cloud_firestore.dart';

/// Model Câu trả lời - Lưu thông tin câu trả lời cho câu hỏi
class CauTraLoi {
  /// ID duy nhất của câu trả lời
  final String id;

  /// ID của câu hỏi mà câu trả lời này thuộc về
  final String cauHoiId;

  /// ID của người dùng đã trả lời
  final String nguoiDungId;

  /// Họ tên người trả lời
  final String hoTenNguoiDung;

  /// Nội dung câu trả lời
  final String noiDung;

  /// Thời gian tạo câu trả lời
  final DateTime ngayTao;

  /// Đánh dấu câu trả lời hữu ích (true = có ích)
  final bool huuIch;

  /// Constructor
  CauTraLoi({
    required this.id,
    required this.cauHoiId,
    required this.nguoiDungId,
    required this.hoTenNguoiDung,
    required this.noiDung,
    required this.ngayTao,
    this.huuIch = false,
  });

  /// Chuyển đổi từ Map thành CauTraLoi (Đã sửa lỗi Timestamp)
  factory CauTraLoi.fromMap(Map<String, dynamic> map, String documentId) {
    // Xử lý ngayTao: Nếu là Timestamp từ Firebase thì lấy toDate(), còn nếu là String thì parse
    DateTime ngayTao;
    if (map['ngayTao'] is Timestamp) {
      ngayTao = (map['ngayTao'] as Timestamp).toDate();
    } else if (map['ngayTao'] is String) {
      ngayTao = DateTime.tryParse(map['ngayTao']) ?? DateTime.now();
    } else {
      ngayTao = DateTime.now(); // Fallback an toàn
    }

    return CauTraLoi(
      id: documentId,
      cauHoiId: map['cauHoiId'] ?? '',
      nguoiDungId: map['nguoiDungId'] ?? '',
      hoTenNguoiDung: map['hoTenNguoiDung'] ?? '',
      noiDung: map['noiDung'] ?? '',
      ngayTao: ngayTao,
      huuIch: map['huuIch'] ?? false,
    );
  }

  /// Chuyển đổi từ CauTraLoi thành Map
  Map<String, dynamic> toMap() {
    return {
      'cauHoiId': cauHoiId,
      'nguoiDungId': nguoiDungId,
      'hoTenNguoiDung': hoTenNguoiDung,
      'noiDung': noiDung,
      'ngayTao': ngayTao.toIso8601String(),
      'huuIch': huuIch,
    };
  }
}