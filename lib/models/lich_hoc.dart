/// Model Lịch học - Lưu thông tin lịch học và sự kiện cá nhân của sinh viên
class LichHoc {
  /// ID duy nhất của lịch
  final String id;

  /// ID của người dùng sở hữu lịch này
  final String nguoiDungId;

  /// Tiêu đề sự kiện (ví dụ: "Lập trình di động", "Nộp bài tập")
  final String tieuDe;

  /// Ghi chú thêm (có thể null nếu không có)
  final String? ghiChu;

  /// Thời gian bắt đầu
  final DateTime thoiGianBatDau;

  /// Thời gian kết thúc
  final DateTime thoiGianKetThuc;

  /// Có nhắc nhở hay không (true = có, false = không)
  final bool nhacNho;

  /// Constructor
  LichHoc({
    required this.id,
    required this.nguoiDungId,
    required this.tieuDe,
    this.ghiChu,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
    this.nhacNho = false,
  });

  /// Dữ liệu mẫu (mock data) để test giao diện
  static List<LichHoc> getMockData(String nguoiDungId) {
    final now = DateTime.now();
    return [
      LichHoc(
        id: '1',
        nguoiDungId: nguoiDungId,
        tieuDe: 'Lập trình di động',
        ghiChu: 'Phòng A102 - Tòa A1, Thầy Nguyễn Văn X',
        thoiGianBatDau: DateTime(now.year, now.month, now.day, 9, 0),
        thoiGianKetThuc: DateTime(now.year, now.month, now.day, 11, 30),
        nhacNho: true,
      ),
      LichHoc(
        id: '2',
        nguoiDungId: nguoiDungId,
        tieuDe: 'Nộp bài tập lớn',
        ghiChu: 'Hạn nộp trước 17h00',
        thoiGianBatDau: DateTime(now.year, now.month, now.day, 0, 0),
        thoiGianKetThuc: DateTime(now.year, now.month, now.day, 17, 0),
        nhacNho: true,
      ),
      LichHoc(
        id: '3',
        nguoiDungId: nguoiDungId,
        tieuDe: 'Cơ sở dữ liệu',
        ghiChu: 'Phòng B201 - Tòa B',
        thoiGianBatDau: DateTime(now.year, now.month, now.day, 13, 30),
        thoiGianKetThuc: DateTime(now.year, now.month, now.day, 16, 0),
        nhacNho: false,
      ),
    ];
  }

  /// Chuyển đổi từ Map thành LichHoc
  factory LichHoc.fromMap(Map<String, dynamic> map, String documentId) {
    return LichHoc(
      id: documentId,
      nguoiDungId: map['nguoiDungId'] ?? '',
      tieuDe: map['tieuDe'] ?? '',
      ghiChu: map['ghiChu'],
      thoiGianBatDau: DateTime.tryParse(map['thoiGianBatDau'] ?? '') ?? DateTime.now(),
      thoiGianKetThuc: DateTime.tryParse(map['thoiGianKetThuc'] ?? '') ?? DateTime.now(),
      nhacNho: map['nhacNho'] ?? false,
    );
  }

  /// Chuyển đổi từ LichHoc thành Map
  Map<String, dynamic> toMap() {
    return {
      'nguoiDungId': nguoiDungId,
      'tieuDe': tieuDe,
      'ghiChu': ghiChu,
      'thoiGianBatDau': thoiGianBatDau.toIso8601String(),
      'thoiGianKetThuc': thoiGianKetThuc.toIso8601String(),
      'nhacNho': nhacNho,
    };
  }
}