import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/lich_hoc_import.dart';

class LichHocService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Lấy danh sách lịch học của người dùng hiện tại
  Stream<List<LichHocImport>> layDanhSachLichHoc() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('lich_hoc')
        .where('nguoiDungId', isEqualTo: user.uid)
        .orderBy('thoiGianBatDau', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Lấy thời gian từ Firestore
        final thoiGianBatDau = (data['thoiGianBatDau'] as Timestamp).toDate();
        final thoiGianKetThuc = (data['thoiGianKetThuc'] as Timestamp).toDate();

        return LichHocImport(
          id: doc.id,
          tenMon: data['tieuDe'] ?? '',
          thuTrongTuan: thoiGianBatDau.weekday + 1,
          tietBatDau: 1,
          tietKetThuc: 1,
          diaDiem: data['ghiChu'] ?? '',
          nguon: data['nguon'] ?? 'manual',
          ngayHoc: thoiGianBatDau,
          thoiGianBatDau: thoiGianBatDau,
          thoiGianKetThuc: thoiGianKetThuc,
        );
      }).toList();
    });
  }

  /// Thêm lịch học mới
  Future<void> themLichHoc(LichHocImport lich) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Chưa đăng nhập');

    // Lấy thời gian (ưu tiên dùng thoiGianBatDau nếu có)
    final gioBatDau = lich.thoiGianBatDau ?? lich.gioBatDau;
    final gioKetThuc = lich.thoiGianKetThuc ?? lich.gioKetThuc;

    final lichMoi = {
      'nguoiDungId': user.uid,
      'tieuDe': lich.tenMon,
      'ghiChu': lich.diaDiem,
      'thoiGianBatDau': Timestamp.fromDate(gioBatDau),
      'thoiGianKetThuc': Timestamp.fromDate(gioKetThuc),
      'nhacNho': false,
      'nguon': lich.nguon,
    };

    await _firestore.collection('lich_hoc').add(lichMoi);
  }

  /// Xóa lịch học
  Future<void> xoaLichHoc(String id) async {
    await _firestore.collection('lich_hoc').doc(id).delete();
  }

}