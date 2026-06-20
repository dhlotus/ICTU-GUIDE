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

  /// Dữ liệu mẫu (mock data) để test giao diện
  static List<CauTraLoi> getMockData(String cauHoiId) {
    return [
      CauTraLoi(
        id: 'tl1',
        cauHoiId: cauHoiId,
        nguoiDungId: 'u4',
        hoTenNguoiDung: 'Trần Văn C',
        noiDung: 'Bạn vào cổng daotao.ictu.edu.vn, đăng nhập bằng mã sinh viên. Sau đó chọn mục "Đăng ký tín chỉ" nhé.',
        ngayTao: DateTime.now().subtract(const Duration(hours: 1)),
        huuIch: true,
      ),
      CauTraLoi(
        id: 'tl2',
        cauHoiId: cauHoiId,
        nguoiDungId: 'u5',
        hoTenNguoiDung: 'Cô giáo X',
        noiDung: 'Mình bổ sung thêm: Sau khi đăng ký cần xác nhận lại trong vòng 24h nhé.',
        ngayTao: DateTime.now().subtract(const Duration(minutes: 30)),
        huuIch: true,
      ),
    ];
  }

  /// Chuyển đổi từ Map thành CauTraLoi
  factory CauTraLoi.fromMap(Map<String, dynamic> map, String documentId) {
    return CauTraLoi(
      id: documentId,
      cauHoiId: map['cauHoiId'] ?? '',
      nguoiDungId: map['nguoiDungId'] ?? '',
      hoTenNguoiDung: map['hoTenNguoiDung'] ?? '',
      noiDung: map['noiDung'] ?? '',
      ngayTao: DateTime.tryParse(map['ngayTao'] ?? '') ?? DateTime.now(),
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