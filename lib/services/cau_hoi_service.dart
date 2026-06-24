import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cau_hoi.dart';
import '../models/cau_tra_loi.dart';

class CauHoiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Lấy danh sách câu hỏi (theo thời gian mới nhất)
  Stream<List<CauHoi>> layDanhSachCauHoi() {
    return _firestore
        .collection('cau_hoi')
        .orderBy('ngayTao', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return CauHoi.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  /// Lấy chi tiết 1 câu hỏi theo ID
  Future<CauHoi?> layCauHoiTheoId(String id) async {
    final doc = await _firestore.collection('cau_hoi').doc(id).get();
    if (doc.exists) {
      return CauHoi.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  /// Thêm câu hỏi mới
  Future<void> themCauHoi(String tieuDe, String noiDung) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Chưa đăng nhập');

    final cauHoiMoi = {
      'nguoiDungId': user.uid,
      'hoTenNguoiDung': user.displayName ?? 'Người dùng',
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'ngayTao': FieldValue.serverTimestamp(),
      'trangThai': 'dang_cho',
    };

    await _firestore.collection('cau_hoi').add(cauHoiMoi);
  }

  /// Lấy danh sách câu trả lời cho 1 câu hỏi
  Stream<List<CauTraLoi>> layDanhSachTraLoi(String cauHoiId) {
    return _firestore
        .collection('cau_tra_loi')
        .where('cauHoiId', isEqualTo: cauHoiId)
        .orderBy('ngayTao', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return CauTraLoi.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  /// Thêm câu trả lời
  Future<void> themTraLoi(String cauHoiId, String noiDung) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Chưa đăng nhập');

    final traLoiMoi = {
      'cauHoiId': cauHoiId,
      'nguoiDungId': user.uid,
      'hoTenNguoiDung': user.displayName ?? 'Người dùng',
      'noiDung': noiDung,
      'ngayTao': FieldValue.serverTimestamp(),
      'huuIch': false,
    };

    await _firestore.collection('cau_tra_loi').add(traLoiMoi);
  }
}
