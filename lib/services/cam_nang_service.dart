import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cam_nang.dart';

class CamNangService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Lấy danh sách bài viết cẩm nang (theo thời gian mới nhất)
  Stream<List<CamNang>> layDanhSachCamNang() {
    return _firestore
        .collection('cam_nang')
        .orderBy('ngayTao', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CamNang.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Lấy chi tiết 1 bài viết theo ID
  Future<CamNang?> layBaiVietTheoId(String id) async {
    final doc = await _firestore.collection('cam_nang').doc(id).get();
    if (doc.exists) {
      return CamNang.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  /// Thêm bài viết mới (Chỉ Admin mới dùng sau này)
  Future<void> themBaiViet(CamNang baiViet) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Chưa đăng nhập');

    final baiVietMoi = {
      'tieuDe': baiViet.tieuDe,
      'noiDung': baiViet.noiDung,
      'hinhAnh': baiViet.hinhAnh,
      'ngayTao': FieldValue.serverTimestamp(),
      'luotXem': 0,
    };

    await _firestore.collection('cam_nang').add(baiVietMoi);
  }
  /// Tăng lượt xem cho bài viết
  Future<void> tangLuotXem(String id) async {
    // Lấy document hiện tại
    final docRef = _firestore.collection('cam_nang').doc(id);

    // Dùng transaction để đảm bảo dữ liệu không bị lệch nếu 2 người cùng xem lúc
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (snapshot.exists) {
        final currentLuotXem = snapshot.data()?['luotXem'] ?? 0;
        // Cộng thêm 1
        transaction.update(docRef, {'luotXem': currentLuotXem + 1});
      }
    });
  }
}