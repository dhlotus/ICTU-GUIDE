/// Model Địa điểm - Lưu thông tin các địa điểm trong trường ICTU
class DiaDiem {
  /// ID duy nhất của địa điểm
  final String id;

  /// Tên địa điểm (ví dụ: "Tòa nhà C4", "Thư viện", "Căng tin")
  final String tenDiaDiem;

  /// Mô tả chi tiết về địa điểm
  final String moTa;

  /// Đường dẫn ảnh của địa điểm
  final String? hinhAnh;

  /// Tọa độ X trên bản đồ tĩnh (px)
  final double toaDoX;

  /// Tọa độ Y trên bản đồ tĩnh (px)
  final double toaDoY;

  /// Constructor
  DiaDiem({
    required this.id,
    required this.tenDiaDiem,
    required this.moTa,
    this.hinhAnh,
    required this.toaDoX,
    required this.toaDoY,
  });

  /// Dữ liệu mẫu (mock data) để test giao diện trước khi có Firebase
  static List<DiaDiem> getMockData() {
    return [
      DiaDiem(
        id: '1',
        tenDiaDiem: 'Tòa nhà A1 - Phòng Đào tạo',
        moTa: 'Phòng Đào tạo Đại học CNTT, nơi giải quyết các thủ tục học vụ',
        hinhAnh: null,
        toaDoX: 120,
        toaDoY: 200,
      ),
      DiaDiem(
        id: '2',
        tenDiaDiem: 'Thư viện ICTU',
        moTa: 'Thư viện trung tâm, mở cửa 7h30 - 21h00 các ngày trong tuần',
        hinhAnh: null,
        toaDoX: 350,
        toaDoY: 150,
      ),
      DiaDiem(
        id: '3',
        tenDiaDiem: 'Ký túc xá',
        moTa: 'Khu nhà ở cho sinh viên, có 5 tòa nhà A, B, C, D, E',
        hinhAnh: null,
        toaDoX: 500,
        toaDoY: 300,
      ),
      DiaDiem(
        id: '4',
        tenDiaDiem: 'Căng tin sinh viên',
        moTa: 'Khu ăn uống, phục vụ từ 6h30 - 18h00',
        hinhAnh: null,
        toaDoX: 200,
        toaDoY: 400,
      ),
      DiaDiem(
        id: '5',
        tenDiaDiem: 'Bãi gửi xe',
        moTa: 'Bãi xe sinh viên, có bảo vệ 24/7',
        hinhAnh: null,
        toaDoX: 450,
        toaDoY: 450,
      ),
    ];
  }

  /// Chuyển đổi từ Map thành DiaDiem
  factory DiaDiem.fromMap(Map<String, dynamic> map, String documentId) {
    return DiaDiem(
      id: documentId,
      tenDiaDiem: map['tenDiaDiem'] ?? '',
      moTa: map['moTa'] ?? '',
      hinhAnh: map['hinhAnh'],
      toaDoX: (map['toaDoX'] ?? 0).toDouble(),
      toaDoY: (map['toaDoY'] ?? 0).toDouble(),
    );
  }

  /// Chuyển đổi từ DiaDiem thành Map
  Map<String, dynamic> toMap() {
    return {
      'tenDiaDiem': tenDiaDiem,
      'moTa': moTa,
      'hinhAnh': hinhAnh,
      'toaDoX': toaDoX,
      'toaDoY': toaDoY,
    };
  }
}