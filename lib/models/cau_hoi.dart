import 'package:cloud_firestore/cloud_firestore.dart';
/// Model Câu hỏi - Lưu thông tin câu hỏi của sinh viên trong mục Hỏi đáp
class CauHoi {
  /// ID duy nhất của câu hỏi
  final String id;

  /// ID của người dùng đã đăng câu hỏi
  final String nguoiDungId;

  /// Họ tên người đăng (lấy từ collection NguoiDung)
  final String hoTenNguoiDung;

  /// Tiêu đề câu hỏi (ngắn gọn, khoảng 50-100 ký tự)
  final String tieuDe;

  /// Nội dung câu hỏi chi tiết
  final String noiDung;

  /// Thời gian tạo câu hỏi
  final DateTime ngayTao;

  /// Trạng thái câu hỏi (đã giải đáp, đang chờ, đã khóa...)
  final String trangThai;

  /// Constructor
  CauHoi({
    required this.id,
    required this.nguoiDungId,
    required this.hoTenNguoiDung,
    required this.tieuDe,
    required this.noiDung,
    required this.ngayTao,
    this.trangThai = 'dang_cho', // mặc định là đang chờ trả lời
  });

  /// Dữ liệu mẫu (mock data) để test giao diện
  static List<CauHoi> getMockData() {
    return [
      CauHoi(
        id: '1',
        nguoiDungId: 'u1',
        hoTenNguoiDung: 'Nguyễn Văn A',
        tieuDe: 'Làm sao để đăng ký môn học?',
        noiDung: 'Mình là sinh viên mới, không biết quy trình đăng ký môn học như thế nào. Ai có kinh nghiệm chỉ mình với ạ.',
        ngayTao: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      CauHoi(
        id: '2',
        nguoiDungId: 'u2',
        hoTenNguoiDung: 'Trần Thị B',
        tieuDe: 'Thẻ sinh viên làm ở đâu?',
        noiDung: 'Cho mình hỏi thủ tục làm thẻ sinh viên cần những gì và làm ở phòng nào?',
        ngayTao: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CauHoi(
        id: '3',
        nguoiDungId: 'u3',
        hoTenNguoiDung: 'Lê Văn C',
        tieuDe: 'Khi nào có lịch thi?',
        noiDung: 'Em muốn hỏi lịch thi học kỳ 1 năm nay được công bố khi nào ạ?',
        ngayTao: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  /// Chuyển đổi từ Map thành CauHoi

  factory CauHoi.fromMap(Map<String, dynamic> map, String documentId) {
    return CauHoi(
      id: documentId,
      nguoiDungId: map['nguoiDungId'] ?? '',
      hoTenNguoiDung: map['hoTenNguoiDung'] ?? '',
      tieuDe: map['tieuDe'] ?? '',
      noiDung: map['noiDung'] ?? '',
      ngayTao: (map['ngayTao'] as Timestamp?)?.toDate() ?? DateTime.now(),
      trangThai: map['trangThai'] ?? 'dang_cho',
    );
  }

  /// Chuyển đổi từ CauHoi thành Map
  Map<String, dynamic> toMap() {
    return {
      'nguoiDungId': nguoiDungId,
      'hoTenNguoiDung': hoTenNguoiDung,
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'ngayTao': ngayTao.toIso8601String(),
      'trangThai': trangThai,
    };
  }
}