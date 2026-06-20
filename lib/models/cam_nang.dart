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
  /// TODO: Sửa lại sau khi cài Firebase
  factory CamNang.fromMap(Map<String, dynamic> map, String documentId) {
    return CamNang(
      id: documentId,
      tieuDe: map['tieuDe'] ?? '',
      noiDung: map['noiDung'] ?? '',
      hinhAnh: map['hinhAnh'],
      ngayTao: DateTime.tryParse(map['ngayTao'] ?? '') ?? DateTime.now(),
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